import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_metadata.dart';
import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import 'native_alarm_service.dart';

/// Why a backup file was rejected. The UI maps these to localized messages.
enum BackupIssue {
  invalidFormat,
  unsupportedFile,
  corruptContent,
  invalidGroup,
  invalidAlarm,
  duplicateAlarm,
  invalidSettings,
  invalidSleep,
  invalidCity,
}

/// Extends [FormatException] so existing callers that only care about a
/// malformed backup keep working, while [issue] carries the localizable cause.
class BackupFormatException extends FormatException {
  const BackupFormatException(this.issue) : super('');

  final BackupIssue issue;
}

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
  static const _groupsInitializedKey = 'groups_initialized_v1';
  static const _citiesInitializedKey = 'cities_initialized_v1';
  static const _timerStateKey = 'timer_state_v1';
  static const _timersKey = 'timers_v1';
  static const _stopwatchKey = 'stopwatch_v1';
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
  String? lastNativeError;

  /// Wallpaper accent reported by Android 12+, or `null` on older releases.
  int? dynamicSeedColor;
  bool _sleepReminderNeedsSync = false;

  /// Elapsed time already banked before the current run.
  Duration stopwatchBase = Duration.zero;

  /// When the running segment started, or `null` while paused.
  DateTime? stopwatchStartedAt;
  List<Duration> stopwatchLaps = [];

  bool get stopwatchRunning => stopwatchStartedAt != null;

  Duration get stopwatchElapsed => stopwatchStartedAt == null
      ? stopwatchBase
      : stopwatchBase + DateTime.now().difference(stopwatchStartedAt!);

  /// Every countdown the user has going. The native layer schedules by id, so
  /// more than one can run at a time.
  List<TimerItem> timers = [];

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
    alarms = _decodeList(
      _alarmsKey,
      AlarmItem.fromJson,
    ).map((alarm) => alarm.withPrunedSkips()).toList();
    groups = _decodeList(_groupsKey, AlarmGroup.fromJson);
    history = _decodeList(_historyKey, AlarmHistoryEvent.fromJson);
    cities = _decodeList(_citiesKey, WorldCity.fromJson);

    final groupsInitialized =
        _prefs.getBool(_groupsInitializedKey) ?? _prefs.containsKey(_groupsKey);
    final citiesInitialized =
        _prefs.getBool(_citiesInitializedKey) ?? _prefs.containsKey(_citiesKey);
    if (!groupsInitialized) {
      groups = const [
        AlarmGroup(id: 'work', name: 'İş', colorValue: 0xFF8B5CF6),
        AlarmGroup(id: 'personal', name: 'Kişisel', colorValue: 0xFF2DD4BF),
      ];
    }
    if (!citiesInitialized) {
      cities = const [
        WorldCity(
          name: 'İstanbul',
          offsetMinutes: 180,
          timeZoneId: 'Europe/Istanbul',
        ),
      ];
    }
    if (!groupsInitialized || !citiesInitialized) {
      await Future.wait([
        if (!groupsInitialized) ...[
          _prefs.setString(
            _groupsKey,
            jsonEncode(groups.map((item) => item.toJson()).toList()),
          ),
          _prefs.setBool(_groupsInitializedKey, true),
        ],
        if (!citiesInitialized) ...[
          _persistCities(),
          _prefs.setBool(_citiesInitializedKey, true),
        ],
      ]);
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

    timers = _decodeList(_timersKey, TimerItem.fromJson);
    if (!_prefs.containsKey(_timersKey)) {
      // Migrate the single countdown written by builds before 1.2.
      final rawTimer = _prefs.getString(_timerStateKey);
      if (rawTimer != null) {
        try {
          final legacy = Map<String, dynamic>.from(jsonDecode(rawTimer) as Map);
          final total = (legacy['selectedSeconds'] as int? ?? 300).clamp(
            1,
            7 * 86400,
          );
          timers = [
            TimerItem(
              id: legacy['id'] as String? ?? newId('timer'),
              label: '',
              totalSeconds: total,
              remainingSeconds: (legacy['remainingSeconds'] as int? ?? total)
                  .clamp(0, 7 * 86400),
              target: legacy['running'] == true
                  ? DateTime.tryParse(legacy['target']?.toString() ?? '')
                  : null,
            ),
          ];
        } catch (_) {
          timers = [];
        }
      }
      await _prefs.remove(_timerStateKey);
      await _persistTimers();
    }
    // Drop countdowns that ran out while the app was closed.
    timers = timers
        .where((timer) => timer.target == null || timer.secondsLeft() > 0)
        .toList();

    final rawStopwatch = _prefs.getString(_stopwatchKey);
    if (rawStopwatch != null) {
      try {
        final data = Map<String, dynamic>.from(jsonDecode(rawStopwatch) as Map);
        stopwatchBase = Duration(
          milliseconds: (data['baseMillis'] as int? ?? 0).clamp(0, 1 << 40),
        );
        stopwatchStartedAt = DateTime.tryParse(
          data['startedAt']?.toString() ?? '',
        );
        stopwatchLaps = [
          for (final lap in data['laps'] as List? ?? const [])
            Duration(milliseconds: (lap as num).toInt()),
        ];
      } catch (_) {
        await clearStopwatch();
      }
    }

    await _safeNative(() => native.setApplicationLocale(localeCode));

    await _consumeNativeHistory();
    _sleepReminderNeedsSync = rawSleep != null;
    ready = true;
    notifyListeners();
  }

  /// Reads the Android 12+ wallpaper accent.
  ///
  /// Deliberately kept out of [load]: a platform-channel call that is awaited
  /// before the first pump deadlocks `testWidgets`, and the palette is not
  /// needed to build correct state. `main` calls it once at start-up.
  Future<void> loadDynamicColor() async {
    await _safeNative(() async {
      dynamicSeedColor = await native.dynamicColorSeed();
    });
  }

  /// Writes an automatic backup when one is due.
  ///
  /// Runs on launch rather than on a timer: a weekly cadence needs no scheduler
  /// when the check is "is the last copy older than a week?".
  Future<void> runAutoBackupIfDue({
    Duration every = const Duration(days: 7),
  }) async {
    final folder = settings.autoBackupFolder;
    if (folder == null) return;
    final last = settings.lastAutoBackupAt;
    if (last != null && DateTime.now().difference(last) < every) return;
    try {
      final json = await createBackupJson();
      final written = await native.writeAutoBackup(treeUri: folder, json: json);
      if (!written) return;
      settings = settings.copyWith(lastAutoBackupAt: DateTime.now());
      await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
      notifyListeners();
    } on MissingPluginException {
      // Non-Android previews have no folder to write to.
    } on PlatformException {
      // A revoked folder grant must not break start-up.
    }
  }

  /// Pushes every stored alarm back to the Android scheduler.
  ///
  /// Kept out of [load] because it costs one platform-channel round trip per
  /// alarm; `main` runs it after the first frame so a large alarm list no
  /// longer delays start-up.
  Future<void> syncDeliveryQueue() async {
    await rescheduleAll();
    await runAutoBackupIfDue();
    if (_sleepReminderNeedsSync) {
      _sleepReminderNeedsSync = false;
      await _scheduleSleepReminder(sleepProfile);
    }
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
      await _safeNative(() => native.cancel(id), reportFailure: true);
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

  /// Drops the next occurrence of each alarm without disabling it. Returns the
  /// ids that actually had an occurrence left to skip.
  Future<Set<String>> skipNextOccurrence(Iterable<String> ids) async {
    final idSet = ids.toSet();
    final skipped = <String>{};
    alarms = [
      for (final alarm in alarms)
        if (!idSet.contains(alarm.id))
          alarm
        else
          () {
            final next = alarm.nextOccurrence(group: groupFor(alarm.groupId));
            if (next == null) return alarm;
            final key = dateKey(next);
            if (alarm.skippedDates.contains(key)) return alarm;
            skipped.add(alarm.id);
            return alarm
                .copyWith(skippedDates: [...alarm.skippedDates, key])
                .withPrunedSkips();
          }(),
    ];
    if (skipped.isEmpty) return skipped;
    await _persistAlarms();
    notifyListeners();
    await _rescheduleIds(skipped);
    return skipped;
  }

  /// Clears every pending skip so the alarm resumes its normal schedule.
  Future<void> clearSkips(String id) async {
    final alarm = alarms.firstWhere((item) => item.id == id);
    if (alarm.skippedDates.isEmpty) return;
    await updateAlarm(alarm.copyWith(skippedDates: const []));
  }

  Future<void> saveGroup(AlarmGroup group) async {
    final exists = groups.any((item) => item.id == group.id);
    groups = exists
        ? [
            for (final item in groups)
              if (item.id == group.id) group else item,
          ]
        : [...groups, group];
    await Future.wait([
      _prefs.setString(
        _groupsKey,
        jsonEncode(groups.map((item) => item.toJson()).toList()),
      ),
      _prefs.setBool(_groupsInitializedKey, true),
    ]);
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
    await Future.wait([
      _prefs.setString(
        _groupsKey,
        jsonEncode(groups.map((item) => item.toJson()).toList()),
      ),
      _prefs.setBool(_groupsInitializedKey, true),
    ]);
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

  Future<void> _persistTimers() => _prefs.setString(
    _timersKey,
    jsonEncode(timers.map((item) => item.toJson()).toList()),
  );

  void _replaceTimer(TimerItem timer) {
    timers = [
      for (final item in timers)
        if (item.id == timer.id) timer else item,
    ];
  }

  /// Creates a countdown and starts it straight away, which is what picking a
  /// duration means in practice.
  Future<TimerItem?> addTimer({
    required int seconds,
    required String label,
    required String deliveryLabel,
  }) async {
    final timer = TimerItem(
      id: newId('timer'),
      label: label,
      totalSeconds: seconds.clamp(1, 7 * 86400),
      remainingSeconds: seconds.clamp(1, 7 * 86400),
    );
    timers = [...timers, timer];
    await _persistTimers();
    notifyListeners();
    return startTimer(timer.id, deliveryLabel: deliveryLabel);
  }

  Future<TimerItem?> startTimer(
    String id, {
    required String deliveryLabel,
  }) async {
    final index = timers.indexWhere((item) => item.id == id);
    if (index < 0) return null;
    final timer = timers[index];
    final seconds = timer.secondsLeft() > 0
        ? timer.secondsLeft()
        : timer.totalSeconds;
    final target = DateTime.now().add(Duration(seconds: seconds));
    final scheduled = await scheduleTimerDelivery(
      id: timer.id,
      label: timer.label.isEmpty ? deliveryLabel : timer.label,
      triggerAtMillis: target.millisecondsSinceEpoch,
    );
    if (!scheduled) return null;
    final started = timer.copyWith(remainingSeconds: seconds, target: target);
    _replaceTimer(started);
    await _persistTimers();
    notifyListeners();
    return started;
  }

  Future<void> pauseTimer(String id) async {
    final index = timers.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final timer = timers[index];
    await cancelTimerDelivery(id);
    _replaceTimer(
      timer.copyWith(remainingSeconds: timer.secondsLeft(), target: null),
    );
    await _persistTimers();
    notifyListeners();
  }

  Future<void> resetTimer(String id) async {
    final index = timers.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final timer = timers[index];
    await cancelTimerDelivery(id);
    _replaceTimer(
      timer.copyWith(remainingSeconds: timer.totalSeconds, target: null),
    );
    await _persistTimers();
    notifyListeners();
  }

  Future<void> removeTimer(String id) async {
    await cancelTimerDelivery(id);
    timers = timers.where((item) => item.id != id).toList();
    await _persistTimers();
    notifyListeners();
  }

  /// Called by the UI when a countdown reaches zero; the native alarm has
  /// already fired by then.
  Future<void> expireTimer(String id) async {
    final index = timers.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _replaceTimer(
      timers[index].copyWith(
        remainingSeconds: timers[index].totalSeconds,
        target: null,
      ),
    );
    await _persistTimers();
    notifyListeners();
  }

  Future<void> _persistStopwatch() => _prefs.setString(
    _stopwatchKey,
    jsonEncode({
      'baseMillis': stopwatchBase.inMilliseconds,
      'startedAt': stopwatchStartedAt?.toIso8601String(),
      'laps': stopwatchLaps.map((lap) => lap.inMilliseconds).toList(),
    }),
  );

  Future<void> toggleStopwatch() async {
    if (stopwatchStartedAt == null) {
      stopwatchStartedAt = DateTime.now();
    } else {
      stopwatchBase = stopwatchElapsed;
      stopwatchStartedAt = null;
    }
    notifyListeners();
    await _persistStopwatch();
  }

  Future<void> addStopwatchLap() async {
    stopwatchLaps = [stopwatchElapsed, ...stopwatchLaps];
    notifyListeners();
    await _persistStopwatch();
  }

  Future<void> clearStopwatch() async {
    stopwatchBase = Duration.zero;
    stopwatchStartedAt = null;
    stopwatchLaps = [];
    notifyListeners();
    await _prefs.remove(_stopwatchKey);
  }

  Future<bool> scheduleTimerDelivery({
    required String id,
    required String label,
    required int triggerAtMillis,
  }) => _safeNative(
    () => native.scheduleTimer(
      id: id,
      label: label,
      triggerAtMillis: triggerAtMillis,
      ringtoneUri: settings.timerRingtoneUri,
      volume: settings.alarmVolume,
    ),
    reportFailure: true,
  );

  Future<bool> cancelTimerDelivery(String id) =>
      _safeNative(() => native.cancelTimer(id), reportFailure: true);

  void clearNativeError() {
    if (lastNativeError == null) return;
    lastNativeError = null;
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
    late final Map<String, dynamic> root;
    late final List<AlarmItem> restoredAlarms;
    late final List<AlarmGroup> restoredGroups;
    late final List<AlarmHistoryEvent> restoredHistory;
    late final List<WorldCity> restoredCities;
    late final AppSettings restoredSettings;
    late final SleepProfile restoredSleep;
    String? restoredLocale;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        throw const BackupFormatException(BackupIssue.invalidFormat);
      }
      root = Map<String, dynamic>.from(decoded);
      if (root['schemaVersion'] != 1 || root['app'] != 'Snoon') {
        throw const BackupFormatException(BackupIssue.unsupportedFile);
      }

      List<T> decodeItems<T>(
        String key,
        T Function(Map<String, dynamic>) parse,
      ) {
        final value = root[key];
        if (value is! List) {
          throw const BackupFormatException(BackupIssue.corruptContent);
        }
        return value.map((item) {
          if (item is! Map) {
            throw const BackupFormatException(BackupIssue.corruptContent);
          }
          return parse(Map<String, dynamic>.from(item));
        }).toList();
      }

      restoredAlarms = decodeItems('alarms', AlarmItem.fromJson);
      restoredGroups = decodeItems('groups', AlarmGroup.fromJson);
      restoredHistory = decodeItems('history', AlarmHistoryEvent.fromJson);
      restoredCities = decodeItems('cities', WorldCity.fromJson);
      if (root['settings'] is! Map || root['sleepProfile'] is! Map) {
        throw const BackupFormatException(BackupIssue.corruptContent);
      }
      restoredSettings = AppSettings.fromJson(
        Map<String, dynamic>.from(root['settings'] as Map),
      );
      restoredSleep = SleepProfile.fromJson(
        Map<String, dynamic>.from(root['sleepProfile'] as Map),
      );
      restoredLocale = root['localeCode']?.toString();
    } on BackupFormatException {
      rethrow;
    } catch (_) {
      // Includes the FormatException jsonDecode raises on malformed files.
      throw const BackupFormatException(BackupIssue.corruptContent);
    }

    final groupIds = restoredGroups.map((item) => item.id).toSet();
    if (restoredGroups.any(
          (group) =>
              group.id.trim().isEmpty ||
              group.name.trim().isEmpty ||
              group.excludedDates.any(
                (date) => DateTime.tryParse(date) == null,
              ),
        ) ||
        groupIds.length != restoredGroups.length) {
      throw const BackupFormatException(BackupIssue.invalidGroup);
    }
    if (restoredAlarms.any((alarm) {
      final end = alarm.rangeEndMinutes;
      final volume = alarm.volume;
      return alarm.id.trim().isEmpty ||
          (volume != null &&
              (!volume.isFinite || volume < 0.05 || volume > 1)) ||
          alarm.skippedDates.any((date) => DateTime.tryParse(date) == null) ||
          !alarm.hour.inRange(0, 23) ||
          !alarm.minute.inRange(0, 59) ||
          alarm.intervalMinutes <= 0 ||
          alarm.intervalMinutes > 24 * 60 ||
          alarm.repeatDays.any((day) => !day.inRange(1, 7)) ||
          alarm.repeatDays.toSet().length != alarm.repeatDays.length ||
          (alarm.groupId != null && !groupIds.contains(alarm.groupId)) ||
          (end != null &&
              (end <= alarm.startMinutes || end > alarm.startMinutes + 1439));
    })) {
      throw const BackupFormatException(BackupIssue.invalidAlarm);
    }
    if (restoredAlarms.map((item) => item.id).toSet().length !=
        restoredAlarms.length) {
      throw const BackupFormatException(BackupIssue.duplicateAlarm);
    }
    if (!restoredSettings.alarmVolume.isFinite ||
        restoredSettings.alarmVolume < 0.05 ||
        restoredSettings.alarmVolume > 1 ||
        restoredSettings.autoSilenceMinutes <= 0 ||
        restoredSettings.snoozeMinutes <= 0 ||
        restoredSettings.maxSnoozes < 0 ||
        restoredSettings.preNotificationMinutes < 0) {
      throw const BackupFormatException(BackupIssue.invalidSettings);
    }
    if (!restoredSleep.bedHour.inRange(0, 23) ||
        !restoredSleep.wakeHour.inRange(0, 23) ||
        !restoredSleep.bedMinute.inRange(0, 59) ||
        !restoredSleep.wakeMinute.inRange(0, 59) ||
        restoredSleep.windDownMinutes <= 0 ||
        restoredSleep.days.any((day) => !day.inRange(1, 7))) {
      throw const BackupFormatException(BackupIssue.invalidSleep);
    }
    if (restoredCities.any(
      (city) =>
          city.name.trim().isEmpty || !city.offsetMinutes.inRange(-840, 840),
    )) {
      throw const BackupFormatException(BackupIssue.invalidCity);
    }

    await _safeNative(native.cancelAll, reportFailure: true);
    alarms = restoredAlarms;
    groups = restoredGroups;
    history = restoredHistory.take(300).toList();
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
      _prefs.setBool(_groupsInitializedKey, true),
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
      await _safeNative(() => native.cancel(alarm.id), reportFailure: true);
      return;
    }
    final record = _nativeRecord(alarm);
    if (record['triggerAtMillis'] == null) {
      await _safeNative(() => native.cancel(alarm.id), reportFailure: true);
      return;
    }
    await _safeNative(() => native.schedule(record), reportFailure: true);
  }

  Future<void> _scheduleSleepReminder(SleepProfile profile) async {
    const id = 'sleep-bedtime-reminder';
    if (!profile.enabled || profile.days.isEmpty) {
      await _safeNative(() => native.cancel(id), reportFailure: true);
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
      await _safeNative(() => native.cancel(id), reportFailure: true);
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
      reportFailure: true,
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
      'skippedDates': alarm.skippedDates,
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
      'mathDifficulty': alarm.mathDifficulty.name,
      'morningRoutine': alarm.morningRoutine,
      'gentleReminderMinutes': alarm.gentleReminderMinutes,
      'backupAlarmMinutes': alarm.backupAlarmMinutes,
      'volume': alarm.volume ?? settings.alarmVolume,
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

  Future<void> _persistCities() => Future.wait([
    _prefs.setString(
      _citiesKey,
      jsonEncode(cities.map((item) => item.toJson()).toList()),
    ),
    _prefs.setBool(_citiesInitializedKey, true),
  ]).then((_) {});

  Future<bool> _safeNative(
    Future<void> Function() operation, {
    bool reportFailure = false,
  }) async {
    try {
      await operation();
      if (reportFailure && lastNativeError != null) {
        lastNativeError = null;
        if (ready) notifyListeners();
      }
      return true;
    } on MissingPluginException {
      // Non-Android previews intentionally run without alarm delivery.
      return false;
    } on PlatformException catch (error) {
      if (reportFailure) {
        lastNativeError = error.message?.trim().isNotEmpty == true
            ? error.message!.trim()
            : error.code;
        if (ready) notifyListeners();
      }
      return false;
    }
  }
}

extension on int {
  bool inRange(int minimum, int maximum) => this >= minimum && this <= maximum;
}
