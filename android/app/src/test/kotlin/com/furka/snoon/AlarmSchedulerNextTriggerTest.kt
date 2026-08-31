package com.furka.snoon

import org.json.JSONArray
import org.json.JSONObject
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test
import java.time.LocalDateTime
import java.time.ZoneId
import java.util.TimeZone

/**
 * Mirrors `test/alarm_models_test.dart` case for case.
 *
 * [AlarmScheduler.nextTrigger] is the implementation that actually decides when
 * an alarm fires after a reboot or after the previous occurrence, while
 * `AlarmItem.nextOccurrence` only drives the Flutter UI. The two must agree, so
 * every scheduling rule is asserted on both sides.
 */
class AlarmSchedulerNextTriggerTest {
    private lateinit var originalZone: TimeZone

    @Before
    fun captureZone() {
        originalZone = TimeZone.getDefault()
        useZone("Europe/Istanbul")
    }

    @After
    fun restoreZone() {
        TimeZone.setDefault(originalZone)
    }

    @Test
    fun rangeAlarmReturnsTheNextIntervalMinute() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            rangeEndMinutes = 7 * 60 + 30,
        )

        assertEquals(
            at(2026, 8, 16, 7, 15),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 7, 12)),
        )
    }

    @Test
    fun excludedGroupDateIsSkipped() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            excludedDates = listOf("2026-08-17"),
        )

        assertEquals(
            at(2026, 8, 18, 7, 0),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 8, 0)),
        )
    }

    @Test
    fun alarmAndGroupShiftsAreAppliedTogether() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            alarmShiftDate = "2026-08-16",
            alarmShiftMinutes = 15,
            groupShiftDate = "2026-08-16",
            groupShiftMinutes = 30,
        )

        assertEquals(
            at(2026, 8, 16, 7, 45),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 6, 0)),
        )
    }

    @Test
    fun noOccurrenceBeforeTheHolidayPauseEnds() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            pausedUntil = "2026-08-20",
        )

        assertEquals(
            at(2026, 8, 21, 7, 0),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 6, 0)),
        )
    }

    @Test
    fun theLongestOfTheAlarmAndGroupPausesWins() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            pausedUntil = "2026-08-20",
            groupPausedUntil = "2026-08-25",
        )

        assertEquals(
            at(2026, 8, 26, 7, 0),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 6, 0)),
        )
    }

    @Test
    fun aPastOneShotAlarmIsNotRescheduled() {
        val record = record(hour = 7, oneShotDate = "2026-08-16")

        assertNull(AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 8, 0)))
    }

    @Test
    fun aFutureOneShotAlarmIsScheduledExactlyOnce() {
        val record = record(hour = 9, minute = 15, oneShotDate = "2026-09-02")

        assertEquals(
            at(2026, 9, 2, 9, 15),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 0, 0)),
        )
        assertNull(AlarmScheduler.nextTrigger(record, at(2026, 9, 2, 9, 16)))
    }

    @Test
    fun aCorruptZeroIntervalDoesNotHang() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            rangeEndMinutes = 7 * 60 + 5,
            intervalMinutes = 0,
        )

        assertEquals(
            at(2026, 8, 16, 7, 3),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 7, 2)),
        )
    }

    @Test
    fun theCorrectNextDayIsPickedFromSeveralRepeatDays() {
        val record = record(hour = 7, minute = 30, repeatDays = listOf(1, 3, 5))

        assertEquals(
            at(2026, 8, 19, 7, 30),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 17, 8, 0)),
        )
        assertEquals(
            at(2026, 8, 19, 7, 30),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 19, 6, 0)),
        )
        assertEquals(
            at(2026, 8, 24, 7, 30),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 21, 8, 0)),
        )
    }

    @Test
    fun aRangeIncludesItsEndMinute() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            rangeEndMinutes = 7 * 60 + 30,
        )

        assertEquals(
            at(2026, 8, 16, 7, 30),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 7, 29)),
        )
        assertEquals(
            at(2026, 8, 17, 7, 0),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 7, 30)),
        )
    }

    @Test
    fun aRangeCrossingMidnightContinuesIntoTheNextDay() {
        val record = record(
            hour = 23,
            minute = 55,
            repeatDays = listOf(1),
            rangeEndMinutes = 24 * 60 + 5,
        )

        assertEquals(
            at(2026, 8, 18, 0, 0),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 17, 23, 56)),
        )
    }

    @Test
    fun afterMidnightThePreviousDayRangeStillRuns() {
        val record = record(
            hour = 23,
            minute = 55,
            repeatDays = listOf(1),
            rangeEndMinutes = 24 * 60 + 15,
        )

        assertEquals(
            at(2026, 8, 18, 0, 5),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 18, 0, 1)),
        )
    }

    @Test
    fun aSkippedDateIsPassedOver() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            skippedDates = listOf("2026-08-17"),
        )

        assertEquals(
            at(2026, 8, 18, 7, 0),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 8, 0)),
        )
    }

    /**
     * A range end at or before the start is not a range for `AlarmItem.isRange`,
     * so the Dart side still reports one occurrence at the start minute. Without
     * the coercion in [AlarmScheduler.nextTrigger] the candidate loop never ran
     * and the alarm silently never fired.
     */
    @Test
    fun aRangeEndBeforeTheStartStillFiresOnceAtTheStart() {
        val record = record(
            hour = 7,
            repeatDays = listOf(1, 2, 3, 4, 5, 6, 7),
            rangeEndMinutes = 6 * 60,
        )

        assertEquals(
            at(2026, 8, 16, 7, 0),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 6, 0)),
        )
    }

    /**
     * With neither repeat days nor a one-shot date the Dart side falls through
     * to the first candidate after `now`, so the record must not be treated as
     * a one-shot for the literal string "null".
     */
    @Test
    fun anAlarmWithoutRepeatDaysOrAOneShotDateStillFires() {
        val record = record(hour = 7)

        assertEquals(
            at(2026, 8, 16, 7, 0),
            AlarmScheduler.nextTrigger(record, at(2026, 8, 16, 6, 0)),
        )
    }

    /**
     * The shift moves the wall-clock minute, not the absolute instant. Berlin
     * springs forward at 02:00 on 2026-03-29, so 01:30 shifted by two hours is
     * 03:30 local; adding two absolute hours would land on 04:30 instead.
     */
    @Test
    fun aShiftAcrossADaylightSavingChangeKeepsTheWallClockTime() {
        useZone("Europe/Berlin")
        val record = record(
            hour = 1,
            minute = 30,
            repeatDays = listOf(7),
            alarmShiftDate = "2026-03-29",
            alarmShiftMinutes = 120,
        )

        assertEquals(
            at(2026, 3, 29, 3, 30),
            AlarmScheduler.nextTrigger(record, at(2026, 3, 29, 0, 0)),
        )
    }

    private fun useZone(id: String) {
        TimeZone.setDefault(TimeZone.getTimeZone(id))
    }

    private fun at(year: Int, month: Int, day: Int, hour: Int, minute: Int): Long =
        LocalDateTime.of(year, month, day, hour, minute)
            .atZone(ZoneId.systemDefault())
            .toInstant()
            .toEpochMilli()

    private fun record(
        hour: Int = 7,
        minute: Int = 0,
        repeatDays: List<Int> = emptyList(),
        oneShotDate: String? = null,
        rangeEndMinutes: Int? = null,
        intervalMinutes: Int = 5,
        pausedUntil: String? = null,
        groupPausedUntil: String? = null,
        excludedDates: List<String> = emptyList(),
        skippedDates: List<String> = emptyList(),
        alarmShiftDate: String? = null,
        alarmShiftMinutes: Int = 0,
        groupShiftDate: String? = null,
        groupShiftMinutes: Int = 0,
    ): JSONObject = JSONObject().apply {
        put("id", "test-alarm")
        put("label", "Test")
        put("enabled", true)
        put("hour", hour)
        put("minute", minute)
        put("repeatDays", JSONArray(repeatDays))
        put("oneShotDate", oneShotDate ?: JSONObject.NULL)
        put("rangeEndMinutes", rangeEndMinutes ?: JSONObject.NULL)
        put("intervalMinutes", intervalMinutes)
        put("pausedUntil", pausedUntil ?: JSONObject.NULL)
        put("groupPausedUntil", groupPausedUntil ?: JSONObject.NULL)
        put("excludedDates", JSONArray(excludedDates))
        put("skippedDates", JSONArray(skippedDates))
        put("alarmShiftDate", alarmShiftDate ?: JSONObject.NULL)
        put("alarmShiftMinutes", alarmShiftMinutes)
        put("groupShiftDate", groupShiftDate ?: JSONObject.NULL)
        put("groupShiftMinutes", groupShiftMinutes)
    }
}
