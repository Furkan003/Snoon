import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.store});
  final AppStore store;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    widget.store.refreshNativeState();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.alarmHistory),
        actions: [
          if (widget.store.history.isNotEmpty)
            IconButton(
              tooltip: context.l10n.clearHistory,
              onPressed: widget.store.clearHistory,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: widget.store.history.isEmpty
          ? EmptyState(
              icon: Icons.history,
              title: context.l10n.noHistory,
              message: context.l10n.historyEmptySubtitle,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              itemCount: widget.store.history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final event = widget.store.history[index];
                final (icon, color) = switch (event.action) {
                  'snoozed' ||
                  'Ertelendi' => (Icons.snooze, const Color(0xFFF59E0B)),
                  'snooze_cancelled' || 'Erteleme iptal edildi' => (
                    Icons.snooze_outlined,
                    const Color(0xFFFB7185),
                  ),
                  'dismissed' ||
                  'Kapatıldı' => (Icons.alarm_off, const Color(0xFF2DD4BF)),
                  'auto_silenced' || 'Otomatik susturuldu' => (
                    Icons.volume_off_outlined,
                    const Color(0xFFFB7185),
                  ),
                  _ => (
                    Icons.notifications_active_outlined,
                    const Color(0xFFA78BFA),
                  ),
                };
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(
                      event.label,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      dateTimeTextLocalized(context, event.timestamp),
                    ),
                    trailing: Text(
                      _localizedAction(context, event.action),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
    ),
  );
}

String _localizedAction(BuildContext context, String action) =>
    switch (action) {
      'snoozed' || 'Ertelendi' => context.l10n.actionSnoozed,
      'snooze_cancelled' ||
      'Erteleme iptal edildi' => context.l10n.actionSnoozeCancelled,
      'dismissed' || 'Kapatıldı' => context.l10n.actionDismissed,
      'auto_silenced' ||
      'Otomatik susturuldu' => context.l10n.actionAutoSilenced,
      _ => context.l10n.actionRang,
    };
