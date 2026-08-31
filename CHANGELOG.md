# Changelog

All notable Snoon changes are documented here. The format follows Keep a Changelog and versions follow semantic versioning.

## [Unreleased]

### Added

- Skip the next occurrence of an alarm without disabling it, with a badge on the
  card to undo it.
- Quick alarm: wake me in 10 to 90 minutes, deleting itself after it rings.
- Statistics screen over the existing alarm history - rings, snoozes,
  dismissals, snoozes per alarm and a weekday breakdown. No new data collected.
- Per-alarm ringing volume, overriding the app-wide level.
- Easy, medium and hard math tasks for dismissal.
- Several countdowns at once, replacing the single timer. The old single-timer
  state migrates on first launch.
- The stopwatch keeps running across app restarts.
- Optional wallpaper-based colours on Android 12 and later.
- Weekly automatic backup into a folder of your choosing, written through the
  Storage Access Framework with no network involved.
- Home-screen widget and Quick Settings tile showing the next alarm. Both read
  the scheduler records directly, so they work without the Flutter engine.

- Kotlin unit tests covering `AlarmScheduler.nextTrigger`, the implementation
  that decides when an alarm actually fires, mirroring the Dart scheduling
  tests case for case. They run in CI alongside Android lint.
- Explicit Auto Backup and device-transfer rules. Alarms, groups, settings and
  the world clock are backed up; the native scheduler caches are excluded and
  rebuilt on the next launch.

### Fixed

- Backup restore errors and the default ringtone names were shown in Turkish in
  every language. Both are now localized in all seven languages.
- A range whose end was at or before its start was silently never scheduled on
  Android while the app still showed a next occurrence for it.
- Date fields sent as `null` were read as the literal string "null" by the
  Android scheduler, which could drop an alarm that had neither repeat days nor
  a one-shot date.
- Today-only shifts moved the absolute instant instead of the wall-clock
  minute, so a shifted alarm could land an hour off across a daylight saving
  change.
- A one-minute snooze read as "Snoozed for 1 minutes" in the notification and
  toast. Both native strings are now plurals in all seven languages.
- The ringing screen showed the time the alarm started and never updated, so it
  was wrong for as long as the alarm kept ringing.
- Shake-to-dismiss progress was lost when the phone was rotated, and the button
  always read 0/5 when the screen was rebuilt.
- A volume-button press set to dismiss did nothing, silently, when the alarm had
  a dismissal task; it now says which task is pending.
- Importing a backup read the whole picked file into memory with no size limit.

### Changed

- Alarms are re-registered with Android after the first frame instead of during
  start-up, so a large alarm list no longer delays launch.
- The APK no longer ships the ARB and generated localization sources as runtime
  assets, and the 1254px icon master is replaced by right-sized derivatives for
  the language screen and the adaptive launcher icon.
- Removed unused Turkish-only date and label helpers superseded by the
  localized versions.

## [1.1.0] - 2026-08-17

### Added

- First-launch language selection before the Android permission flow.
- Turkish, English, German, Spanish, French, Italian and Portuguese Flutter translations.
- Matching native Android translations for ringing alarms, notification actions, snooze status and sleep reminders.
- In-app language switching without an application restart.
- Locale-aware dates, weekdays, repeat summaries and world-clock labels.
- Bilingual GitHub documentation, contribution templates and CI workflow.

### Changed

- Native alarm history now stores stable action codes instead of language-dependent labels.
- JSON backups include the application version and selected language while
  remaining compatible with older Snoon backups.

## [1.0.0] - 2026-08-17

### Added

- Alarm, world clock, stopwatch, timer and sleep schedule.
- Interval alarms, groups, holiday exceptions and today-only shifts.
- Morning routine, dismissal tasks, Reliability Center and alarm history.
- Actionable full-screen alarm notification, five-minute snooze and reboot recovery.
- JSON backup and restore.
