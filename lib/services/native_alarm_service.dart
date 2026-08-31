import 'package:flutter/services.dart';

class RingtoneChoice {
  const RingtoneChoice({required this.name, required this.uri});

  /// `null` when Android reports no display name; the UI then falls back to
  /// its localized default label.
  final String? name;
  final String uri;
}

class NativeAlarmService {
  static const _channel = MethodChannel('com.furka.snoon/alarm');

  Future<void> schedule(Map<String, dynamic> record) =>
      _channel.invokeMethod<void>('scheduleAlarm', record);

  Future<void> cancel(String id) =>
      _channel.invokeMethod<void>('cancelAlarm', {'id': id});

  Future<void> cancelAll() => _channel.invokeMethod<void>('cancelAll');

  Future<void> setApplicationLocale(String languageCode) =>
      _channel.invokeMethod<void>('setApplicationLocale', {
        'languageCode': languageCode,
      });

  Future<bool> canScheduleExactAlarms() async =>
      await _channel.invokeMethod<bool>('canScheduleExactAlarms') ?? false;

  Future<bool> notificationsGranted() async =>
      await _channel.invokeMethod<bool>('notificationsGranted') ?? false;

  Future<bool> alarmNotificationsOperational() async =>
      await _channel.invokeMethod<bool>('alarmNotificationsOperational') ??
      false;

  Future<bool> batteryOptimizationDisabled() async =>
      await _channel.invokeMethod<bool>('batteryOptimizationDisabled') ?? false;

  Future<void> requestExactAlarmPermission() =>
      _channel.invokeMethod<void>('requestExactAlarmPermission');

  Future<bool> requestNotificationPermission() async =>
      await _channel.invokeMethod<bool>('requestNotificationPermission') ??
      false;

  Future<bool> canUseFullScreenIntent() async =>
      await _channel.invokeMethod<bool>('canUseFullScreenIntent') ?? false;

  Future<void> requestFullScreenIntentPermission() =>
      _channel.invokeMethod<void>('requestFullScreenIntentPermission');

  Future<bool> alarmStreamAudible() async =>
      await _channel.invokeMethod<bool>('alarmStreamAudible') ?? false;

  Future<void> openSoundSettings() =>
      _channel.invokeMethod<void>('openSoundSettings');

  Future<void> openBatterySettings() =>
      _channel.invokeMethod<void>('openBatterySettings');

  Future<void> openAppSettings() =>
      _channel.invokeMethod<void>('openAppSettings');

  Future<void> openNotificationSettings() =>
      _channel.invokeMethod<void>('openNotificationSettings');

  /// ARGB of the Android 12+ wallpaper accent, or `null` when the platform
  /// does not offer one.
  Future<int?> dynamicColorSeed() =>
      _channel.invokeMethod<int>('dynamicColorSeed');

  Future<String> deviceManufacturer() async =>
      await _channel.invokeMethod<String>('deviceManufacturer') ?? 'Android';

  Future<void> openDateTimeSettings() =>
      _channel.invokeMethod<void>('openDateTimeSettings');

  Future<RingtoneChoice?> pickRingtone({required bool alarm}) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'pickRingtone',
      {'alarm': alarm},
    );
    if (result == null || result['uri'] == null) return null;
    final name = result['name'] as String?;
    return RingtoneChoice(
      name: name == null || name.isEmpty ? null : name,
      uri: result['uri'] as String,
    );
  }

  Future<List<Map<String, dynamic>>> consumeHistory() async {
    final result = await _channel.invokeListMethod<dynamic>('consumeHistory');
    return (result ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> showTestAlarm(Map<String, dynamic> record) =>
      _channel.invokeMethod<void>('showTestAlarm', record);

  Future<void> scheduleTimer({
    required String id,
    required String label,
    required int triggerAtMillis,
    String? ringtoneUri,
    required double volume,
  }) => _channel.invokeMethod<void>('scheduleTimer', {
    'id': id,
    'label': label,
    'triggerAtMillis': triggerAtMillis,
    'ringtoneUri': ringtoneUri,
    'volume': volume,
  });

  Future<void> cancelTimer(String id) =>
      _channel.invokeMethod<void>('cancelTimer', {'id': id});

  Future<bool> saveBackup(String json) async =>
      await _channel.invokeMethod<bool>('saveBackup', {'json': json}) ?? false;

  Future<String?> pickBackup() => _channel.invokeMethod<String>('pickBackup');

  /// Asks for a folder and keeps the grant, returning its tree URI.
  Future<String?> pickBackupFolder() =>
      _channel.invokeMethod<String>('pickBackupFolder');

  Future<bool> writeAutoBackup({
    required String treeUri,
    required String json,
  }) async =>
      await _channel.invokeMethod<bool>('writeAutoBackup', {
        'treeUri': treeUri,
        'json': json,
      }) ??
      false;
}
