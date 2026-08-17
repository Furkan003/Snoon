import 'package:flutter/material.dart';

import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';

class SleepPage extends StatelessWidget {
  const SleepPage({super.key, required this.store});
  final AppStore store;

  Future<void> _syncProfile(SleepProfile profile) async {
    await store.updateSleepProfile(profile);
    final existing = store.alarms
        .where((alarm) => alarm.id == 'sleep-wake')
        .firstOrNull;
    final alarm = AlarmItem(
      id: 'sleep-wake',
      hour: profile.wakeHour,
      minute: profile.wakeMinute,
      label: localizedSleepScheduleName(store.localeCode),
      enabled: profile.enabled && profile.days.isNotEmpty,
      repeatDays: profile.days,
      vibrate: true,
      morningRoutine: false,
      createdAt: existing?.createdAt ?? DateTime.now(),
    );
    if (existing == null) {
      await store.addAlarm(alarm);
    } else {
      await store.updateAlarm(alarm);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final profile = store.sleepProfile;
      final bedtime = TimeOfDay(
        hour: profile.bedHour,
        minute: profile.bedMinute,
      );
      final wake = TimeOfDay(
        hour: profile.wakeHour,
        minute: profile.wakeMinute,
      );
      var sleepMinutes =
          profile.wakeHour * 60 +
          profile.wakeMinute -
          (profile.bedHour * 60 + profile.bedMinute);
      if (sleepMinutes <= 0) sleepMinutes += 24 * 60;
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.sleep)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF20173A), Color(0xFF10213B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  const Icon(Icons.bedtime, size: 38, color: Color(0xFFC4B5FD)),
                  const SizedBox(height: 10),
                  Text(
                    '${context.l10n.hourShort(sleepMinutes ~/ 60)} ${context.l10n.minutesShort(sleepMinutes % 60)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    context.l10n.plannedSleepDuration,
                    style: const TextStyle(color: Color(0xFFB6B2C8)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.auto_awesome_outlined),
                    title: Text(context.l10n.sleepSchedule),
                    subtitle: Text(context.l10n.sleepReminderAndWakeAlarm),
                    value: profile.enabled,
                    onChanged: (value) =>
                        _syncProfile(profile.copyWith(enabled: value)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.nights_stay_outlined),
                    title: Text(context.l10n.bedtime),
                    trailing: Text(
                      clockText(profile.bedHour, profile.bedMinute),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      final value = await pickClockTime(context, bedtime);
                      if (value != null) {
                        _syncProfile(
                          profile.copyWith(
                            bedHour: value.hour,
                            bedMinute: value.minute,
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.wb_sunny_outlined),
                    title: Text(context.l10n.wakeTime),
                    trailing: Text(
                      clockText(profile.wakeHour, profile.wakeMinute),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      final value = await pickClockTime(context, wake);
                      if (value != null) {
                        _syncProfile(
                          profile.copyWith(
                            wakeHour: value.hour,
                            wakeMinute: value.minute,
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.self_improvement_outlined),
                    title: Text(context.l10n.windDownTime),
                    subtitle: Text(context.l10n.windDownSubtitle),
                    trailing: DropdownButton<int>(
                      value: profile.windDownMinutes,
                      underline: const SizedBox.shrink(),
                      items: const [15, 30, 45, 60]
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(context.l10n.minutesShort(value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => _syncProfile(
                        profile.copyWith(windDownMinutes: value ?? 30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SectionTitle(context.l10n.scheduleDays),
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
                      selected: profile.days.contains(day),
                      onSelected: (selected) {
                        final days = [...profile.days];
                        if (!selected && days.length == 1) {
                          showMessage(context, context.l10n.atLeastOneSleepDay);
                          return;
                        }
                        selected ? days.add(day) : days.remove(day);
                        days.sort();
                        _syncProfile(profile.copyWith(days: days));
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
