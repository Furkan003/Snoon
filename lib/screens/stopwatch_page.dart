import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/app_store.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key, required this.store});

  final AppStore store;

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // The store owns the elapsed time, so a run survives leaving the app.
    if (widget.store.stopwatchRunning) _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _toggle() async {
    // Start and stop the ticker synchronously with the tap. Doing it after the
    // await would leave a periodic timer alive across the gap, which keeps the
    // frame scheduler busy and stalls anything waiting for the UI to settle.
    if (widget.store.stopwatchRunning) {
      _ticker?.cancel();
      _ticker = null;
    } else {
      _startTicker();
    }
    await widget.store.toggleStopwatch();
    if (mounted) setState(() {});
  }

  Future<void> _reset() async {
    _ticker?.cancel();
    _ticker = null;
    await widget.store.clearStopwatch();
    if (mounted) setState(() {});
  }

  Future<void> _lap() async {
    await widget.store.addStopwatchLap();
    if (mounted) setState(() {});
  }

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
  Widget build(BuildContext context) {
    final running = widget.store.stopwatchRunning;
    final laps = widget.store.stopwatchLaps;
    return Scaffold(
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
                        _format(widget.store.stopwatchElapsed),
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
          if (laps.isNotEmpty)
            Expanded(
              flex: 2,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                itemCount: laps.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, index) => ListTile(
                  title: Text(context.l10n.lapNumber(laps.length - index)),
                  trailing: Text(
                    _format(laps[index]),
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
                  icon: running ? Icons.flag_outlined : Icons.refresh,
                  label: running ? context.l10n.lap : context.l10n.reset,
                  onTap: running ? _lap : _reset,
                  filled: false,
                ),
                _RoundAction(
                  icon: running ? Icons.pause : Icons.play_arrow,
                  label: running ? context.l10n.pause : context.l10n.start,
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
