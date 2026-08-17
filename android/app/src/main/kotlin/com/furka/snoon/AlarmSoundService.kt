package com.furka.snoon

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.Ringtone
import android.media.RingtoneManager
import android.media.ToneGenerator
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationCompat
import org.json.JSONObject
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import kotlin.math.roundToInt

class AlarmSoundService : Service() {
    companion object {
        const val ACTION_START = "com.furka.snoon.START_ALARM"
        const val ACTION_STOP = "com.furka.snoon.STOP_ALARM"
        const val NOTIFICATION_ID = 4207
        private const val CHANNEL_ID = "ringing_alarm"
        private const val TAG = "SnoonAlarmSound"
    }

    private var ringtone: Ringtone? = null
    private var fallbackPlayer: MediaPlayer? = null
    private var emergencyTone: ToneGenerator? = null
    private var emergencyToneLoop: Runnable? = null
    private var vibrator: Vibrator? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private val handler = Handler(Looper.getMainLooper())
    private val stringsContext: Context
        get() = LocaleHelper.wrap(this)

    override fun onCreate() {
        super.onCreate()
        createChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopAlarm()
            stopSelf()
            AlarmRingingActivity.finishIfVisible()
            return START_NOT_STICKY
        }
        val raw = intent?.getStringExtra("recordJson")
        if (raw.isNullOrBlank()) {
            stopSelf()
            return START_NOT_STICKY
        }
        val record = try {
            JSONObject(raw)
        } catch (error: Exception) {
            Log.e(TAG, "Alarm kaydı okunamadı", error)
            stopSelf()
            return START_NOT_STICKY
        }
        val kind = intent.getStringExtra("kind") ?: AlarmScheduler.KIND_MAIN
        val occurrenceToken = intent.getLongExtra(
            "occurrenceToken",
            record.optLong("triggerAtMillis", 0L),
        )
        val snoozeCount = intent.getIntExtra("snoozeCount", 0)

