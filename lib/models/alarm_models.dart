import 'package:timezone/timezone.dart' as tz;

const _unset = Object();

String dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

DateTime? parseDate(dynamic value) {
  if (value == null || value.toString().isEmpty) return null;
  return DateTime.tryParse(value.toString());
}

enum DismissTask { none, math, shake }

extension DismissTaskX on DismissTask {
  String get label => switch (this) {
    DismissTask.none => 'Görev yok',
    DismissTask.math => 'Matematik işlemi',
    DismissTask.shake => 'Telefonu 5 kez salla',
  };
}

enum VolumeButtonAction { volume, snooze, dismiss }

enum SnoonThemeMode { system, dark, light }

extension SnoonThemeModeX on SnoonThemeMode {
  String get label => switch (this) {
    SnoonThemeMode.system => 'Sistem temasını kullan',
    SnoonThemeMode.dark => 'Koyu tema',
    SnoonThemeMode.light => 'Açık tema',
  };
}

extension VolumeButtonActionX on VolumeButtonAction {
  String get label => switch (this) {
    VolumeButtonAction.volume => 'Ses düzeyini değiştir',
    VolumeButtonAction.snooze => 'Alarmı ertele',
    VolumeButtonAction.dismiss => 'Alarmı kapat',
  };
}

class AlarmGroup {
  const AlarmGroup({
    required this.id,
    required this.name,
    required this.colorValue,
    this.pausedUntil,
    this.excludedDates = const [],
    this.todayShiftDate,
    this.todayShiftMinutes = 0,
  });

  final String id;
  final String name;
  final int colorValue;
  final DateTime? pausedUntil;
  final List<String> excludedDates;
  final String? todayShiftDate;
  final int todayShiftMinutes;

  AlarmGroup copyWith({
    String? name,
    int? colorValue,
    Object? pausedUntil = _unset,
    List<String>? excludedDates,
    Object? todayShiftDate = _unset,
    int? todayShiftMinutes,
  }) {
    return AlarmGroup(
      id: id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      pausedUntil: identical(pausedUntil, _unset)
          ? this.pausedUntil
          : pausedUntil as DateTime?,
      excludedDates: excludedDates ?? this.excludedDates,
      todayShiftDate: identical(todayShiftDate, _unset)
          ? this.todayShiftDate
          : todayShiftDate as String?,
      todayShiftMinutes: todayShiftMinutes ?? this.todayShiftMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'colorValue': colorValue,
    'pausedUntil': pausedUntil?.toIso8601String(),
    'excludedDates': excludedDates,
    'todayShiftDate': todayShiftDate,
    'todayShiftMinutes': todayShiftMinutes,
  };

  factory AlarmGroup.fromJson(Map<String, dynamic> json) => AlarmGroup(
    id: json['id'] as String,
    name: json['name'] as String? ?? 'Grup',
    colorValue: json['colorValue'] as int? ?? 0xFF8B5CF6,
    pausedUntil: parseDate(json['pausedUntil']),
    excludedDates: List<String>.from(
      json['excludedDates'] as List? ?? const [],
    ),
    todayShiftDate: json['todayShiftDate'] as String?,
    todayShiftMinutes: json['todayShiftMinutes'] as int? ?? 0,
  );
}

class AlarmItem {
  const AlarmItem({
    required this.id,
    required this.hour,
    required this.minute,
    required this.label,
    this.enabled = true,
    this.repeatDays = const [],
    this.oneShotDate,
    this.groupId,
    this.rangeEndMinutes,
    this.intervalMinutes = 5,
    this.vibrate = true,
    this.deleteAfterRinging = false,
    this.ringtoneUri,
    this.ringtoneName,
    this.dismissTask = DismissTask.none,
    this.morningRoutine = false,
    this.gentleReminderMinutes = 10,
    this.backupAlarmMinutes = 10,
    this.pausedUntil,
    this.todayShiftDate,
    this.todayShiftMinutes = 0,
    this.createdAt,
  });

