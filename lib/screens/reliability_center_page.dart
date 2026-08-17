import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import '../services/app_store.dart';

class ReliabilityCenterPage extends StatefulWidget {
  const ReliabilityCenterPage({super.key, required this.store});
  final AppStore store;

  @override
  State<ReliabilityCenterPage> createState() => _ReliabilityCenterPageState();
}

class _ReliabilityCenterPageState extends State<ReliabilityCenterPage>
    with WidgetsBindingObserver {
  bool? _exact;
  bool? _notifications;
  bool? _fullScreen;
  bool? _sound;
  bool? _battery;
  String _manufacturer = 'Android';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    try {
      final values = await Future.wait([
        widget.store.native.canScheduleExactAlarms(),
        widget.store.native.alarmNotificationsOperational(),
        widget.store.native.canUseFullScreenIntent(),
        widget.store.native.alarmStreamAudible(),
        widget.store.native.batteryOptimizationDisabled(),
      ]);
      final manufacturer = await widget.store.native.deviceManufacturer();
      if (mounted) {
        setState(() {
          _exact = values[0];
          _notifications = values[1];
          _fullScreen = values[2];
          _sound = values[3];
          _battery = values[4];
          _manufacturer = manufacturer;
        });
      }
    } on PlatformException {
      if (mounted) {
        setState(
          () =>
              _exact = _notifications = _fullScreen = _sound = _battery = false,
        );
      }
    }
  }

  Future<void> _testAlarm() async {
    final l10n = context.l10n;
    final task = await showModalBottomSheet<DismissTask>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.testAlarmType,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              for (final value in DismissTask.values)
                ListTile(
                  leading: Icon(switch (value) {
                    DismissTask.none => Icons.alarm,
                    DismissTask.math => Icons.calculate_outlined,
                    DismissTask.shake => Icons.vibration,
                  }),
                  title: Text(localizedDismissTaskLabel(l10n, value)),
                  subtitle: value == DismissTask.none
                      ? Text(l10n.dismissDirectly)
                      : Text(l10n.verifyDismissTask),
                  onTap: () => Navigator.pop(context, value),
                ),
            ],
          ),
        ),
      ),
    );
    if (task == null || !mounted) return;
    final now = DateTime.now().add(const Duration(seconds: 10));
    final alarm = AlarmItem(
      id: 'test-${DateTime.now().millisecondsSinceEpoch}',
      hour: now.hour,
      minute: now.minute,
      label: l10n.testAlarm,
      oneShotDate: now,
      dismissTask: task,
    );
    await widget.store.native.showTestAlarm(
      widget.store.nativeRecordFor(alarm),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.testScheduled(localizedDismissTaskLabel(l10n, task)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allGood =
        _exact == true &&
        _notifications == true &&
        _fullScreen == true &&
        _sound == true &&
        widget.store.lastNativeError == null;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reliabilityCenter)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: allGood
                  ? const Color(0xFF12352F)
                  : const Color(0xFF3B2816),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Icon(
                  allGood
                      ? Icons.verified_outlined
                      : Icons.warning_amber_rounded,
                  size: 42,
                  color: allGood
                      ? const Color(0xFF5EEAD4)
                      : const Color(0xFFFBBF24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allGood
                            ? context.l10n.alarmsReady
                            : context.l10n.checkPermissions,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        allGood
                            ? context.l10n.alarmsReadySubtitle
                            : context.l10n.permissionsWarningSubtitle,
                        style: const TextStyle(
                          color: Color(0xFFE7E2F2),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _CheckTile(
            title: context.l10n.exactAlarmPermission,
            subtitle: context.l10n.exactAlarmCheckSubtitle,
            value: _exact,
            actionLabel: context.l10n.grantPermission,
            onAction: widget.store.native.requestExactAlarmPermission,
          ),
          const SizedBox(height: 9),
          _CheckTile(
            title: context.l10n.manufacturerBackgroundSettings,
            subtitle: context.l10n.manufacturerSettingsSubtitle(_manufacturer),
            value: false,
            actionLabel: context.l10n.appSettings,
            onAction: widget.store.native.openAppSettings,
            optional: true,
          ),
          const SizedBox(height: 9),
          _CheckTile(
            title: context.l10n.notificationPermission,
            subtitle: context.l10n.notificationCheckSubtitle,
            value: _notifications,
            actionLabel: context.l10n.openSettings,
            onAction: widget.store.native.openNotificationSettings,
          ),
          const SizedBox(height: 9),
          _CheckTile(
            title: context.l10n.fullScreenPermission,
            subtitle: context.l10n.fullScreenCheckSubtitle,
            value: _fullScreen,
            actionLabel: context.l10n.grantPermission,
            onAction: widget.store.native.requestFullScreenIntentPermission,
          ),
          const SizedBox(height: 9),
          _CheckTile(
            title: context.l10n.alarmSoundLevel,
            subtitle: _sound == true
                ? context.l10n.alarmSoundAudible
                : context.l10n.alarmSoundMuted,
            value: _sound,
            actionLabel: context.l10n.soundSettings,
            onAction: widget.store.native.openSoundSettings,
            optional: true,
          ),
          const SizedBox(height: 9),
          _CheckTile(
            title: context.l10n.batteryOptimization,
            subtitle: _battery == true
                ? context.l10n.batteryUnrestricted
                : context.l10n.batteryMayDelay,
            value: _battery,
            actionLabel: context.l10n.openSettings,
            onAction: widget.store.native.openBatterySettings,
            optional: true,
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _testAlarm,
            icon: const Icon(Icons.notifications_active_outlined),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text(context.l10n.runTenSecondTest),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _check,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.refreshChecks),
          ),
        ],
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  const _CheckTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.actionLabel,
    required this.onAction,
    this.optional = false,
  });
  final String title;
  final String subtitle;
  final bool? value;
  final String actionLabel;
  final VoidCallback onAction;
  final bool optional;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: value == null
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              value!
                  ? Icons.check_circle
                  : (optional ? Icons.info_outline : Icons.error_outline),
              color: value! ? const Color(0xFF2DD4BF) : const Color(0xFFF59E0B),
              size: 30,
            ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: value == false
          ? TextButton(onPressed: onAction, child: Text(actionLabel))
          : null,
    ),
  );
}
