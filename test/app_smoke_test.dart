import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snoon/main.dart';
import 'package:snoon/models/alarm_models.dart';
import 'package:snoon/services/app_store.dart';
import 'package:snoon/services/native_alarm_service.dart';
import 'package:timezone/data/latest.dart' as timezone_data;

class _SmokeNativeAlarmService extends NativeAlarmService {
  final List<Map<String, dynamic>> scheduled = [];
  final List<String> canceled = [];
  final List<String> timers = [];

  @override
  Future<void> setApplicationLocale(String languageCode) async {}

  @override
  Future<void> schedule(Map<String, dynamic> record) async {
    scheduled.add(Map<String, dynamic>.from(record));
  }

  @override
  Future<void> cancel(String id) async {
    canceled.add(id);
  }

  @override
  Future<List<Map<String, dynamic>>> consumeHistory() async => [];

  @override
  Future<bool> notificationsGranted() async => true;

  @override
  Future<bool> canScheduleExactAlarms() async => true;

  @override
  Future<bool> canUseFullScreenIntent() async => true;

  @override
  Future<bool> alarmStreamAudible() async => true;

  @override
  Future<bool> batteryOptimizationDisabled() async => true;

  @override
  Future<String> deviceManufacturer() async => 'Test cihazı';

  @override
  Future<void> scheduleTimer({
    required String id,
    required String label,
    required int triggerAtMillis,
    String? ringtoneUri,
    required double volume,
  }) async {
    timers.add(id);
  }

  @override
  Future<void> cancelTimer(String id) async {
    timers.remove(id);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  timezone_data.initializeTimeZones();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'language_selected_v1': true,
      'locale_v1': 'tr',
    });
  });

  testWidgets('ana bölümler ve temel işlemler birlikte çalışır', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final native = _SmokeNativeAlarmService();
    final store = AppStore(native: native);
    await store.load();
    await tester.pumpWidget(SnoonApp(store: store));
    await tester.pumpAndSettle();

    expect(find.text('İlk alarmını oluştur'), findsOneWidget);

    await tester.tap(find.text('Dünya'));
    await tester.pumpAndSettle();
    expect(find.text('Dünya Saati'), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Tokyo'),
      350,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Tokyo'));
    await tester.pumpAndSettle();
    expect(find.text('Tokyo'), findsOneWidget);

    await tester.tap(find.text('Kronometre'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(const Duration(milliseconds: 120));
    await tester.tap(find.byIcon(Icons.flag_outlined));
    await tester.pump();
    expect(find.text('Tur 1'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    expect(find.text('Tur 1'), findsNothing);

    await tester.tap(find.text('Zamanlayıcı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1 dk'));
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(const Duration(milliseconds: 350));
    expect(native.timers, hasLength(1));
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();
    expect(native.timers, isEmpty);
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    await tester.tap(find.text('Özel'));
    await tester.pumpAndSettle();
    final durationFields = find.byType(TextField);
    expect(durationFields, findsNWidgets(3));
    await tester.enterText(durationFields.at(0), '0');
    await tester.enterText(durationFields.at(1), '0');
    await tester.enterText(durationFields.at(2), '3');
    await tester.tap(find.text('Uygula'));
    await tester.pumpAndSettle();
    expect(find.text('00:00:03'), findsOneWidget);

    await tester.tap(find.text('Uyku'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Uyku programı'));
    await tester.pumpAndSettle();
    expect(store.sleepProfile.enabled, isTrue);
    expect(
      store.alarms
          .singleWhere((item) => item.id == 'sleep-wake')
          .morningRoutine,
      isFalse,
    );

    await tester.tap(find.text('Alarm'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Çok günlü alarm');
    for (final day in ['Pzt', 'Çar', 'Cum']) {
      await tester.tap(find.text(day));
    }
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Çok günlü alarm'), findsOneWidget);
    expect(
      store.alarms
          .singleWhere((item) => item.label == 'Çok günlü alarm')
          .repeatDays,
      [1, 3, 5],
    );

    await tester.tap(find.textContaining('Çok günlü alarm'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Belirli zaman aralığı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(
      store.alarms
          .singleWhere((item) => item.label == 'Çok günlü alarm')
          .isRange,
      isTrue,
    );
  });

  testWidgets('grup, geçmiş, güvenilirlik ve ayarlar ekranları açılır', (
    tester,
  ) async {
    final native = _SmokeNativeAlarmService();
    final store = AppStore(native: native);
    await store.load();
    await tester.pumpWidget(SnoonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.folder_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Alarm grupları'), findsOneWidget);
    await tester.tap(find.text('Grup ekle'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Test grubu');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Test grubu'), findsOneWidget);
    Navigator.of(tester.element(find.text('Alarm grupları'))).pop();
    await tester.pumpAndSettle();

    Future<void> openMenuItem(String text) async {
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(text));
      await tester.pumpAndSettle();
    }

    await openMenuItem('Alarm geçmişi');
    expect(find.text('Henüz alarm geçmişi yok'), findsOneWidget);
    Navigator.of(tester.element(find.text('Alarm geçmişi'))).pop();
    await tester.pumpAndSettle();

    await openMenuItem('Güvenilirlik merkezi');
    expect(find.text('Alarmlar hazır'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('10 saniyelik test alarmı çalıştır'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('10 saniyelik test alarmı çalıştır'), findsOneWidget);
    Navigator.of(tester.element(find.text('Güvenilirlik merkezi'))).pop();
    await tester.pumpAndSettle();

    await openMenuItem('Ayarlar');
    expect(find.text('Ayarlar'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Alarm zil sesi'),
      350,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Alarm zil sesi'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Artan alarm sesi'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    final gradualTile = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Artan alarm sesi'),
    );
    gradualTile.onChanged!(false);
    await tester.pumpAndSettle();
    expect(store.settings.gradualVolume, isFalse);
    await store.updateSettings(
      store.settings.copyWith(themeMode: SnoonThemeMode.light),
    );
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Alarm zil sesi'))).brightness,
      Brightness.light,
    );
  });
}
