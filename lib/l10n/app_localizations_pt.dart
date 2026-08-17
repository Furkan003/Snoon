// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Snoon';

  @override
  String get languageTitle => 'Escolha o seu idioma';

  @override
  String get languageSubtitle => 'Pode alterá-lo mais tarde nas Definições.';

  @override
  String get languageContinue => 'Continuar';

  @override
  String get languageRecommended => 'Idioma do dispositivo';

  @override
  String get languageSetting => 'Idioma da aplicação';

  @override
  String get languageSettingSubtitle =>
      'Altere o idioma da interface e dos alarmes';

  @override
  String get languageChanged => 'Idioma alterado';

  @override
  String get turkish => 'Turco';

  @override
  String get english => 'Inglês';

  @override
  String get german => 'Alemão';

  @override
  String get spanish => 'Espanhol';

  @override
  String get french => 'Francês';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Português';

  @override
  String get alarm => 'Alarme';

  @override
  String get world => 'Mundo';

  @override
  String get stopwatch => 'Cronómetro';

  @override
  String get timer => 'Temporizador';

  @override
  String get sleep => 'Sono';

  @override
  String get settings => 'Definições';

  @override
  String get general => 'Geral';

  @override
  String get backup => 'Cópia de segurança';

  @override
  String get sounds => 'Sons';

  @override
  String get extraAlarmSettings => 'Definições adicionais de alarme';

  @override
  String get off => 'Desativado';

  @override
  String get ringtonePickerFailed =>
      'Não foi possível abrir o seletor de toques.';

  @override
  String get backupSaveFailed =>
      'Não foi possível guardar o ficheiro de cópia.';

  @override
  String get backupReadFailed => 'Não foi possível ler o ficheiro de cópia.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get apply => 'Aplicar';

  @override
  String get clear => 'Limpar';

  @override
  String get later => 'Mais tarde';

  @override
  String get openSetting => 'Abrir definição';

  @override
  String get exactAlarmPermission => 'Permissão de alarmes exatos';

  @override
  String get exactAlarmPermissionMessage =>
      'O Snoon precisa da permissão Android ‘Alarmes e lembretes’ para tocar exatamente à hora definida.';

  @override
  String get fullScreenPermission => 'Permissão de alarme em ecrã inteiro';

  @override
  String get fullScreenPermissionMessage =>
      'Ative as notificações em ecrã inteiro para gerir o alarme no ecrã de bloqueio.';

  @override
  String get alarmGroups => 'Grupos de alarmes';

  @override
  String get groupsIntro =>
      'Pause um grupo durante as férias, ignore datas específicas ou desloque em conjunto todos os horários de hoje.';

  @override
  String get addGroup => 'Adicionar grupo';

  @override
  String get newGroup => 'Novo grupo';

  @override
  String get editGroup => 'Editar grupo';

  @override
  String get groupName => 'Nome do grupo';

  @override
  String get groupNameRequired => 'Introduza um nome para o grupo.';

  @override
  String pausedUntil(String date) {
    return 'Pausado até $date';
  }

  @override
  String exceptionDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias de exceção',
      one: '1 dia de exceção',
    );
    return '$_temp0';
  }

  @override
  String get vacationMode => 'Modo de férias';

  @override
  String get notSet => 'Não definido';

  @override
  String get exceptionCalendar => 'Calendário de exceções';

  @override
  String get exceptionCalendarSubtitle =>
      'Nenhum alarme do grupo tocará nestas datas.';

  @override
  String get noExceptionDates => 'Ainda não existem datas de exceção.';

  @override
  String get addDate => 'Adicionar data';

  @override
  String get bulkShiftToday => 'Deslocamento conjunto de hoje';

  @override
  String get todayGroupTimes => 'Horários do grupo de hoje';

  @override
  String get scheduleUnchanged => 'O horário permanente mantém-se inalterado';

  @override
  String get noChange => 'Sem alteração';

  @override
  String get deleteGroup => 'Eliminar grupo';

  @override
  String get alarmHistory => 'Histórico de alarmes';

  @override
  String get historyEmptySubtitle =>
      'Os alarmes que tocaram, foram adiados, desligados ou silenciados automaticamente aparecem aqui.';

  @override
  String get actionRang => 'Tocou';

  @override
  String get actionSnoozed => 'Adiado';

  @override
  String get actionSnoozeCancelled => 'Adiamento cancelado';

  @override
  String get actionDismissed => 'Desligado';

  @override
  String get actionAutoSilenced => 'Silenciado automaticamente';

  @override
  String get reliabilityCenter => 'Centro de fiabilidade';

  @override
  String get createFirstAlarm => 'Crie o primeiro alarme';

  @override
  String get createFirstAlarmSubtitle =>
      'Use o botão + para um alarme ou uma série por intervalos.';

  @override
  String get noActiveAlarm => 'Nenhum alarme ativo';

  @override
  String get newAlarm => 'Novo alarme';

  @override
  String get editAlarm => 'Editar alarme';

  @override
  String get specificTimeRange => 'Intervalo de tempo';

  @override
  String get specificTimeRangeSubtitle =>
      'Crie automaticamente vários alarmes entre duas horas';

  @override
  String get rangeNextDay => 'A hora de fim será aplicada ao dia seguinte.';

  @override
  String get repeat => 'Repetir';

  @override
  String get alarmInformation => 'Informações do alarme';

  @override
  String get beforeDismiss => 'Antes de desligar';

  @override
  String get morningRoutine => 'Rotina matinal';

  @override
  String get rangeMorningUnavailable =>
      'Indisponível para alarmes por intervalo porque os alarmes de reserva se sobreporiam';

  @override
  String get disabledByDefault => 'Desativado por predefinição';

  @override
  String get endTime => 'Hora de fim';

  @override
  String get ringInterval => 'Intervalo';

  @override
  String get label => 'Etiqueta';

  @override
  String get labelHint => 'ex.: Preparar para o trabalho';

  @override
  String get alarmGroup => 'Grupo de alarmes';

  @override
  String get noGroup => 'Sem grupo';

  @override
  String get ringtone => 'Toque';

  @override
  String get vibrateWhenRinging => 'Vibrar ao tocar';

  @override
  String get deleteAfterRinging => 'Eliminar depois de tocar';

  @override
  String get oneTimeAlarmOnly => 'Para alarmes únicos';

  @override
  String get dismissTask => 'Tarefa para desligar';

  @override
  String get noTask => 'Sem tarefa';

  @override
  String get mathTask => 'Problema de matemática';

  @override
  String get shakeTask => 'Agitar o telefone 5 vezes';

  @override
  String get useMorningRoutine => 'Usar rotina matinal';

  @override
  String get gentlePreAlert => 'Pré-aviso suave';

  @override
  String get backupAlarm => 'Alarme de reserva';

  @override
  String get backupAlarmSubtitle =>
      'Toca novamente se o primeiro alarme não for desligado';

  @override
  String get appearance => 'Aspeto';

  @override
  String get systemTheme => 'Usar tema do sistema';

  @override
  String get darkTheme => 'Tema escuro';

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get changeSystemTime => 'Alterar hora do sistema';

  @override
  String get changeSystemTimeSubtitle =>
      'Abre as definições de data e hora do Android';

  @override
  String get reliabilityCenterSubtitle =>
      'Verifique permissões, volume do alarme e restrições da bateria';

  @override
  String get exportBackup => 'Exportar cópia';

  @override
  String get exportBackupSubtitle =>
      'Guardar alarmes e definições num ficheiro JSON';

  @override
  String get restoreBackup => 'Restaurar cópia';

  @override
  String get restoreBackupSubtitle => 'Escolher uma cópia JSON do Snoon';

  @override
  String get restoreBackupQuestion => 'Restaurar cópia?';

  @override
  String get restoreBackupWarning =>
      'Os alarmes e definições atuais serão substituídos.';

  @override
  String get chooseFile => 'Escolher ficheiro';

  @override
  String get backupSaved => 'Cópia Snoon guardada.';

  @override
  String get backupRestored => 'Cópia Snoon restaurada.';

  @override
  String get backupCancelled => 'Operação de cópia cancelada.';

  @override
  String get alarmRingtone => 'Toque do alarme';

  @override
  String get timerRingtone => 'Toque do temporizador';

  @override
  String get alarmVolume => 'Volume do alarme';

  @override
  String get autoSilence => 'Silenciar automaticamente';

  @override
  String get increasingVolume => 'Volume crescente';

  @override
  String get increasingVolumeSubtitle =>
      'O volume aumenta gradualmente durante os primeiros 30 segundos';

  @override
  String get snooze => 'Adiar';

  @override
  String get maximumSnoozes => 'Máximo de adiamentos';

  @override
  String get volumeButtons => 'Botões de volume';

  @override
  String get volumeChange => 'Alterar volume';

  @override
  String get snoozeAlarm => 'Adiar alarme';

  @override
  String get dismissAlarm => 'Desligar alarme';

  @override
  String get notifyBeforeRinging => 'Notificar antes de tocar';

  @override
  String get showOnLockScreen => 'Mostrar alarmes no ecrã de bloqueio';

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String minutesBefore(int count) {
    return '$count min antes';
  }

  @override
  String minutesAfter(int count) {
    return '$count min depois';
  }

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vezes',
      one: '1 vez',
    );
    return '$_temp0';
  }

  @override
  String maximumTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Até $count vezes',
      one: 'Até 1 vez',
    );
    return '$_temp0';
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
      other: '$count selecionados',
      one: '1 selecionado',
    );
    return '$_temp0';
  }

  @override
  String get alarmsDeleteQuestion => 'Eliminar alarmes?';

  @override
  String alarmsDeleteMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmes serão eliminados permanentemente.',
      one: '1 alarme será eliminado permanentemente.',
    );
    return '$_temp0';
  }

  @override
  String get pauseUntilDate => 'Pausar até uma data';

  @override
  String get shiftToday => 'Deslocar hoje';

  @override
  String get pauseDateHelp => 'ATÉ QUANDO PAUSAR OS ALARMES?';

  @override
  String pauseSuccess(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmes pausados até $date.',
      one: '1 alarme pausado até $date.',
    );
    return '$_temp0';
  }

  @override
  String get shiftTodayTitle => 'Deslocar os alarmes de hoje';

  @override
  String get shiftTodaySubtitle =>
      'O horário habitual mantém-se; apenas os horários de hoje são afetados.';

  @override
  String shiftSuccess(int count, int minutes, String direction) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmes deslocados $minutes minutos para $direction hoje.',
      one: '1 alarme deslocado $minutes minutos para $direction hoje.',
    );
    return '$_temp0';
  }

  @override
  String get forward => 'a frente';

  @override
  String get backward => 'trás';

  @override
  String get nextAlarm => 'Próximo alarme';

  @override
  String get once => 'Uma vez';

  @override
  String get everyDay => 'Todos os dias';

  @override
  String get weekdays => 'Dias úteis';

  @override
  String get weekend => 'Fim de semana';

  @override
  String intervalEvery(int count) {
    return 'a cada $count min';
  }

  @override
  String get paused => 'Pausado';

  @override
  String todayOffset(int count) {
    return '$count min hoje';
  }

  @override
  String get noHistory => 'Ainda não existe histórico de alarmes';

  @override
  String get clearHistory => 'Limpar histórico';

  @override
  String get worldClock => 'Relógio mundial';

  @override
  String get searchCity => 'Procurar cidade';

  @override
  String get cityNotFound => 'Nenhuma cidade encontrada';

  @override
  String get customTimer => 'Temporizador personalizado';

  @override
  String get hours => 'Horas';

  @override
  String get minutes => 'Minutos';

  @override
  String get seconds => 'Segundos';

  @override
  String hourShort(int count) {
    return '$count h';
  }

  @override
  String get invalidDuration => 'Introduza uma duração válida.';

  @override
  String get custom => 'Personalizado';

  @override
  String get start => 'Iniciar';

  @override
  String get pause => 'Pausa';

  @override
  String get reset => 'Repor';

  @override
  String get lap => 'Volta';

  @override
  String lapNumber(int count) {
    return 'Volta $count';
  }

  @override
  String get sleepSchedule => 'Horário de sono';

  @override
  String get plannedSleepDuration => 'Duração de sono planeada';

  @override
  String get sleepReminderAndWakeAlarm =>
      'Lembrete para dormir e alarme de despertar';

  @override
  String get scheduleDays => 'Dias do horário';

  @override
  String get atLeastOneSleepDay =>
      'Pelo menos um dia deve permanecer selecionado no horário de sono.';

  @override
  String get sleepScheduleSubtitle =>
      'Receba um lembrete antes de dormir e mantenha um horário regular para acordar';

  @override
  String get bedtime => 'Hora de dormir';

  @override
  String get wakeTime => 'Hora de acordar';

  @override
  String get windDownTime => 'Tempo de relaxamento';

  @override
  String get windDownSubtitle => 'É enviada uma notificação antes de dormir';

  @override
  String get addCity => 'Adicionar cidade';

  @override
  String get tryDifferentCity => 'Experimente outro nome de cidade.';

  @override
  String get localTime => 'Hora local';

  @override
  String localTimeDifference(int hours, int minutes, String direction) {
    return '$hours h $minutes min para $direction da hora local';
  }

  @override
  String get testAlarm => 'Alarme de teste';

  @override
  String get testAlarmType => 'Tipo de alarme de teste';

  @override
  String get dismissDirectly => 'Desligar diretamente o alarme';

  @override
  String get verifyDismissTask => 'Verificar também a tarefa de desligar';

  @override
  String get alarmsReady => 'Os alarmes estão prontos';

  @override
  String get checkPermissions => 'Verificar permissões';

  @override
  String get alarmsReadySubtitle =>
      'As permissões de alarmes exatos e notificações estão ativas.';

  @override
  String get permissionsWarningSubtitle =>
      'Permissões em falta podem fazer um alarme tocar atrasado ou sem som.';

  @override
  String get exactAlarmCheckSubtitle =>
      'Permite que o alarme seja executado no segundo exato programado.';

  @override
  String get grantPermission => 'Conceder permissão';

  @override
  String manufacturerSettingsSubtitle(String manufacturer) {
    return 'Em $manufacturer, permita o arranque automático do Snoon e defina o uso em segundo plano e de bateria como ‘Sem restrições’.';
  }

  @override
  String get appSettings => 'Definições da aplicação';

  @override
  String get notificationCheckSubtitle =>
      'Necessário para pré-avisos e alarmes no ecrã de bloqueio.';

  @override
  String get fullScreenCheckSubtitle =>
      'Mostra os controlos no ecrã de bloqueio e sobre outras aplicações.';

  @override
  String get alarmSoundLevel => 'Nível de som do alarme';

  @override
  String get alarmSoundAudible => 'O canal de alarme Android está audível.';

  @override
  String get alarmSoundMuted =>
      'O som de alarme do sistema está silenciado. O Snoon aumentará para o nível configurado enquanto toca.';

  @override
  String get soundSettings => 'Definições de som';

  @override
  String get batteryUnrestricted =>
      'A aplicação não é afetada por restrições de bateria.';

  @override
  String get batteryMayDelay =>
      'Alguns telefones podem atrasar alarmes em segundo plano.';

  @override
  String get openSettings => 'Abrir definições';

  @override
  String get runTenSecondTest => 'Iniciar alarme de teste de 10 segundos';

  @override
  String get refreshChecks => 'Atualizar verificações';

  @override
  String get notificationPermission => 'Permissão de notificações';

  @override
  String get batteryOptimization => 'Otimização da bateria';

  @override
  String get manufacturerBackgroundSettings =>
      'Definições de segundo plano do fabricante';

  @override
  String testScheduled(String task) {
    return 'O alarme de teste tocará dentro de 10 segundos • $task';
  }

  @override
  String get sameStartEndError =>
      'As horas de início e fim não podem ser iguais.';
}
