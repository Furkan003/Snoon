import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';

class AlarmEditorPage extends StatefulWidget {
  const AlarmEditorPage({super.key, required this.store, this.alarm});
  final AppStore store;
  final AlarmItem? alarm;

  @override
  State<AlarmEditorPage> createState() => _AlarmEditorPageState();
}

class _AlarmEditorPageState extends State<AlarmEditorPage> {
  late TimeOfDay _start;
  late TimeOfDay _end;
  late bool _isRange;
  late int _interval;
  late Set<int> _days;
  late String _label;
  late String? _groupId;
  late bool _vibrate;
  late bool _deleteAfter;
  late DismissTask _dismissTask;
  late bool _morningRoutine;
  late int _gentleMinutes;
  late int _backupMinutes;
  String? _ringtoneUri;
  String? _ringtoneName;

  @override
  void initState() {
    super.initState();
    final alarm = widget.alarm;
    final now = TimeOfDay.now();
    _start = alarm == null
        ? TimeOfDay(hour: (now.hour + 1) % 24, minute: 0)
        : TimeOfDay(hour: alarm.hour, minute: alarm.minute);
    final endMinutes =
        alarm?.rangeEndMinutes ?? (_start.hour * 60 + _start.minute + 30);
    _end = TimeOfDay(hour: (endMinutes ~/ 60) % 24, minute: endMinutes % 60);
    _isRange = alarm?.isRange ?? false;
    _interval = alarm?.intervalMinutes ?? 5;
    _days = {...?alarm?.repeatDays};
    _label = alarm?.label ?? '';
    _groupId = alarm?.groupId;
    _vibrate = alarm?.vibrate ?? true;
    _deleteAfter = alarm?.deleteAfterRinging ?? false;
    _dismissTask = alarm?.dismissTask ?? DismissTask.none;
    _morningRoutine = (alarm?.morningRoutine ?? false) && !_isRange;
    _gentleMinutes = alarm?.gentleReminderMinutes ?? 10;
    _backupMinutes = alarm?.backupAlarmMinutes ?? 10;
    _ringtoneUri = alarm?.ringtoneUri;
    _ringtoneName = alarm?.ringtoneName;
  }

  Future<void> _pickStart() async {
    final result = await pickClockTime(context, _start);
    if (result != null) setState(() => _start = result);
  }

  Future<void> _pickEnd() async {
    final result = await pickClockTime(context, _end);
    if (result != null) setState(() => _end = result);
  }

  Future<void> _pickRingtone() async {
    try {
      final choice = await widget.store.native.pickRingtone(alarm: true);
      if (choice != null && mounted) {
        setState(() {
          _ringtoneUri = choice.uri;
          _ringtoneName = choice.name;
        });
      }
    } on PlatformException {
      if (mounted) showMessage(context, context.l10n.ringtonePickerFailed);
    }
  }

