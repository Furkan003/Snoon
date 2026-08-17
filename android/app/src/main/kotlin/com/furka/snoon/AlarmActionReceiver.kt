package com.furka.snoon

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import org.json.JSONObject

class AlarmActionReceiver : BroadcastReceiver() {
    companion object {
        const val ACTION_SNOOZE = "com.furka.snoon.ACTION_SNOOZE"
        const val ACTION_DISMISS = "com.furka.snoon.ACTION_DISMISS"
        const val ACTION_CANCEL_SNOOZE = "com.furka.snoon.ACTION_CANCEL_SNOOZE"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val strings = LocaleHelper.wrap(context)
        val record = try {
            JSONObject(intent.getStringExtra("recordJson") ?: return)
        } catch (_: Exception) {
            return
        }
        val occurrenceToken = intent.getLongExtra(
            "occurrenceToken",
            record.optLong("triggerAtMillis", 0L),
        )
        val snoozeCount = intent.getIntExtra("snoozeCount", 0)
        val kind = intent.getStringExtra("kind") ?: AlarmScheduler.KIND_MAIN

        when (intent.action) {
            ACTION_SNOOZE -> {
                val maxSnoozes = record.optInt("maxSnoozes", 3)
                if (record.optBoolean("isTimer", false) || snoozeCount >= maxSnoozes) {
                    return
                }
                AlarmScheduler.cancelBackup(
                    context,
                    record.optString("id"),
                    occurrenceToken,
                )
                AlarmScheduler.suspendRangeUntilSnooze(context, record)
                val minutes = record.optInt("snoozeMinutes", 5).coerceAtLeast(1)
                val trigger = AlarmScheduler.scheduleSnooze(
                    context,
                    record,
                    minutes,
                    snoozeCount + 1,
                )
                SnoozeNotification.show(context, record, minutes, trigger)
                HistoryStore.add(
                    context,
                    record.optString("id", "alarm"),
                    record.optString("label", strings.getString(R.string.alarm_default)),
                    "snoozed",
                )
                stopRinging(context)
            }

            ACTION_CANCEL_SNOOZE -> {
                val id = record.optString("id")
                AlarmScheduler.cancelSnooze(context, id)
                AlarmScheduler.resumeRangeAfterCancelledSnooze(context, record)
                HistoryStore.add(
                    context,
                    id,
                    record.optString("label", strings.getString(R.string.alarm_default)),
                    "snooze_cancelled",
                )
                Toast.makeText(
                    context,
                    strings.getString(R.string.snooze_cancelled),
                    Toast.LENGTH_SHORT,
                )
                    .show()
            }

            ACTION_DISMISS -> {
                if (
                    !record.optBoolean("isTimer", false) &&
                    record.optString("dismissTask", "none") != "none"
                ) {
                    openRingingScreen(
                        context,
                        record,
                        kind,
                        occurrenceToken,
                        snoozeCount,
                    )
                    return
                }
                AlarmScheduler.cancelBackup(
                    context,
                    record.optString("id"),
                    occurrenceToken,
                )
                HistoryStore.add(
                    context,
                    record.optString("id", "alarm"),
                    record.optString("label", strings.getString(R.string.alarm_default)),
                    "dismissed",
                )
                stopRinging(context)
            }
        }
    }

    private fun stopRinging(context: Context) {
        context.stopService(Intent(context, AlarmSoundService::class.java))
        context.getSystemService(NotificationManager::class.java)
            .cancel(AlarmSoundService.NOTIFICATION_ID)
        AlarmRingingActivity.finishIfVisible()
    }

    private fun openRingingScreen(
        context: Context,
        record: JSONObject,
        kind: String,
        occurrenceToken: Long,
        snoozeCount: Int,
    ) {
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
    }
}
