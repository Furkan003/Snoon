import 'package:flutter/material.dart';

import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';
import 'alarm_editor_page.dart';
import 'groups_page.dart';
import 'history_page.dart';
import 'reliability_center_page.dart';
import 'settings_page.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key, required this.store});
  final AppStore store;

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final Set<String> _selected = {};

  bool get _selectionMode => _selected.isNotEmpty;

  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _toggleSelection(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
  }

  Future<void> _pauseSelected() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
      initialDate: now.add(const Duration(days: 7)),
      helpText: context.l10n.pauseDateHelp,
    );
    if (result == null) return;
    await widget.store.pauseAlarmsUntil(_selected, result);
    if (mounted) {
      showMessage(
        context,
        context.l10n.pauseSuccess(
          _selected.length,
          shortDateLocalized(context, result),
        ),
      );
      setState(_selected.clear);
    }
  }

  Future<void> _shiftSelected() async {
    final value = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.shiftTodayTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(context.l10n.shiftTodaySubtitle),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [-60, -30, -15, 15, 30, 60]
                    .map(
                      (minutes) => ActionChip(
                        label: Text(
                          '${minutes > 0 ? '+' : ''}${context.l10n.minutesShort(minutes)}',
                        ),
                        onPressed: () => Navigator.pop(context, minutes),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
    if (value == null) return;
    await widget.store.shiftAlarmsToday(_selected, value);
    if (mounted) {
      showMessage(
        context,
        context.l10n.shiftSuccess(
          _selected.length,
          value.abs(),
          value > 0 ? context.l10n.forward : context.l10n.backward,
        ),
      );
      setState(_selected.clear);
    }
  }

  Future<void> _deleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.alarmsDeleteQuestion),
        content: Text(context.l10n.alarmsDeleteMessage(_selected.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.store.deleteAlarms(_selected);
    if (mounted) setState(_selected.clear);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final alarms = [...widget.store.alarms]
        ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _selectionMode
                ? context.l10n.selectedCount(_selected.length)
                : context.l10n.alarm,
          ),
          leading: _selectionMode
              ? IconButton(
                  onPressed: () => setState(_selected.clear),
                  icon: const Icon(Icons.close),
                )
              : null,
          actions: _selectionMode
              ? [
                  IconButton(
                    tooltip: context.l10n.pauseUntilDate,
                    onPressed: _pauseSelected,
                    icon: const Icon(Icons.event_busy_outlined),
                  ),
                  IconButton(
                    tooltip: context.l10n.shiftToday,
                    onPressed: _shiftSelected,
                    icon: const Icon(Icons.more_time),
                  ),
                  IconButton(
                    tooltip: context.l10n.delete,
                    onPressed: _deleteSelected,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ]
              : [
                  IconButton(
                    tooltip: context.l10n.alarmGroups,
                    onPressed: () => _open(GroupsPage(store: widget.store)),
                    icon: const Icon(Icons.folder_outlined),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'history') {
                        _open(HistoryPage(store: widget.store));
                      }
                      if (value == 'reliability') {
                        _open(ReliabilityCenterPage(store: widget.store));
                      }
                      if (value == 'settings') {
                        _open(SettingsPage(store: widget.store));
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'history',
                        child: Text(context.l10n.alarmHistory),
                      ),
                      PopupMenuItem(
                        value: 'reliability',
                        child: Text(context.l10n.reliabilityCenter),
                      ),
                      PopupMenuItem(
                        value: 'settings',
                        child: Text(context.l10n.settings),
                      ),
                    ],
                  ),
                ],
        ),
        body: Column(
          children: [
            if (widget.store.lastNativeError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Material(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(18),
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_rounded),
                    title: Text(context.l10n.checkPermissions),
                    subtitle: Text(
                      '${context.l10n.permissionsWarningSubtitle}\n'
                      '${widget.store.lastNativeError}',
                    ),
                    trailing: IconButton(
                      tooltip: context.l10n.cancel,
                      onPressed: widget.store.clearNativeError,
                      icon: const Icon(Icons.close),
                    ),
                    onTap: () =>
                        _open(ReliabilityCenterPage(store: widget.store)),
                  ),
                ),
              ),
            Expanded(
              child: alarms.isEmpty
                  ? EmptyState(
                      icon: Icons.alarm_add_outlined,
                      title: context.l10n.createFirstAlarm,
                      message: context.l10n.createFirstAlarmSubtitle,
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      children: [
                        _NextAlarmCard(store: widget.store),
                        const SizedBox(height: 16),
                        ...alarms.map(
                          (alarm) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _AlarmCard(
                              alarm: alarm,
                              group: widget.store.groupFor(alarm.groupId),
                              selected: _selected.contains(alarm.id),
                              selectionMode: _selectionMode,
                              onTap: () {
                                if (_selectionMode) {
                                  _toggleSelection(alarm.id);
                                } else {
                                  _open(
                                    AlarmEditorPage(
                                      store: widget.store,
                                      alarm: alarm,
                                    ),
                                  );
                                }
                              },
                              onLongPress: () => _toggleSelection(alarm.id),
                              onToggle: (value) =>
                                  widget.store.toggleAlarm(alarm, value),
                              onClearPause: alarm.pausedUntil == null
                                  ? null
                                  : () =>
                                        widget.store.clearAlarmPause(alarm.id),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        floatingActionButton: _selectionMode
            ? null
            : FloatingActionButton.large(
                heroTag: 'alarm-add',
                onPressed: () => _open(AlarmEditorPage(store: widget.store)),
                child: const Icon(Icons.add),
              ),
      );
    },
  );
}

class _NextAlarmCard extends StatelessWidget {
  const _NextAlarmCard({required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final next = store.nextAlarm;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C1D4D), Color(0xFF17233C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF49356D)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF3B2861),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: Color(0xFFC4B5FD),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.nextAlarm,
                  style: const TextStyle(color: Color(0xFFB9B4CB)),
                ),
                const SizedBox(height: 3),
                Text(
                  next == null
                      ? context.l10n.noActiveAlarm
                      : dateTimeTextLocalized(context, next),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
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

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    required this.alarm,
    required this.group,
    required this.selected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onToggle,
    this.onClearPause,
  });

  final AlarmItem alarm;
  final AlarmGroup? group;
  final bool selected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onClearPause;

  @override
  Widget build(BuildContext context) {
    final paused = alarm.pausedUntil != null || group?.pausedUntil != null;
    final groupColor = group == null ? null : Color(group!.colorValue);
    return Card(
      color: selected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
          child: Row(
            children: [
              if (selectionMode) ...[
                Checkbox(value: selected, onChanged: (_) => onTap()),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Opacity(
                  opacity: alarm.enabled ? 1 : 0.45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              clockText(alarm.hour, alarm.minute),
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1,
                              ),
                            ),
                            if (alarm.isRange) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 17,
                                  color: Color(0xFF9FA1AD),
                                ),
                              ),
                              Text(
                                rangeClockText(alarm.rangeEndMinutes!),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${alarm.label} • ${repeatSummaryLocalized(context, alarm.repeatDays)}${alarm.isRange ? ' • ${context.l10n.intervalEvery(alarm.intervalMinutes)}' : ''}',
                        style: const TextStyle(color: Color(0xFFB0B2BE)),
                      ),
                      const SizedBox(height: 9),
                      Wrap(
                        spacing: 7,
                        runSpacing: 6,
                        children: [
                          if (group != null)
                            _Badge(
                              icon: Icons.folder_outlined,
                              text: group!.name,
                              color: groupColor,
                            ),
                          if (paused)
                            _Badge(
                              icon: Icons.event_busy_outlined,
                              text: context.l10n.paused,
                              color: const Color(0xFFF59E0B),
                              onTap: onClearPause,
                            ),
                          if (alarm.todayShiftDate == dateKey(DateTime.now()))
                            _Badge(
                              icon: Icons.more_time,
                              text:
                                  '${alarm.todayShiftMinutes > 0 ? '+' : ''}${context.l10n.todayOffset(alarm.todayShiftMinutes)}',
                              color: const Color(0xFF38BDF8),
                            ),
                          if (alarm.morningRoutine)
                            _Badge(
                              icon: Icons.wb_twilight_outlined,
                              text: context.l10n.morningRoutine,
                            ),
                          if (alarm.dismissTask != DismissTask.none)
                            _Badge(
                              icon: Icons.task_alt,
                              text: context.l10n.dismissTask,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!selectionMode)
                Switch(value: alarm.enabled, onChanged: onToggle),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.text,
    this.color,
    this.onTap,
  });
  final IconData icon;
  final String text;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effective = color ?? const Color(0xFFA78BFA);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: effective.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: effective),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: effective,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
