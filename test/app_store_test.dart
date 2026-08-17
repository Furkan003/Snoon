import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snoon/models/alarm_models.dart';
import 'package:snoon/services/app_store.dart';
import 'package:snoon/services/native_alarm_service.dart';

class _FakeNativeAlarmService extends NativeAlarmService {
  final List<Map<String, dynamic>> scheduled = [];
  final List<String> canceled = [];
  List<Map<String, dynamic>> nativeHistory = [];

  @override
  Future<void> schedule(Map<String, dynamic> record) async {
    scheduled.add(Map<String, dynamic>.from(record));
  }

  @override
  Future<void> cancel(String id) async {
    canceled.add(id);
  }

  @override
  Future<List<Map<String, dynamic>>> consumeHistory() async {
    final result = nativeHistory;
    nativeHistory = [];
    return result;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ilk yüklemede varsayılan grup ve şehirleri oluşturur', () async {
    final store = AppStore(native: _FakeNativeAlarmService());

    await store.load();

    expect(store.ready, isTrue);
    expect(
      store.groups.map((item) => item.id),
      containsAll(['work', 'personal']),
    );
    expect(store.cities.single.name, 'İstanbul');
  });

  test('alarm ekleme, kapatma ve silme Android kuyruğunu günceller', () async {
    final native = _FakeNativeAlarmService();
    final store = AppStore(native: native);
    await store.load();
    final alarm = AlarmItem(
      id: 'alarm-1',
      hour: 7,
      minute: 0,
      label: 'İş',
      repeatDays: const [1, 2, 3, 4, 5, 6, 7],
      createdAt: DateTime(2026, 8, 16),
    );

    await store.addAlarm(alarm);
    await store.toggleAlarm(alarm, false);
    await store.deleteAlarms([alarm.id]);

    expect(native.scheduled.single['id'], alarm.id);
    expect(native.canceled, [alarm.id, alarm.id]);
    expect(store.alarms, isEmpty);
  });

  test('grup ayarları alarmın yerel Android kaydına yansır', () async {
    final native = _FakeNativeAlarmService();
    final store = AppStore(native: native);
    await store.load();
    final alarm = AlarmItem(
      id: 'grouped',
      hour: 7,
      minute: 0,
      label: 'Grup alarmı',
      repeatDays: const [1, 2, 3, 4, 5, 6, 7],
      groupId: 'work',
    );
    await store.addAlarm(alarm);
    native.scheduled.clear();

    await store.saveGroup(
      AlarmGroup(
        id: 'work',
        name: 'İş',
        colorValue: 0xFF8B5CF6,
        excludedDates: const ['2026-08-18'],
        pausedUntil: DateTime(2026, 8, 20),
        todayShiftDate: '2026-08-16',
        todayShiftMinutes: 30,
      ),
    );

    final record = native.scheduled.single;
    expect(record['excludedDates'], ['2026-08-18']);
    expect(record['groupPausedUntil'], '2026-08-20');
    expect(record['groupShiftMinutes'], 30);
  });

  test('yerel geçmişte sil işareti alan alarmı kaldırır', () async {
    final alarm = AlarmItem(
      id: 'delete-me',
      hour: 7,
      minute: 0,
      label: 'Silinecek',
      deleteAfterRinging: true,
      oneShotDate: DateTime(2026, 8, 17),
    );
    SharedPreferences.setMockInitialValues({
      'alarms_v1': jsonEncode([alarm.toJson()]),
    });
    final native = _FakeNativeAlarmService()
      ..nativeHistory = [
        {
          'id': 'event-1',
          'alarmId': alarm.id,
          'label': alarm.label,
          'action': 'Çaldıktan sonra silindi',
          'timestamp': '2026-08-17T04:00:00Z',
          'disableAlarm': true,
        },
      ];
    final store = AppStore(native: native);

    await store.load();

    expect(store.alarms, isEmpty);
    expect(store.history.single.action, 'Çaldıktan sonra silindi');
  });

  test('bozuk ayar verisi uygulama açılışını engellemez', () async {
    SharedPreferences.setMockInitialValues({
      'settings_v1': '{bozuk-json',
      'sleep_v1': '[yanlış-tip]',
    });
    final store = AppStore(native: _FakeNativeAlarmService());

    await store.load();

    expect(store.settings.alarmVolume, 0.8);
    expect(store.sleepProfile.enabled, isFalse);
  });

  test('seçili alarmları topluca duraklatır ve bugün kaydırır', () async {
    final native = _FakeNativeAlarmService();
    final store = AppStore(native: native);
    await store.load();
    for (final id in ['a', 'b', 'c']) {
      await store.addAlarm(
        AlarmItem(
          id: id,
          hour: 7,
          minute: 0,
          label: id,
          repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        ),
      );
    }
    native.scheduled.clear();

    await store.pauseAlarmsUntil(['a', 'b'], DateTime(2026, 8, 25));
    await store.shiftAlarmsToday(['a', 'b'], 30);

    expect(
      store.alarms
          .where((item) => item.pausedUntil != null)
          .map((item) => item.id),
      containsAll(['a', 'b']),
    );
    expect(
      store.alarms.singleWhere((item) => item.id == 'c').pausedUntil,
      isNull,
    );
    expect(
      store.alarms.singleWhere((item) => item.id == 'a').todayShiftMinutes,
      30,
    );
    expect(native.scheduled.map((item) => item['id']).toSet(), {'a', 'b'});
  });

  test('grup silinince alarmlar silinmeden gruptan çıkarılır', () async {
    final native = _FakeNativeAlarmService();
    final store = AppStore(native: native);
    await store.load();
    await store.addAlarm(
      const AlarmItem(
        id: 'grouped',
        hour: 7,
        minute: 0,
        label: 'İş',
        repeatDays: [1, 2, 3, 4, 5],
        groupId: 'work',
      ),
    );

    await store.deleteGroup('work');

    expect(store.groupFor('work'), isNull);
    expect(store.alarms.single.groupId, isNull);
    expect(native.scheduled.last['groupPausedUntil'], isNull);
  });

  test('uyku rahatlama bildirimi doğru gün ve saatte planlanır', () async {
    final native = _FakeNativeAlarmService();
    final store = AppStore(native: native);
    await store.load();

    await store.updateSleepProfile(
      const SleepProfile(
        enabled: true,
        bedHour: 23,
        bedMinute: 0,
        wakeHour: 7,
        wakeMinute: 0,
        windDownMinutes: 30,
        days: [1, 2, 3, 4, 5],
      ),
    );

    final record = native.scheduled.single;
    expect(record['id'], 'sleep-bedtime-reminder');
    expect(record['hour'], 22);
    expect(record['minute'], 30);
    expect(record['repeatDays'], [1, 2, 3, 4, 7]);
    expect(record['isSleepReminder'], isTrue);

    await store.updateSleepProfile(store.sleepProfile.copyWith(enabled: false));
    expect(native.canceled.last, 'sleep-bedtime-reminder');
  });

  test('tüm alarm ayarları JSON dönüşümünde korunur', () {
    const original = AppSettings(
      alarmRingtoneUri: 'content://alarm/main',
      alarmRingtoneName: 'Ana zil',
      timerRingtoneUri: 'content://alarm/timer',
      timerRingtoneName: 'Sayaç zili',
      alarmVolume: 0.35,
      autoSilenceMinutes: 15,
      vibrate: false,
      gradualVolume: false,
      snoozeMinutes: 10,
      maxSnoozes: 5,
      volumeButtonAction: VolumeButtonAction.dismiss,
      preNotificationMinutes: 30,
      showOnLockScreen: false,
      themeMode: SnoonThemeMode.light,
    );

    final restored = AppSettings.fromJson(original.toJson());

    expect(restored.toJson(), original.toJson());
  });

  test('tam yedek dışa aktarılır ve geri yüklenir', () async {
    final native = _FakeNativeAlarmService();
    final store = AppStore(native: native);
    await store.load();
    await store.selectLanguage(
      languageCode: 'fr',
      workGroupName: 'Travail',
      personalGroupName: 'Personnel',
    );
    await store.addAlarm(
      const AlarmItem(
        id: 'backup-alarm',
        hour: 23,
        minute: 55,
        label: 'Yedek alarmı',
        repeatDays: [1, 3, 5],
        rangeEndMinutes: 1445,
      ),
    );
    await store.updateSettings(
      store.settings.copyWith(themeMode: SnoonThemeMode.light),
    );
    final backup = await store.createBackupJson();
    final decodedBackup = jsonDecode(backup) as Map<String, dynamic>;

    expect(decodedBackup['appVersion'], '1.1.0+2');
    expect(decodedBackup['localeCode'], 'fr');

    await store.deleteAlarms(['backup-alarm']);
    await store.selectLanguage(
      languageCode: 'en',
      workGroupName: 'Work',
      personalGroupName: 'Personal',
    );
    await store.updateSettings(
      store.settings.copyWith(themeMode: SnoonThemeMode.dark),
    );
    await store.restoreBackupJson(backup);

    expect(store.alarms.single.id, 'backup-alarm');
    expect(store.alarms.single.rangeEndMinutes, 1445);
    expect(store.settings.themeMode, SnoonThemeMode.light);
    expect(store.localeCode, 'fr');
    expect(native.scheduled.last['id'], 'backup-alarm');
  });

  test('eski yedek dil alanı olmadan geriye dönük yüklenir', () async {
    final store = AppStore(native: _FakeNativeAlarmService());
    await store.load();
    await store.selectLanguage(
      languageCode: 'tr',
      workGroupName: 'İş',
      personalGroupName: 'Kişisel',
    );
    final backup =
        jsonDecode(await store.createBackupJson()) as Map<String, dynamic>;
    backup.remove('appVersion');
    backup.remove('localeCode');

    await store.restoreBackupJson(jsonEncode(backup));

    expect(store.localeCode, 'tr');
    expect(store.languageSelected, isTrue);
  });

  test('geçersiz yedek mevcut veriyi değiştirmez', () async {
    final store = AppStore(native: _FakeNativeAlarmService());
    await store.load();
    await store.addAlarm(
      const AlarmItem(id: 'safe', hour: 7, minute: 0, label: 'Korunacak'),
    );

    await expectLater(
      store.restoreBackupJson('{"schemaVersion":99,"app":"Snoon"}'),
      throwsFormatException,
    );
    expect(store.alarms.single.id, 'safe');
  });
}
