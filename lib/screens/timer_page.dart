import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../models/alarm_models.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.store});

  final AppStore store;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _syncTicker();
  }

  /// One ticker drives every running countdown; it stops as soon as none are
  /// running so an idle page schedules no frames.
  void _syncTicker() {
    final anyRunning = widget.store.timers.any((timer) => timer.running);
    if (anyRunning && _ticker == null) {
      _ticker = Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => _tick(),
      );
    } else if (!anyRunning) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  void _tick() {
    if (!mounted) return;
    for (final timer in widget.store.timers) {
      if (timer.running && timer.secondsLeft() <= 0) {
        unawaited(widget.store.expireTimer(timer.id));
      }
    }
    setState(_syncTicker);
  }

  Future<void> _add(int seconds) async {
    final l10n = context.l10n;
    final added = await widget.store.addTimer(
      seconds: seconds,
      label: '',
      deliveryLabel: l10n.timer,
    );
    if (!mounted) return;
    if (added == null) {
      showMessage(context, l10n.permissionsWarningSubtitle);
      return;
    }
    setState(_syncTicker);
  }

  Future<void> _toggle(TimerItem timer) async {
    if (timer.running) {
      await widget.store.pauseTimer(timer.id);
    } else {
      final started = await widget.store.startTimer(
        timer.id,
        deliveryLabel: context.mounted ? context.l10n.timer : 'Timer',
      );
      if (started == null && mounted) {
        showMessage(context, context.l10n.permissionsWarningSubtitle);
      }
    }
    if (mounted) setState(_syncTicker);
  }

  Future<void> _pickCustomDuration() async {
    var hours = '';
    var minutes = '';
    var seconds = '';
    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.customTimer),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: context.l10n.hours),
                onChanged: (text) => hours = text,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: context.l10n.minutes),
                onChanged: (text) => minutes = text,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: context.l10n.seconds),
                onChanged: (text) => seconds = text,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final total =
                  (int.tryParse(hours) ?? 0) * 3600 +
                  (int.tryParse(minutes) ?? 0) * 60 +
                  (int.tryParse(seconds) ?? 0);
              Navigator.pop(context, total);
            },
            child: Text(context.l10n.start),
          ),
        ],
      ),
    );
    if (value != null && value > 0 && mounted) await _add(value);
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
    final l10n = context.l10n;
    final timers = widget.store.timers;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.timer)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in const [60, 300, 600, 900, 1800, 3600])
                  ActionChip(
                    label: Text(
                      preset < 3600
                          ? l10n.minutesShort(preset ~/ 60)
                          : l10n.hourShort(preset ~/ 3600),
                    ),
                    onPressed: () => _add(preset),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.tune, size: 18),
                  label: Text(l10n.customTimer),
                  onPressed: _pickCustomDuration,
                ),
              ],
            ),
          ),
          const Divider(height: 20),
          Expanded(
            child: timers.isEmpty
                ? EmptyState(
                    icon: Icons.hourglass_empty,
                    title: l10n.timerEmptyTitle,
                    message: l10n.timerEmptyMessage,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                    itemCount: timers.length,
                    itemBuilder: (context, index) {
                      final timer = timers[index];
                      final left = timer.secondsLeft();
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 14, 8, 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _format(left),
                                      style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: timer.totalSeconds == 0
                                            ? 0
                                            : left / timer.totalSeconds,
                                        minHeight: 5,
                                        backgroundColor: const Color(
                                          0xFF2A2C36,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _format(timer.totalSeconds),
                                      style: const TextStyle(
                                        color: Color(0xFFA7A9B5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: timer.running
                                    ? l10n.pause
                                    : l10n.start,
                                onPressed: () => _toggle(timer),
                                icon: Icon(
                                  timer.running
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                              IconButton(
                                tooltip: l10n.reset,
                                onPressed: () async {
                                  await widget.store.resetTimer(timer.id);
                                  if (mounted) setState(_syncTicker);
                                },
                                icon: const Icon(Icons.refresh),
                              ),
                              IconButton(
                                tooltip: l10n.delete,
                                onPressed: () async {
                                  await widget.store.removeTimer(timer.id);
                                  if (mounted) setState(_syncTicker);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