  final String id;
  final int hour;
  final int minute;
  final String label;
  final bool enabled;
  final List<int> repeatDays;
  final DateTime? oneShotDate;
  final String? groupId;
  final int? rangeEndMinutes;
  final int intervalMinutes;
  final bool vibrate;
  final bool deleteAfterRinging;
  final String? ringtoneUri;
  final String? ringtoneName;
  final DismissTask dismissTask;
  final bool morningRoutine;
  final int gentleReminderMinutes;
  final int backupAlarmMinutes;
  final DateTime? pausedUntil;
  final String? todayShiftDate;
  final int todayShiftMinutes;
  final DateTime? createdAt;

  int get startMinutes => hour * 60 + minute;
  bool get isRange =>
      rangeEndMinutes != null && rangeEndMinutes! > startMinutes;

  AlarmItem copyWith({
    int? hour,
    int? minute,
    String? label,
    bool? enabled,
    List<int>? repeatDays,
    Object? oneShotDate = _unset,
    Object? groupId = _unset,
    Object? rangeEndMinutes = _unset,
    int? intervalMinutes,
    bool? vibrate,
    bool? deleteAfterRinging,
    Object? ringtoneUri = _unset,
    Object? ringtoneName = _unset,
    DismissTask? dismissTask,
    bool? morningRoutine,
    int? gentleReminderMinutes,
    int? backupAlarmMinutes,
    Object? pausedUntil = _unset,
    Object? todayShiftDate = _unset,
    int? todayShiftMinutes,
  }) {
    return AlarmItem(
      id: id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      repeatDays: repeatDays ?? this.repeatDays,
      oneShotDate: identical(oneShotDate, _unset)
          ? this.oneShotDate
          : oneShotDate as DateTime?,
      groupId: identical(groupId, _unset) ? this.groupId : groupId as String?,
      rangeEndMinutes: identical(rangeEndMinutes, _unset)
          ? this.rangeEndMinutes
          : rangeEndMinutes as int?,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      vibrate: vibrate ?? this.vibrate,
      deleteAfterRinging: deleteAfterRinging ?? this.deleteAfterRinging,
      ringtoneUri: identical(ringtoneUri, _unset)
          ? this.ringtoneUri
          : ringtoneUri as String?,
      ringtoneName: identical(ringtoneName, _unset)
          ? this.ringtoneName
          : ringtoneName as String?,
      dismissTask: dismissTask ?? this.dismissTask,
      morningRoutine: morningRoutine ?? this.morningRoutine,
      gentleReminderMinutes:
          gentleReminderMinutes ?? this.gentleReminderMinutes,
      backupAlarmMinutes: backupAlarmMinutes ?? this.backupAlarmMinutes,
      pausedUntil: identical(pausedUntil, _unset)
          ? this.pausedUntil
          : pausedUntil as DateTime?,
      todayShiftDate: identical(todayShiftDate, _unset)
          ? this.todayShiftDate
          : todayShiftDate as String?,
      todayShiftMinutes: todayShiftMinutes ?? this.todayShiftMinutes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hour': hour,
    'minute': minute,
    'label': label,
    'enabled': enabled,
    'repeatDays': repeatDays,
    'oneShotDate': oneShotDate?.toIso8601String(),
    'groupId': groupId,
    'rangeEndMinutes': rangeEndMinutes,
    'intervalMinutes': intervalMinutes,
    'vibrate': vibrate,
    'deleteAfterRinging': deleteAfterRinging,
    'ringtoneUri': ringtoneUri,
    'ringtoneName': ringtoneName,
    'dismissTask': dismissTask.name,
    'morningRoutine': morningRoutine,
    'gentleReminderMinutes': gentleReminderMinutes,
    'backupAlarmMinutes': backupAlarmMinutes,
    'pausedUntil': pausedUntil?.toIso8601String(),
    'todayShiftDate': todayShiftDate,
    'todayShiftMinutes': todayShiftMinutes,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory AlarmItem.fromJson(Map<String, dynamic> json) => AlarmItem(
    id: json['id'] as String,
    hour: json['hour'] as int? ?? 7,
    minute: json['minute'] as int? ?? 0,
    label: json['label'] as String? ?? 'Alarm',
    enabled: json['enabled'] as bool? ?? true,
    repeatDays: List<int>.from(json['repeatDays'] as List? ?? const []),
    oneShotDate: parseDate(json['oneShotDate']),
    groupId: json['groupId'] as String?,
    rangeEndMinutes: json['rangeEndMinutes'] as int?,
    intervalMinutes: json['intervalMinutes'] as int? ?? 5,
    vibrate: json['vibrate'] as bool? ?? true,
    deleteAfterRinging: json['deleteAfterRinging'] as bool? ?? false,
    ringtoneUri: json['ringtoneUri'] as String?,
    ringtoneName: json['ringtoneName'] as String?,
    dismissTask: DismissTask.values.firstWhere(
      (value) => value.name == json['dismissTask'],
      orElse: () => DismissTask.none,
    ),
    morningRoutine: json['morningRoutine'] as bool? ?? false,
    gentleReminderMinutes: json['gentleReminderMinutes'] as int? ?? 10,
    backupAlarmMinutes: json['backupAlarmMinutes'] as int? ?? 10,
    pausedUntil: parseDate(json['pausedUntil']),
    todayShiftDate: json['todayShiftDate'] as String?,
    todayShiftMinutes: json['todayShiftMinutes'] as int? ?? 0,
    createdAt: parseDate(json['createdAt']),
  );

  DateTime? nextOccurrence({DateTime? from, AlarmGroup? group}) {
    if (!enabled) return null;
    final now = from ?? DateTime.now();
    final alarmPause = pausedUntil;
    final groupPause = group?.pausedUntil;
    final resumeAfter = [alarmPause, groupPause]
        .whereType<DateTime>()
        .fold<DateTime?>(null, (latest, item) {
          if (latest == null || item.isAfter(latest)) return item;
          return latest;
        });

    for (var dayOffset = 0; dayOffset < 370; dayOffset++) {
      final date = DateTime(now.year, now.month, now.day + dayOffset);
      if (resumeAfter != null && !date.isAfter(resumeAfter)) continue;
      if (group?.excludedDates.contains(dateKey(date)) ?? false) continue;
      if (repeatDays.isNotEmpty && !repeatDays.contains(date.weekday)) continue;
      if (repeatDays.isEmpty &&
          oneShotDate != null &&
          dateKey(date) != dateKey(oneShotDate!)) {
        continue;
      }

      var shift = 0;
      if (todayShiftDate == dateKey(date)) shift += todayShiftMinutes;
      if (group?.todayShiftDate == dateKey(date)) {
        shift += group?.todayShiftMinutes ?? 0;
      }
      final end = isRange ? rangeEndMinutes! : startMinutes;
      for (
        var minutes = startMinutes;
        minutes <= end;
        minutes += intervalMinutes > 0 ? intervalMinutes : 1
      ) {
        final candidate = DateTime(
          date.year,
          date.month,
          date.day,
          minutes ~/ 60,
          minutes % 60,
        ).add(Duration(minutes: shift));
        if (candidate.isAfter(now)) return candidate;
      }
    }
    return null;
  }
}

class AppSettings {
  const AppSettings({
    this.alarmRingtoneUri,
    this.alarmRingtoneName = 'Sistem alarm sesi',
    this.timerRingtoneUri,
    this.timerRingtoneName = 'Sistem zamanlayıcı sesi',
    this.alarmVolume = 0.8,
    this.autoSilenceMinutes = 10,
    this.vibrate = true,
    this.gradualVolume = true,
    this.snoozeMinutes = 5,
    this.maxSnoozes = 3,
    this.volumeButtonAction = VolumeButtonAction.snooze,
    this.preNotificationMinutes = 10,
    this.showOnLockScreen = true,
    this.themeMode = SnoonThemeMode.system,
  });

  final String? alarmRingtoneUri;
  final String alarmRingtoneName;
  final String? timerRingtoneUri;
  final String timerRingtoneName;
  final double alarmVolume;
  final int autoSilenceMinutes;
  final bool vibrate;
  final bool gradualVolume;
  final int snoozeMinutes;
  final int maxSnoozes;
  final VolumeButtonAction volumeButtonAction;
  final int preNotificationMinutes;
  final bool showOnLockScreen;
  final SnoonThemeMode themeMode;

  AppSettings copyWith({
    Object? alarmRingtoneUri = _unset,
    String? alarmRingtoneName,
    Object? timerRingtoneUri = _unset,
    String? timerRingtoneName,
    double? alarmVolume,
    int? autoSilenceMinutes,
    bool? vibrate,
    bool? gradualVolume,
    int? snoozeMinutes,
    int? maxSnoozes,
    VolumeButtonAction? volumeButtonAction,
    int? preNotificationMinutes,
    bool? showOnLockScreen,
    SnoonThemeMode? themeMode,
  }) => AppSettings(
    alarmRingtoneUri: identical(alarmRingtoneUri, _unset)
        ? this.alarmRingtoneUri
        : alarmRingtoneUri as String?,
    alarmRingtoneName: alarmRingtoneName ?? this.alarmRingtoneName,
    timerRingtoneUri: identical(timerRingtoneUri, _unset)
        ? this.timerRingtoneUri
        : timerRingtoneUri as String?,
    timerRingtoneName: timerRingtoneName ?? this.timerRingtoneName,
    alarmVolume: alarmVolume ?? this.alarmVolume,
    autoSilenceMinutes: autoSilenceMinutes ?? this.autoSilenceMinutes,
    vibrate: vibrate ?? this.vibrate,
    gradualVolume: gradualVolume ?? this.gradualVolume,
    snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
    maxSnoozes: maxSnoozes ?? this.maxSnoozes,
    volumeButtonAction: volumeButtonAction ?? this.volumeButtonAction,
    preNotificationMinutes:
        preNotificationMinutes ?? this.preNotificationMinutes,
    showOnLockScreen: showOnLockScreen ?? this.showOnLockScreen,
    themeMode: themeMode ?? this.themeMode,
  );

  Map<String, dynamic> toJson() => {
    'alarmRingtoneUri': alarmRingtoneUri,
    'alarmRingtoneName': alarmRingtoneName,
    'timerRingtoneUri': timerRingtoneUri,
    'timerRingtoneName': timerRingtoneName,
    'alarmVolume': alarmVolume,
    'autoSilenceMinutes': autoSilenceMinutes,
    'vibrate': vibrate,
    'gradualVolume': gradualVolume,
    'snoozeMinutes': snoozeMinutes,
    'maxSnoozes': maxSnoozes,
    'volumeButtonAction': volumeButtonAction.name,
    'preNotificationMinutes': preNotificationMinutes,
    'showOnLockScreen': showOnLockScreen,
    'themeMode': themeMode.name,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    alarmRingtoneUri: json['alarmRingtoneUri'] as String?,
    alarmRingtoneName:
        json['alarmRingtoneName'] as String? ?? 'Sistem alarm sesi',
    timerRingtoneUri: json['timerRingtoneUri'] as String?,
    timerRingtoneName:
        json['timerRingtoneName'] as String? ?? 'Sistem zamanlayıcı sesi',
    alarmVolume: (json['alarmVolume'] as num?)?.toDouble() ?? 0.8,
    autoSilenceMinutes: json['autoSilenceMinutes'] as int? ?? 10,
    vibrate: json['vibrate'] as bool? ?? true,
    gradualVolume: json['gradualVolume'] as bool? ?? true,
    snoozeMinutes: json['snoozeMinutes'] as int? ?? 5,
    maxSnoozes: json['maxSnoozes'] as int? ?? 3,
    volumeButtonAction: VolumeButtonAction.values.firstWhere(
      (value) => value.name == json['volumeButtonAction'],
      orElse: () => VolumeButtonAction.snooze,
    ),
    preNotificationMinutes: json['preNotificationMinutes'] as int? ?? 10,
    showOnLockScreen: json['showOnLockScreen'] as bool? ?? true,
    themeMode: SnoonThemeMode.values.firstWhere(
      (value) => value.name == json['themeMode'],
      orElse: () => SnoonThemeMode.system,
    ),
  );
}

class AlarmHistoryEvent {
  const AlarmHistoryEvent({
    required this.id,
    required this.alarmId,
    required this.label,
    required this.action,
    required this.timestamp,
  });

  final String id;
  final String alarmId;
  final String label;
  final String action;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'id': id,
    'alarmId': alarmId,
    'label': label,
    'action': action,
    'timestamp': timestamp.toIso8601String(),
  };

  factory AlarmHistoryEvent.fromJson(Map<String, dynamic> json) =>
      AlarmHistoryEvent(
        id: json['id'] as String,
        alarmId: json['alarmId'] as String? ?? '',
        label: json['label'] as String? ?? 'Alarm',
        action: json['action'] as String? ?? 'Çaldı',
        timestamp: parseDate(json['timestamp']) ?? DateTime.now(),
      );
}

class SleepProfile {
  const SleepProfile({
    this.enabled = false,
    this.bedHour = 23,
    this.bedMinute = 0,
    this.wakeHour = 7,
    this.wakeMinute = 0,
    this.windDownMinutes = 30,
    this.days = const [1, 2, 3, 4, 5],
  });

