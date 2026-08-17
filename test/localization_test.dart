import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snoon/l10n/app_localizations.dart';
import 'package:snoon/main.dart';
import 'package:snoon/services/app_store.dart';
import 'package:snoon/services/native_alarm_service.dart';

class _LocaleNativeService extends NativeAlarmService {
  String? languageCode;

  @override
  Future<void> setApplicationLocale(String languageCode) async {
    this.languageCode = languageCode;
  }

  @override
  Future<List<Map<String, dynamic>>> consumeHistory() async => [];

  @override
  Future<void> schedule(Map<String, dynamic> record) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('yedi desteklenen dil eksiksiz üretilir', () {
    expect(
      AppLocalizations.supportedLocales.map((locale) => locale.languageCode),
      containsAll(['tr', 'en', 'de', 'es', 'fr', 'it', 'pt']),
    );
  });

  test('sayaçlar dilin tekil ve çoğul kurallarını uygular', () {
    final english = lookupAppLocalizations(const Locale('en'));
    final german = lookupAppLocalizations(const Locale('de'));
    final spanish = lookupAppLocalizations(const Locale('es'));
    final french = lookupAppLocalizations(const Locale('fr'));
    final italian = lookupAppLocalizations(const Locale('it'));
    final portuguese = lookupAppLocalizations(const Locale('pt'));

    expect(english.alarmsCount(1), '1 alarm');
    expect(english.alarmsCount(2), '2 alarms');
    expect(german.alarmsCount(1), '1 Alarm');
    expect(german.alarmsCount(2), '2 Alarme');
    expect(spanish.timesCount(1), '1 vez');
    expect(
      french.alarmsDeleteMessage(1),
      '1 alarme sera définitivement supprimée.',
    );
    expect(italian.exceptionDays(1), '1 giorno di eccezione');
    expect(portuguese.alarmsCount(2), '2 alarmes');
  });

  testWidgets('ilk açılış dil seçimi saklanır ve arayüze uygulanır', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final native = _LocaleNativeService();
    final store = AppStore(native: native);
    await store.load();

    await tester.pumpWidget(SnoonApp(store: store));
    await tester.pumpAndSettle();
    expect(find.text('Choose your language'), findsOneWidget);

    await tester.tap(find.text('Türkçe'));
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    final continueButton = find.widgetWithText(FilledButton, 'Continue');
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(store.languageSelected, isTrue);
    expect(store.localeCode, 'tr');
    expect(native.languageCode, 'tr');
    expect(find.text('İlk alarmını oluştur'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('locale_v1'), 'tr');
    expect(preferences.getBool('language_selected_v1'), isTrue);
  });

  testWidgets('Ayarlar üzerinden İngilizceye geçiş yeniden başlatma istemez', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'language_selected_v1': true,
      'locale_v1': 'tr',
    });
    final store = AppStore(native: _LocaleNativeService());
    await store.load();
    await tester.pumpWidget(SnoonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ayarlar'));
    await tester.pumpAndSettle();
    final languageTile = find.text('Uygulama dili');
    await tester.ensureVisible(languageTile);
    await tester.tap(languageTile);
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    final applyButton = find.widgetWithText(FilledButton, 'Uygula');
    await tester.ensureVisible(applyButton);
    await tester.tap(applyButton);
    await tester.pumpAndSettle();

    expect(store.localeCode, 'en');
    expect(find.text('Settings'), findsOneWidget);
  });
}
