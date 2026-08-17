// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Snoon';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageSubtitle => 'You can change this later in Settings.';

  @override
  String get languageContinue => 'Continue';

  @override
  String get languageRecommended => 'Device language';

  @override
  String get languageSetting => 'App language';

  @override
  String get languageSettingSubtitle =>
      'Change Snoon\'s display and alarm language';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get turkish => 'Turkish';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';

  @override
  String get italian => 'Italian';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get alarm => 'Alarm';

  @override
  String get world => 'World';

  @override
  String get stopwatch => 'Stopwatch';

  @override
  String get timer => 'Timer';

  @override
  String get sleep => 'Sleep';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get backup => 'Backup';

  @override
  String get sounds => 'Sounds';

  @override
  String get extraAlarmSettings => 'Additional alarm settings';

  @override
  String get off => 'Off';

  @override
  String get ringtonePickerFailed => 'Ringtone picker could not be opened.';

  @override
  String get backupSaveFailed => 'Backup file could not be saved.';

  @override
  String get backupReadFailed => 'Backup file could not be read.';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get apply => 'Apply';

  @override
  String get clear => 'Clear';

  @override
  String get later => 'Later';

  @override
  String get openSetting => 'Open setting';

  @override
  String get exactAlarmPermission => 'Exact alarm permission';

  @override
  String get exactAlarmPermissionMessage =>
      'Snoon needs the Android ‘Alarms & reminders’ permission to ring exactly when you set it.';

  @override
  String get fullScreenPermission => 'Full-screen alarm permission';

  @override
  String get fullScreenPermissionMessage =>
      'Enable full-screen notification permission to manage ringing alarms on the lock screen.';

  @override
  String get alarmGroups => 'Alarm groups';

  @override
  String get groupsIntro =>
      'Pause a group during a holiday, skip specific dates or shift all of today\'s times together.';

  @override
  String get addGroup => 'Add group';

  @override
  String get newGroup => 'New group';

  @override
  String get editGroup => 'Edit group';

  @override
  String get groupName => 'Group name';

  @override
  String get groupNameRequired => 'Enter a group name.';

  @override
  String pausedUntil(String date) {
    return 'Paused until $date';
  }

  @override
  String exceptionDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exception days',
      one: '1 exception day',
    );
    return '$_temp0';
  }

  @override
  String get vacationMode => 'Vacation mode';

  @override
  String get notSet => 'Not set';

  @override
  String get exceptionCalendar => 'Exception calendar';

  @override
  String get exceptionCalendarSubtitle =>
      'No alarm in the group will ring on these dates.';

  @override
  String get noExceptionDates => 'No exception date yet.';

  @override
  String get addDate => 'Add date';

  @override
  String get bulkShiftToday => 'Bulk shift for today';

  @override
  String get todayGroupTimes => 'Today\'s group times';

  @override
  String get scheduleUnchanged =>
      'The permanent alarm schedule stays unchanged';

  @override
  String get noChange => 'No change';

  @override
  String get deleteGroup => 'Delete group';

  @override
  String get alarmHistory => 'Alarm history';

  @override
  String get historyEmptySubtitle =>
      'Ringing, snoozed, dismissed and automatically silenced alarms appear here.';

  @override
  String get actionRang => 'Rang';

  @override
  String get actionSnoozed => 'Snoozed';

  @override
  String get actionSnoozeCancelled => 'Snooze cancelled';

  @override
  String get actionDismissed => 'Dismissed';

  @override
  String get actionAutoSilenced => 'Auto silenced';

  @override
  String get reliabilityCenter => 'Reliability center';

  @override
  String get createFirstAlarm => 'Create your first alarm';

  @override
  String get createFirstAlarmSubtitle =>
      'Use the + button for a single alarm or an interval series.';

  @override
  String get noActiveAlarm => 'No active alarm';

  @override
  String get newAlarm => 'New alarm';

  @override
  String get editAlarm => 'Edit alarm';

  @override
  String get specificTimeRange => 'Specific time range';

  @override
  String get specificTimeRangeSubtitle =>
      'Create several alarms automatically between two times';

  @override
  String get rangeNextDay => 'The end time will be applied to the next day.';

  @override
  String get repeat => 'Repeat';

  @override
  String get alarmInformation => 'Alarm information';

  @override
  String get beforeDismiss => 'Before dismissing';

  @override
  String get morningRoutine => 'Morning routine';

  @override
  String get rangeMorningUnavailable =>
      'Unavailable for interval alarms because backup alarms would overlap';

  @override
  String get disabledByDefault => 'Off by default';

  @override
  String get endTime => 'End time';

  @override
  String get ringInterval => 'Ring interval';

  @override
  String get label => 'Label';

  @override
  String get labelHint => 'e.g. Get ready for work';

  @override
  String get alarmGroup => 'Alarm group';

  @override
  String get noGroup => 'No group';

  @override
  String get ringtone => 'Ringtone';

  @override
  String get vibrateWhenRinging => 'Vibrate when alarm rings';

  @override
  String get deleteAfterRinging => 'Delete after ringing';

  @override
  String get oneTimeAlarmOnly => 'Used for one-time alarms';

  @override
  String get dismissTask => 'Dismiss task';

  @override
  String get noTask => 'No task';

  @override
  String get mathTask => 'Math problem';

  @override
  String get shakeTask => 'Shake phone 5 times';

  @override
  String get useMorningRoutine => 'Use morning routine';

  @override
  String get gentlePreAlert => 'Gentle pre-alert';

  @override
  String get backupAlarm => 'Backup alarm';

  @override
  String get backupAlarmSubtitle =>
      'Rings again if the first alarm is not dismissed';

  @override
  String get appearance => 'Appearance';

  @override
  String get systemTheme => 'Use system theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get changeSystemTime => 'Change system time';

  @override
  String get changeSystemTimeSubtitle => 'Opens Android date and time settings';

  @override
  String get reliabilityCenterSubtitle =>
      'Check permissions, alarm volume and battery restrictions';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get exportBackupSubtitle => 'Save alarms and settings as a JSON file';

  @override
  String get restoreBackup => 'Restore backup';

  @override
  String get restoreBackupSubtitle => 'Choose a Snoon JSON backup';

  @override
  String get restoreBackupQuestion => 'Restore backup?';

  @override
  String get restoreBackupWarning =>
      'Current alarms and settings will be replaced with the contents of the selected file.';

  @override
  String get chooseFile => 'Choose file';

  @override
  String get backupSaved => 'Snoon backup saved.';

  @override
  String get backupRestored => 'Snoon backup restored.';

  @override
  String get backupCancelled => 'Backup operation cancelled.';

  @override
  String get alarmRingtone => 'Alarm ringtone';

  @override
  String get timerRingtone => 'Timer ringtone';

  @override
  String get alarmVolume => 'Alarm volume';

  @override
  String get autoSilence => 'Auto silence';

  @override
  String get increasingVolume => 'Increasing alarm volume';

  @override
  String get increasingVolumeSubtitle =>
      'Volume rises gradually during the first 30 seconds';

  @override
  String get snooze => 'Snooze';

  @override
  String get maximumSnoozes => 'Maximum snoozes';

  @override
  String get volumeButtons => 'Volume buttons';

  @override
  String get volumeChange => 'Change volume';

  @override
  String get snoozeAlarm => 'Snooze alarm';

  @override
  String get dismissAlarm => 'Dismiss alarm';

  @override
  String get notifyBeforeRinging => 'Notify before ringing';

  @override
  String get showOnLockScreen => 'Show alarms on lock screen';

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String minutesBefore(int count) {
    return '$count min before';
  }

  @override
  String minutesAfter(int count) {
    return '$count min later';
  }

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: '1 time',
    );
    return '$_temp0';
  }

  @override
  String maximumTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Up to $count times',
      one: 'Up to 1 time',
    );
    return '$_temp0';
  }

  @override
  String alarmsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarms',
      one: '1 alarm',
    );
    return '$_temp0';
  }

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get alarmsDeleteQuestion => 'Delete alarms?';

  @override
  String alarmsDeleteMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarms will be permanently deleted.',
      one: '1 alarm will be permanently deleted.',
    );
    return '$_temp0';
  }

  @override
  String get pauseUntilDate => 'Pause until date';

  @override
  String get shiftToday => 'Shift for today';

  @override
  String get pauseDateHelp => 'PAUSE ALARMS UNTIL WHEN?';

  @override
  String pauseSuccess(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarms paused until $date.',
      one: '1 alarm paused until $date.',
    );
    return '$_temp0';
  }

  @override
  String get shiftTodayTitle => 'Shift today\'s alarms';

  @override
  String get shiftTodaySubtitle =>
      'The regular schedule stays unchanged; only today\'s ring times are affected.';

  @override
  String shiftSuccess(int count, int minutes, String direction) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarms moved $minutes minutes $direction today.',
      one: '1 alarm moved $minutes minutes $direction today.',
    );
    return '$_temp0';
  }

  @override
  String get forward => 'forward';

  @override
  String get backward => 'back';

  @override
  String get nextAlarm => 'Next alarm';

  @override
  String get once => 'Once';

  @override
  String get everyDay => 'Every day';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get weekend => 'Weekend';

  @override
  String intervalEvery(int count) {
    return 'every $count min';
  }

  @override
  String get paused => 'Paused';

  @override
  String todayOffset(int count) {
    return '$count min today';
  }

  @override
  String get noHistory => 'No alarm history yet';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get worldClock => 'World Clock';

  @override
  String get searchCity => 'Search city';

  @override
  String get cityNotFound => 'No city found';

  @override
  String get customTimer => 'Custom timer';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Seconds';

  @override
  String hourShort(int count) {
    return '$count hr';
  }

  @override
  String get invalidDuration => 'Enter a valid duration.';

  @override
  String get custom => 'Custom';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get reset => 'Reset';

  @override
  String get lap => 'Lap';

  @override
  String lapNumber(int count) {
    return 'Lap $count';
  }

  @override
  String get sleepSchedule => 'Sleep schedule';

  @override
  String get plannedSleepDuration => 'Planned sleep duration';

  @override
  String get sleepReminderAndWakeAlarm => 'Bedtime reminder and wake-up alarm';

  @override
  String get scheduleDays => 'Schedule days';

  @override
  String get atLeastOneSleepDay =>
      'At least one day must remain selected for the sleep schedule.';

  @override
  String get sleepScheduleSubtitle =>
      'Get a reminder before bedtime and keep wake-up times consistent';

  @override
  String get bedtime => 'Bedtime';

  @override
  String get wakeTime => 'Wake-up time';

  @override
  String get windDownTime => 'Wind-down time';

  @override
  String get windDownSubtitle => 'A notification is sent before bedtime';

  @override
  String get addCity => 'Add city';

  @override
  String get tryDifferentCity => 'Try another city name.';

  @override
  String get localTime => 'Local time';

  @override
  String localTimeDifference(int hours, int minutes, String direction) {
    return '$hours hr $minutes min $direction of local time';
  }

  @override
  String get testAlarm => 'Test alarm';

  @override
  String get testAlarmType => 'Test alarm type';

  @override
  String get dismissDirectly => 'Dismiss the alarm directly';

  @override
  String get verifyDismissTask => 'Also verify the dismissal task';

  @override
  String get alarmsReady => 'Alarms are ready';

  @override
  String get checkPermissions => 'Check permissions';

  @override
  String get alarmsReadySubtitle =>
      'Exact alarm and notification permissions are enabled.';

  @override
  String get permissionsWarningSubtitle =>
      'Missing permissions may make an alarm ring late or silently.';

  @override
  String get exactAlarmCheckSubtitle =>
      'Allows the alarm to run at the exact scheduled second.';

  @override
  String get grantPermission => 'Grant permission';

  @override
  String manufacturerSettingsSubtitle(String manufacturer) {
    return 'On $manufacturer, allow Snoon to auto-start and set background and battery use to ‘Unrestricted’.';
  }

  @override
  String get appSettings => 'App settings';

  @override
  String get notificationCheckSubtitle =>
      'Required for pre-alerts and lock-screen alarms.';

  @override
  String get fullScreenCheckSubtitle =>
      'Shows alarm controls on the lock screen and over other apps.';

  @override
  String get alarmSoundLevel => 'Alarm sound level';

  @override
  String get alarmSoundAudible => 'The Android alarm sound channel is audible.';

  @override
  String get alarmSoundMuted =>
      'The system alarm sound is muted. Snoon will raise it to the configured level while ringing.';

  @override
  String get soundSettings => 'Sound settings';

  @override
  String get batteryUnrestricted =>
      'The app is not affected by battery restrictions.';

  @override
  String get batteryMayDelay =>
      'Some phones may delay alarms in the background.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get runTenSecondTest => 'Run 10-second test alarm';

  @override
  String get refreshChecks => 'Refresh checks';

  @override
  String get notificationPermission => 'Notification permission';

  @override
  String get batteryOptimization => 'Battery optimization';

  @override
  String get manufacturerBackgroundSettings =>
      'Manufacturer background settings';

  @override
  String testScheduled(String task) {
    return 'Test alarm will ring in 10 seconds • $task';
  }

  @override
  String get sameStartEndError => 'Start and end time cannot be the same.';
}