  final bool enabled;
  final int bedHour;
  final int bedMinute;
  final int wakeHour;
  final int wakeMinute;
  final int windDownMinutes;
  final List<int> days;

  SleepProfile copyWith({
    bool? enabled,
    int? bedHour,
    int? bedMinute,
    int? wakeHour,
    int? wakeMinute,
    int? windDownMinutes,
    List<int>? days,
  }) => SleepProfile(
    enabled: enabled ?? this.enabled,
    bedHour: bedHour ?? this.bedHour,
    bedMinute: bedMinute ?? this.bedMinute,
    wakeHour: wakeHour ?? this.wakeHour,
    wakeMinute: wakeMinute ?? this.wakeMinute,
    windDownMinutes: windDownMinutes ?? this.windDownMinutes,
    days: days ?? this.days,
  );

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'bedHour': bedHour,
    'bedMinute': bedMinute,
    'wakeHour': wakeHour,
    'wakeMinute': wakeMinute,
    'windDownMinutes': windDownMinutes,
    'days': days,
  };

  factory SleepProfile.fromJson(Map<String, dynamic> json) => SleepProfile(
    enabled: json['enabled'] as bool? ?? false,
    bedHour: json['bedHour'] as int? ?? 23,
    bedMinute: json['bedMinute'] as int? ?? 0,
    wakeHour: json['wakeHour'] as int? ?? 7,
    wakeMinute: json['wakeMinute'] as int? ?? 0,
    windDownMinutes: json['windDownMinutes'] as int? ?? 30,
    days: List<int>.from(json['days'] as List? ?? const [1, 2, 3, 4, 5]),
  );
}

class WorldCity {
  const WorldCity({
    required this.name,
    required this.offsetMinutes,
    this.timeZoneId,
  });
  final String name;
  final int offsetMinutes;
  final String? timeZoneId;

  DateTime timeAt(DateTime utc) {
    final zoneId = timeZoneId;
    if (zoneId != null) {
      try {
        return tz.TZDateTime.from(utc.toUtc(), tz.getLocation(zoneId));
      } catch (_) {
        // Eski kaydın sabit UTC farkına geri dön.
      }
    }
    return utc.toUtc().add(Duration(minutes: offsetMinutes));
  }

  int offsetAt(DateTime utc) {
    final time = timeAt(utc);
    return time is tz.TZDateTime
        ? time.timeZoneOffset.inMinutes
        : offsetMinutes;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'offsetMinutes': offsetMinutes,
    'timeZoneId': timeZoneId,
  };

  factory WorldCity.fromJson(Map<String, dynamic> json) => WorldCity(
    name: json['name'] as String,
    offsetMinutes: json['offsetMinutes'] as int,
    timeZoneId: json['timeZoneId'] as String?,
  );
}
