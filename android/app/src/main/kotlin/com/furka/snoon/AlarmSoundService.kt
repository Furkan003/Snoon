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

        /// Gradual volume opens here rather than at 0.05. An alarm that starts
        /// at five percent of an already scaled stream is inaudible, which
        /// defeats the point of it being an alarm.
        private const val RAMP_START_VOLUME = 0.35f

        /// Reach full volume in RAMP_STEPS * RAMP_STEP_MILLIS -- ten seconds,
        /// not the thirty it used to take.
        private const val RAMP_STEPS = 10
        private const val RAMP_STEP_MILLIS = 1_000L

        /// How long to give a Ringtone to actually produce sound before
        /// treating it as a silent failure and falling back.
        private const val PLAYBACK_HEALTH_CHECK_MILLIS = 1_200L
    }

    private var ringtone: Ringtone? = null
    private var fallbackPlayer: MediaPlayer? = null
    private var emergencyTone: ToneGenerator? = null
    private var emergencyToneLoop: Runnable? = null
    private var vibrator: Vibrator? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var previousAlarmStreamVolume: Int? = null
    private var forcedAlarmStreamVolume: Int? = null
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
                        RAMP_START_VOLUME
                    } else {
                        1f
                    }
                    candidate.play()
                    // Deliberately no isPlaying check right here: play() starts
                    // asynchronously, so it routinely still reads false at this
                    // point and acting on that killed a ringtone that was about
                    // to sound. Opening the URI is checked by
                    // ringtoneCandidates; that the sound actually arrived is
                    // checked a moment later by the health check below, because
                    // a Ringtone can also fail silently after play() returns.
                    ringtone = candidate
                    if (record.optBoolean("gradualVolume", true)) rampVolume()
                    handler.postDelayed(
                        { verifyRingtonePlaying(record, attributes, candidates) },
                        PLAYBACK_HEALTH_CHECK_MILLIS,
                    )
                    return
                } catch (error: Exception) {
                    Log.w(TAG, "Zil sesi açılamadı: $uri", error)
                }
            }
        }

        if (startFallbackPlayer(record, attributes, candidates)) return
        Log.e(TAG, "Cihazda oynatılabilir zil sesi bulunamadı; acil tona geçiliyor")
        startEmergencyTone(configuredVolume)
    }

    /// A Ringtone that opened cleanly can still end up silent on some ROMs. If
    /// nothing is playing shortly after start, hand over to the MediaPlayer
    /// chain rather than leaving the alarm mute.
    private fun verifyRingtonePlaying(
        record: JSONObject,
        attributes: AudioAttributes,
        candidates: List<Uri>,
    ) {
        val playing = try {
            ringtone?.isPlaying == true
        } catch (_: Exception) {
            false
        }
        if (playing) return
        Log.w(TAG, "Zil sesi sessiz kaldı; yedek oynatıcıya geçiliyor")
        try {
            ringtone?.stop()
        } catch (_: Exception) {
            // Zaten durmuş olabilir.
        }
        ringtone = null
        if (startFallbackPlayer(record, attributes, candidates)) return
        val configuredVolume = record.optDouble("volume", 0.8)
            .toFloat()
            .coerceIn(0.05f, 1f)
        startEmergencyTone(configuredVolume)
    }

    /// Çok özelleştirilmiş OEM ROM'larında Ringtone nesnesi null dönebilir veya
    /// sessiz kalabilir. Aynı URI'leri doğrudan MediaPlayer ile dener.
    private fun startFallbackPlayer(
        record: JSONObject,
        attributes: AudioAttributes,
        candidates: List<Uri>,
    ): Boolean {
        for (uri in candidates) {
            try {
                fallbackPlayer = MediaPlayer().apply {
                    setAudioAttributes(attributes)
                    setWakeMode(this@AlarmSoundService, PowerManager.PARTIAL_WAKE_LOCK)
                    setDataSource(this@AlarmSoundService, uri)
                    isLooping = true
                    prepare()
                    val startVolume =
                        if (record.optBoolean("gradualVolume", true)) {
                            RAMP_START_VOLUME
                        } else {
                            1f
                        }
                    setVolume(startVolume, startVolume)
                    start()
                }
                if (record.optBoolean("gradualVolume", true)) rampVolume()
                return true
            } catch (error: Exception) {
                Log.w(TAG, "Yedek oynatıcı zil sesini açamadı: $uri", error)
                stopFallbackPlayer()
            }
        }
        return false
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
        ).forEach(values::add)
        // Some OEM ROMs (MIUI) point the default alarm at a theme file living
        // inside another app's Android/data sandbox, mode 0660 and owned by a
        // system user, so we cannot open it whatever permissions we hold. The
        // installed alarm ringtones are ordinary world-readable media, so list
        // them as real fallbacks before giving up on a proper alarm sound.
        values.addAll(installedAlarmUris())
        // Absolute last resort. A notification blip is a poor alarm -- it is
        // short and quiet -- so it only runs when nothing above could open.
        listOfNotNull(
            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION),
            Settings.System.DEFAULT_NOTIFICATION_URI,
        ).forEach(values::add)
        return values.filter(::isPlayable)
    }

    /// Alarm ringtones the device actually ships, as MediaStore content URIs.
    private fun installedAlarmUris(): List<Uri> {
        val uris = mutableListOf<Uri>()
        try {
            val manager = RingtoneManager(this)
            manager.setType(RingtoneManager.TYPE_ALARM)
            val cursor = manager.cursor
            while (cursor.moveToNext()) {
                uris.add(manager.getRingtoneUri(cursor.position))
            }
        } catch (error: Exception) {
            Log.w(TAG, "Sistem alarm sesleri listelenemedi", error)
        }
        return uris
    }

    /// Whether this process can actually open [uri]. Checking up front beats
    /// starting a candidate and stopping it again, which is audible as a chirp.
    private fun isPlayable(uri: Uri): Boolean = try {
        contentResolver.openInputStream(uri).use { it != null }
    } catch (_: Exception) {
        false
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
            val current = audio.getStreamVolume(AudioManager.STREAM_ALARM)
            if (current != target) {
                // Remember what the user had before we raise it, so stopAlarm
                // can hand the phone back unchanged. Only the first alarm of a
                // ringing session records it: a second alarm arriving while one
                // rings would otherwise memorise our own raised value.
                if (previousAlarmStreamVolume == null) {
                    previousAlarmStreamVolume = current
                }
                audio.setStreamVolume(AudioManager.STREAM_ALARM, target, 0)
                forcedAlarmStreamVolume = target
            }
        } catch (error: Exception) {
            Log.w(TAG, "Alarm ses kanalı ayarlanamadı", error)
        }
    }

    /// Puts the system alarm stream back where the user had it. Leaving it
    /// raised would silently rewrite a phone-wide setting the user never
    /// changed themselves.
    private fun restoreAlarmStreamVolume() {
        val previous = previousAlarmStreamVolume ?: return
        val forced = forcedAlarmStreamVolume
        previousAlarmStreamVolume = null
        forcedAlarmStreamVolume = null
        try {
            val audio = getSystemService(AudioManager::class.java)
            // Only undo our own change. If the volume no longer reads as what
            // we set, the user moved it while the alarm rang and that choice
            // outranks the level they had beforehand.
            if (audio.getStreamVolume(AudioManager.STREAM_ALARM) != forced) return
            audio.setStreamVolume(AudioManager.STREAM_ALARM, previous, 0)
        } catch (error: Exception) {
            Log.w(TAG, "Alarm ses kanalı geri yüklenemedi", error)
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
        for (step in 1..RAMP_STEPS) {
            handler.postDelayed({
                val progress = step.toFloat() / RAMP_STEPS
                val value = (RAMP_START_VOLUME + (1f - RAMP_START_VOLUME) * progress)
                    .coerceIn(RAMP_START_VOLUME, 1f)
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        ringtone?.volume = value
                    }
                    fallbackPlayer?.setVolume(value, value)
                } catch (_: Exception) {
                    // Alarm bu sırada kapatılmış olabilir.
                }
            }, step * RAMP_STEP_MILLIS)
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
        restoreAlarmStreamVolume()
        vibrator?.cancel()
        vibrator = null
        releaseWakeLock()
        stopForeground(STOP_FOREGROUND_REMOVE)
    }

    private fun createChannel() {
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
