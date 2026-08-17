package com.furka.snoon

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.core.app.NotificationCompat
import org.json.JSONObject
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter

object SnoozeNotification {
    private const val CHANNEL_ID = "snoozed_alarm"

    fun show(
        context: Context,
        record: JSONObject,
        minutes: Int,
        triggerAtMillis: Long,
        showToast: Boolean = true,
    ) {
        val strings = LocaleHelper.wrap(context)
        val id = record.optString("id", "alarm")
        val label = record.optString("label", strings.getString(R.string.alarm_default))
        val triggerTime = Instant.ofEpochMilli(triggerAtMillis)
            .atZone(ZoneId.systemDefault())
            .format(DateTimeFormatter.ofPattern("HH:mm"))
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                strings.getString(R.string.snoozed_channel),
                NotificationManager.IMPORTANCE_DEFAULT,
            ).apply {
                description = strings.getString(R.string.snoozed_channel_description)
                setSound(null, null)
                enableVibration(false)
            },
        )

        val openApp = PendingIntent.getActivity(
            context,
            notificationId(id),
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val cancelSnooze = PendingIntent.getBroadcast(
            context,
            notificationId(id) xor 0x55AA,
            Intent(context, AlarmActionReceiver::class.java).apply {
                action = AlarmActionReceiver.ACTION_CANCEL_SNOOZE
                putExtra("recordJson", record.toString())
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle(strings.getString(R.string.snoozed_minutes, minutes))
            .setContentText(strings.getString(R.string.rings_again_at, label, triggerTime))
            .setSubText("Snoon")
            .setContentIntent(openApp)
            .setAutoCancel(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .addAction(
                android.R.drawable.ic_menu_close_clear_cancel,
                strings.getString(R.string.cancel_snooze),
                cancelSnooze,
            )
            .build()
        manager.notify(notificationId(id), notification)
        if (showToast) {
            Toast.makeText(
                context,
                strings.getString(R.string.snooze_toast, minutes, triggerTime),
                Toast.LENGTH_LONG,
            ).show()
        }
    }

    fun cancel(context: Context, id: String) {
        context.getSystemService(NotificationManager::class.java)
            .cancel(notificationId(id))
    }

    private fun notificationId(id: String): Int =
        "snooze-status|$id".hashCode() and 0x7fffffff
}
