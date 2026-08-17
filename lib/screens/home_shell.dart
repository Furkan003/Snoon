import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/app_store.dart';
import 'alarm_page.dart';
import 'sleep_page.dart';
import 'stopwatch_page.dart';
import 'timer_page.dart';
import 'world_clock_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.store});
  final AppStore store;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int _index = 0;
  bool _permissionFlowRunning = false;
  bool _promptedExactAlarm = false;
  bool _promptedFullScreen = false;

  late final List<Widget> _pages = [
    AlarmPage(store: widget.store),
    WorldClockPage(store: widget.store),
    const StopwatchPage(),
    TimerPage(store: widget.store),
    SleepPage(store: widget.store),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestRequiredPermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.store.refreshNativeState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestRequiredPermissions();
      });
    }
  }

  Future<void> _requestRequiredPermissions() async {
    if (!mounted || _permissionFlowRunning) return;
    final l10n = context.l10n;
    _permissionFlowRunning = true;
    try {
      if (!await widget.store.native.notificationsGranted()) {
        await widget.store.native.requestNotificationPermission();
      }
      if (!mounted) return;

      final exactAlarmGranted = await widget.store.native
          .canScheduleExactAlarms();
      if (!exactAlarmGranted && !_promptedExactAlarm) {
        _promptedExactAlarm = true;
        final openSettings = await _showPermissionExplanation(
          icon: Icons.alarm_on_outlined,
          title: l10n.exactAlarmPermission,
          message: l10n.exactAlarmPermissionMessage,
        );
        if (openSettings == true) {
          await widget.store.native.requestExactAlarmPermission();
          return;
        }
      }
      if (!mounted) return;

      final fullScreenGranted = await widget.store.native
          .canUseFullScreenIntent();
      if (!fullScreenGranted && !_promptedFullScreen) {
        _promptedFullScreen = true;
        final openSettings = await _showPermissionExplanation(
          icon: Icons.screen_lock_portrait_outlined,
          title: l10n.fullScreenPermission,
          message: l10n.fullScreenPermissionMessage,
        );
        if (openSettings == true) {
          await widget.store.native.requestFullScreenIntentPermission();
        }
      }
    } catch (_) {
      // İzinler Güvenilirlik Merkezi'nden de yönetilebilir.
    } finally {
      _permissionFlowRunning = false;
    }
  }

  Future<bool?> _showPermissionExplanation({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(icon, size: 34),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.later),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.openSetting),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _index, children: _pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: (value) => setState(() => _index = value),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.alarm_outlined),
          selectedIcon: Icon(Icons.alarm),
          label: context.l10n.alarm,
        ),
        NavigationDestination(
          icon: Icon(Icons.public_outlined),
          selectedIcon: Icon(Icons.public),
          label: context.l10n.world,
        ),
        NavigationDestination(
          icon: Icon(Icons.timer_outlined),
          selectedIcon: Icon(Icons.timer),
          label: context.l10n.stopwatch,
        ),
        NavigationDestination(
          icon: Icon(Icons.hourglass_empty),
          selectedIcon: Icon(Icons.hourglass_bottom),
          label: context.l10n.timer,
        ),
        NavigationDestination(
          icon: Icon(Icons.bedtime_outlined),
          selectedIcon: Icon(Icons.bedtime),
          label: context.l10n.sleep,
        ),
      ],
    ),
  );
}
