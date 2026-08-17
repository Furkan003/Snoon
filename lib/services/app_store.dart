import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_metadata.dart';
import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import 'native_alarm_service.dart';

class AppStore extends ChangeNotifier {
  AppStore({NativeAlarmService? native})
    : native = native ?? NativeAlarmService();

  static const _alarmsKey = 'alarms_v1';
  static const _groupsKey = 'groups_v1';
  static const _settingsKey = 'settings_v1';
  static const _historyKey = 'history_v1';
  static const _sleepKey = 'sleep_v1';
  static const _citiesKey = 'cities_v1';
  static const _localeKey = 'locale_v1';
  static const _languageSelectedKey = 'language_selected_v1';
  static const supportedLanguageCodes = {
    'tr',
    'en',
    'de',
    'es',
    'fr',
    'it',
    'pt',
  };

  final NativeAlarmService native;
  late SharedPreferences _prefs;

  bool ready = false;
  List<AlarmItem> alarms = [];
  List<AlarmGroup> groups = [];
  List<AlarmHistoryEvent> history = [];
  List<WorldCity> cities = [];
  AppSettings settings = const AppSettings();
  SleepProfile sleepProfile = const SleepProfile();
  String localeCode = 'en';
  bool languageSelected = false;

  String newId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final deviceCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final storedLocale = _prefs.getString(_localeKey);
    localeCode = supportedLanguageCodes.contains(storedLocale)
        ? storedLocale!
        : supportedLanguageCodes.contains(deviceCode)
        ? deviceCode
        : 'en';
    languageSelected = _prefs.getBool(_languageSelectedKey) ?? false;
    alarms = _decodeList(_alarmsKey, AlarmItem.fromJson);
    groups = _decodeList(_groupsKey, AlarmGroup.fromJson);
    history = _decodeList(_historyKey, AlarmHistoryEvent.fromJson);
    cities = _decodeList(_citiesKey, WorldCity.fromJson);

    if (groups.isEmpty) {
      groups = const [
        AlarmGroup(id: 'work', name: 'İş', colorValue: 0xFF8B5CF6),
        AlarmGroup(id: 'personal', name: 'Kişisel', colorValue: 0xFF2DD4BF),
      ];
    }
    if (cities.isEmpty) {
      cities = const [
        WorldCity(
          name: 'İstanbul',
          offsetMinutes: 180,
          timeZoneId: 'Europe/Istanbul',
        ),
      ];
    }

    final rawSettings = _prefs.getString(_settingsKey);
    if (rawSettings != null) {
      try {
        settings = AppSettings.fromJson(
          Map<String, dynamic>.from(jsonDecode(rawSettings) as Map),
        );
      } catch (_) {
        settings = const AppSettings();
      }
    }
    final rawSleep = _prefs.getString(_sleepKey);
    if (rawSleep != null) {
      try {
        sleepProfile = SleepProfile.fromJson(
          Map<String, dynamic>.from(jsonDecode(rawSleep) as Map),
        );
      } catch (_) {
        sleepProfile = const SleepProfile();
      }
    }

    await _safeNative(() => native.setApplicationLocale(localeCode));

