import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snoon/main.dart' as app;
import 'package:snoon/models/alarm_models.dart';
import 'package:snoon/services/native_alarm_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('native aralık alarmı bildirim ve erteleme denetimi', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final now = DateTime.now();
    final startMinutes = now.hour * 60 + now.minute;
    final trigger = now.add(const Duration(seconds: 10));
    await NativeAlarmService().schedule({
      'id': 'native-delivery-test',
      'label': 'Snoon teslimat testi',
      'enabled': true,
      'hour': now.hour,
      'minute': now.minute,
      'repeatDays': <int>[],
      'oneShotDate': dateKey(now),
      'rangeEndMinutes': startMinutes + 30,
      'intervalMinutes': 5,
      'triggerAtMillis': trigger.millisecondsSinceEpoch,
      'vibrate': false,
      'deleteAfterRinging': false,
      'dismissTask': 'none',
      'morningRoutine': false,
      'volume': 0.5,
      'gradualVolume': false,
      'autoSilenceMinutes': 10,
      'snoozeMinutes': 5,
      'maxSnoozes': 3,
      'volumeButtonAction': 'snooze',
      'preNotificationMinutes': 0,
      'showOnLockScreen': true,
    });

    // The host-side verification inspects and operates the native Android
    // ringing and snoozed notifications while this test keeps the app alive.
    await Future<void>.delayed(const Duration(seconds: 120));
  }, timeout: const Timeout(Duration(minutes: 3)));
}
