package com.furka.snoon

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId

object AlarmScheduler {
    const val KIND_MAIN = "main"
    const val KIND_PRE = "pre"
    const val KIND_GENTLE = "gentle"
    const val KIND_BACKUP = "backup"
    const val KIND_SNOOZE = "snooze"
    const val KIND_TIMER = "timer"

    // Kept for upgrade compatibility: changing this key would orphan alarms
    // created by early Snoon/Saat2 builds.
    private const val PREFS = "saat2_native_alarms"
    private const val RECORDS = "records"
    private const val SNOOZE_TRIGGER = "snoozeTriggerAtMillis"
    private const val SNOOZE_COUNT = "pendingSnoozeCount"

    fun schedule(
        context: Context,
        record: JSONObject,
        persist: Boolean = true,
        preserveCurrentBackup: Boolean = false,
    ) {
        val id = record.getString("id")
        val previous = getRecord(context, id)
        val previousSnooze = previous?.optLong(SNOOZE_TRIGGER, 0L) ?: 0L
        if (previousSnooze > System.currentTimeMillis()) {
            record.put(SNOOZE_TRIGGER, previousSnooze)
            record.put(SNOOZE_COUNT, previous?.optInt(SNOOZE_COUNT, 1) ?: 1)
        }
        cancelStable(context, id)
        if (!preserveCurrentBackup && previous != null) {
            cancelBackup(context, id, previous.optLong("triggerAtMillis", 0L))
        }

        val trigger = when {
            record.has("fixedTriggerAtMillis") -> record.optLong("fixedTriggerAtMillis", 0L)
            record.optLong("triggerAtMillis", 0L) > System.currentTimeMillis() ->
                record.optLong("triggerAtMillis")
            else -> nextTrigger(record, System.currentTimeMillis()) ?: 0L
        }
        if (trigger <= System.currentTimeMillis()) {
            if (persist) removeRecord(context, id)
            return
        }
        record.put("triggerAtMillis", trigger)
        if (persist) putRecord(context, record)

        if (previousSnooze > System.currentTimeMillis() && !record.isNull("rangeEndMinutes")) {
            return
        }

        setExact(context, trigger, pendingIntent(context, record, KIND_MAIN, trigger))

        if (record.optBoolean("fixed", false)) return

        val preMinutes = record.optInt("preNotificationMinutes", 0)
        if (preMinutes > 0) {
            val preTrigger = trigger - preMinutes * 60_000L
            if (preTrigger > System.currentTimeMillis()) {
                setExact(context, preTrigger, pendingIntent(context, record, KIND_PRE, trigger))
            }
        }
        if (
            record.optBoolean("morningRoutine", false) &&
            record.isNull("rangeEndMinutes")
        ) {
            val gentleTrigger = trigger - record.optInt("gentleReminderMinutes", 10) * 60_000L
            if (gentleTrigger > System.currentTimeMillis()) {
                setExact(context, gentleTrigger, pendingIntent(context, record, KIND_GENTLE, trigger))
            }
            val backupTrigger = trigger + record.optInt("backupAlarmMinutes", 10) * 60_000L
            setExact(context, backupTrigger, pendingIntent(context, record, KIND_BACKUP, trigger))
        }
    }

    fun scheduleFixed(context: Context, record: JSONObject, trigger: Long, kind: String) {
        record.put("fixed", true)
        record.put("fixedTriggerAtMillis", trigger)
        record.put("triggerAtMillis", trigger)
        record.put("deliveryKind", kind)
        schedule(context, record, persist = kind == KIND_TIMER)
    }

    fun scheduleSnooze(
        context: Context,
        record: JSONObject,
        minutes: Int,
        snoozeCount: Int,
    ): Long {
        val trigger = System.currentTimeMillis() + minutes * 60_000L
        val intent = pendingIntent(context, record, KIND_SNOOZE, trigger, snoozeCount)
        setExact(context, trigger, intent)
        val stored = getRecord(context, record.getString("id"))
            ?: JSONObject(record.toString())
        stored.put(SNOOZE_TRIGGER, trigger)
        stored.put(SNOOZE_COUNT, snoozeCount)
        putRecord(context, stored)
        return trigger
    }

    fun suspendRangeUntilSnooze(context: Context, record: JSONObject) {
        if (!record.isNull("rangeEndMinutes") && !record.optBoolean("deleteAfterRinging", false)) {
            cancelStable(context, record.getString("id"))
        }
    }

    fun clearFiredSnooze(context: Context, id: String) {
        val stored = getRecord(context, id) ?: return
        stored.remove(SNOOZE_TRIGGER)
        stored.remove(SNOOZE_COUNT)
        if (
            !stored.optBoolean("fixed", false) &&
            nextTrigger(stored, System.currentTimeMillis() + 10_000L) == null
        ) {
            removeRecord(context, id)
        } else {
            putRecord(context, stored)
        }
    }