  Future<void> _save() async {
    final startMinutes = _start.hour * 60 + _start.minute;
    final endMinutes = _end.hour * 60 + _end.minute;
    if (_isRange && endMinutes == startMinutes) {
      showMessage(context, context.l10n.sameStartEndError);
      return;
    }
    final normalizedEndMinutes = _isRange && endMinutes < startMinutes
        ? endMinutes + 24 * 60
        : endMinutes;
    DateTime? oneShotDate;
    if (_days.isEmpty) {
      final now = DateTime.now();
      var candidate = DateTime(
        now.year,
        now.month,
        now.day,
        _start.hour,
        _start.minute,
      );
      if (!candidate.isAfter(now)) {
        candidate = candidate.add(const Duration(days: 1));
      }
      oneShotDate = DateTime(candidate.year, candidate.month, candidate.day);
    }
    final previous = widget.alarm;
    final alarm = AlarmItem(
      id: previous?.id ?? widget.store.newId('alarm'),
      hour: _start.hour,
      minute: _start.minute,
      label: _label.trim().isEmpty ? context.l10n.alarm : _label.trim(),
      enabled: previous?.enabled ?? true,
      repeatDays: _days.toList()..sort(),
      oneShotDate: oneShotDate,
      groupId: _groupId,
      rangeEndMinutes: _isRange ? normalizedEndMinutes : null,
      intervalMinutes: _interval,
      vibrate: _vibrate,
      deleteAfterRinging: _deleteAfter,
      ringtoneUri: _ringtoneUri,
      ringtoneName: _ringtoneName,
      dismissTask: _dismissTask,
      morningRoutine: _morningRoutine,
      gentleReminderMinutes: _gentleMinutes,
      backupAlarmMinutes: _backupMinutes,
      pausedUntil: previous?.pausedUntil,
      todayShiftDate: previous?.todayShiftDate,
      todayShiftMinutes: previous?.todayShiftMinutes ?? 0,
      createdAt: previous?.createdAt ?? DateTime.now(),
    );
    if (previous == null) {
      await widget.store.addAlarm(alarm);
    } else {
      await widget.store.updateAlarm(alarm);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarm == null ? l10n.newAlarm : l10n.editAlarm),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              l10n.save,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  InkWell(
                    onTap: _pickStart,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        clockText(_start.hour, _start.minute),
                        style: TextStyle(
                          fontSize: 62,
                          height: 1,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -2,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.specificTimeRange),
                    subtitle: Text(l10n.specificTimeRangeSubtitle),
                    value: _isRange,
                    onChanged: (value) => setState(() {
                      _isRange = value;
                      if (value) _morningRoutine = false;
                    }),
                  ),
                  if (_isRange) ...[
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.flag_outlined),
                      title: Text(l10n.endTime),
                      trailing: Text(
                        clockText(_end.hour, _end.minute),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: _pickEnd,
                    ),
                    if (_end.hour * 60 + _end.minute < startMinutesSafe)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.rangeNextDay,
                          style: const TextStyle(color: Color(0xFF93C5FD)),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(child: Text(l10n.ringInterval)),
                        DropdownButton<int>(
                          value: _interval,
                          items: const [1, 2, 5, 10, 15]
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(l10n.minutesShort(value)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _interval = value ?? 5),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${clockText(_start.hour, _start.minute)}–${clockText(_end.hour, _end.minute)} • ${l10n.alarmsCount(((endMinutesSafe - startMinutesSafe) ~/ _interval) + 1)}',
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SectionTitle(l10n.repeat),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(7, (index) {
                  final day = index + 1;
                  return FilterChip(
                    label: Text(weekdayShortLocalized(context, index)),
                    selected: _days.contains(day),
                    onSelected: (selected) => setState(() {
                      selected ? _days.add(day) : _days.remove(day);
                    }),
                  );
                }),
              ),
            ),
          ),
          SectionTitle(l10n.alarmInformation),
          SettingCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: TextFormField(
                  initialValue: _label,
                  onChanged: (value) => _label = value,
                  decoration: InputDecoration(
                    labelText: l10n.label,
                    prefixIcon: const Icon(Icons.label_outline),
                    hintText: l10n.labelHint,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(l10n.alarmGroup),
                trailing: DropdownButton<String>(
                  value: _groupId ?? '__none__',
                  underline: const SizedBox.shrink(),
                  items: [
                    DropdownMenuItem(
                      value: '__none__',
                      child: Text(l10n.noGroup),
                    ),
                    ...widget.store.groups.map(
                      (group) => DropdownMenuItem(
                        value: group.id,
                        child: Text(group.name),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(
                    () => _groupId = value == '__none__' ? null : value,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.music_note_outlined),
                title: Text(l10n.ringtone),
                subtitle: Text(
                  _ringtoneName ?? widget.store.settings.alarmRingtoneName,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickRingtone,
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.vibration),
                title: Text(l10n.vibrateWhenRinging),
                value: _vibrate,
                onChanged: (value) => setState(() => _vibrate = value),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.delete_outline),
                title: Text(l10n.deleteAfterRinging),
                subtitle: Text(l10n.oneTimeAlarmOnly),
                value: _deleteAfter,
                onChanged: (value) => setState(() => _deleteAfter = value),
              ),
            ],
          ),
          SectionTitle(l10n.dismissTask),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<DismissTask>(
                initialValue: _dismissTask,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.task_alt),
                  labelText: l10n.beforeDismiss,
                ),
                items: DismissTask.values
                    .map(
                      (task) => DropdownMenuItem(
                        value: task,
                        child: Text(localizedDismissTaskLabel(l10n, task)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _dismissTask = value ?? DismissTask.none),
              ),
            ),
          ),
          SectionTitle(l10n.morningRoutine),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.wb_twilight_outlined),
                  title: Text(l10n.useMorningRoutine),
                  subtitle: Text(
                    _isRange
                        ? l10n.rangeMorningUnavailable
                        : l10n.disabledByDefault,
                  ),
                  value: _morningRoutine,
                  onChanged: _isRange
                      ? null
                      : (value) => setState(() => _morningRoutine = value),
                ),
                if (_morningRoutine) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: Text(l10n.gentlePreAlert),
                    trailing: DropdownButton<int>(
                      value: _gentleMinutes,
                      underline: const SizedBox.shrink(),
                      items: const [5, 10, 15, 20]
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(l10n.minutesBefore(value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _gentleMinutes = value ?? 10),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.add_alarm_outlined),
                    title: Text(l10n.backupAlarm),
                    subtitle: Text(l10n.backupAlarmSubtitle),
                    trailing: DropdownButton<int>(
                      value: _backupMinutes,
                      underline: const SizedBox.shrink(),
                      items: const [5, 10, 15, 20]
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(l10n.minutesAfter(value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _backupMinutes = value ?? 10),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  int get startMinutesSafe => _start.hour * 60 + _start.minute;
  int get endMinutesSafe {
    final result = _end.hour * 60 + _end.minute;
    return result < startMinutesSafe ? result + 24 * 60 : result;
  }
}
