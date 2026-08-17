// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Snoon';

  @override
  String get languageTitle => 'Scegli la lingua';

  @override
  String get languageSubtitle =>
      'Puoi cambiarla in seguito nelle Impostazioni.';

  @override
  String get languageContinue => 'Continua';

  @override
  String get languageRecommended => 'Lingua del dispositivo';

  @override
  String get languageSetting => 'Lingua dell\'app';

  @override
  String get languageSettingSubtitle =>
      'Cambia la lingua dell\'interfaccia e degli allarmi';

  @override
  String get languageChanged => 'Lingua modificata';

  @override
  String get turkish => 'Turco';

  @override
  String get english => 'Inglese';

  @override
  String get german => 'Tedesco';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get french => 'Francese';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Portoghese';

  @override
  String get alarm => 'Sveglia';

  @override
  String get world => 'Mondo';

  @override
  String get stopwatch => 'Cronometro';

  @override
  String get timer => 'Timer';

  @override
  String get sleep => 'Sonno';

  @override
  String get settings => 'Impostazioni';

  @override
  String get general => 'Generali';

  @override
  String get backup => 'Backup';

  @override
  String get sounds => 'Suoni';

  @override
  String get extraAlarmSettings => 'Impostazioni sveglia aggiuntive';

  @override
  String get off => 'Disattivato';

  @override
  String get ringtonePickerFailed =>
      'Impossibile aprire il selettore delle suonerie.';

  @override
  String get backupSaveFailed => 'Impossibile salvare il file di backup.';

  @override
  String get backupReadFailed => 'Impossibile leggere il file di backup.';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get apply => 'Applica';

  @override
  String get clear => 'Cancella';

  @override
  String get later => 'Più tardi';

  @override
  String get openSetting => 'Apri impostazione';

  @override
  String get exactAlarmPermission => 'Autorizzazione sveglie esatte';

  @override
  String get exactAlarmPermissionMessage =>
      'Snoon richiede l\'autorizzazione Android ‘Sveglie e promemoria’ per suonare esattamente all\'ora impostata.';

  @override
  String get fullScreenPermission => 'Autorizzazione sveglia a schermo intero';

  @override
  String get fullScreenPermissionMessage =>
      'Attiva le notifiche a schermo intero per gestire la sveglia dalla schermata di blocco.';

  @override
  String get alarmGroups => 'Gruppi di sveglie';

  @override
  String get groupsIntro =>
      'Metti in pausa un gruppo durante le vacanze, salta date specifiche o sposta insieme tutti gli orari di oggi.';

  @override
  String get addGroup => 'Aggiungi gruppo';

  @override
  String get newGroup => 'Nuovo gruppo';

  @override
  String get editGroup => 'Modifica gruppo';

  @override
  String get groupName => 'Nome gruppo';

  @override
  String get groupNameRequired => 'Inserisci un nome per il gruppo.';

  @override
  String pausedUntil(String date) {
    return 'In pausa fino al $date';
  }

  @override
  String exceptionDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni di eccezione',
      one: '1 giorno di eccezione',
    );
    return '$_temp0';
  }

  @override
  String get vacationMode => 'Modalità vacanza';

  @override
  String get notSet => 'Non impostato';

  @override
  String get exceptionCalendar => 'Calendario eccezioni';

  @override
  String get exceptionCalendarSubtitle =>
      'In queste date non suonerà nessuna sveglia del gruppo.';

  @override
  String get noExceptionDates => 'Nessuna data di eccezione.';

  @override
  String get addDate => 'Aggiungi data';

  @override
  String get bulkShiftToday => 'Spostamento collettivo di oggi';

  @override
  String get todayGroupTimes => 'Orari del gruppo di oggi';

  @override
  String get scheduleUnchanged => 'Il programma permanente resta invariato';

  @override
  String get noChange => 'Nessuna modifica';

  @override
  String get deleteGroup => 'Elimina gruppo';

  @override
  String get alarmHistory => 'Cronologia sveglie';

  @override
  String get historyEmptySubtitle =>
      'Qui appaiono le sveglie suonate, posticipate, spente e silenziate automaticamente.';

  @override
  String get actionRang => 'Suonata';

  @override
  String get actionSnoozed => 'Posticipata';

  @override
  String get actionSnoozeCancelled => 'Rinvio annullato';

  @override
  String get actionDismissed => 'Spenta';

  @override
  String get actionAutoSilenced => 'Silenziata automaticamente';

  @override
  String get reliabilityCenter => 'Centro affidabilità';

  @override
  String get createFirstAlarm => 'Crea la prima sveglia';

  @override
  String get createFirstAlarmSubtitle =>
      'Usa il pulsante + per una sveglia o una serie a intervalli.';

  @override
  String get noActiveAlarm => 'Nessuna sveglia attiva';

  @override
  String get newAlarm => 'Nuova sveglia';

  @override
  String get editAlarm => 'Modifica sveglia';

  @override
  String get specificTimeRange => 'Intervallo di tempo';

  @override
  String get specificTimeRangeSubtitle =>
      'Crea automaticamente più sveglie tra due orari';

  @override
  String get rangeNextDay =>
      'L\'ora di fine verrà applicata al giorno successivo.';

  @override
  String get repeat => 'Ripeti';

  @override
  String get alarmInformation => 'Informazioni sveglia';

  @override
  String get beforeDismiss => 'Prima di spegnere';

  @override
  String get morningRoutine => 'Routine mattutina';

  @override
  String get rangeMorningUnavailable =>
      'Non disponibile per le sveglie a intervalli perché le sveglie di riserva si sovrapporrebbero';

  @override
  String get disabledByDefault => 'Disattivata per impostazione predefinita';

  @override
  String get endTime => 'Ora di fine';

  @override
  String get ringInterval => 'Intervallo';

  @override
  String get label => 'Etichetta';

  @override
  String get labelHint => 'es. Prepararsi per il lavoro';

  @override
  String get alarmGroup => 'Gruppo di sveglie';

  @override
  String get noGroup => 'Nessun gruppo';

  @override
  String get ringtone => 'Suoneria';

  @override
  String get vibrateWhenRinging => 'Vibra quando suona';

  @override
  String get deleteAfterRinging => 'Elimina dopo la suoneria';

  @override
  String get oneTimeAlarmOnly => 'Per sveglie singole';

  @override
  String get dismissTask => 'Attività di spegnimento';

  @override
  String get noTask => 'Nessuna attività';

  @override
  String get mathTask => 'Problema matematico';

  @override
  String get shakeTask => 'Scuoti il telefono 5 volte';

  @override
  String get useMorningRoutine => 'Usa routine mattutina';

  @override
  String get gentlePreAlert => 'Preavviso delicato';

  @override
  String get backupAlarm => 'Sveglia di riserva';

  @override
  String get backupAlarmSubtitle =>
      'Suona di nuovo se la prima sveglia non viene spenta';

  @override
  String get appearance => 'Aspetto';

  @override
  String get systemTheme => 'Usa tema di sistema';

  @override
  String get darkTheme => 'Tema scuro';

  @override
  String get lightTheme => 'Tema chiaro';

  @override
  String get changeSystemTime => 'Cambia ora di sistema';

  @override
  String get changeSystemTimeSubtitle =>
      'Apre le impostazioni data e ora di Android';

  @override
  String get reliabilityCenterSubtitle =>
      'Controlla autorizzazioni, volume e restrizioni della batteria';

  @override
  String get exportBackup => 'Esporta backup';

  @override
  String get exportBackupSubtitle =>
      'Salva sveglie e impostazioni come file JSON';

  @override
  String get restoreBackup => 'Ripristina backup';

  @override
  String get restoreBackupSubtitle => 'Scegli un backup JSON Snoon';

  @override
  String get restoreBackupQuestion => 'Ripristinare il backup?';

  @override
  String get restoreBackupWarning =>
      'Le sveglie e le impostazioni attuali verranno sostituite.';

  @override
  String get chooseFile => 'Scegli file';

  @override
  String get backupSaved => 'Backup Snoon salvato.';

  @override
  String get backupRestored => 'Backup Snoon ripristinato.';

  @override
  String get backupCancelled => 'Operazione di backup annullata.';

  @override
  String get alarmRingtone => 'Suoneria sveglia';

  @override
  String get timerRingtone => 'Suoneria timer';

  @override
  String get alarmVolume => 'Volume sveglia';

  @override
  String get autoSilence => 'Silenzia automaticamente';

  @override
  String get increasingVolume => 'Volume crescente';

  @override
  String get increasingVolumeSubtitle =>
      'Il volume aumenta gradualmente nei primi 30 secondi';

  @override
  String get snooze => 'Posticipa';

  @override
  String get maximumSnoozes => 'Numero massimo di rinvii';

  @override
  String get volumeButtons => 'Tasti volume';

  @override
  String get volumeChange => 'Cambia volume';

  @override
  String get snoozeAlarm => 'Posticipa sveglia';

  @override
  String get dismissAlarm => 'Spegni sveglia';

  @override
  String get notifyBeforeRinging => 'Avvisa prima della suoneria';

  @override
  String get showOnLockScreen => 'Mostra sveglie nella schermata di blocco';

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String minutesBefore(int count) {
    return '$count min prima';
  }

  @override
  String minutesAfter(int count) {
    return '$count min dopo';
  }

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volte',
      one: '1 volta',
    );
    return '$_temp0';
  }

  @override
  String maximumTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fino a $count volte',
      one: 'Fino a 1 volta',
    );
    return '$_temp0';
  }

  @override
  String alarmsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sveglie',
      one: '1 sveglia',
    );
    return '$_temp0';
  }

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selezionate',
      one: '1 selezionata',
    );
    return '$_temp0';
  }

  @override
  String get alarmsDeleteQuestion => 'Eliminare le sveglie?';

  @override
  String alarmsDeleteMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sveglie verranno eliminate definitivamente.',
      one: '1 sveglia verrà eliminata definitivamente.',
    );
    return '$_temp0';
  }

  @override
  String get pauseUntilDate => 'Metti in pausa fino a una data';

  @override
  String get shiftToday => 'Sposta oggi';

  @override
  String get pauseDateHelp => 'FINO A QUANDO METTERE IN PAUSA LE SVEGLIE?';

  @override
  String pauseSuccess(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sveglie in pausa fino al $date.',
      one: '1 sveglia in pausa fino al $date.',
    );
    return '$_temp0';
  }

  @override
  String get shiftTodayTitle => 'Sposta le sveglie di oggi';

  @override
  String get shiftTodaySubtitle =>
      'Il programma regolare resta invariato; cambiano solo gli orari di oggi.';

  @override
  String shiftSuccess(int count, int minutes, String direction) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sveglie spostate di $minutes minuti $direction oggi.',
      one: '1 sveglia spostata di $minutes minuti $direction oggi.',
    );
    return '$_temp0';
  }

  @override
  String get forward => 'in avanti';

  @override
  String get backward => 'indietro';

  @override
  String get nextAlarm => 'Prossima sveglia';

  @override
  String get once => 'Una volta';

  @override
  String get everyDay => 'Ogni giorno';

  @override
  String get weekdays => 'Giorni feriali';

  @override
  String get weekend => 'Fine settimana';

  @override
  String intervalEvery(int count) {
    return 'ogni $count min';
  }

  @override
  String get paused => 'In pausa';

  @override
  String todayOffset(int count) {
    return '$count min oggi';
  }

  @override
  String get noHistory => 'Nessuna cronologia sveglie';

  @override
  String get clearHistory => 'Cancella cronologia';

  @override
  String get worldClock => 'Orologio mondiale';

  @override
  String get searchCity => 'Cerca città';

  @override
  String get cityNotFound => 'Nessuna città trovata';

  @override
  String get customTimer => 'Timer personalizzato';

  @override
  String get hours => 'Ore';

  @override
  String get minutes => 'Minuti';

  @override
  String get seconds => 'Secondi';

  @override
  String hourShort(int count) {
    return '$count h';
  }

  @override
  String get invalidDuration => 'Inserisci una durata valida.';

  @override
  String get custom => 'Personalizzato';

  @override
  String get start => 'Avvia';

  @override
  String get pause => 'Pausa';

  @override
  String get reset => 'Azzera';

  @override
  String get lap => 'Giro';

  @override
  String lapNumber(int count) {
    return 'Giro $count';
  }

  @override
  String get sleepSchedule => 'Programma sonno';

  @override
  String get plannedSleepDuration => 'Durata del sonno pianificata';

  @override
  String get sleepReminderAndWakeAlarm => 'Promemoria per dormire e sveglia';

  @override
  String get scheduleDays => 'Giorni del programma';

  @override
  String get atLeastOneSleepDay =>
      'Almeno un giorno deve restare selezionato per il programma sonno.';

  @override
  String get sleepScheduleSubtitle =>
      'Ricevi un promemoria prima di dormire e mantieni regolare l\'orario di risveglio';

  @override
  String get bedtime => 'Ora di dormire';

  @override
  String get wakeTime => 'Ora del risveglio';

  @override
  String get windDownTime => 'Tempo di relax';

  @override
  String get windDownSubtitle => 'Viene inviata una notifica prima di dormire';

  @override
  String get addCity => 'Aggiungi città';

  @override
  String get tryDifferentCity => 'Prova un altro nome di città.';

  @override
  String get localTime => 'Ora locale';

  @override
  String localTimeDifference(int hours, int minutes, String direction) {
    return '$hours h $minutes min $direction rispetto all\'ora locale';
  }

  @override
  String get testAlarm => 'Sveglia di prova';

  @override
  String get testAlarmType => 'Tipo di sveglia di prova';

  @override
  String get dismissDirectly => 'Spegni direttamente la sveglia';

  @override
  String get verifyDismissTask => 'Verifica anche l\'attività di spegnimento';

  @override
  String get alarmsReady => 'Le sveglie sono pronte';

  @override
  String get checkPermissions => 'Controlla autorizzazioni';

  @override
  String get alarmsReadySubtitle =>
      'Le autorizzazioni per sveglie esatte e notifiche sono attive.';

  @override
  String get permissionsWarningSubtitle =>
      'Autorizzazioni mancanti possono far suonare una sveglia in ritardo o senza audio.';

  @override
  String get exactAlarmCheckSubtitle =>
      'Consente alla sveglia di attivarsi esattamente al secondo programmato.';

  @override
  String get grantPermission => 'Concedi autorizzazione';

  @override
  String manufacturerSettingsSubtitle(String manufacturer) {
    return 'Su $manufacturer, consenti l\'avvio automatico di Snoon e imposta uso in background e batteria su ‘Senza restrizioni’.';
  }

  @override
  String get appSettings => 'Impostazioni app';

  @override
  String get notificationCheckSubtitle =>
      'Necessario per i preavvisi e le sveglie nella schermata di blocco.';

  @override
  String get fullScreenCheckSubtitle =>
      'Mostra i controlli nella schermata di blocco e sopra le altre app.';

  @override
  String get alarmSoundLevel => 'Livello suono sveglia';

  @override
  String get alarmSoundAudible => 'Il canale sveglia Android è udibile.';

  @override
  String get alarmSoundMuted =>
      'Il suono di sistema è disattivato. Snoon lo alzerà al livello configurato mentre suona.';

  @override
  String get soundSettings => 'Impostazioni audio';

  @override
  String get batteryUnrestricted =>
      'L\'app non è soggetta a restrizioni della batteria.';

  @override
  String get batteryMayDelay =>
      'Alcuni telefoni possono ritardare le sveglie in background.';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get runTenSecondTest => 'Avvia sveglia di prova di 10 secondi';

  @override
  String get refreshChecks => 'Aggiorna controlli';

  @override
  String get notificationPermission => 'Autorizzazione notifiche';

  @override
  String get batteryOptimization => 'Ottimizzazione batteria';

  @override
  String get manufacturerBackgroundSettings =>
      'Impostazioni in background del produttore';

  @override
  String testScheduled(String task) {
    return 'La sveglia di prova suonerà tra 10 secondi • $task';
  }

  @override
  String get sameStartEndError =>
      'L\'ora di inizio e fine non possono coincidere.';
}
