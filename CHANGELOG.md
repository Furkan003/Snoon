# Changelog

All notable Snoon changes are documented here. The format follows Keep a Changelog and versions follow semantic versioning.

## [Unreleased]

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