    fun advanceAfterFire(context: Context, record: JSONObject, occurrenceToken: Long) {
        if (record.optBoolean("fixed", false)) {
            removeRecord(context, record.getString("id"))
            return
        }
        if (record.optBoolean("deleteAfterRinging", false)) {
            val id = record.getString("id")
            cancelStable(context, id)
            cancelSnooze(context, id)
            cancelBackup(context, id, occurrenceToken)
            removeRecord(context, id)
            HistoryStore.add(
                context,
                id,
                record.optString("label", "Alarm"),
                "Çaldıktan sonra silindi",
                disableAlarm = true,
            )
            return
        }
        val next = nextTrigger(record, System.currentTimeMillis() + 10_000L)
        if (next == null) {
            removeRecord(context, record.getString("id"))
            HistoryStore.add(
                context,
                record.getString("id"),
                record.optString("label", "Alarm"),
                "Tek sefer tamamlandı",
                disableAlarm = true,
            )
            return
        }
        record.put("triggerAtMillis", next)
        schedule(context, record, persist = true, preserveCurrentBackup = true)
    }

    fun cancel(context: Context, id: String) {
        val record = getRecord(context, id)
        cancelStable(context, id)
        cancelSnooze(context, id)
        if (record != null) cancelBackup(context, id, record.optLong("triggerAtMillis", 0L))
        removeRecord(context, id)
    }

    fun cancelSnooze(context: Context, id: String) {
        cancelStableKind(context, id, KIND_SNOOZE)
        clearFiredSnooze(context, id)
        SnoozeNotification.cancel(context, id)
    }

    fun cancelAll(context: Context) {
        allRecords(context).forEach { record -> cancel(context, record.getString("id")) }
    }

    fun cancelBackup(context: Context, id: String, occurrenceToken: Long) {
        if (occurrenceToken <= 0L) return
        val alarmManager = context.getSystemService(AlarmManager::class.java)
        alarmManager.cancel(
            pendingIntentForCancel(context, id, KIND_BACKUP, occurrenceToken),
        )
    }

    fun rescheduleAll(context: Context) {
        allRecords(context).forEach { record ->
            val snoozeTrigger = record.optLong(SNOOZE_TRIGGER, 0L)
            if (snoozeTrigger > System.currentTimeMillis()) {
                setExact(
                    context,
                    snoozeTrigger,
                    pendingIntent(
                        context,
                        record,
                        KIND_SNOOZE,
                        snoozeTrigger,
                        record.optInt(SNOOZE_COUNT, 1),
                    ),
                )
                SnoozeNotification.show(
                    context,
                    record,
                    record.optInt("snoozeMinutes", 5).coerceAtLeast(1),
                    snoozeTrigger,
                    showToast = false,
                )
                if (!record.isNull("rangeEndMinutes")) return@forEach
            } else if (snoozeTrigger > 0L) {
                record.remove(SNOOZE_TRIGGER)
                record.remove(SNOOZE_COUNT)
                putRecord(context, record)
            }
            if (record.optBoolean("fixed", false)) {
                val trigger = record.optLong("fixedTriggerAtMillis", 0L)
                if (trigger > System.currentTimeMillis()) schedule(context, record)
                else removeRecord(context, record.getString("id"))
            } else {
                record.remove("triggerAtMillis")
                schedule(context, record)
            }
        }
    }

    fun nextTrigger(record: JSONObject, afterMillis: Long): Long? {
        val zone = ZoneId.systemDefault()
        val after = Instant.ofEpochMilli(afterMillis).atZone(zone)
        val afterDate = after.toLocalDate()
        val days = record.optJSONArray("repeatDays") ?: JSONArray()
        val oneShotDate = record.optString("oneShotDate", "")
        val excluded = record.optJSONArray("excludedDates") ?: JSONArray()
        val excludedSet = buildSet {
            for (index in 0 until excluded.length()) add(excluded.optString(index))
        }
        val alarmPause = parseDate(record.optString("pausedUntil", ""))
        val groupPause = parseDate(record.optString("groupPausedUntil", ""))
        val pauseUntil = listOfNotNull(alarmPause, groupPause).maxOrNull()
        val startMinutes = record.optInt("hour", 7) * 60 + record.optInt("minute", 0)
        val endMinutes = if (record.isNull("rangeEndMinutes")) {
            startMinutes
        } else {
            record.optInt("rangeEndMinutes", startMinutes)
        }
        val interval = record.optInt("intervalMinutes", 5).coerceAtLeast(1)

        for (offset in 0..370) {
            val date = afterDate.plusDays(offset.toLong())
            if (pauseUntil != null && !date.isAfter(pauseUntil)) continue
            if (excludedSet.contains(date.toString())) continue
            if (days.length() > 0) {
                var matches = false
                for (index in 0 until days.length()) {
                    if (days.optInt(index) == date.dayOfWeek.value) matches = true
                }
                if (!matches) continue
            } else if (oneShotDate.isNotEmpty() && date.toString() != oneShotDate) {
                continue
            }

            var shift = 0
            if (record.optString("alarmShiftDate", "") == date.toString()) {
                shift += record.optInt("alarmShiftMinutes", 0)
            }
            if (record.optString("groupShiftDate", "") == date.toString()) {
                shift += record.optInt("groupShiftMinutes", 0)
            }
            var minute = startMinutes
            while (minute <= endMinutes) {
                val candidate = date.atStartOfDay(zone)
                    .plusMinutes((minute + shift).toLong())
                    .toInstant()
                    .toEpochMilli()
                if (candidate > afterMillis) return candidate
                minute += interval
            }
        }
        return null
    }

