import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/alarm_models.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';

/// Read-only view over the alarm history the native layer already records.
/// Nothing new is collected: every number here is derived from events that
/// exist because an alarm rang, was snoozed, dismissed or auto-silenced.
class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.store});
  final AppStore store;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final since = DateTime.now().subtract(Duration(days: _days));
    final events = widget.store.history
        .where((event) => event.timestamp.isAfter(since))
        .toList();

    final rang = events.where((e) => _is(e, 'rang')).length;
    final snoozed = events.where((e) => _is(e, 'snoozed')).length;
    final dismissed = events.where((e) => _is(e, 'dismissed')).length;
    final silenced = events.where((e) => _is(e, 'auto_silenced')).length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statistics)),
      body: events.isEmpty
          ? EmptyState(
              icon: Icons.insights_outlined,
              title: l10n.statsEmptyTitle,
              message: l10n.statsEmptyMessage,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                SegmentedButton<int>(
                  segments: [
                    ButtonSegment(value: 7, label: Text(l10n.lastDays(7))),
                    ButtonSegment(value: 30, label: Text(l10n.lastDays(30))),
                    ButtonSegment(value: 90, label: Text(l10n.lastDays(90))),
                  ],
                  selected: {_days},
                  onSelectionChanged: (value) =>
                      setState(() => _days = value.first),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.notifications_active_outlined,
                        value: '$rang',
                        label: l10n.statsRang,
                        color: const Color(0xFFA78BFA),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.snooze,
                        value: '$snoozed',
                        label: l10n.statsSnoozed,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.alarm_off,
                        value: '$dismissed',
                        label: l10n.statsDismissed,
                        color: const Color(0xFF2DD4BF),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.volume_off_outlined,
                        value: '$silenced',
                        label: l10n.statsAutoSilenced,
                        color: const Color(0xFFFB7185),
                      ),
                    ),
                  ],
                ),
                SectionTitle(l10n.statsSnoozePerAlarm),
                _SnoozeRatioCard(rang: rang, snoozed: snoozed),
                SectionTitle(l10n.statsByAlarm),
                ..._perAlarm(events).map(
                  (entry) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(entry.label),
                      subtitle: Text(
                        l10n.statsAlarmBreakdown(entry.rang, entry.snoozed),
                      ),
                      trailing: Text(
                        '${entry.snoozed}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ),
                ),
                SectionTitle(l10n.statsBusiestDays),
                _WeekdayChart(events: events),
              ],
            ),
    );
  }

  /// Early builds stored localized Turkish labels instead of stable codes.
  static const _legacy = {
    'rang': 'Çaldı',
    'snoozed': 'Ertelendi',
    'dismissed': 'Kapatıldı',
    'auto_silenced': 'Otomatik susturuldu',
  };

  bool _is(AlarmHistoryEvent event, String code) =>
      event.action == code || event.action == _legacy[code];

  List<_AlarmStat> _perAlarm(List<AlarmHistoryEvent> events) {
    final byId = <String, _AlarmStat>{};
    for (final event in events) {
      final stat = byId.putIfAbsent(
        event.alarmId,
        () => _AlarmStat(event.label),
      );
      if (_is(event, 'rang')) stat.rang++;
      if (_is(event, 'snoozed')) stat.snoozed++;
    }
    final rows =
        byId.values.where((stat) => stat.rang + stat.snoozed > 0).toList()
          ..sort((a, b) => b.snoozed.compareTo(a.snoozed));
    return rows.take(8).toList();
  }
}

class _AlarmStat {
  _AlarmStat(this.label);
  final String label;
  int rang = 0;
  int snoozed = 0;
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          Text(label, style: const TextStyle(color: Color(0xFFA7A9B5))),
        ],
      ),
    ),
  );
}

class _SnoozeRatioCard extends StatelessWidget {
  const _SnoozeRatioCard({required this.rang, required this.snoozed});
  final int rang;
  final int snoozed;

  @override
  Widget build(BuildContext context) {
    final ratio = rang == 0 ? 0.0 : snoozed / rang;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ratio.toStringAsFixed(1),
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.statsSnoozePerAlarmHint,
              style: const TextStyle(color: Color(0xFFA7A9B5)),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (ratio / 3).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: const Color(0xFF2A2C36),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFF59E0B)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayChart extends StatelessWidget {
  const _WeekdayChart({required this.events});
  final List<AlarmHistoryEvent> events;

  @override
  Widget build(BuildContext context) {
    final counts = List<int>.filled(7, 0);
    for (final event in events) {
      counts[event.timestamp.weekday - 1]++;
    }
    final peak = counts.fold(0, (a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final height = peak == 0 ? 0.0 : 96 * counts[index] / peak;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${counts[index]}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFA7A9B5),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 22,
                  height: height < 3 && counts[index] > 0 ? 3 : height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  weekdayShortLocalized(context, index),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
