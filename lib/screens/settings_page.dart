import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';
import 'language_selection_page.dart';
import 'reliability_center_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.store});
  final AppStore store;

  Future<void> _pickAlarmRingtone(BuildContext context) async {
    try {
      final choice = await store.native.pickRingtone(alarm: true);
      if (choice != null) {
        await store.updateSettings(
          store.settings.copyWith(
            alarmRingtoneUri: choice.uri,
            alarmRingtoneName: choice.name,
          ),
        );
      }
    } on PlatformException {
      if (context.mounted) {
        showMessage(context, context.l10n.ringtonePickerFailed);
      }
    }
  }

  Future<void> _pickTimerRingtone(BuildContext context) async {
    try {
      final choice = await store.native.pickRingtone(alarm: false);
      if (choice != null) {
        await store.updateSettings(
          store.settings.copyWith(
            timerRingtoneUri: choice.uri,
            timerRingtoneName: choice.name,
          ),
        );
      }
    } on PlatformException {
      if (context.mounted) {
        showMessage(context, context.l10n.ringtonePickerFailed);
      }
    }
  }

  Future<void> _exportBackup(BuildContext context) async {
    try {
      final json = await store.createBackupJson();
      final saved = await store.native.saveBackup(json);
      if (saved && context.mounted) {
        showMessage(context, context.l10n.backupSaved);
      }
    } on PlatformException {
      if (context.mounted) showMessage(context, context.l10n.backupSaveFailed);
    }
  }

  Future<void> _importBackup(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.restoreBackupQuestion),
        content: Text(context.l10n.restoreBackupWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.chooseFile),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final raw = await store.native.pickBackup();
      if (raw == null) return;
      await store.restoreBackupJson(raw);
      if (context.mounted) showMessage(context, context.l10n.backupRestored);
    } on FormatException catch (error) {
      if (context.mounted) showMessage(context, error.message.toString());
    } on PlatformException {
      if (context.mounted) showMessage(context, context.l10n.backupReadFailed);
    } catch (_) {
      if (context.mounted) showMessage(context, context.l10n.backupReadFailed);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final settings = store.settings;
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.settings)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            SectionTitle(context.l10n.general),
            SettingCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(context.l10n.changeSystemTime),
                  subtitle: Text(context.l10n.changeSystemTimeSubtitle),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: store.native.openDateTimeSettings,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: Text(context.l10n.appearance),
                  subtitle: Text(
                    localizedThemeLabel(context.l10n, settings.themeMode),
                  ),
                  trailing: DropdownButton<SnoonThemeMode>(
                    value: settings.themeMode,
                    underline: const SizedBox.shrink(),
                    items: SnoonThemeMode.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              localizedThemeLabel(context.l10n, value),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        store.updateSettings(
                          settings.copyWith(themeMode: value),
                        );
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_user_outlined),
                  title: Text(context.l10n.reliabilityCenter),
                  subtitle: Text(context.l10n.reliabilityCenterSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReliabilityCenterPage(store: store),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(context.l10n.languageSetting),
                  subtitle: Text(languageNativeName(store.localeCode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showSnoonLanguagePicker(context, store),
                ),
              ],
            ),
            SectionTitle(context.l10n.backup),
            SettingCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.save_alt),
                  title: Text(context.l10n.exportBackup),
                  subtitle: Text(context.l10n.exportBackupSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportBackup(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_backup_restore),
                  title: Text(context.l10n.restoreBackup),
                  subtitle: Text(context.l10n.restoreBackupSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _importBackup(context),
                ),
              ],
            ),
            SectionTitle(context.l10n.sounds),
            SettingCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(context.l10n.alarmRingtone),
                  subtitle: Text(settings.alarmRingtoneName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickAlarmRingtone(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.hourglass_bottom),
                  title: Text(context.l10n.timerRingtone),
                  subtitle: Text(settings.timerRingtoneName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickTimerRingtone(context),
                ),
                const Divider(height: 1),
                _AlarmVolumeControl(store: store),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.volume_off_outlined),
                  title: Text(context.l10n.autoSilence),
                  trailing: DropdownButton<int>(
                    value: settings.autoSilenceMinutes,
                    underline: const SizedBox.shrink(),
                    items: const [1, 5, 10, 15, 30]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(context.l10n.minutesShort(value)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => store.updateSettings(
                      settings.copyWith(autoSilenceMinutes: value ?? 10),
                    ),
                  ),
                ),
              ],
            ),
            SectionTitle(context.l10n.extraAlarmSettings),
            SettingCard(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.vibration),
                  title: Text(context.l10n.vibrateWhenRinging),
                  value: settings.vibrate,
                  onChanged: (value) =>
                      store.updateSettings(settings.copyWith(vibrate: value)),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.trending_up),
                  title: Text(context.l10n.increasingVolume),
                  subtitle: Text(context.l10n.increasingVolumeSubtitle),
                  value: settings.gradualVolume,
                  onChanged: (value) => store.updateSettings(
                    settings.copyWith(gradualVolume: value),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.snooze),
                  title: Text(context.l10n.snooze),
                  subtitle: Text(
                    context.l10n.maximumTimes(settings.maxSnoozes),
                  ),
                  trailing: DropdownButton<int>(
                    value: settings.snoozeMinutes,
                    underline: const SizedBox.shrink(),
                    items: const [1, 5, 10, 15, 20]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(context.l10n.minutesShort(value)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => store.updateSettings(
                      settings.copyWith(snoozeMinutes: value ?? 5),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.repeat),
                  title: Text(context.l10n.maximumSnoozes),
                  trailing: DropdownButton<int>(
                    value: settings.maxSnoozes,
                    underline: const SizedBox.shrink(),
                    items: const [1, 2, 3, 5, 10]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(context.l10n.timesCount(value)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => store.updateSettings(
                      settings.copyWith(maxSnoozes: value ?? 3),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.volume_down_outlined),
                  title: Text(context.l10n.volumeButtons),
                  subtitle: Text(
                    localizedVolumeButtonLabel(
                      context.l10n,
                      settings.volumeButtonAction,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final value =
                        await showModalBottomSheet<VolumeButtonAction>(
                          context: context,
                          showDragHandle: true,
                          builder: (context) => SafeArea(
                            child: RadioGroup<VolumeButtonAction>(
                              groupValue: settings.volumeButtonAction,
                              onChanged: (value) =>
                                  Navigator.pop(context, value),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: VolumeButtonAction.values
                                    .map(
                                      (action) =>
                                          RadioListTile<VolumeButtonAction>(
                                            value: action,
                                            title: Text(
                                              localizedVolumeButtonLabel(
                                                context.l10n,
                                                action,
                                              ),
                                            ),
                                          ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        );
                    if (value != null) {
                      store.updateSettings(
                        settings.copyWith(volumeButtonAction: value),
                      );
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notification_important_outlined),
                  title: Text(context.l10n.notifyBeforeRinging),
                  trailing: DropdownButton<int>(
                    value: settings.preNotificationMinutes,
                    underline: const SizedBox.shrink(),
                    items: const [0, 5, 10, 15, 30]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value == 0
                                  ? context.l10n.off
                                  : context.l10n.minutesBefore(value),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => store.updateSettings(
                      settings.copyWith(preNotificationMinutes: value ?? 10),
                    ),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.screen_lock_portrait_outlined),
                  title: Text(context.l10n.showOnLockScreen),
                  value: settings.showOnLockScreen,
                  onChanged: (value) => store.updateSettings(
                    settings.copyWith(showOnLockScreen: value),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class _AlarmVolumeControl extends StatefulWidget {
  const _AlarmVolumeControl({required this.store});

  final AppStore store;

  @override
  State<_AlarmVolumeControl> createState() => _AlarmVolumeControlState();
}

class _AlarmVolumeControlState extends State<_AlarmVolumeControl> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.store.settings.alarmVolume.clamp(0.05, 1).toDouble();
  }

  @override
  void didUpdateWidget(covariant _AlarmVolumeControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    final stored = widget.store.settings.alarmVolume.clamp(0.05, 1).toDouble();
    if ((stored - _value).abs() > 0.001) _value = stored;
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.volume_up_outlined),
            const SizedBox(width: 16),
            Expanded(child: Text(context.l10n.alarmVolume)),
            Text('%${(_value * 100).round()}'),
          ],
        ),
        Slider(
          min: 0.05,
          value: _value,
          onChanged: (value) => setState(() => _value = value),
          onChangeEnd: (value) => widget.store.updateSettings(
            widget.store.settings.copyWith(alarmVolume: value),
          ),
        ),
      ],
    ),
  );
}