    private fun parseDate(value: String): LocalDate? = try {
        if (value.isBlank()) null else LocalDate.parse(value.take(10))
    } catch (_: Exception) {
        null
    }

    private fun setExact(context: Context, trigger: Long, operation: PendingIntent) {
        val manager = context.getSystemService(AlarmManager::class.java)
        try {
            val showIntent = PendingIntent.getActivity(
                context,
                operation.hashCode(),
                Intent(context, MainActivity::class.java),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            manager.setAlarmClock(AlarmManager.AlarmClockInfo(trigger, showIntent), operation)
        } catch (_: SecurityException) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, trigger, operation)
            } else {
                manager.set(AlarmManager.RTC_WAKEUP, trigger, operation)
            }
        }
    }

    private fun pendingIntent(
        context: Context,
        record: JSONObject,
        kind: String,
        occurrenceToken: Long,
        snoozeCount: Int = 0,
    ): PendingIntent {
        val id = record.getString("id")
        val actionToken = if (kind == KIND_BACKUP) {
            occurrenceToken.toString()
        } else {
            "stable"
        }
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            action = "com.furka.snoon.ALARM.$kind.$id.$actionToken"
            putExtra("recordJson", record.toString())
            putExtra("kind", kind)
            putExtra("occurrenceToken", occurrenceToken)
            putExtra("snoozeCount", snoozeCount)
        }
        return PendingIntent.getBroadcast(
            context,
            requestCode(id, kind, occurrenceToken),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun pendingIntentForCancel(
        context: Context,
        id: String,
        kind: String,
        occurrenceToken: Long,
    ): PendingIntent {
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            action = "com.furka.snoon.ALARM.$kind.$id.$occurrenceToken"
        }
        return PendingIntent.getBroadcast(
            context,
            requestCode(id, kind, occurrenceToken),
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
        ) ?: PendingIntent.getBroadcast(
            context,
            requestCode(id, kind, occurrenceToken),
            intent,
            PendingIntent.FLAG_CANCEL_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun cancelStable(context: Context, id: String) {
        listOf(KIND_MAIN, KIND_PRE, KIND_GENTLE).forEach { kind ->
            cancelStableKind(context, id, kind)
        }
    }

    private fun cancelStableKind(context: Context, id: String, kind: String) {
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            action = "com.furka.snoon.ALARM.$kind.$id.stable"
        }
        val operation = PendingIntent.getBroadcast(
            context,
            requestCode(id, kind, 0L),
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
        ) ?: return
        context.getSystemService(AlarmManager::class.java).cancel(operation)
    }

    private fun requestCode(id: String, kind: String, token: Long): Int {
        val effectiveToken = if (kind == KIND_BACKUP) token else 0L
        return "$id|$kind|$effectiveToken".hashCode() and 0x7fffffff
    }

    private fun prefs(context: Context) = storageContext(context)
        .getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    private fun storageContext(context: Context): Context {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N || context.isDeviceProtectedStorage) {
            return context
        }
        val deviceContext = context.createDeviceProtectedStorageContext()
        try {
            deviceContext.moveSharedPreferencesFrom(context, PREFS)
        } catch (_: Exception) {
            // Direct Boot sırasında kimlik bilgisi korumalı alan henüz açılamayabilir.
        }
        return deviceContext
    }

    private fun recordMap(context: Context): JSONObject = try {
        JSONObject(prefs(context).getString(RECORDS, "{}") ?: "{}")
    } catch (_: Exception) {
        JSONObject()
    }

    private fun putRecord(context: Context, record: JSONObject) {
        val records = recordMap(context)
        records.put(record.getString("id"), record)
        prefs(context).edit().putString(RECORDS, records.toString()).apply()
    }

    private fun getRecord(context: Context, id: String): JSONObject? =
        recordMap(context).optJSONObject(id)

    private fun removeRecord(context: Context, id: String) {
        val records = recordMap(context)
        records.remove(id)
        prefs(context).edit().putString(RECORDS, records.toString()).apply()
    }

    private fun allRecords(context: Context): List<JSONObject> {
        val records = recordMap(context)
        return records.keys().asSequence().mapNotNull(records::optJSONObject).toList()
    }
}
