import 'package:flutter/material.dart';

import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key, required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.alarmGroups)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF17233C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: Color(0xFF93C5FD)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.groupsIntro,
                    style: const TextStyle(color: Colors.white, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...store.groups.map((group) {
            final count = store.alarms
                .where((alarm) => alarm.groupId == group.id)
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Color(group.colorValue)
                        .withValues(alpha: 0.2),
                    child: Icon(Icons.folder, color: Color(group.colorValue)),
                  ),
                  title: Text(
                    group.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    [
                      context.l10n.alarmsCount(count),
                      if (group.pausedUntil != null)
                        context.l10n.pausedUntil(
                          shortDateLocalized(context, group.pausedUntil!),
                        ),
                      if (group.excludedDates.isNotEmpty)
                        context.l10n.exceptionDays(group.excludedDates.length),
                    ].join(' • '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          GroupEditorPage(store: store, group: group),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'alarm-group-add',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupEditorPage(store: store)),
        ),
        icon: const Icon(Icons.create_new_folder_outlined),
        label: Text(context.l10n.addGroup),
      ),
    ),
  );
}

class GroupEditorPage extends StatefulWidget {
  const GroupEditorPage({super.key, required this.store, this.group});
  final AppStore store;
  final AlarmGroup? group;

  @override
  State<GroupEditorPage> createState() => _GroupEditorPageState();
}

class _GroupEditorPageState extends State<GroupEditorPage> {
  static const colors = [
    0xFF8B5CF6,
    0xFF2DD4BF,
    0xFF38BDF8,
    0xFFF59E0B,
    0xFFFB7185,
    0xFF84CC16,
  ];

  late String _name;
  late int _color;
  DateTime? _pausedUntil;
  late List<String> _excludedDates;
  String? _shiftDate;
  int _shiftMinutes = 0;

  @override
  void initState() {
    super.initState();
    _name = widget.group?.name ?? '';
    _color = widget.group?.colorValue ?? colors.first;
    _pausedUntil = widget.group?.pausedUntil;
    _excludedDates = [...?widget.group?.excludedDates];
    _shiftDate = widget.group?.todayShiftDate;
    _shiftMinutes = widget.group?.todayShiftMinutes ?? 0;
  }

  Future<DateTime?> _pickDate({DateTime? initial}) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
      initialDate: initial ?? now.add(const Duration(days: 1)),
    );
  }

  Future<void> _save() async {
    if (_name.trim().isEmpty) {
      showMessage(context, context.l10n.groupNameRequired);
      return;
    }
    await widget.store.saveGroup(
      AlarmGroup(
        id: widget.group?.id ?? widget.store.newId('group'),
        name: _name.trim(),
        colorValue: _color,
        pausedUntil: _pausedUntil,
        excludedDates: _excludedDates..sort(),
        todayShiftDate: _shiftDate,
        todayShiftMinutes: _shiftMinutes,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final group = widget.group;
    if (group == null) return;
    await widget.store.deleteGroup(group.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.group == null ? context.l10n.newGroup : context.l10n.editGroup,
      ),
      actions: [TextButton(onPressed: _save, child: Text(context.l10n.save))],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  onChanged: (value) => _name = value,
                  decoration: InputDecoration(
                    labelText: context.l10n.groupName,
                    prefixIcon: const Icon(Icons.folder_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  children: colors
                      .map(
                        (value) => InkWell(
                          onTap: () => setState(() => _color = value),
                          borderRadius: BorderRadius.circular(40),
                          child: CircleAvatar(
                            radius: 19,
                            backgroundColor: Color(value),
                            child: _color == value
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        SectionTitle(context.l10n.vacationMode),
        SettingCard(
          children: [
            ListTile(
              leading: const Icon(Icons.beach_access_outlined),
              title: Text(context.l10n.pauseUntilDate),
              subtitle: Text(
                _pausedUntil == null
                    ? context.l10n.notSet
                    : shortDateLocalized(context, _pausedUntil!),
              ),
              trailing: _pausedUntil == null
                  ? const Icon(Icons.chevron_right)
                  : IconButton(
                      tooltip: context.l10n.clear,
                      onPressed: () => setState(() => _pausedUntil = null),
                      icon: const Icon(Icons.close),
                    ),
              onTap: () async {
                final date = await _pickDate(initial: _pausedUntil);
                if (date != null) setState(() => _pausedUntil = date);
              },
            ),
          ],
        ),
        SectionTitle(context.l10n.exceptionCalendar),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.exceptionCalendarSubtitle,
                  style: const TextStyle(color: Color(0xFFB0B2BE)),
                ),
                const SizedBox(height: 14),
                if (_excludedDates.isEmpty)
                  Text(context.l10n.noExceptionDates)
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _excludedDates
                        .map(
                          (date) => InputChip(
                            label: Text(
                              shortDateLocalized(context, DateTime.parse(date)),
                            ),
                            onDeleted: () =>
                                setState(() => _excludedDates.remove(date)),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    final date = await _pickDate();
                    if (date != null &&
                        !_excludedDates.contains(dateKey(date))) {
                      setState(() => _excludedDates.add(dateKey(date)));
                    }
                  },
                  icon: const Icon(Icons.event_busy_outlined),
                  label: Text(context.l10n.addDate),
                ),
              ],
            ),
          ),
        ),
        SectionTitle(context.l10n.bulkShiftToday),
        Card(
          child: ListTile(
            leading: const Icon(Icons.more_time),
            title: Text(context.l10n.todayGroupTimes),
            subtitle: Text(context.l10n.scheduleUnchanged),
            trailing: DropdownButton<int>(
              value: _shiftDate == dateKey(DateTime.now()) ? _shiftMinutes : 0,
              underline: const SizedBox.shrink(),
              items: const [-60, -30, -15, 0, 15, 30, 60]
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        value == 0
                            ? context.l10n.noChange
                            : '${value > 0 ? '+' : ''}${context.l10n.minutesShort(value)}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _shiftMinutes = value ?? 0;
                _shiftDate = _shiftMinutes == 0
                    ? null
                    : dateKey(DateTime.now());
              }),
            ),
          ),
        ),
        if (widget.group != null) ...[
          const SizedBox(height: 28),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline),
            label: Text(context.l10n.deleteGroup),
          ),
        ],
      ],
    ),
  );
}
