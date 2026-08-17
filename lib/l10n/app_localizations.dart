import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Snoon'**
  String get appName;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get languageSubtitle;

  /// No description provided for @languageContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get languageContinue;

  /// No description provided for @languageRecommended.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get languageRecommended;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageSetting;

  /// No description provided for @languageSettingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change Snoon\'s display and alarm language'**
  String get languageSettingSubtitle;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @alarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get alarm;

  /// No description provided for @world.
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get world;

  /// No description provided for @stopwatch.
  ///
  /// In en, this message translates to:
  /// **'Stopwatch'**
  String get stopwatch;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @sounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get sounds;

  /// No description provided for @extraAlarmSettings.
  ///
  /// In en, this message translates to:
  /// **'Additional alarm settings'**
  String get extraAlarmSettings;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @ringtonePickerFailed.
  ///
  /// In en, this message translates to:
  /// **'Ringtone picker could not be opened.'**
  String get ringtonePickerFailed;

  /// No description provided for @backupSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup file could not be saved.'**
  String get backupSaveFailed;

  /// No description provided for @backupReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup file could not be read.'**
  String get backupReadFailed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @openSetting.
  ///
  /// In en, this message translates to:
  /// **'Open setting'**
  String get openSetting;

  /// No description provided for @exactAlarmPermission.
  ///
  /// In en, this message translates to:
  /// **'Exact alarm permission'**
  String get exactAlarmPermission;

  /// No description provided for @exactAlarmPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Snoon needs the Android ‘Alarms & reminders’ permission to ring exactly when you set it.'**
  String get exactAlarmPermissionMessage;

  /// No description provided for @fullScreenPermission.
  ///
  /// In en, this message translates to:
  /// **'Full-screen alarm permission'**
  String get fullScreenPermission;

  /// No description provided for @fullScreenPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Enable full-screen notification permission to manage ringing alarms on the lock screen.'**
  String get fullScreenPermissionMessage;

  /// No description provided for @alarmGroups.
  ///
  /// In en, this message translates to:
  /// **'Alarm groups'**
  String get alarmGroups;

  /// No description provided for @groupsIntro.
  ///
  /// In en, this message translates to:
  /// **'Pause a group during a holiday, skip specific dates or shift all of today\'s times together.'**
  String get groupsIntro;

  /// No description provided for @addGroup.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get addGroup;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get newGroup;

  /// No description provided for @editGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit group'**
  String get editGroup;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get groupName;

  /// No description provided for @groupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a group name.'**
  String get groupNameRequired;

  /// No description provided for @pausedUntil.
  ///
  /// In en, this message translates to:
  /// **'Paused until {date}'**
  String pausedUntil(String date);

  /// No description provided for @exceptionDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exception day} other{{count} exception days}}'**
  String exceptionDays(int count);

  /// No description provided for @vacationMode.
  ///
  /// In en, this message translates to:
  /// **'Vacation mode'**
  String get vacationMode;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @exceptionCalendar.
  ///
  /// In en, this message translates to:
  /// **'Exception calendar'**
  String get exceptionCalendar;

  /// No description provided for @exceptionCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No alarm in the group will ring on these dates.'**
  String get exceptionCalendarSubtitle;

  /// No description provided for @noExceptionDates.
  ///
  /// In en, this message translates to:
  /// **'No exception date yet.'**
  String get noExceptionDates;

  /// No description provided for @addDate.
  ///
  /// In en, this message translates to:
  /// **'Add date'**
  String get addDate;

  /// No description provided for @bulkShiftToday.
  ///
  /// In en, this message translates to:
  /// **'Bulk shift for today'**
  String get bulkShiftToday;

  /// No description provided for @todayGroupTimes.
  ///
  /// In en, this message translates to:
  /// **'Today\'s group times'**
  String get todayGroupTimes;

  /// No description provided for @scheduleUnchanged.
  ///
  /// In en, this message translates to:
  /// **'The permanent alarm schedule stays unchanged'**
  String get scheduleUnchanged;

  /// No description provided for @noChange.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get noChange;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get deleteGroup;

  /// No description provided for @alarmHistory.
  ///
  /// In en, this message translates to:
  /// **'Alarm history'**
  String get alarmHistory;

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ringing, snoozed, dismissed and automatically silenced alarms appear here.'**
  String get historyEmptySubtitle;

  /// No description provided for @actionRang.
  ///
  /// In en, this message translates to:
  /// **'Rang'**
  String get actionRang;

  /// No description provided for @actionSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get actionSnoozed;

  /// No description provided for @actionSnoozeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Snooze cancelled'**
  String get actionSnoozeCancelled;

  /// No description provided for @actionDismissed.
  ///
  /// In en, this message translates to:
  /// **'Dismissed'**
  String get actionDismissed;

  /// No description provided for @actionAutoSilenced.
  ///
  /// In en, this message translates to:
  /// **'Auto silenced'**
  String get actionAutoSilenced;

  /// No description provided for @reliabilityCenter.
  ///
  /// In en, this message translates to:
  /// **'Reliability center'**
  String get reliabilityCenter;

  /// No description provided for @createFirstAlarm.
  ///
  /// In en, this message translates to:
  /// **'Create your first alarm'**
  String get createFirstAlarm;

  /// No description provided for @createFirstAlarmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the + button for a single alarm or an interval series.'**
  String get createFirstAlarmSubtitle;

  /// No description provided for @noActiveAlarm.
  ///
  /// In en, this message translates to:
  /// **'No active alarm'**
  String get noActiveAlarm;

  /// No description provided for @newAlarm.
  ///
  /// In en, this message translates to:
  /// **'New alarm'**
  String get newAlarm;

  /// No description provided for @editAlarm.
  ///
  /// In en, this message translates to:
  /// **'Edit alarm'**
  String get editAlarm;

  /// No description provided for @specificTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Specific time range'**
  String get specificTimeRange;

  /// No description provided for @specificTimeRangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create several alarms automatically between two times'**
  String get specificTimeRangeSubtitle;

  /// No description provided for @rangeNextDay.
  ///
  /// In en, this message translates to:
  /// **'The end time will be applied to the next day.'**
  String get rangeNextDay;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @alarmInformation.
  ///
  /// In en, this message translates to:
  /// **'Alarm information'**
  String get alarmInformation;

  /// No description provided for @beforeDismiss.
  ///
  /// In en, this message translates to:
  /// **'Before dismissing'**
  String get beforeDismiss;

  /// No description provided for @morningRoutine.
  ///
  /// In en, this message translates to:
  /// **'Morning routine'**
  String get morningRoutine;

  /// No description provided for @rangeMorningUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable for interval alarms because backup alarms would overlap'**
  String get rangeMorningUnavailable;

  /// No description provided for @disabledByDefault.
  ///
  /// In en, this message translates to:
  /// **'Off by default'**
  String get disabledByDefault;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// No description provided for @ringInterval.
  ///
  /// In en, this message translates to:
  /// **'Ring interval'**
  String get ringInterval;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @labelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Get ready for work'**
  String get labelHint;

  /// No description provided for @alarmGroup.
  ///
  /// In en, this message translates to:
  /// **'Alarm group'**
  String get alarmGroup;

  /// No description provided for @noGroup.
  ///
  /// In en, this message translates to:
  /// **'No group'**
  String get noGroup;

  /// No description provided for @ringtone.
  ///
  /// In en, this message translates to:
  /// **'Ringtone'**
  String get ringtone;

  /// No description provided for @vibrateWhenRinging.
  ///
  /// In en, this message translates to:
  /// **'Vibrate when alarm rings'**
  String get vibrateWhenRinging;

  /// No description provided for @deleteAfterRinging.
  ///
  /// In en, this message translates to:
  /// **'Delete after ringing'**
  String get deleteAfterRinging;

  /// No description provided for @oneTimeAlarmOnly.
  ///
  /// In en, this message translates to:
  /// **'Used for one-time alarms'**
  String get oneTimeAlarmOnly;

  /// No description provided for @dismissTask.
  ///
  /// In en, this message translates to:
  /// **'Dismiss task'**
  String get dismissTask;

  /// No description provided for @noTask.
  ///
  /// In en, this message translates to:
  /// **'No task'**
  String get noTask;

  /// No description provided for @mathTask.
  ///
  /// In en, this message translates to:
  /// **'Math problem'**
  String get mathTask;

  /// No description provided for @shakeTask.
  ///
  /// In en, this message translates to:
  /// **'Shake phone 5 times'**
  String get shakeTask;

  /// No description provided for @useMorningRoutine.
  ///
  /// In en, this message translates to:
  /// **'Use morning routine'**
  String get useMorningRoutine;

  /// No description provided for @gentlePreAlert.
  ///
  /// In en, this message translates to:
  /// **'Gentle pre-alert'**
  String get gentlePreAlert;

  /// No description provided for @backupAlarm.
  ///
  /// In en, this message translates to:
  /// **'Backup alarm'**
  String get backupAlarm;

  /// No description provided for @backupAlarmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rings again if the first alarm is not dismissed'**
  String get backupAlarmSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'Use system theme'**
  String get systemTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// No description provided for @changeSystemTime.
  ///
  /// In en, this message translates to:
  /// **'Change system time'**
  String get changeSystemTime;

  /// No description provided for @changeSystemTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Opens Android date and time settings'**
  String get changeSystemTimeSubtitle;

  /// No description provided for @reliabilityCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check permissions, alarm volume and battery restrictions'**
  String get reliabilityCenterSubtitle;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @exportBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save alarms and settings as a JSON file'**
  String get exportBackupSubtitle;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreBackup;

  /// No description provided for @restoreBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a Snoon JSON backup'**
  String get restoreBackupSubtitle;

  /// No description provided for @restoreBackupQuestion.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get restoreBackupQuestion;

  /// No description provided for @restoreBackupWarning.
  ///
  /// In en, this message translates to:
  /// **'Current alarms and settings will be replaced with the contents of the selected file.'**
  String get restoreBackupWarning;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFile;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Snoon backup saved.'**
  String get backupSaved;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Snoon backup restored.'**
  String get backupRestored;

  /// No description provided for @backupCancelled.
  ///
  /// In en, this message translates to:
  /// **'Backup operation cancelled.'**
  String get backupCancelled;

  /// No description provided for @alarmRingtone.
  ///
  /// In en, this message translates to:
  /// **'Alarm ringtone'**
  String get alarmRingtone;

  /// No description provided for @timerRingtone.
  ///
  /// In en, this message translates to:
  /// **'Timer ringtone'**
  String get timerRingtone;

  /// No description provided for @alarmVolume.
  ///
  /// In en, this message translates to:
  /// **'Alarm volume'**
  String get alarmVolume;

  /// No description provided for @autoSilence.
  ///
  /// In en, this message translates to:
  /// **'Auto silence'**
  String get autoSilence;

  /// No description provided for @increasingVolume.
  ///
  /// In en, this message translates to:
  /// **'Increasing alarm volume'**
  String get increasingVolume;

  /// No description provided for @increasingVolumeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Volume rises gradually during the first 30 seconds'**
  String get increasingVolumeSubtitle;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @maximumSnoozes.
  ///
  /// In en, this message translates to:
  /// **'Maximum snoozes'**
  String get maximumSnoozes;

  /// No description provided for @volumeButtons.
  ///
  /// In en, this message translates to:
  /// **'Volume buttons'**
  String get volumeButtons;

  /// No description provided for @volumeChange.
  ///
  /// In en, this message translates to:
  /// **'Change volume'**
  String get volumeChange;

  /// No description provided for @snoozeAlarm.
  ///
  /// In en, this message translates to:
  /// **'Snooze alarm'**
  String get snoozeAlarm;

  /// No description provided for @dismissAlarm.
  ///
  /// In en, this message translates to:
  /// **'Dismiss alarm'**
  String get dismissAlarm;

  /// No description provided for @notifyBeforeRinging.
  ///
  /// In en, this message translates to:
  /// **'Notify before ringing'**
  String get notifyBeforeRinging;

  /// No description provided for @showOnLockScreen.
  ///
  /// In en, this message translates to:
  /// **'Show alarms on lock screen'**
  String get showOnLockScreen;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesShort(int count);

  /// No description provided for @minutesBefore.
  ///
  /// In en, this message translates to:
  /// **'{count} min before'**
  String minutesBefore(int count);

  /// No description provided for @minutesAfter.
  ///
  /// In en, this message translates to:
  /// **'{count} min later'**
  String minutesAfter(int count);

  /// No description provided for @timesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 time} other{{count} times}}'**
  String timesCount(int count);

  /// No description provided for @maximumTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Up to 1 time} other{Up to {count} times}}'**
  String maximumTimes(int count);

  /// No description provided for @alarmsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 alarm} other{{count} alarms}}'**
  String alarmsCount(int count);

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @alarmsDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete alarms?'**
  String get alarmsDeleteQuestion;

  /// No description provided for @alarmsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 alarm will be permanently deleted.} other{{count} alarms will be permanently deleted.}}'**
  String alarmsDeleteMessage(int count);

  /// No description provided for @pauseUntilDate.
  ///
  /// In en, this message translates to:
  /// **'Pause until date'**
  String get pauseUntilDate;

  /// No description provided for @shiftToday.
  ///
  /// In en, this message translates to:
  /// **'Shift for today'**
  String get shiftToday;

  /// No description provided for @pauseDateHelp.
  ///
  /// In en, this message translates to:
  /// **'PAUSE ALARMS UNTIL WHEN?'**
  String get pauseDateHelp;

  /// No description provided for @pauseSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 alarm paused until {date}.} other{{count} alarms paused until {date}.}}'**
  String pauseSuccess(int count, String date);

  /// No description provided for @shiftTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Shift today\'s alarms'**
  String get shiftTodayTitle;

  /// No description provided for @shiftTodaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'The regular schedule stays unchanged; only today\'s ring times are affected.'**
  String get shiftTodaySubtitle;

  /// No description provided for @shiftSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 alarm moved {minutes} minutes {direction} today.} other{{count} alarms moved {minutes} minutes {direction} today.}}'**
  String shiftSuccess(int count, int minutes, String direction);

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'forward'**
  String get forward;

  /// No description provided for @backward.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get backward;

  /// No description provided for @nextAlarm.
  ///
  /// In en, this message translates to:
  /// **'Next alarm'**
  String get nextAlarm;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// No description provided for @weekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekend;

  /// No description provided for @intervalEvery.
  ///
  /// In en, this message translates to:
  /// **'every {count} min'**
  String intervalEvery(int count);

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @todayOffset.
  ///
  /// In en, this message translates to:
  /// **'{count} min today'**
  String todayOffset(int count);

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No alarm history yet'**
  String get noHistory;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @worldClock.
  ///
  /// In en, this message translates to:
  /// **'World Clock'**
  String get worldClock;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get searchCity;

  /// No description provided for @cityNotFound.
  ///
  /// In en, this message translates to:
  /// **'No city found'**
  String get cityNotFound;

  /// No description provided for @customTimer.
  ///
  /// In en, this message translates to:
  /// **'Custom timer'**
  String get customTimer;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @hourShort.
  ///
  /// In en, this message translates to:
  /// **'{count} hr'**
  String hourShort(int count);

  /// No description provided for @invalidDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid duration.'**
  String get invalidDuration;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @lap.
  ///
  /// In en, this message translates to:
  /// **'Lap'**
  String get lap;

  /// No description provided for @lapNumber.
  ///
  /// In en, this message translates to:
  /// **'Lap {count}'**
  String lapNumber(int count);

  /// No description provided for @sleepSchedule.
  ///
  /// In en, this message translates to:
  /// **'Sleep schedule'**
  String get sleepSchedule;

  /// No description provided for @plannedSleepDuration.
  ///
  /// In en, this message translates to:
  /// **'Planned sleep duration'**
  String get plannedSleepDuration;

  /// No description provided for @sleepReminderAndWakeAlarm.
  ///
  /// In en, this message translates to:
  /// **'Bedtime reminder and wake-up alarm'**
  String get sleepReminderAndWakeAlarm;

  /// No description provided for @scheduleDays.
  ///
  /// In en, this message translates to:
  /// **'Schedule days'**
  String get scheduleDays;

  /// No description provided for @atLeastOneSleepDay.
  ///
  /// In en, this message translates to:
  /// **'At least one day must remain selected for the sleep schedule.'**
  String get atLeastOneSleepDay;

  /// No description provided for @sleepScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a reminder before bedtime and keep wake-up times consistent'**
  String get sleepScheduleSubtitle;

  /// No description provided for @bedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get bedtime;

  /// No description provided for @wakeTime.
  ///
  /// In en, this message translates to:
  /// **'Wake-up time'**
  String get wakeTime;

  /// No description provided for @windDownTime.
  ///
  /// In en, this message translates to:
  /// **'Wind-down time'**
  String get windDownTime;

  /// No description provided for @windDownSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A notification is sent before bedtime'**
  String get windDownSubtitle;

  /// No description provided for @addCity.
  ///
  /// In en, this message translates to:
  /// **'Add city'**
  String get addCity;

  /// No description provided for @tryDifferentCity.
  ///
  /// In en, this message translates to:
  /// **'Try another city name.'**
  String get tryDifferentCity;

  /// No description provided for @localTime.
  ///
  /// In en, this message translates to:
  /// **'Local time'**
  String get localTime;

  /// No description provided for @localTimeDifference.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr {minutes} min {direction} of local time'**
  String localTimeDifference(int hours, int minutes, String direction);

  /// No description provided for @testAlarm.
  ///
  /// In en, this message translates to:
  /// **'Test alarm'**
  String get testAlarm;

  /// No description provided for @testAlarmType.
  ///
  /// In en, this message translates to:
  /// **'Test alarm type'**
  String get testAlarmType;

  /// No description provided for @dismissDirectly.
  ///
  /// In en, this message translates to:
  /// **'Dismiss the alarm directly'**
  String get dismissDirectly;

  /// No description provided for @verifyDismissTask.
  ///
  /// In en, this message translates to:
  /// **'Also verify the dismissal task'**
  String get verifyDismissTask;

  /// No description provided for @alarmsReady.
  ///
  /// In en, this message translates to:
  /// **'Alarms are ready'**
  String get alarmsReady;

  /// No description provided for @checkPermissions.
  ///
  /// In en, this message translates to:
  /// **'Check permissions'**
  String get checkPermissions;

  /// No description provided for @alarmsReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exact alarm and notification permissions are enabled.'**
  String get alarmsReadySubtitle;

  /// No description provided for @permissionsWarningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Missing permissions may make an alarm ring late or silently.'**
  String get permissionsWarningSubtitle;

  /// No description provided for @exactAlarmCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allows the alarm to run at the exact scheduled second.'**
  String get exactAlarmCheckSubtitle;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant permission'**
  String get grantPermission;

  /// No description provided for @manufacturerSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On {manufacturer}, allow Snoon to auto-start and set background and battery use to ‘Unrestricted’.'**
  String manufacturerSettingsSubtitle(String manufacturer);

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get appSettings;

  /// No description provided for @notificationCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Required for pre-alerts and lock-screen alarms.'**
  String get notificationCheckSubtitle;

  /// No description provided for @fullScreenCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows alarm controls on the lock screen and over other apps.'**
  String get fullScreenCheckSubtitle;

  /// No description provided for @alarmSoundLevel.
  ///
  /// In en, this message translates to:
  /// **'Alarm sound level'**
  String get alarmSoundLevel;

  /// No description provided for @alarmSoundAudible.
  ///
  /// In en, this message translates to:
  /// **'The Android alarm sound channel is audible.'**
  String get alarmSoundAudible;

  /// No description provided for @alarmSoundMuted.
  ///
  /// In en, this message translates to:
  /// **'The system alarm sound is muted. Snoon will raise it to the configured level while ringing.'**
  String get alarmSoundMuted;

  /// No description provided for @soundSettings.
  ///
  /// In en, this message translates to:
  /// **'Sound settings'**
  String get soundSettings;

  /// No description provided for @batteryUnrestricted.
  ///
  /// In en, this message translates to:
  /// **'The app is not affected by battery restrictions.'**
  String get batteryUnrestricted;

  /// No description provided for @batteryMayDelay.
  ///
  /// In en, this message translates to:
  /// **'Some phones may delay alarms in the background.'**
  String get batteryMayDelay;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @runTenSecondTest.
  ///
  /// In en, this message translates to:
  /// **'Run 10-second test alarm'**
  String get runTenSecondTest;

  /// No description provided for @refreshChecks.
  ///
  /// In en, this message translates to:
  /// **'Refresh checks'**
  String get refreshChecks;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notification permission'**
  String get notificationPermission;

  /// No description provided for @batteryOptimization.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization'**
  String get batteryOptimization;

  /// No description provided for @manufacturerBackgroundSettings.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer background settings'**
  String get manufacturerBackgroundSettings;

  /// No description provided for @testScheduled.
  ///
  /// In en, this message translates to:
  /// **'Test alarm will ring in 10 seconds • {task}'**
  String testScheduled(String task);

  /// No description provided for @sameStartEndError.
  ///
  /// In en, this message translates to:
  /// **'Start and end time cannot be the same.'**
  String get sameStartEndError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
