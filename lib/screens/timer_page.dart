import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/app_store.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.store});
  final AppStore store;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _selectedSeconds = 5 * 60;
  int _remainingSeconds = 5 * 60;
  DateTime? _target;
  Timer? _ticker;
  bool _running = false;
  String? _timerId;

  @override
  void initState() {
    super.initState();
    _selectedSeconds = widget.store.timerSelectedSeconds;
    _remainingSeconds = widget.store.timerRemainingSeconds;
    _target = widget.store.timerTarget;
    _running =
        widget.store.timerRunning &&
        _target != null &&
        _target!.isAfter(DateTime.now());
    _timerId = widget.store.timerId;
    if (_running) {
      _ticker = Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => _tick(),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) => _tick());
    }
  }

  void _setPreset(int seconds) {
    if (_running) return;
    setState(() {
      _selectedSeconds = seconds;
      _remainingSeconds = seconds;
    });
  }

  Future<void> _pickCustomDuration() async {
    if (_running) return;
    var hours = '';
    var minutes = '';
    var seconds = '';
    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.customTimer),
        content: Row(
          children: [
            for (final field in [
              (context.l10n.hours, (String value) => hours = value),
              (context.l10n.minutes, (String value) => minutes = value),
              (context.l10n.seconds, (String value) => seconds = value),
            ]) ...[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: field.$1,
                    counterText: '',
                  ),
                  onChanged: field.$2,
                ),
              ),
              if (field.$1 != context.l10n.seconds) const SizedBox(width: 8),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final hour = int.tryParse(hours) ?? 0;
              final minute = int.tryParse(minutes) ?? 0;
              final second = int.tryParse(seconds) ?? 0;
              final total = hour * 3600 + minute * 60 + second;
              if (hour > 99 || minute > 59 || second > 59 || total <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.invalidDuration)),
                );
                return;
              }
              Navigator.pop(context, total);
            },
            child: Text(context.l10n.apply),
          ),
        ],
      ),
    );
    if (value != null && mounted) _setPreset(value);
  }

  Future<void> _startOrPause() async {
    if (_running) {
      _ticker?.cancel();
      if (_target != null) {
        _remainingSeconds = _target!
            .difference(DateTime.now())
            .inSeconds
            .clamp(0, 86400 * 7);
      }
      if (_timerId != null) {
        await widget.store.cancelTimerDelivery(_timerId!);
        await widget.store.saveTimerState(
          id: _timerId!,
          selectedSeconds: _selectedSeconds,
          remainingSeconds: _remainingSeconds,
          running: false,
        );
      }
      if (mounted) setState(() => _running = false);
      return;
    }
    if (_remainingSeconds <= 0) _remainingSeconds = _selectedSeconds;
    _target = DateTime.now().add(Duration(seconds: _remainingSeconds));
    _timerId ??= 'timer-${DateTime.now().millisecondsSinceEpoch}';
    final scheduled = await widget.store.scheduleTimerDelivery(
      id: _timerId!,
      label: context.l10n.timer,
      triggerAtMillis: _target!.millisecondsSinceEpoch,
    );
    if (!scheduled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.permissionsWarningSubtitle)),
        );
      }
      return;
    }
    await widget.store.saveTimerState(
      id: _timerId!,
      selectedSeconds: _selectedSeconds,
      remainingSeconds: _remainingSeconds,
      running: true,
      target: _target,
    );
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
    if (mounted) setState(() => _running = true);
  }

  void _tick() {
    if (_target == null || !mounted) return;
    final remaining = _target!.difference(DateTime.now()).inSeconds + 1;
    if (remaining <= 0) {
      _ticker?.cancel();
      unawaited(widget.store.clearTimerState());
      setState(() {
        _running = false;
        _remainingSeconds = 0;
        _target = null;
        _timerId = null;
      });
    } else {
      setState(() => _remainingSeconds = remaining);
    }
  }

  Future<void> _reset() async {
    _ticker?.cancel();
    if (_timerId != null) await widget.store.cancelTimerDelivery(_timerId!);
    await widget.store.clearTimerState();
    if (!mounted) return;
    setState(() {
      _running = false;
      _remainingSeconds = _selectedSeconds;
      _target = null;
      _timerId = null;
    });
  }

  String _format(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _selectedSeconds == 0
        ? 0.0
        : _remainingSeconds / _selectedSeconds;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.timer)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: progress.clamp(0, 1),
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFF20222C),
                      strokeCap: StrokeCap.round,
                    ),
                    Center(
                      child: Text(
                        _format(_remainingSeconds),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!_running)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 8,
                children: [
                  for (final preset in [
                    (60, context.l10n.minutesShort(1)),
                    (300, context.l10n.minutesShort(5)),
                    (600, context.l10n.minutesShort(10)),
                    (1500, context.l10n.minutesShort(25)),
                    (3600, context.l10n.hourShort(1)),
                  ])
                    ActionChip(
                      label: Text(preset.$2),
                      onPressed: () => _setPreset(preset.$1),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.tune, size: 18),
                    label: Text(context.l10n.custom),
                    onPressed: _pickCustomDuration,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filledTonal(
                  style: IconButton.styleFrom(fixedSize: const Size(70, 70)),
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh, size: 30),
                ),
                IconButton.filled(
                  style: IconButton.styleFrom(fixedSize: const Size(78, 78)),
                  onPressed: _startOrPause,
                  icon: Icon(
                    _running ? Icons.pause : Icons.play_arrow,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
