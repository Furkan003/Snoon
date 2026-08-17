import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  final List<Duration> _laps = [];
  Timer? _ticker;

  void _toggle() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _ticker?.cancel();
    } else {
      _stopwatch.start();
      _ticker = Timer.periodic(const Duration(milliseconds: 40), (_) {
        if (mounted) setState(() {});
      });
    }
    setState(() {});
  }

  void _reset() {
    _ticker?.cancel();
    _stopwatch
      ..stop()
      ..reset();
    setState(_laps.clear);
  }

  void _lap() => setState(() => _laps.insert(0, _stopwatch.elapsed));

  String _format(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    final seconds = value.inSeconds.remainder(60);
    final hundredths = value.inMilliseconds.remainder(1000) ~/ 10;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${hundredths.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.stopwatch)),
    body: Column(
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3A2F55), width: 2),
                gradient: const RadialGradient(
                  colors: [Color(0xFF201834), Color(0xFF0A0B10)],
                ),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Text(
                      _format(_stopwatch.elapsed),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 37,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_laps.isNotEmpty)
          Expanded(
            flex: 2,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              itemCount: _laps.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                title: Text(context.l10n.lapNumber(_laps.length - index)),
                trailing: Text(
                  _format(_laps[index]),
                  style: const TextStyle(fontFeatures: []),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RoundAction(
                icon: _stopwatch.isRunning
                    ? Icons.flag_outlined
                    : Icons.refresh,
                label: _stopwatch.isRunning
                    ? context.l10n.lap
                    : context.l10n.reset,
                onTap: _stopwatch.isRunning ? _lap : _reset,
                filled: false,
              ),
              _RoundAction(
                icon: _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                label: _stopwatch.isRunning
                    ? context.l10n.pause
                    : context.l10n.start,
                onTap: _toggle,
                filled: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.filled,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton.filledTonal(
        style: IconButton.styleFrom(
          fixedSize: const Size(72, 72),
          backgroundColor: filled
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFF1C1E28),
          foregroundColor: filled ? const Color(0xFF1B102D) : Colors.white,
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 30),
      ),
      const SizedBox(height: 8),
      Text(label),
    ],
  );
}