        handler.removeCallbacksAndMessages(null)
        stopPlayback()
        startForeground(
            NOTIFICATION_ID,
            buildNotification(record, kind, occurrenceToken, snoozeCount),
        )
        acquireWakeLock(record)
        startSound(record)
        startVibration(record)
        scheduleAutoSilence(record)
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        stopAlarm()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun buildNotification(
        record: JSONObject,
        kind: String,
        occurrenceToken: Long,
        snoozeCount: Int,
    ): android.app.Notification {
        val ringing = Intent(this, AlarmRingingActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("recordJson", record.toString())
            putExtra("kind", kind)
            putExtra("occurrenceToken", occurrenceToken)
            putExtra("snoozeCount", snoozeCount)
        }
        val fullScreen = PendingIntent.getActivity(
            this,
            (record.optString("id") + occurrenceToken).hashCode(),
            ringing,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val time = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm"))
        val label = record.optString(
            "label",
            stringsContext.getString(R.string.alarm_default),
        )
        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle("$time  •  $label")
            .setContentText(stringsContext.getString(R.string.alarm_ringing))
            .setSubText("Snoon")
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setColor(0xFF2F6BFF.toInt())
            .setColorized(true)
            .setOngoing(true)
            .setAutoCancel(false)
            .setShowWhen(false)
            .setContentIntent(fullScreen)
            .setFullScreenIntent(
                fullScreen,
                record.optBoolean("showOnLockScreen", true),
            )

        val isTimer = record.optBoolean("isTimer", false)
        val maxSnoozes = record.optInt("maxSnoozes", 3)
        if (!isTimer && snoozeCount < maxSnoozes) {
            builder.addAction(
                android.R.drawable.ic_lock_idle_alarm,
                stringsContext.getString(
                    R.string.snooze_minutes,
                    record.optInt("snoozeMinutes", 5),
                ),
                actionPendingIntent(
                    AlarmActionReceiver.ACTION_SNOOZE,
                    record,
                    kind,
                    occurrenceToken,
                    snoozeCount,
                ),
            )
        }
        builder.addAction(
            android.R.drawable.ic_menu_close_clear_cancel,
            stringsContext.getString(R.string.dismiss),
            actionPendingIntent(
                AlarmActionReceiver.ACTION_DISMISS,
                record,
                kind,
                occurrenceToken,
                snoozeCount,
            ),
        )
        return builder.build()
    }

    private fun actionPendingIntent(
        action: String,
        record: JSONObject,
        kind: String,
        occurrenceToken: Long,
        snoozeCount: Int,
    ): PendingIntent {
        val intent = Intent(this, AlarmActionReceiver::class.java).apply {
            this.action = action
            putExtra("recordJson", record.toString())
            putExtra("kind", kind)
            putExtra("occurrenceToken", occurrenceToken)
            putExtra("snoozeCount", snoozeCount)
        }
        return PendingIntent.getBroadcast(
            this,
            "$action|${record.optString("id")}|$occurrenceToken|$snoozeCount"
                .hashCode() and 0x7fffffff,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun startSound(record: JSONObject) {
        val configuredVolume = record.optDouble("volume", 0.8)
            .toFloat()
            .coerceIn(0.05f, 1f)
        ensureAlarmStreamIsAudible(configuredVolume)

        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val candidates = ringtoneCandidates(record)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            for (uri in candidates) {
                try {
                    val candidate = RingtoneManager.getRingtone(this, uri) ?: continue
                    candidate.audioAttributes = attributes
                    candidate.isLooping = true
                    candidate.volume = if (record.optBoolean("gradualVolume", true)) {
                        0.05f
                    } else {
                        1f
                    }
                    candidate.play()
                    if (!candidate.isPlaying) {
                        candidate.stop()
                        continue
                    }
                    ringtone = candidate
                    if (record.optBoolean("gradualVolume", true)) rampVolume()
                    return
                } catch (error: Exception) {
                    Log.w(TAG, "Zil sesi açılamadı: $uri", error)
                }
            }
        }

        // Çok özelleştirilmiş OEM ROM'larında Ringtone nesnesi null dönebilir.
        // Aynı URI'leri doğrudan MediaPlayer ile son kez dene.
        for (uri in candidates) {
            try {
                fallbackPlayer = MediaPlayer().apply {
                    setAudioAttributes(attributes)
                    setWakeMode(this@AlarmSoundService, PowerManager.PARTIAL_WAKE_LOCK)
                    setDataSource(this@AlarmSoundService, uri)
                    isLooping = true
                    prepare()
                    val startVolume =
                        if (record.optBoolean("gradualVolume", true)) 0.05f else 1f
                    setVolume(startVolume, startVolume)
                    start()
                }
                if (record.optBoolean("gradualVolume", true)) rampVolume()
                return
            } catch (error: Exception) {
                Log.w(TAG, "Yedek oynatıcı zil sesini açamadı: $uri", error)
                stopFallbackPlayer()
            }
        }
        Log.e(TAG, "Cihazda oynatılabilir zil sesi bulunamadı; acil tona geçiliyor")
        startEmergencyTone(configuredVolume)
    }

    private fun ringtoneCandidates(record: JSONObject): List<Uri> {
        val values = linkedSetOf<Uri>()
        if (!record.isNull("ringtoneUri")) {
            val selected = record.optString("ringtoneUri", "").trim()
            if (
                selected.isNotEmpty() &&
                !selected.equals("null", ignoreCase = true)
            ) {
                try {
                    val parsed = Uri.parse(selected)
                    if (parsed.scheme in setOf("content", "android.resource", "file")) {
                        values.add(parsed)
                    }
                } catch (_: Exception) {
                    // Sistem varsayılanlarına devam et.
                }
            }
        }
        listOfNotNull(
            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM),
            Settings.System.DEFAULT_ALARM_ALERT_URI,
            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION),
            Settings.System.DEFAULT_NOTIFICATION_URI,
        ).forEach(values::add)
        return values.toList()
    }

