// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Snoon';

  @override
  String get languageTitle => 'Sprache auswählen';

  @override
  String get languageSubtitle =>
      'Du kannst dies später in den Einstellungen ändern.';

  @override
  String get languageContinue => 'Weiter';

  @override
  String get languageRecommended => 'Gerätesprache';

  @override
  String get languageSetting => 'App-Sprache';

  @override
  String get languageSettingSubtitle =>
      'Anzeige- und Alarmsprache von Snoon ändern';

  @override
  String get languageChanged => 'Sprache geändert';

  @override
  String get turkish => 'Türkisch';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get french => 'Französisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get portuguese => 'Portugiesisch';

  @override
  String get alarm => 'Alarm';

  @override
  String get world => 'Welt';

  @override
  String get stopwatch => 'Stoppuhr';

  @override
  String get timer => 'Timer';

  @override
  String get sleep => 'Schlaf';

  @override
  String get settings => 'Einstellungen';

  @override
  String get general => 'Allgemein';

  @override
  String get backup => 'Sicherung';

  @override
  String get sounds => 'Töne';

  @override
  String get extraAlarmSettings => 'Zusätzliche Alarmeinstellungen';

  @override
  String get off => 'Aus';

  @override
  String get ringtonePickerFailed =>
      'Klingeltonauswahl konnte nicht geöffnet werden.';

  @override
  String get backupSaveFailed =>
      'Sicherungsdatei konnte nicht gespeichert werden.';

  @override
  String get backupReadFailed => 'Sicherungsdatei konnte nicht gelesen werden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get apply => 'Anwenden';

  @override
  String get clear => 'Leeren';

  @override
  String get later => 'Später';

  @override
  String get openSetting => 'Einstellung öffnen';

  @override
  String get exactAlarmPermission => 'Berechtigung für genaue Alarme';

  @override
  String get exactAlarmPermissionMessage =>
      'Snoon benötigt die Android-Berechtigung ‚Alarme & Erinnerungen‘, um genau zur eingestellten Zeit zu klingeln.';

  @override
  String get fullScreenPermission => 'Vollbildalarm-Berechtigung';

  @override
  String get fullScreenPermissionMessage =>
      'Aktiviere Vollbildbenachrichtigungen, um Alarme auf dem Sperrbildschirm zu steuern.';

  @override
  String get alarmGroups => 'Alarmgruppen';

  @override
  String get groupsIntro =>
      'Pausiere eine Gruppe im Urlaub, überspringe bestimmte Daten oder verschiebe alle heutigen Zeiten gemeinsam.';

  @override
  String get addGroup => 'Gruppe hinzufügen';

  @override
  String get newGroup => 'Neue Gruppe';

  @override
  String get editGroup => 'Gruppe bearbeiten';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get groupNameRequired => 'Gib einen Gruppennamen ein.';

  @override
  String pausedUntil(String date) {
    return 'Pausiert bis $date';
  }

  @override
  String exceptionDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ausnahmetage',
      one: '1 Ausnahmetag',
    );
    return '$_temp0';
  }

  @override
  String get vacationMode => 'Urlaubsmodus';

  @override
  String get notSet => 'Nicht festgelegt';

  @override
  String get exceptionCalendar => 'Ausnahmekalender';

  @override
  String get exceptionCalendarSubtitle =>
      'An diesen Tagen klingelt kein Alarm der Gruppe.';

  @override
  String get noExceptionDates => 'Noch kein Ausnahmedatum.';

  @override
  String get addDate => 'Datum hinzufügen';

  @override
  String get bulkShiftToday => 'Heute gemeinsam verschieben';

  @override
  String get todayGroupTimes => 'Heutige Gruppenzeiten';

  @override
  String get scheduleUnchanged => 'Der dauerhafte Alarmplan bleibt unverändert';

  @override
  String get noChange => 'Keine Änderung';

  @override
  String get deleteGroup => 'Gruppe löschen';

  @override
  String get alarmHistory => 'Alarmverlauf';

  @override
  String get historyEmptySubtitle =>
      'Klingelnde, verschobene, beendete und automatisch stummgeschaltete Alarme erscheinen hier.';

  @override
  String get actionRang => 'Geklingelt';

  @override
  String get actionSnoozed => 'Verschoben';

  @override
  String get actionSnoozeCancelled => 'Schlummern abgebrochen';

  @override
  String get actionDismissed => 'Beendet';

  @override
  String get actionAutoSilenced => 'Automatisch stumm';

  @override
  String get reliabilityCenter => 'Zuverlässigkeitscenter';

  @override
  String get createFirstAlarm => 'Ersten Alarm erstellen';

  @override
  String get createFirstAlarmSubtitle =>
      'Verwende die + Taste für einen Alarm oder eine Intervallserie.';

  @override
  String get noActiveAlarm => 'Kein aktiver Alarm';

  @override
  String get newAlarm => 'Neuer Alarm';

  @override
  String get editAlarm => 'Alarm bearbeiten';

  @override
  String get specificTimeRange => 'Bestimmter Zeitraum';

  @override
  String get specificTimeRangeSubtitle =>
      'Mehrere Alarme automatisch zwischen zwei Zeiten erstellen';

  @override
  String get rangeNextDay =>
      'Die Endzeit wird auf den nächsten Tag angewendet.';

  @override
  String get repeat => 'Wiederholen';

  @override
  String get alarmInformation => 'Alarminformationen';

  @override
  String get beforeDismiss => 'Vor dem Beenden';

  @override
  String get morningRoutine => 'Morgenroutine';

  @override
  String get rangeMorningUnavailable =>
      'Für Intervallalarme nicht verfügbar, da sich Ersatzalarme überschneiden würden';

  @override
  String get disabledByDefault => 'Standardmäßig aus';

  @override
  String get endTime => 'Endzeit';

  @override
  String get ringInterval => 'Klingelintervall';

  @override
  String get label => 'Bezeichnung';

  @override
  String get labelHint => 'z. B. Für die Arbeit vorbereiten';

  @override
  String get alarmGroup => 'Alarmgruppe';

  @override
  String get noGroup => 'Keine Gruppe';

  @override
  String get ringtone => 'Klingelton';

  @override
  String get vibrateWhenRinging => 'Beim Klingeln vibrieren';

  @override
  String get deleteAfterRinging => 'Nach dem Klingeln löschen';

  @override
  String get oneTimeAlarmOnly => 'Für einmalige Alarme';

  @override
  String get dismissTask => 'Ausschaltaufgabe';

  @override
  String get noTask => 'Keine Aufgabe';

  @override
  String get mathTask => 'Rechenaufgabe';

  @override
  String get shakeTask => 'Telefon 5-mal schütteln';

  @override
  String get useMorningRoutine => 'Morgenroutine verwenden';

  @override
  String get gentlePreAlert => 'Sanfte Vorwarnung';

  @override
  String get backupAlarm => 'Ersatzalarm';

  @override
  String get backupAlarmSubtitle =>
      'Klingelt erneut, wenn der erste Alarm nicht beendet wird';

  @override
  String get appearance => 'Darstellung';

  @override
  String get systemTheme => 'Systemdesign verwenden';

  @override
  String get darkTheme => 'Dunkles Design';

  @override
  String get lightTheme => 'Helles Design';

  @override
  String get changeSystemTime => 'Systemzeit ändern';

  @override
  String get changeSystemTimeSubtitle =>
      'Öffnet die Android-Einstellungen für Datum und Uhrzeit';

  @override
  String get reliabilityCenterSubtitle =>
      'Berechtigungen, Alarmlautstärke und Akkubeschränkungen prüfen';

  @override
  String get exportBackup => 'Sicherung exportieren';

  @override
  String get exportBackupSubtitle =>
      'Alarme und Einstellungen als JSON-Datei speichern';

  @override
  String get restoreBackup => 'Sicherung wiederherstellen';

  @override
  String get restoreBackupSubtitle => 'Eine Snoon-JSON-Sicherung auswählen';

  @override
  String get restoreBackupQuestion => 'Sicherung wiederherstellen?';

  @override
  String get restoreBackupWarning =>
      'Aktuelle Alarme und Einstellungen werden durch die ausgewählte Datei ersetzt.';

  @override
  String get chooseFile => 'Datei auswählen';

  @override
  String get backupSaved => 'Snoon-Sicherung gespeichert.';

  @override
  String get backupRestored => 'Snoon-Sicherung wiederhergestellt.';

  @override
  String get backupCancelled => 'Sicherungsvorgang abgebrochen.';

  @override
  String get alarmRingtone => 'Alarmklingelton';

  @override
  String get timerRingtone => 'Timerklingelton';

  @override
  String get alarmVolume => 'Alarmlautstärke';

  @override
  String get autoSilence => 'Automatisch stummschalten';

  @override
  String get increasingVolume => 'Ansteigende Lautstärke';

  @override
  String get increasingVolumeSubtitle =>
      'Die Lautstärke steigt in den ersten 30 Sekunden langsam an';

  @override
  String get snooze => 'Schlummern';

  @override
  String get maximumSnoozes => 'Maximale Schlummeranzahl';

  @override
  String get volumeButtons => 'Lautstärketasten';

  @override
  String get volumeChange => 'Lautstärke ändern';

  @override
  String get snoozeAlarm => 'Alarm verschieben';

  @override
  String get dismissAlarm => 'Alarm beenden';

  @override
  String get notifyBeforeRinging => 'Vor dem Klingeln benachrichtigen';

  @override
  String get showOnLockScreen => 'Alarme auf dem Sperrbildschirm anzeigen';

  @override
  String minutesShort(int count) {
    return '$count Min.';
  }

  @override
  String minutesBefore(int count) {
    return '$count Min. vorher';
  }

  @override
  String minutesAfter(int count) {
    return '$count Min. später';
  }

  @override
  String timesCount(int count) {
    return '$count-mal';
  }

  @override
  String maximumTimes(int count) {
    return 'Bis zu $count-mal';
  }

  @override
  String alarmsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alarme',
      one: '1 Alarm',
    );
    return '$_temp0';
  }

  @override
  String selectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get alarmsDeleteQuestion => 'Alarme löschen?';

  @override
  String alarmsDeleteMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alarme werden dauerhaft gelöscht.',
      one: '1 Alarm wird dauerhaft gelöscht.',
    );
    return '$_temp0';
  }

  @override
  String get pauseUntilDate => 'Bis Datum pausieren';

  @override
  String get shiftToday => 'Heute verschieben';

  @override
  String get pauseDateHelp => 'BIS WANN SOLLEN DIE ALARME PAUSIERT WERDEN?';

  @override
  String pauseSuccess(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alarme bis $date pausiert.',
      one: '1 Alarm bis $date pausiert.',
    );
    return '$_temp0';
  }

  @override
  String get shiftTodayTitle => 'Heutige Alarme verschieben';

  @override
  String get shiftTodaySubtitle =>
      'Der reguläre Plan bleibt unverändert; nur die heutigen Klingelzeiten werden beeinflusst.';

  @override
  String shiftSuccess(int count, int minutes, String direction) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Alarme heute um $minutes Minuten nach $direction verschoben.',
      one: '1 Alarm heute um $minutes Minuten nach $direction verschoben.',
    );
    return '$_temp0';
  }

  @override
  String get forward => 'vorn';

  @override
  String get backward => 'hinten';

  @override
  String get nextAlarm => 'Nächster Alarm';

  @override
  String get once => 'Einmal';

  @override
  String get everyDay => 'Jeden Tag';

  @override
  String get weekdays => 'Wochentage';

  @override
  String get weekend => 'Wochenende';

  @override
  String intervalEvery(int count) {
    return 'alle $count Min.';
  }

  @override
  String get paused => 'Pausiert';

  @override
  String todayOffset(int count) {
    return '$count Min. heute';
  }

  @override
  String get noHistory => 'Noch kein Alarmverlauf';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get worldClock => 'Weltzeituhr';

  @override
  String get searchCity => 'Stadt suchen';

  @override
  String get cityNotFound => 'Keine Stadt gefunden';

  @override
  String get customTimer => 'Benutzerdefinierter Timer';

  @override
  String get hours => 'Stunden';

  @override
  String get minutes => 'Minuten';

  @override
  String get seconds => 'Sekunden';

  @override
  String hourShort(int count) {
    return '$count Std.';
  }

  @override
  String get invalidDuration => 'Gib eine gültige Dauer ein.';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get lap => 'Runde';

  @override
  String lapNumber(int count) {
    return 'Runde $count';
  }

  @override
  String get sleepSchedule => 'Schlafplan';

  @override
  String get plannedSleepDuration => 'Geplante Schlafdauer';

  @override
  String get sleepReminderAndWakeAlarm =>
      'Schlafenszeiterinnerung und Weckalarm';

  @override
  String get scheduleDays => 'Programmtage';

  @override
  String get atLeastOneSleepDay =>
      'Mindestens ein Tag muss für den Schlafplan ausgewählt bleiben.';

  @override
  String get sleepScheduleSubtitle =>
      'Vor dem Schlafengehen erinnern lassen und Aufwachzeiten einhalten';

  @override
  String get bedtime => 'Schlafenszeit';

  @override
  String get wakeTime => 'Aufwachzeit';

  @override
  String get windDownTime => 'Entspannungszeit';

  @override
  String get windDownSubtitle =>
      'Vor dem Schlafengehen wird eine Benachrichtigung gesendet';

  @override
  String get addCity => 'Stadt hinzufügen';

  @override
  String get tryDifferentCity => 'Versuche einen anderen Stadtnamen.';

  @override
  String get localTime => 'Ortszeit';

  @override
  String localTimeDifference(int hours, int minutes, String direction) {
    return '$hours Std. $minutes Min. $direction der Ortszeit';
  }

  @override
  String get testAlarm => 'Testalarm';

  @override
  String get testAlarmType => 'Testalarmtyp';

  @override
  String get dismissDirectly => 'Alarm direkt beenden';

  @override
  String get verifyDismissTask => 'Auch die Ausschaltaufgabe prüfen';

  @override
  String get alarmsReady => 'Alarme sind bereit';

  @override
  String get checkPermissions => 'Berechtigungen prüfen';

  @override
  String get alarmsReadySubtitle =>
      'Berechtigungen für genaue Alarme und Benachrichtigungen sind aktiv.';

  @override
  String get permissionsWarningSubtitle =>
      'Fehlende Berechtigungen können Alarme verspätet oder lautlos auslösen.';

  @override
  String get exactAlarmCheckSubtitle =>
      'Ermöglicht den Alarm zur genau festgelegten Sekunde.';

  @override
  String get grantPermission => 'Berechtigung erteilen';

  @override
  String manufacturerSettingsSubtitle(String manufacturer) {
    return 'Erlaube Snoon auf $manufacturer den Autostart und setze Hintergrund- und Akkunutzung auf ‚Uneingeschränkt‘.';
  }

  @override
  String get appSettings => 'App-Einstellungen';

  @override
  String get notificationCheckSubtitle =>
      'Für Vorwarnungen und Sperrbildschirmalarme erforderlich.';

  @override
  String get fullScreenCheckSubtitle =>
      'Zeigt Alarmsteuerungen auf dem Sperrbildschirm und über anderen Apps.';

  @override
  String get alarmSoundLevel => 'Alarmlautstärke';

  @override
  String get alarmSoundAudible => 'Der Android-Alarmkanal ist hörbar.';

  @override
  String get alarmSoundMuted =>
      'Der Systemalarm ist stumm. Snoon erhöht ihn beim Klingeln auf die eingestellte Lautstärke.';

  @override
  String get soundSettings => 'Toneinstellungen';

  @override
  String get batteryUnrestricted =>
      'Die App wird nicht durch Akkubeschränkungen beeinträchtigt.';

  @override
  String get batteryMayDelay =>
      'Einige Telefone können Alarme im Hintergrund verzögern.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get runTenSecondTest => '10-Sekunden-Testalarm starten';

  @override
  String get refreshChecks => 'Prüfungen aktualisieren';

  @override
  String get notificationPermission => 'Benachrichtigungsberechtigung';

  @override
  String get batteryOptimization => 'Akkuoptimierung';

  @override
  String get manufacturerBackgroundSettings =>
      'Hersteller-Hintergrundeinstellungen';

  @override
  String testScheduled(String task) {
    return 'Testalarm klingelt in 10 Sekunden • $task';
  }

  @override
  String get sameStartEndError =>
      'Start- und Endzeit dürfen nicht gleich sein.';
}
