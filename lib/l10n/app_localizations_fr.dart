// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Snoon';

  @override
  String get languageTitle => 'Choisissez votre langue';

  @override
  String get languageSubtitle =>
      'Vous pourrez la modifier plus tard dans les paramètres.';

  @override
  String get languageContinue => 'Continuer';

  @override
  String get languageRecommended => 'Langue de l\'appareil';

  @override
  String get languageSetting => 'Langue de l\'application';

  @override
  String get languageSettingSubtitle =>
      'Modifier la langue d\'affichage et des alarmes';

  @override
  String get languageChanged => 'Langue modifiée';

  @override
  String get turkish => 'Turc';

  @override
  String get english => 'Anglais';

  @override
  String get german => 'Allemand';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Français';

  @override
  String get italian => 'Italien';

  @override
  String get portuguese => 'Portugais';

  @override
  String get alarm => 'Alarme';

  @override
  String get world => 'Monde';

  @override
  String get stopwatch => 'Chronomètre';

  @override
  String get timer => 'Minuteur';

  @override
  String get sleep => 'Sommeil';

  @override
  String get settings => 'Paramètres';

  @override
  String get general => 'Général';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get sounds => 'Sons';

  @override
  String get extraAlarmSettings => 'Paramètres d\'alarme supplémentaires';

  @override
  String get off => 'Désactivé';

  @override
  String get ringtonePickerFailed =>
      'Impossible d\'ouvrir le sélecteur de sonnerie.';

  @override
  String get backupSaveFailed =>
      'Impossible d\'enregistrer le fichier de sauvegarde.';

  @override
  String get backupReadFailed => 'Impossible de lire le fichier de sauvegarde.';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get apply => 'Appliquer';

  @override
  String get clear => 'Effacer';

  @override
  String get later => 'Plus tard';

  @override
  String get openSetting => 'Ouvrir le réglage';

  @override
  String get exactAlarmPermission => 'Autorisation des alarmes exactes';

  @override
  String get exactAlarmPermissionMessage =>
      'Snoon a besoin de l\'autorisation Android « Alarmes et rappels » pour sonner exactement à l\'heure choisie.';

  @override
  String get fullScreenPermission => 'Autorisation d\'alarme plein écran';

  @override
  String get fullScreenPermissionMessage =>
      'Activez les notifications plein écran pour gérer l\'alarme sur l\'écran verrouillé.';

  @override
  String get alarmGroups => 'Groupes d\'alarmes';

  @override
  String get groupsIntro =>
      'Mettez un groupe en pause pendant les vacances, ignorez certaines dates ou décalez ensemble toutes les heures d\'aujourd\'hui.';

  @override
  String get addGroup => 'Ajouter un groupe';

  @override
  String get newGroup => 'Nouveau groupe';

  @override
  String get editGroup => 'Modifier le groupe';

  @override
  String get groupName => 'Nom du groupe';

  @override
  String get groupNameRequired => 'Saisissez un nom de groupe.';

  @override
  String pausedUntil(String date) {
    return 'En pause jusqu\'au $date';
  }

  @override
  String exceptionDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours d\'exception',
      one: '1 jour d\'exception',
    );
    return '$_temp0';
  }

  @override
  String get vacationMode => 'Mode vacances';

  @override
  String get notSet => 'Non défini';

  @override
  String get exceptionCalendar => 'Calendrier des exceptions';

  @override
  String get exceptionCalendarSubtitle =>
      'Aucune alarme du groupe ne sonnera à ces dates.';

  @override
  String get noExceptionDates => 'Aucune date d\'exception pour le moment.';

  @override
  String get addDate => 'Ajouter une date';

  @override
  String get bulkShiftToday => 'Décalage groupé aujourd\'hui';

  @override
  String get todayGroupTimes => 'Heures du groupe aujourd\'hui';

  @override
  String get scheduleUnchanged => 'Le programme permanent reste inchangé';

  @override
  String get noChange => 'Aucun changement';

  @override
  String get deleteGroup => 'Supprimer le groupe';

  @override
  String get alarmHistory => 'Historique des alarmes';

  @override
  String get historyEmptySubtitle =>
      'Les alarmes qui ont sonné, été répétées, arrêtées ou coupées automatiquement apparaissent ici.';

  @override
  String get actionRang => 'A sonné';

  @override
  String get actionSnoozed => 'Reportée';

  @override
  String get actionSnoozeCancelled => 'Répétition annulée';

  @override
  String get actionDismissed => 'Arrêtée';

  @override
  String get actionAutoSilenced => 'Coupée automatiquement';

  @override
  String get reliabilityCenter => 'Centre de fiabilité';

  @override
  String get createFirstAlarm => 'Créez votre première alarme';

  @override
  String get createFirstAlarmSubtitle =>
      'Utilisez le bouton + pour une alarme ou une série d\'intervalles.';

  @override
  String get noActiveAlarm => 'Aucune alarme active';

  @override
  String get newAlarm => 'Nouvelle alarme';

  @override
  String get editAlarm => 'Modifier l\'alarme';

  @override
  String get specificTimeRange => 'Plage horaire';

  @override
  String get specificTimeRangeSubtitle =>
      'Créer automatiquement plusieurs alarmes entre deux heures';

  @override
  String get rangeNextDay => 'L\'heure de fin sera appliquée au jour suivant.';

  @override
  String get repeat => 'Répéter';

  @override
  String get alarmInformation => 'Informations sur l\'alarme';

  @override
  String get beforeDismiss => 'Avant l\'arrêt';

  @override
  String get morningRoutine => 'Routine matinale';

  @override
  String get rangeMorningUnavailable =>
      'Indisponible pour les alarmes par intervalle, car les alarmes de secours se chevaucheraient';

  @override
  String get disabledByDefault => 'Désactivé par défaut';

  @override
  String get endTime => 'Heure de fin';

  @override
  String get ringInterval => 'Intervalle';

  @override
  String get label => 'Libellé';

  @override
  String get labelHint => 'p. ex. Se préparer au travail';

  @override
  String get alarmGroup => 'Groupe d\'alarmes';

  @override
  String get noGroup => 'Aucun groupe';

  @override
  String get ringtone => 'Sonnerie';

  @override
  String get vibrateWhenRinging => 'Vibrer pendant l\'alarme';

  @override
  String get deleteAfterRinging => 'Supprimer après la sonnerie';

  @override
  String get oneTimeAlarmOnly => 'Pour les alarmes ponctuelles';

  @override
  String get dismissTask => 'Tâche d\'arrêt';

  @override
  String get noTask => 'Aucune tâche';

  @override
  String get mathTask => 'Calcul mathématique';

  @override
  String get shakeTask => 'Secouer le téléphone 5 fois';

  @override
  String get useMorningRoutine => 'Utiliser la routine matinale';

  @override
  String get gentlePreAlert => 'Préalerte douce';

  @override
  String get backupAlarm => 'Alarme de secours';

  @override
  String get backupAlarmSubtitle =>
      'Sonne à nouveau si la première alarme n\'est pas arrêtée';

  @override
  String get appearance => 'Apparence';

  @override
  String get systemTheme => 'Utiliser le thème système';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get lightTheme => 'Thème clair';

  @override
  String get changeSystemTime => 'Modifier l\'heure système';

  @override
  String get changeSystemTimeSubtitle =>
      'Ouvre les paramètres de date et d\'heure Android';

  @override
  String get reliabilityCenterSubtitle =>
      'Vérifier les autorisations, le volume et les restrictions de batterie';

  @override
  String get exportBackup => 'Exporter la sauvegarde';

  @override
  String get exportBackupSubtitle =>
      'Enregistrer alarmes et paramètres dans un fichier JSON';

  @override
  String get restoreBackup => 'Restaurer la sauvegarde';

  @override
  String get restoreBackupSubtitle => 'Choisir une sauvegarde JSON Snoon';

  @override
  String get restoreBackupQuestion => 'Restaurer la sauvegarde ?';

  @override
  String get restoreBackupWarning =>
      'Les alarmes et paramètres actuels seront remplacés.';

  @override
  String get chooseFile => 'Choisir un fichier';

  @override
  String get backupSaved => 'Sauvegarde Snoon enregistrée.';

  @override
  String get backupRestored => 'Sauvegarde Snoon restaurée.';

  @override
  String get backupCancelled => 'Opération de sauvegarde annulée.';

  @override
  String get alarmRingtone => 'Sonnerie d\'alarme';

  @override
  String get timerRingtone => 'Sonnerie du minuteur';

  @override
  String get alarmVolume => 'Volume de l\'alarme';

  @override
  String get autoSilence => 'Arrêt automatique';

  @override
  String get increasingVolume => 'Volume progressif';

  @override
  String get increasingVolumeSubtitle =>
      'Le volume augmente progressivement pendant les 30 premières secondes';

  @override
  String get snooze => 'Répéter';

  @override
  String get maximumSnoozes => 'Nombre maximal de répétitions';

  @override
  String get volumeButtons => 'Boutons de volume';

  @override
  String get volumeChange => 'Modifier le volume';

  @override
  String get snoozeAlarm => 'Reporter l\'alarme';

  @override
  String get dismissAlarm => 'Arrêter l\'alarme';

  @override
  String get notifyBeforeRinging => 'Notifier avant la sonnerie';

  @override
  String get showOnLockScreen => 'Afficher les alarmes sur l\'écran verrouillé';

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String minutesBefore(int count) {
    return '$count min avant';
  }

  @override
  String minutesAfter(int count) {
    return '$count min après';
  }

  @override
  String timesCount(int count) {
    return '$count fois';
  }

  @override
  String maximumTimes(int count) {
    return 'Jusqu\'à $count fois';
  }

  @override
  String alarmsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmes',
      one: '1 alarme',
    );
    return '$_temp0';
  }

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnées',
      one: '1 sélectionnée',
    );
    return '$_temp0';
  }

  @override
  String get alarmsDeleteQuestion => 'Supprimer les alarmes ?';

  @override
  String alarmsDeleteMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmes seront définitivement supprimées.',
      one: '1 alarme sera définitivement supprimée.',
    );
    return '$_temp0';
  }

  @override
  String get pauseUntilDate => 'Mettre en pause jusqu\'à une date';

  @override
  String get shiftToday => 'Décaler aujourd\'hui';

  @override
  String get pauseDateHelp => 'JUSQU\'À QUAND METTRE LES ALARMES EN PAUSE ?';

  @override
  String pauseSuccess(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmes en pause jusqu\'au $date.',
      one: '1 alarme en pause jusqu\'au $date.',
    );
    return '$_temp0';
  }

  @override
  String get shiftTodayTitle => 'Décaler les alarmes d\'aujourd\'hui';

  @override
  String get shiftTodaySubtitle =>
      'Le programme habituel reste inchangé ; seules les heures d\'aujourd\'hui sont modifiées.';

  @override
  String shiftSuccess(int count, int minutes, String direction) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count alarmes déplacées de $minutes minutes vers $direction aujourd\'hui.',
      one:
          '1 alarme déplacée de $minutes minutes vers $direction aujourd\'hui.',
    );
    return '$_temp0';
  }

  @override
  String get forward => 'l\'avant';

  @override
  String get backward => 'l\'arrière';

  @override
  String get nextAlarm => 'Prochaine alarme';

  @override
  String get once => 'Une fois';

  @override
  String get everyDay => 'Tous les jours';

  @override
  String get weekdays => 'En semaine';

  @override
  String get weekend => 'Week-end';

  @override
  String intervalEvery(int count) {
    return 'toutes les $count min';
  }

  @override
  String get paused => 'En pause';

  @override
  String todayOffset(int count) {
    return '$count min aujourd\'hui';
  }

  @override
  String get noHistory => 'Aucun historique d\'alarme';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get worldClock => 'Horloge mondiale';

  @override
  String get searchCity => 'Rechercher une ville';

  @override
  String get cityNotFound => 'Aucune ville trouvée';

  @override
  String get customTimer => 'Minuteur personnalisé';

  @override
  String get hours => 'Heures';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Secondes';

  @override
  String hourShort(int count) {
    return '$count h';
  }

  @override
  String get invalidDuration => 'Saisissez une durée valide.';

  @override
  String get custom => 'Personnalisé';

  @override
  String get start => 'Démarrer';

  @override
  String get pause => 'Pause';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get lap => 'Tour';

  @override
  String lapNumber(int count) {
    return 'Tour $count';
  }

  @override
  String get sleepSchedule => 'Programme de sommeil';

  @override
  String get plannedSleepDuration => 'Durée de sommeil prévue';

  @override
  String get sleepReminderAndWakeAlarm =>
      'Rappel du coucher et alarme de réveil';

  @override
  String get scheduleDays => 'Jours du programme';

  @override
  String get atLeastOneSleepDay =>
      'Au moins un jour doit rester sélectionné pour le programme de sommeil.';

  @override
  String get sleepScheduleSubtitle =>
      'Recevez un rappel avant le coucher et gardez une heure de réveil régulière';

  @override
  String get bedtime => 'Heure du coucher';

  @override
  String get wakeTime => 'Heure du réveil';

  @override
  String get windDownTime => 'Temps de détente';

  @override
  String get windDownSubtitle =>
      'Une notification est envoyée avant le coucher';

  @override
  String get addCity => 'Ajouter une ville';

  @override
  String get tryDifferentCity => 'Essayez un autre nom de ville.';

  @override
  String get localTime => 'Heure locale';

  @override
  String localTimeDifference(int hours, int minutes, String direction) {
    return '$hours h $minutes min vers $direction de l\'heure locale';
  }

  @override
  String get testAlarm => 'Alarme test';

  @override
  String get testAlarmType => 'Type d\'alarme test';

  @override
  String get dismissDirectly => 'Arrêter directement l\'alarme';

  @override
  String get verifyDismissTask => 'Vérifier aussi la tâche d\'arrêt';

  @override
  String get alarmsReady => 'Les alarmes sont prêtes';

  @override
  String get checkPermissions => 'Vérifier les autorisations';

  @override
  String get alarmsReadySubtitle =>
      'Les autorisations d\'alarme exacte et de notification sont activées.';

  @override
  String get permissionsWarningSubtitle =>
      'Des autorisations manquantes peuvent retarder ou rendre silencieuse une alarme.';

  @override
  String get exactAlarmCheckSubtitle =>
      'Permet à l\'alarme de se déclencher à la seconde prévue.';

  @override
  String get grantPermission => 'Autoriser';

  @override
  String manufacturerSettingsSubtitle(String manufacturer) {
    return 'Sur $manufacturer, autorisez le démarrage automatique de Snoon et réglez l\'activité en arrière-plan et la batterie sur « Sans restriction ».';
  }

  @override
  String get appSettings => 'Paramètres de l\'application';

  @override
  String get notificationCheckSubtitle =>
      'Nécessaire pour les préalertes et les alarmes sur l\'écran verrouillé.';

  @override
  String get fullScreenCheckSubtitle =>
      'Affiche les commandes d\'alarme sur l\'écran verrouillé et au-dessus des autres applications.';

  @override
  String get alarmSoundLevel => 'Niveau sonore de l\'alarme';

  @override
  String get alarmSoundAudible => 'Le canal d\'alarme Android est audible.';

  @override
  String get alarmSoundMuted =>
      'Le son d\'alarme système est coupé. Snoon l\'augmentera au niveau choisi pendant la sonnerie.';

  @override
  String get soundSettings => 'Paramètres audio';

  @override
  String get batteryUnrestricted =>
      'L\'application n\'est pas affectée par les restrictions de batterie.';

  @override
  String get batteryMayDelay =>
      'Certains téléphones peuvent retarder les alarmes en arrière-plan.';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get runTenSecondTest => 'Lancer l\'alarme test de 10 secondes';

  @override
  String get refreshChecks => 'Actualiser les vérifications';

  @override
  String get notificationPermission => 'Autorisation des notifications';

  @override
  String get batteryOptimization => 'Optimisation de la batterie';

  @override
  String get manufacturerBackgroundSettings =>
      'Paramètres d\'arrière-plan du fabricant';

  @override
  String testScheduled(String task) {
    return 'L\'alarme test sonnera dans 10 secondes • $task';
  }

  @override
  String get sameStartEndError =>
      'Les heures de début et de fin ne peuvent pas être identiques.';
}
