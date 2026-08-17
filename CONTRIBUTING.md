# Contributing to Snoon / Snoon'a Katkı

Thank you for helping make Snoon more reliable. Türkçe katkılar da kabul edilir.

## Before opening a change

1. Search existing issues and avoid duplicate work.
2. Create a focused branch and keep unrelated changes separate.
3. Never commit `android/key.properties`, a keystore, credentials, personal alarm data or generated release packages.
4. For user-visible text, update every ARB locale and the matching native Android resources when the text can appear in an alarm notification or ringing screen.
5. Preserve existing alarm data and reboot behavior.

## Local checks

```powershell
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter build apk --debug
```

Changes to scheduling, notifications, snooze, Direct Boot or alarm audio should also be tested on an Android emulator or physical device.

## Pull requests

- Explain the user-visible result and the reason for the change.
- List tests performed and Android versions used.
- Attach before/after screenshots for UI changes.
- Mention permission, migration, battery or privacy effects.
- Keep translations complete; `untranslated.json` must remain empty after `flutter gen-l10n`.

## Türkçe kısa özet

- Önce mevcut issue'ları kontrol et.
- Her değişikliği ayrı ve anlaşılır tut.
- Görünen yeni metinleri bütün dillere ekle.
- Alarm planlaması değiştiyse yeniden başlatma ve 5 dakika erteleme akışını test et.
- Gizli imza dosyalarını veya kişisel verileri repoya gönderme.
