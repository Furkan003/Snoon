package com.furka.snoon

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import org.json.JSONObject

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val strings = LocaleHelper.wrap(context)
        val raw = intent.getStringExtra("recordJson") ?: return
        val record = try {
            JSONObject(raw)
        } catch (_: Exception) {
            return
        }
        val kind = intent.getStringExtra("kind") ?: AlarmScheduler.KIND_MAIN
        val occurrenceToken = intent.getLongExtra("occurrenceToken", record.optLong("triggerAtMillis", 0L))
        val snoozeCount = intent.getIntExtra("snoozeCount", 0)

        if (kind == AlarmScheduler.KIND_SNOOZE) {
            AlarmScheduler.clearFiredSnooze(context, record.optString("id"))
            SnoozeNotification.cancel(context, record.optString("id"))
        }

        if (kind == AlarmScheduler.KIND_PRE || kind == AlarmScheduler.KIND_GENTLE) {
            showUpcomingNotification(context, record, kind)
            return
        }

        if (record.optBoolean("isSleepReminder", false)) {
            showSleepReminder(context, record)
            AlarmScheduler.advanceAfterFire(context, record, occurrenceToken)
            return
        }

        HistoryStore.add(
            context,
            record.optString("id", "alarm"),
            record.optString("label", strings.getString(R.string.alarm_default)),
            "rang",
            disableAlarm = kind == AlarmScheduler.KIND_MAIN &&
                AlarmScheduler.disablesAfterCurrentFire(record),
        )

        val serviceIntent = Intent(context, AlarmSoundService::class.java).apply {
            action = AlarmSoundService.ACTION_START
            putExtra("recordJson", record.toString())
            putExtra("kind", kind)
            putExtra("occurrenceToken", occurrenceToken)
            putExtra("snoozeCount", snoozeCount)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }

        // When the app is already visible Android may keep a full-screen
        // notification as a heads-up banner. Open the dedicated ringing
        // activity directly; the notification remains the lock-screen and
        // background fallback on devices that restrict activity launches.
        try {
            context.startActivity(
                Intent(context, AlarmRingingActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
                    putExtra("recordJson", record.toString())
                    putExtra("kind", kind)
                    putExtra("occurrenceToken", occurrenceToken)
                    putExtra("snoozeCount", snoozeCount)
                },
            )
        } catch (_: Exception) {
            // The foreground notification still exposes the ringing screen.
        }

        if (kind == AlarmScheduler.KIND_MAIN) {
            AlarmScheduler.advanceAfterFire(context, record, occurrenceToken)
        } else if (
            kind == AlarmScheduler.KIND_SNOOZE &&
            !record.isNull("rangeEndMinutes") &&
            !record.optBoolean("deleteAfterRinging", false)
        ) {
            AlarmScheduler.advanceAfterFire(context, record, occurrenceToken)
        }
    }

    private fun showUpcomingNotification(context: Context, record: JSONObject, kind: String) {
        val strings = LocaleHelper.wrap(context)
        val manager = context.getSystemService(NotificationManager::class.java)
        val channelId = "upcoming_alarm"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            manager.createNotificationChannel(
                NotificationChannel(
                    channelId,
                    strings.getString(R.string.upcoming_channel),
                    NotificationManager.IMPORTANCE_DEFAULT,
                ).apply {
                    description = strings.getString(R.string.upcoming_channel_description)
                },
            )
        }
        val openIntent = PendingIntent.getActivity(
            context,
            record.optString("id").hashCode(),
            Intent(context, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val gentle = kind == AlarmScheduler.KIND_GENTLE
        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle(
                strings.getString(
                    if (gentle) R.string.good_morning else R.string.upcoming_alarm,
                ),
            )
            .setContentText(
                if (gentle) {
                    strings.getString(
                        R.string.gentle_start,
                        record.optString("label", strings.getString(R.string.alarm_default)),
                    )
                } else {
                    strings.getString(
                        R.string.will_ring_soon,
                        record.optString("label", strings.getString(R.string.alarm_default)),
                    )
                },
            )
            .setAutoCancel(true)
            .setContentIntent(openIntent)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()
        manager.notify((record.optString("id") + kind).hashCode(), notification)
    }

    private fun showSleepReminder(context: Context, record: JSONObject) {
        val strings = LocaleHelper.wrap(context)
        val manager = context.getSystemService(NotificationManager::class.java)
        val channelId = "sleep_reminder"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            manager.createNotificationChannel(
                NotificationChannel(
                    channelId,
                    strings.getString(R.string.sleep_channel),
                    NotificationManager.IMPORTANCE_DEFAULT,
                ).apply {
                    description = strings.getString(R.string.sleep_channel_description)
                },
            )
        }
        val openIntent = PendingIntent.getActivity(
            context,
            record.optString("id").hashCode(),
            Intent(context, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle(strings.getString(R.string.prepare_for_sleep))
            .setContentText(
                strings.getString(
                    R.string.bedtime_remaining,
                    record.optInt("windDownMinutes", 30),
                ),
            )
            .setSubText("Snoon")
            .setAutoCancel(true)
            .setContentIntent(openIntent)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()
        manager.notify(record.optString("id").hashCode(), notification)
    }
}