    await _consumeNativeHistory();
    ready = true;
    notifyListeners();
    await rescheduleAll();
    if (rawSleep != null) await _scheduleSleepReminder(sleepProfile);
  }

  Future<void> selectLanguage({
    required String languageCode,
    required String workGroupName,
    required String personalGroupName,
  }) async {
    if (!supportedLanguageCodes.contains(languageCode)) return;
    localeCode = languageCode;
    languageSelected = true;
    groups = [
      for (final group in groups)
        if (group.id == 'work' &&
            const {
              'İş',
              'Work',
              'Arbeit',
              'Trabajo',
              'Travail',
              'Lavoro',
              'Trabalho',
            }.contains(group.name))
          group.copyWith(name: workGroupName)
        else if (group.id == 'personal' &&
            const {
              'Kişisel',
              'Personal',
              'Persönlich',
              'Personnel',
              'Personale',
              'Pessoal',
            }.contains(group.name))
          group.copyWith(name: personalGroupName)
        else
          group,
    ];
    await Future.wait([
      _prefs.setString(_localeKey, localeCode),
      _prefs.setBool(_languageSelectedKey, true),
      _prefs.setString(
        _groupsKey,
        jsonEncode(groups.map((item) => item.toJson()).toList()),
      ),
    ]);
    await _safeNative(() => native.setApplicationLocale(localeCode));
    notifyListeners();
    await rescheduleAll();
  }

  List<T> _decodeList<T>(String key, T Function(Map<String, dynamic>) decoder) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((item) => decoder(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  AlarmGroup? groupFor(String? id) {
    if (id == null) return null;
    for (final group in groups) {
      if (group.id == id) return group;
    }
    return null;
  }

  DateTime? get nextAlarm {
    DateTime? next;
    for (final alarm in alarms) {
      final occurrence = alarm.nextOccurrence(group: groupFor(alarm.groupId));
      if (occurrence != null && (next == null || occurrence.isBefore(next))) {
        next = occurrence;
      }
    }
    return next;
  }

  Future<void> addAlarm(AlarmItem alarm) async {
    alarms = [...alarms, alarm];
    await _persistAlarms();
    notifyListeners();
    await _schedule(alarm);
  }

  Future<void> updateAlarm(AlarmItem alarm) async {
    alarms = [
      for (final item in alarms)
        if (item.id == alarm.id) alarm else item,
    ];
    await _persistAlarms();
    notifyListeners();
    await _schedule(alarm);
  }

  Future<void> toggleAlarm(AlarmItem alarm, bool enabled) =>
      updateAlarm(alarm.copyWith(enabled: enabled));

  Future<void> deleteAlarms(Iterable<String> ids) async {
    final idSet = ids.toSet();
    alarms = alarms.where((alarm) => !idSet.contains(alarm.id)).toList();
    await _persistAlarms();
    notifyListeners();
    for (final id in idSet) {
      await _safeNative(() => native.cancel(id));
    }
  }

  Future<void> pauseAlarmsUntil(Iterable<String> ids, DateTime until) async {
    final idSet = ids.toSet();
    alarms = [
      for (final alarm in alarms)
        if (idSet.contains(alarm.id))
          alarm.copyWith(pausedUntil: until)
        else
          alarm,
    ];
    await _persistAlarms();
    notifyListeners();
    await _rescheduleIds(idSet);
  }

  Future<void> clearAlarmPause(String id) async {
    final alarm = alarms.firstWhere((item) => item.id == id);
    await updateAlarm(alarm.copyWith(pausedUntil: null));
  }

  Future<void> shiftAlarmsToday(Iterable<String> ids, int minutes) async {
    final idSet = ids.toSet();
    final today = dateKey(DateTime.now());
    alarms = [
      for (final alarm in alarms)
        if (idSet.contains(alarm.id))
          alarm.copyWith(todayShiftDate: today, todayShiftMinutes: minutes)
        else
          alarm,
    ];
    await _persistAlarms();
    notifyListeners();
    await _rescheduleIds(idSet);
  }

  Future<void> saveGroup(AlarmGroup group) async {
    final exists = groups.any((item) => item.id == group.id);
    groups = exists
        ? [
            for (final item in groups)
              if (item.id == group.id) group else item,
          ]
        : [...groups, group];
    await _prefs.setString(
      _groupsKey,
      jsonEncode(groups.map((item) => item.toJson()).toList()),
    );
    notifyListeners();
    await _rescheduleIds(
      alarms
          .where((alarm) => alarm.groupId == group.id)
          .map((alarm) => alarm.id)
          .toSet(),
    );
  }

  Future<void> deleteGroup(String id) async {
    groups = groups.where((group) => group.id != id).toList();
    alarms = [
      for (final alarm in alarms)
        if (alarm.groupId == id) alarm.copyWith(groupId: null) else alarm,
    ];
    await _prefs.setString(
      _groupsKey,
      jsonEncode(groups.map((item) => item.toJson()).toList()),
    );
    await _persistAlarms();
    notifyListeners();
    await rescheduleAll();
  }

  Future<void> updateSettings(AppSettings value) async {
    settings = value;
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
    notifyListeners();
    await rescheduleAll();
  }

  Future<void> updateSleepProfile(SleepProfile value) async {
    sleepProfile = value;
    await _prefs.setString(_sleepKey, jsonEncode(value.toJson()));
    notifyListeners();
    await _scheduleSleepReminder(value);
  }

  Future<void> addCity(WorldCity city) async {
    cities = [...cities, city];
    await _persistCities();
    notifyListeners();
  }

  Future<void> removeCity(int index) async {
    cities = [...cities]..removeAt(index);
    await _persistCities();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    history = [];
    await _prefs.setString(_historyKey, '[]');
    notifyListeners();
  }

  Future<String> createBackupJson() async {
    await _consumeNativeHistory();
    return const JsonEncoder.withIndent('  ').convert({
      'schemaVersion': 1,
      'app': 'Snoon',
      'appVersion': snoonVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'localeCode': localeCode,
      'alarms': alarms.map((item) => item.toJson()).toList(),
      'groups': groups.map((item) => item.toJson()).toList(),
      'settings': settings.toJson(),
      'history': history.map((item) => item.toJson()).toList(),
      'sleepProfile': sleepProfile.toJson(),
      'cities': cities.map((item) => item.toJson()).toList(),
    });
  }

  Future<void> restoreBackupJson(String raw) async {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) throw const FormatException('Yedek biçimi geçersiz.');
    final root = Map<String, dynamic>.from(decoded);
    if (root['schemaVersion'] != 1 || root['app'] != 'Snoon') {
      throw const FormatException(
        'Bu dosya desteklenen bir Snoon yedeği değil.',
      );
    }

    List<T> decodeItems<T>(String key, T Function(Map<String, dynamic>) parse) {
      final value = root[key];
      if (value is! List) throw FormatException('$key listesi eksik.');
      return value
          .map((item) => parse(Map<String, dynamic>.from(item as Map)))
          .toList();
    }

    final restoredAlarms = decodeItems('alarms', AlarmItem.fromJson);
    final restoredGroups = decodeItems('groups', AlarmGroup.fromJson);
    final restoredHistory = decodeItems('history', AlarmHistoryEvent.fromJson);
    final restoredCities = decodeItems('cities', WorldCity.fromJson);
    final restoredSettings = AppSettings.fromJson(
      Map<String, dynamic>.from(root['settings'] as Map),
    );
    final restoredSleep = SleepProfile.fromJson(
      Map<String, dynamic>.from(root['sleepProfile'] as Map),
    );
    final restoredLocale = root['localeCode']?.toString();
    if (restoredAlarms.any(
      (alarm) =>
          !alarm.hour.inRange(0, 23) ||
          !alarm.minute.inRange(0, 59) ||
          alarm.intervalMinutes <= 0,
    )) {
      throw const FormatException('Yedekte geçersiz alarm saati var.');
    }
    if (restoredAlarms.map((item) => item.id).toSet().length !=
        restoredAlarms.length) {
      throw const FormatException('Yedekte yinelenen alarm kimliği var.');
    }

    await _safeNative(native.cancelAll);
    alarms = restoredAlarms;
    groups = restoredGroups;
    history = restoredHistory;
    cities = restoredCities;
    settings = restoredSettings;
    sleepProfile = restoredSleep;
    if (supportedLanguageCodes.contains(restoredLocale)) {
      localeCode = restoredLocale!;
      languageSelected = true;
    }
    await Future.wait([
      _persistAlarms(),
      _prefs.setString(
        _groupsKey,
        jsonEncode(groups.map((item) => item.toJson()).toList()),
      ),
      _prefs.setString(_settingsKey, jsonEncode(settings.toJson())),
      _prefs.setString(
        _historyKey,
        jsonEncode(history.map((item) => item.toJson()).toList()),
      ),
      _prefs.setString(_sleepKey, jsonEncode(sleepProfile.toJson())),
      _persistCities(),
      _prefs.setString(_localeKey, localeCode),
      _prefs.setBool(_languageSelectedKey, languageSelected),
    ]);
    await _safeNative(() => native.setApplicationLocale(localeCode));
    notifyListeners();
    await rescheduleAll();
    await _scheduleSleepReminder(sleepProfile);
  }

  Future<void> refreshNativeState() async {
    await _consumeNativeHistory();
    notifyListeners();
  }

  Future<void> _consumeNativeHistory() async {
    try {
      final events = await native.consumeHistory();
      if (events.isEmpty) return;
      final incoming = events.map(AlarmHistoryEvent.fromJson).toList();
      history = [...incoming, ...history]
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      if (history.length > 300) history = history.take(300).toList();

      var alarmsChanged = false;
      for (final event in events) {
        if (event['disableAlarm'] != true) continue;
        final index = alarms.indexWhere(
          (alarm) => alarm.id == event['alarmId'],
        );
        if (index < 0) continue;
        final alarm = alarms[index];
        if (alarm.deleteAfterRinging) {
          alarms.removeAt(index);
        } else {
          alarms[index] = alarm.copyWith(enabled: false);
        }
        alarmsChanged = true;
      }
      await _prefs.setString(
        _historyKey,
        jsonEncode(history.map((item) => item.toJson()).toList()),
      );
      if (alarmsChanged) await _persistAlarms();
    } on MissingPluginException {
      // Widget tests and non-Android previews do not provide the native bridge.
    } on PlatformException {
      // Keep the local UI usable even if the Android service is unavailable.
    }
  }

  Future<void> rescheduleAll() async {
    for (final alarm in alarms) {
      await _schedule(alarm);
    }
  }

  Future<void> _rescheduleIds(Set<String> ids) async {
    for (final alarm in alarms.where((item) => ids.contains(item.id))) {
      await _schedule(alarm);
    }
  }

  Future<void> _schedule(AlarmItem alarm) async {
    if (!alarm.enabled) {
      await _safeNative(() => native.cancel(alarm.id));
      return;
    }
    final record = _nativeRecord(alarm);
    if (record['triggerAtMillis'] == null) {
      await _safeNative(() => native.cancel(alarm.id));
      return;
    }
    await _safeNative(() => native.schedule(record));
  }

  Future<void> _scheduleSleepReminder(SleepProfile profile) async {
    const id = 'sleep-bedtime-reminder';
    if (!profile.enabled || profile.days.isEmpty) {
      await _safeNative(() => native.cancel(id));
      return;
    }

    final bedtimeMinutes = profile.bedHour * 60 + profile.bedMinute;
    final wakeMinutes = profile.wakeHour * 60 + profile.wakeMinute;
    var reminderMinutes = bedtimeMinutes - profile.windDownMinutes;
    var dayOffset = bedtimeMinutes >= wakeMinutes ? -1 : 0;
    if (reminderMinutes < 0) {
      reminderMinutes += 24 * 60;
      dayOffset--;
    }
    final reminderDays =
        profile.days
            .map((day) => ((day - 1 + dayOffset) % 7 + 7) % 7 + 1)
            .toSet()
            .toList()
          ..sort();
    final reminder = AlarmItem(
      id: id,
      hour: reminderMinutes ~/ 60,
      minute: reminderMinutes % 60,
      label: localizedSleepReminderName(localeCode),
      repeatDays: reminderDays,
    );
    final next = reminder.nextOccurrence();
    if (next == null) {
      await _safeNative(() => native.cancel(id));
      return;
    }
    await _safeNative(
      () => native.schedule({
        'id': id,
        'label': reminder.label,
        'enabled': true,
        'hour': reminder.hour,
        'minute': reminder.minute,
        'repeatDays': reminderDays,
        'oneShotDate': null,
        'rangeEndMinutes': null,
        'intervalMinutes': 5,
        'triggerAtMillis': next.millisecondsSinceEpoch,
        'isSleepReminder': true,
        'windDownMinutes': profile.windDownMinutes,
        'preNotificationMinutes': 0,
        'morningRoutine': false,
        'showOnLockScreen': false,
      }),
    );
  }

  Map<String, dynamic> nativeRecordFor(AlarmItem alarm) => _nativeRecord(alarm);

  Map<String, dynamic> _nativeRecord(AlarmItem alarm) {
    final group = groupFor(alarm.groupId);
    final next = alarm.nextOccurrence(group: group);
    return {
      'id': alarm.id,
      'label': alarm.label.isEmpty ? 'Alarm' : alarm.label,
      'enabled': alarm.enabled,
      'hour': alarm.hour,
      'minute': alarm.minute,
      'repeatDays': alarm.repeatDays,
      'oneShotDate': alarm.oneShotDate == null
          ? null
          : dateKey(alarm.oneShotDate!),
      'rangeEndMinutes': alarm.rangeEndMinutes,
      'intervalMinutes': alarm.intervalMinutes,
      'pausedUntil': alarm.pausedUntil == null
          ? null
          : dateKey(alarm.pausedUntil!),
      'groupPausedUntil': group?.pausedUntil == null
          ? null
          : dateKey(group!.pausedUntil!),
      'excludedDates': group?.excludedDates ?? const <String>[],
      'alarmShiftDate': alarm.todayShiftDate,
      'alarmShiftMinutes': alarm.todayShiftMinutes,
      'groupShiftDate': group?.todayShiftDate,
      'groupShiftMinutes': group?.todayShiftMinutes ?? 0,
      'triggerAtMillis': next?.millisecondsSinceEpoch,
      'vibrate': alarm.vibrate && settings.vibrate,
      'deleteAfterRinging': alarm.deleteAfterRinging,
      'ringtoneUri': alarm.ringtoneUri ?? settings.alarmRingtoneUri,
      'ringtoneName': alarm.ringtoneName ?? settings.alarmRingtoneName,
      'dismissTask': alarm.dismissTask.name,
      'morningRoutine': alarm.morningRoutine,
      'gentleReminderMinutes': alarm.gentleReminderMinutes,
      'backupAlarmMinutes': alarm.backupAlarmMinutes,
      'volume': settings.alarmVolume,
      'gradualVolume': settings.gradualVolume,
      'autoSilenceMinutes': settings.autoSilenceMinutes,
      'snoozeMinutes': settings.snoozeMinutes,
      'maxSnoozes': settings.maxSnoozes,
      'volumeButtonAction': settings.volumeButtonAction.name,
      'preNotificationMinutes': settings.preNotificationMinutes,
      'showOnLockScreen': settings.showOnLockScreen,
    };
  }

  Future<void> _persistAlarms() => _prefs.setString(
    _alarmsKey,
    jsonEncode(alarms.map((item) => item.toJson()).toList()),
  );

  Future<void> _persistCities() => _prefs.setString(
    _citiesKey,
    jsonEncode(cities.map((item) => item.toJson()).toList()),
  );

  Future<void> _safeNative(Future<void> Function() operation) async {
    try {
      await operation();
    } on MissingPluginException {
      // Non-Android previews intentionally run without alarm delivery.
    } on PlatformException {
      // Reliability Center exposes missing permissions to the user.
    }
  }
}

extension on int {
  bool inRange(int minimum, int maximum) => this >= minimum && this <= maximum;
}
