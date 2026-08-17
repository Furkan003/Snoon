# Snoon localization guide

Snoon ships Flutter and native Android strings in Turkish, English, German,
Spanish, French, Italian and Portuguese. English is the fallback locale.

## Shared terminology

| Concept | English reference | Turkish reference | Usage |
| --- | --- | --- | --- |
| Alarm | Alarm | Alarm | A scheduled alarm or alarm feature |
| Snooze | Snooze | Ertele | Delay a ringing alarm |
| Dismiss | Dismiss / Stop | Kapat / Durdur | Stop the current ringing alarm |
| Ringtone | Ringtone | Zil sesi | Alarm or timer sound |
| Exact alarm | Exact alarm | Tam zamanlı alarm | Android permission and reliability status |
| Full-screen alarm | Full-screen alarm | Tam ekran alarm | Lock-screen ringing experience |
| Auto silence | Auto silence | Otomatik susturma | Stop ringing after a configured duration |
| Exception date | Exception date | İstisna tarihi | Date on which a group does not ring |

Translations should preserve meaning rather than copy English word order.
Notification action text and full-screen alarm actions must use the same verbs.

## Adding or changing a string

1. Add the key and placeholder metadata to `lib/l10n/app_en.arb`.
2. Add the same key to all six translated ARB files.
3. Use ICU plural syntax for user-visible counts.
4. Run `flutter gen-l10n` and confirm `untranslated.json` is `{}`.
5. If the text is shown while Flutter is not running, update every Android
   `values-*/strings.xml` file too.
6. Run `flutter analyze`, `flutter test` and the Android integration test.

## Manual QA matrix

For each locale, verify first launch, alarm creation, ringing notification,
five-minute snooze, dismissal, timer and reboot rescheduling. Also inspect long
German/French strings with large text, light/dark themes and Android three-button
navigation.