    private fun ensureAlarmStreamIsAudible(configuredVolume: Float) {
        try {
            val audio = getSystemService(AudioManager::class.java)
            val maximum = audio.getStreamMaxVolume(AudioManager.STREAM_ALARM)
            val minimum = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                audio.getStreamMinVolume(AudioManager.STREAM_ALARM).coerceAtLeast(1)
            } else {
                1
            }
            val target = (maximum * configuredVolume)
                .roundToInt()
                .coerceIn(minimum, maximum)
            if (audio.getStreamVolume(AudioManager.STREAM_ALARM) != target) {
                audio.setStreamVolume(AudioManager.STREAM_ALARM, target, 0)
            }
        } catch (error: Exception) {
            Log.w(TAG, "Alarm ses kanalı ayarlanamadı", error)
        }
    }

    private fun acquireWakeLock(record: JSONObject) {
        releaseWakeLock()
        val autoSilenceMinutes = record.optInt("autoSilenceMinutes", 10)
            .coerceAtLeast(1)
        try {
            wakeLock = getSystemService(PowerManager::class.java)
                .newWakeLock(
                    PowerManager.PARTIAL_WAKE_LOCK,
                    "$packageName:SnoonAlarm",
                ).apply {
                    setReferenceCounted(false)
                    acquire((autoSilenceMinutes + 1L) * 60_000L)
                }
        } catch (error: Exception) {
            Log.w(TAG, "Alarm uyanıklık kilidi alınamadı", error)
            wakeLock = null
        }
    }

    private fun releaseWakeLock() {
        try {
            if (wakeLock?.isHeld == true) wakeLock?.release()
        } catch (_: Exception) {
            // Sistem zaman aşımıyla kilidi bırakmış olabilir.
        }
        wakeLock = null
    }

    private fun rampVolume() {
        for (step in 1..15) {
            handler.postDelayed({
                val value = (0.05f + 0.95f * step / 15f).coerceIn(0.05f, 1f)
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        ringtone?.volume = value
                    }
                    fallbackPlayer?.setVolume(value, value)
                } catch (_: Exception) {
                    // Alarm bu sırada kapatılmış olabilir.
                }
            }, step * 2_000L)
        }
    }

    @Suppress("DEPRECATION")
    private fun startVibration(record: JSONObject) {
        if (!record.optBoolean("vibrate", true)) return
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
        vibrator?.vibrate(
            VibrationEffect.createWaveform(
                longArrayOf(0, 700, 400, 700, 400),
                1,
            ),
        )
    }

    private fun scheduleAutoSilence(record: JSONObject) {
        val minutes = record.optInt("autoSilenceMinutes", 10).coerceAtLeast(1)
        handler.postDelayed({
            HistoryStore.add(
                this,
                record.optString("id", "alarm"),
                record.optString(
                    "label",
                    stringsContext.getString(R.string.alarm_default),
                ),
                "auto_silenced",
            )
            stopAlarm()
            AlarmRingingActivity.finishIfVisible()
            stopSelf()
        }, minutes * 60_000L)
    }

    private fun stopPlayback() {
        try {
            ringtone?.stop()
        } catch (_: Exception) {
            // Oynatıcı zaten durmuş olabilir.
        }
        ringtone = null
        stopFallbackPlayer()
        stopEmergencyTone()
    }

    private fun stopFallbackPlayer() {
        try {
            fallbackPlayer?.stop()
        } catch (_: Exception) {
            // Oynatıcı zaten durmuş olabilir.
        }
        fallbackPlayer?.release()
        fallbackPlayer = null
    }

    private fun startEmergencyTone(configuredVolume: Float) {
        stopEmergencyTone()
        val percent = (configuredVolume * 100).roundToInt().coerceIn(5, 100)
        try {
            emergencyTone = ToneGenerator(AudioManager.STREAM_ALARM, percent)
            val loop = object : Runnable {
                override fun run() {
                    emergencyTone?.startTone(ToneGenerator.TONE_CDMA_ALERT_CALL_GUARD, 900)
                    handler.postDelayed(this, 1_100L)
                }
            }
            emergencyToneLoop = loop
            loop.run()
        } catch (error: Exception) {
            Log.e(TAG, "Acil alarm tonu başlatılamadı", error)
            stopEmergencyTone()
        }
    }

    private fun stopEmergencyTone() {
        emergencyToneLoop?.let(handler::removeCallbacks)
        emergencyToneLoop = null
        try {
            emergencyTone?.stopTone()
            emergencyTone?.release()
        } catch (_: Exception) {
            // Ton zaten bırakılmış olabilir.
        }
        emergencyTone = null
    }

    private fun stopAlarm() {
        handler.removeCallbacksAndMessages(null)
        stopPlayback()
        vibrator?.cancel()
        vibrator = null
        releaseWakeLock()
        stopForeground(STOP_FOREGROUND_REMOVE)
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        getSystemService(NotificationManager::class.java).createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                stringsContext.getString(R.string.ringing_channel),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = stringsContext.getString(R.string.ringing_channel_description)
                lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
                setSound(null, null)
                enableVibration(false)
            },
        )
    }
}
