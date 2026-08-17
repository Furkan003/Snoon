package com.furka.snoon

import android.Manifest
import android.app.AlarmManager
import android.app.NotificationManager
import android.content.Intent
import android.content.pm.PackageManager
import android.media.AudioManager
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.furka.snoon/alarm"
        private const val RINGTONE_REQUEST = 8102
        private const val NOTIFICATION_REQUEST = 8103
        private const val BACKUP_EXPORT_REQUEST = 8104
        private const val BACKUP_IMPORT_REQUEST = 8105
    }

    private var ringtoneResult: MethodChannel.Result? = null
    private var notificationPermissionResult: MethodChannel.Result? = null
    private var backupExportResult: MethodChannel.Result? = null
    private var backupImportResult: MethodChannel.Result? = null
    private var backupJson: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setApplicationLocale" -> {
                        val languageCode = call.argument<String>("languageCode") ?: "en"
                        LocaleHelper.set(this, languageCode)
                        result.success(null)
                    }
                    "scheduleAlarm" -> {
                        val record = JSONObject(call.arguments as Map<*, *>)
                        AlarmScheduler.schedule(this, record)
                        result.success(null)
                    }
                    "cancelAlarm" -> {
                        val id = call.argument<String>("id") ?: ""
                        AlarmScheduler.cancel(this, id)
                        result.success(null)
                    }
                    "cancelAll" -> {
                        AlarmScheduler.cancelAll(this)
                        result.success(null)
                    }
                    "canScheduleExactAlarms" -> {
                        val manager = getSystemService(AlarmManager::class.java)
                        result.success(
                            Build.VERSION.SDK_INT < Build.VERSION_CODES.S || manager.canScheduleExactAlarms(),
                        )
                    }
                    "requestExactAlarmPermission" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            startActivity(
                                Intent(
                                    Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,
                                    Uri.parse("package:$packageName"),
                                ),
                            )
                        }
                        result.success(null)
                    }
                    "notificationsGranted" -> {
                        result.success(
                            Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ||
                                checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
                                PackageManager.PERMISSION_GRANTED,
                        )
                    }
                    "alarmNotificationsOperational" -> {
                        val notificationsEnabled =
                            NotificationManagerCompat.from(this).areNotificationsEnabled()
                        val channelsEnabled = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            val manager = getSystemService(NotificationManager::class.java)
                            listOf("ringing_alarm", "snoozed_alarm").all { channelId ->
                                manager.getNotificationChannel(channelId)?.importance !=
                                    NotificationManager.IMPORTANCE_NONE
                            }
                        } else {
                            true
                        }
                        result.success(notificationsEnabled && channelsEnabled)
                    }
                    "requestNotificationPermission" -> {
                        if (
                            Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
                            PackageManager.PERMISSION_GRANTED
                        ) {
                            if (notificationPermissionResult != null) {
                                result.error("permission_busy", "Bildirim izni zaten isteniyor", null)
                                return@setMethodCallHandler
                            }
                            notificationPermissionResult = result
                            requestPermissions(
                                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                                NOTIFICATION_REQUEST,
                            )
                        } else {
                            result.success(true)
                        }
                    }
                    "canUseFullScreenIntent" -> {
                        val manager = getSystemService(NotificationManager::class.java)
                        result.success(
                            Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE ||
                                manager.canUseFullScreenIntent(),
                        )
                    }
                    "requestFullScreenIntentPermission" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                            startActivity(
                                Intent(
                                    Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
                                    Uri.parse("package:$packageName"),
                                ),
                            )
                        }
                        result.success(null)
                    }
                    "alarmStreamAudible" -> {
                        val audio = getSystemService(AudioManager::class.java)
                        result.success(audio.getStreamVolume(AudioManager.STREAM_ALARM) > 0)
                    }
                    "openSoundSettings" -> {
                        startActivity(Intent(Settings.ACTION_SOUND_SETTINGS))
                        result.success(null)
                    }
                    "batteryOptimizationDisabled" -> {
                        val power = getSystemService(PowerManager::class.java)
                        result.success(power.isIgnoringBatteryOptimizations(packageName))
                    }
                    "openBatterySettings" -> {
                        startActivity(Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
                        result.success(null)
                    }
                    "openAppSettings" -> {
                        startActivity(
                            Intent(
                                Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                                Uri.parse("package:$packageName"),
                            ),
                        )
                        result.success(null)
                    }
                    "openNotificationSettings" -> {
                        startActivity(
                            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                                putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                            },
                        )
                        result.success(null)
                    }
                    "deviceManufacturer" -> result.success(
                        "${android.os.Build.MANUFACTURER} ${android.os.Build.MODEL}".trim(),
                    )
                    "openDateTimeSettings" -> {
                        startActivity(Intent(Settings.ACTION_DATE_SETTINGS))
                        result.success(null)
                    }
                    "pickRingtone" -> pickRingtone(
                        alarm = call.argument<Boolean>("alarm") ?: true,
                        result = result,
                    )
                    "consumeHistory" -> result.success(HistoryStore.consume(this))
                    "showTestAlarm" -> {
                        val record = JSONObject(call.arguments as Map<*, *>).apply {
                            put("id", "test-${System.currentTimeMillis()}")
                            put("label", getString(R.string.test_alarm))
                            put("fixed", true)
                        }
                        AlarmScheduler.scheduleFixed(
                            this,
                            record,
                            System.currentTimeMillis() + 10_000L,
                            AlarmScheduler.KIND_MAIN,
                        )
                        result.success(null)
                    }
                    "scheduleTimer" -> {
                        val args = call.arguments as Map<*, *>
                        val record = JSONObject().apply {
                            put("id", args["id"]?.toString() ?: "timer")
                            put(
                                "label",
                                args["label"]?.toString() ?: getString(R.string.timer_default),
                            )
                            put("ringtoneUri", args["ringtoneUri"])
                            put("volume", (args["volume"] as? Number)?.toDouble() ?: 0.8)
                            put("vibrate", true)
                            put("gradualVolume", false)
                            put("autoSilenceMinutes", 10)
                            put("showOnLockScreen", true)
                            put("isTimer", true)
                            put("maxSnoozes", 0)
                            put("fixed", true)
                        }
                        val trigger = (args["triggerAtMillis"] as Number).toLong()
                        AlarmScheduler.scheduleFixed(
                            this,
                            record,
                            trigger,
                            AlarmScheduler.KIND_TIMER,
                        )
                        result.success(null)
                    }
                    "cancelTimer" -> {
                        AlarmScheduler.cancel(this, call.argument<String>("id") ?: "timer")
                        result.success(null)
                    }
                    "saveBackup" -> saveBackup(
                        json = call.argument<String>("json") ?: "",
                        result = result,
                    )
                    "pickBackup" -> pickBackup(result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun pickRingtone(alarm: Boolean, result: MethodChannel.Result) {
        if (ringtoneResult != null) {
            result.error("picker_busy", "Zil sesi seçici zaten açık", null)
            return
        }
        ringtoneResult = result
        val type = if (alarm) RingtoneManager.TYPE_ALARM else RingtoneManager.TYPE_NOTIFICATION
        val picker = Intent(RingtoneManager.ACTION_RINGTONE_PICKER).apply {
            putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, type)
            putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
            putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, false)
            putExtra(
                RingtoneManager.EXTRA_RINGTONE_DEFAULT_URI,
                RingtoneManager.getDefaultUri(type),
            )
        }
        try {
            startActivityForResult(picker, RINGTONE_REQUEST)
        } catch (error: Exception) {
            ringtoneResult = null
            result.error(
                "ringtone_picker_unavailable",
                "Bu cihazda zil sesi seçici açılamadı.",
                error.message,
            )
        }
    }

    private fun saveBackup(json: String, result: MethodChannel.Result) {
        if (backupExportResult != null) {
            result.error("backup_busy", "Yedek dosyası seçici zaten açık", null)
            return
        }
        backupExportResult = result
        backupJson = json
        try {
            startActivityForResult(
                Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    type = "application/json"
                    putExtra(Intent.EXTRA_TITLE, "snoon-yedek.json")
                },
                BACKUP_EXPORT_REQUEST,
            )
        } catch (error: Exception) {
            backupExportResult = null
            backupJson = null
            result.error("backup_export_unavailable", "Yedek konumu açılamadı", error.message)
        }
    }

    private fun pickBackup(result: MethodChannel.Result) {
        if (backupImportResult != null) {
            result.error("backup_busy", "Yedek dosyası seçici zaten açık", null)
            return
        }
        backupImportResult = result
        try {
            startActivityForResult(
                Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    type = "application/json"
                },
                BACKUP_IMPORT_REQUEST,
            )
        } catch (error: Exception) {
            backupImportResult = null
            result.error("backup_import_unavailable", "Yedek dosyası açılamadı", error.message)
        }
    }

    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            RINGTONE_REQUEST -> {
                val pending = ringtoneResult
                ringtoneResult = null
                val uri = data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI) as? Uri
                if (uri == null) {
                    pending?.success(null)
                    return
                }
                val title = try {
                    RingtoneManager.getRingtone(this, uri)?.getTitle(this)
                        ?: getString(R.string.selected_ringtone)
                } catch (_: Exception) {
                    getString(R.string.selected_ringtone)
                }
                pending?.success(mapOf("uri" to uri.toString(), "name" to title))
            }
            BACKUP_EXPORT_REQUEST -> {
                val pending = backupExportResult
                val json = backupJson
                backupExportResult = null
                backupJson = null
                val uri = data?.data
                if (resultCode != RESULT_OK || uri == null || json == null) {
                    pending?.success(false)
                    return
                }
                try {
                    val stream = contentResolver.openOutputStream(uri, "wt")
                        ?: error("Dosya yazma akışı açılamadı")
                    stream.bufferedWriter(Charsets.UTF_8).use { it.write(json) }
                    pending?.success(true)
                } catch (error: Exception) {
                    pending?.error("backup_write_failed", "Yedek yazılamadı", error.message)
                }
            }
            BACKUP_IMPORT_REQUEST -> {
                val pending = backupImportResult
                backupImportResult = null
                val uri = data?.data
                if (resultCode != RESULT_OK || uri == null) {
                    pending?.success(null)
                    return
                }
                try {
                    val stream = contentResolver.openInputStream(uri)
                        ?: error("Dosya okuma akışı açılamadı")
                    pending?.success(stream.bufferedReader(Charsets.UTF_8).use { it.readText() })
                } catch (error: Exception) {
                    pending?.error("backup_read_failed", "Yedek okunamadı", error.message)
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != NOTIFICATION_REQUEST) return
        val granted = grantResults.isNotEmpty() &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED
        notificationPermissionResult?.success(granted)
        notificationPermissionResult = null
    }
}
