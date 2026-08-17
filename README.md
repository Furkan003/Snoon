<p align="center">
  <img src="assets/branding/snoon-icon-source.png" width="128" alt="Snoon app icon">
</p>

<h1 align="center">Snoon</h1>

<p align="center"><strong>A reliable Android alarm clock for real-life schedules.</strong></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README_TR.md">Türkçe</a>
</p>

Snoon is a privacy-friendly Flutter clock app that combines familiar alarm, world clock, stopwatch, timer and sleep tools with flexible scheduling features. Create an entire series of alarms from a time range, pause recurring alarm groups for a holiday, or shift today's schedule without changing the permanent plan.

> Status: active Android development. Minimum Android version: Android 8.0 (API 26).

## Highlights

- Create one-time, weekly and cross-midnight alarms.
- Generate alarms every 1, 2, 5, 10 or 15 minutes inside a time range.
- Organize alarms into groups with holiday pauses and exception dates.
- Shift selected alarms or a whole group only for today.
- Use optional math or shake-to-dismiss tasks.
- Snooze or dismiss directly from the actionable lock-screen notification.
- Verify permissions, alarm sound and battery restrictions in the Reliability Center.
- Keep all data on the device and export or restore a JSON backup.
- Use Snoon in Turkish, English, German, Spanish, French, Italian or Portuguese.

## Screenshots

<p align="center">
  <img src="store-assets/screenshots/00-language-selection.png" width="210" alt="Snoon language selection">
  <img src="store-assets/screenshots/01-alarm-list.png" width="210" alt="Snoon alarm list">
  <img src="store-assets/screenshots/02-world-clock.png" width="210" alt="Snoon world clock">
</p>

<p align="center">
  <img src="store-assets/screenshots/03-settings-and-backup.png" width="210" alt="Snoon settings and backup">
  <img src="store-assets/screenshots/04-actionable-alarm-notification.png" width="260" alt="Actionable Snoon alarm notification">
  <img src="store-assets/screenshots/05-math-dismiss-task.png" width="260" alt="Snoon math dismissal task">
  <img src="store-assets/screenshots/06-french-native-alarm.png" width="260" alt="French native Snoon alarm screen">
</p>

## Features

### Alarm and schedule management

- Ringtone, label, vibration, repeat days and delete-after-ringing settings
- Configurable snooze duration, maximum snoozes and volume-button behavior
- Increasing volume, automatic silence, pre-alert and backup alarm
- Full-screen lock-screen alarm with **Snooze** and **Dismiss** actions
- Alarm groups, holiday pauses, exception calendar and bulk operations
- Optional morning routine and dismissal tasks, disabled by default
- Alarm history and a built-in 10-second delivery test
- Automatic rescheduling after reboot, time or time-zone changes

### Clock tools

- World clock with city search and daylight-saving-time support
- Stopwatch with laps
- Preset and custom countdown timers
- Sleep schedule with wind-down reminder and wake-up alarm
- System, light and dark themes

## Languages

Snoon asks for a language before requesting Android permissions on first launch. The language can be changed later under **Settings → App language** without restarting the app.

Supported languages:

- Turkish
- English
- German
- Spanish
- French
- Italian
- Portuguese

Flutter screens and native Android alarm notifications use the same selected language. English is the safe fallback for an unsupported device locale.

## Privacy

Snoon has no account system, ads, analytics or tracking SDK. Alarms, groups, settings, sleep data and history remain on the device unless the user explicitly exports a JSON backup. See the [privacy policy](PRIVACY_POLICY.md).

## Development

Requirements:

- Flutter 3.47 or newer
- Dart 3.13 or newer
- Android Studio and Android SDK
- JDK 17
- An Android 8.0+ device or emulator

```powershell
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter build apk --debug
```

Release builds require a local `android/key.properties` file and upload keystore. Those secrets are intentionally ignored by Git. See the [release checklist](RELEASE_CHECKLIST.md).

## Architecture

- **Flutter/Dart:** UI, local data model, localization and user flows
- **Kotlin/Android:** exact scheduling, foreground alarm sound, vibration, full-screen activity, notification actions and reboot recovery
- **SharedPreferences:** account-free local persistence
- **ARB + Android resources:** synchronized Flutter and native translations

Alarms use Android's `AlarmManager.setAlarmClock()` when exact-alarm access is available. Snoon exposes permission and OEM battery checks instead of silently hiding delivery risks.

## Android permissions

| Permission | Why Snoon needs it |
| --- | --- |
| Notifications | Upcoming, snoozed and ringing alarm controls |
| Exact alarms | Deliver user-created alarms at the selected time |
| Full-screen intents | Show alarm controls on the lock screen |
| Vibration | Vibrate only when enabled by the user |
| Boot completed | Restore alarms after a device restart |
| Foreground media playback | Keep alarm audio reliable while ringing |

## Tests

The repository includes model, store, widget, localization and full Android integration tests. The integration suite covers multi-day interval alarms, groups, world clock, stopwatch, timer, sleep plan, settings and reliability checks.

```powershell
flutter analyze
flutter test
flutter test integration_test/full_app_test.dart -d <android-device-id>
```

## Project documents

- [Product requirements](PRODUCT_REQUIREMENTS.md)
- [Roadmap](Yapılacaklar.md)
- [Release checklist](RELEASE_CHECKLIST.md)
- [Play Console declarations](PLAY_CONSOLE_DECLARATIONS.md)
- [Localized store listings](STORE_LISTINGS.md)
- [Localization and terminology guide](docs/LOCALIZATION.md)
- [Changelog](CHANGELOG.md)

## Contributing and security

Issues and pull requests are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) before contributing and report sensitive problems according to [SECURITY.md](SECURITY.md). Never commit a keystore, `key.properties` file or private signing credential.

## License

Snoon is available under the [MIT License](LICENSE).
