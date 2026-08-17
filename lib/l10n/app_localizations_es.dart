// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Snoon';

  @override
  String get languageTitle => 'Elige tu idioma';

  @override
  String get languageSubtitle => 'Puedes cambiarlo más tarde en Ajustes.';

  @override
  String get languageContinue => 'Continuar';

  @override
  String get languageRecommended => 'Idioma del dispositivo';

  @override
  String get languageSetting => 'Idioma de la aplicación';

  @override
  String get languageSettingSubtitle =>
      'Cambia el idioma de la interfaz y las alarmas';

  @override
  String get languageChanged => 'Idioma cambiado';

  @override
  String get turkish => 'Turco';

  @override
  String get english => 'Inglés';

  @override
  String get german => 'Alemán';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Portugués';

  @override
  String get alarm => 'Alarma';

  @override
  String get world => 'Mundo';

  @override
  String get stopwatch => 'Cronómetro';

  @override
  String get timer => 'Temporizador';

  @override
  String get sleep => 'Sueño';

  @override
  String get settings => 'Ajustes';

  @override
  String get general => 'General';

  @override
  String get backup => 'Copia de seguridad';

  @override
  String get sounds => 'Sonidos';

  @override
  String get extraAlarmSettings => 'Ajustes adicionales de alarma';

  @override
  String get off => 'Desactivado';

  @override
  String get ringtonePickerFailed => 'No se pudo abrir el selector de tonos.';

  @override
  String get backupSaveFailed => 'No se pudo guardar el archivo de copia.';

  @override
  String get backupReadFailed => 'No se pudo leer el archivo de copia.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get apply => 'Aplicar';

  @override
  String get clear => 'Limpiar';

  @override
  String get later => 'Más tarde';

  @override
  String get openSetting => 'Abrir ajuste';

  @override
  String get exactAlarmPermission => 'Permiso de alarmas exactas';

  @override
  String get exactAlarmPermissionMessage =>
      'Snoon necesita el permiso de Android ‘Alarmas y recordatorios’ para sonar exactamente a la hora configurada.';

  @override
  String get fullScreenPermission => 'Permiso de alarma a pantalla completa';

  @override
  String get fullScreenPermissionMessage =>
      'Activa las notificaciones a pantalla completa para controlar la alarma desde la pantalla de bloqueo.';

  @override
  String get alarmGroups => 'Grupos de alarmas';

  @override
  String get groupsIntro =>
      'Pausa un grupo durante las vacaciones, omite fechas concretas o desplaza todas las horas de hoy a la vez.';

  @override
  String get addGroup => 'Añadir grupo';

  @override
  String get newGroup => 'Nuevo grupo';

  @override
  String get editGroup => 'Editar grupo';

  @override
  String get groupName => 'Nombre del grupo';

  @override
  String get groupNameRequired => 'Escribe un nombre para el grupo.';

  @override
  String pausedUntil(String date) {
    return 'Pausado hasta $date';
  }

  @override
  String exceptionDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días de excepción',
      one: '1 día de excepción',
    );
    return '$_temp0';
  }

  @override
  String get vacationMode => 'Modo vacaciones';

  @override
  String get notSet => 'Sin configurar';

  @override
  String get exceptionCalendar => 'Calendario de excepciones';

  @override
  String get exceptionCalendarSubtitle =>
      'Ninguna alarma del grupo sonará en estas fechas.';

  @override
  String get noExceptionDates => 'Aún no hay fechas de excepción.';

  @override
  String get addDate => 'Añadir fecha';

  @override
  String get bulkShiftToday => 'Desplazamiento conjunto de hoy';

  @override
  String get todayGroupTimes => 'Horas del grupo de hoy';

  @override
  String get scheduleUnchanged => 'El horario permanente no cambia';

  @override
  String get noChange => 'Sin cambios';

  @override
  String get deleteGroup => 'Eliminar grupo';

  @override
  String get alarmHistory => 'Historial de alarmas';

  @override
  String get historyEmptySubtitle =>
      'Aquí aparecen las alarmas que sonaron, se pospusieron, se apagaron o se silenciaron automáticamente.';

  @override
  String get actionRang => 'Sonó';

  @override
  String get actionSnoozed => 'Pospuesta';

  @override
  String get actionSnoozeCancelled => 'Repetición cancelada';

  @override
  String get actionDismissed => 'Apagada';

  @override
  String get actionAutoSilenced => 'Silenciada automáticamente';

  @override
  String get reliabilityCenter => 'Centro de fiabilidad';

  @override
  String get createFirstAlarm => 'Crea tu primera alarma';

  @override
  String get createFirstAlarmSubtitle =>
      'Usa el botón + para una alarma o una serie por intervalos.';

  @override
  String get noActiveAlarm => 'No hay alarmas activas';

  @override
  String get newAlarm => 'Nueva alarma';

  @override
  String get editAlarm => 'Editar alarma';

  @override
  String get specificTimeRange => 'Intervalo de tiempo';

  @override
  String get specificTimeRangeSubtitle =>
      'Crea varias alarmas automáticamente entre dos horas';

  @override
  String get rangeNextDay => 'La hora final se aplicará al día siguiente.';

  @override
  String get repeat => 'Repetir';

  @override
  String get alarmInformation => 'Información de la alarma';

  @override
  String get beforeDismiss => 'Antes de apagar';

  @override
  String get morningRoutine => 'Rutina matutina';

  @override
  String get rangeMorningUnavailable =>
      'No disponible para alarmas por intervalos porque las alarmas de respaldo se solaparían';

  @override
  String get disabledByDefault => 'Desactivado por defecto';

  @override
  String get endTime => 'Hora de fin';

  @override
  String get ringInterval => 'Intervalo';

  @override
  String get label => 'Etiqueta';

  @override
  String get labelHint => 'p. ej., Prepararse para el trabajo';

  @override
  String get alarmGroup => 'Grupo de alarmas';

  @override
  String get noGroup => 'Sin grupo';

  @override
  String get ringtone => 'Tono';

  @override
  String get vibrateWhenRinging => 'Vibrar al sonar';

  @override
  String get deleteAfterRinging => 'Eliminar después de sonar';

  @override
  String get oneTimeAlarmOnly => 'Para alarmas de una sola vez';

  @override
  String get dismissTask => 'Tarea para apagar';

  @override
  String get noTask => 'Sin tarea';

  @override
  String get mathTask => 'Problema matemático';

  @override
  String get shakeTask => 'Agitar el teléfono 5 veces';

  @override
  String get useMorningRoutine => 'Usar rutina matutina';

  @override
  String get gentlePreAlert => 'Aviso previo suave';

  @override
  String get backupAlarm => 'Alarma de respaldo';

  @override
  String get backupAlarmSubtitle =>
      'Vuelve a sonar si no se apaga la primera alarma';

  @override
  String get appearance => 'Apariencia';

  @override
  String get systemTheme => 'Usar tema del sistema';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get changeSystemTime => 'Cambiar hora del sistema';

  @override
  String get changeSystemTimeSubtitle =>
      'Abre los ajustes de fecha y hora de Android';

  @override
  String get reliabilityCenterSubtitle =>
      'Comprueba permisos, volumen de alarma y restricciones de batería';

  @override
  String get exportBackup => 'Exportar copia';

  @override
  String get exportBackupSubtitle =>
      'Guardar alarmas y ajustes como archivo JSON';

  @override
  String get restoreBackup => 'Restaurar copia';

  @override
  String get restoreBackupSubtitle => 'Elegir una copia JSON de Snoon';

  @override
  String get restoreBackupQuestion => '¿Restaurar copia?';

  @override
  String get restoreBackupWarning =>
      'Las alarmas y ajustes actuales serán reemplazados.';

  @override
  String get chooseFile => 'Elegir archivo';

  @override
  String get backupSaved => 'Copia de Snoon guardada.';

  @override
  String get backupRestored => 'Copia de Snoon restaurada.';

  @override
  String get backupCancelled => 'Operación de copia cancelada.';

  @override
  String get alarmRingtone => 'Tono de alarma';

  @override
  String get timerRingtone => 'Tono del temporizador';

  @override
  String get alarmVolume => 'Volumen de alarma';

  @override
  String get autoSilence => 'Silencio automático';

  @override
  String get increasingVolume => 'Volumen gradual';

  @override
  String get increasingVolumeSubtitle =>
      'El volumen aumenta gradualmente durante los primeros 30 segundos';

  @override
  String get snooze => 'Posponer';

  @override
  String get maximumSnoozes => 'Máximo de repeticiones';

  @override
  String get volumeButtons => 'Botones de volumen';

  @override
  String get volumeChange => 'Cambiar volumen';

  @override
  String get snoozeAlarm => 'Posponer alarma';

  @override
  String get dismissAlarm => 'Apagar alarma';

  @override
  String get notifyBeforeRinging => 'Avisar antes de sonar';

  @override
  String get showOnLockScreen => 'Mostrar alarmas en la pantalla de bloqueo';

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
    return '$count min después';
  }

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veces',
      one: '1 vez',
    );
    return '$_temp0';
  }

  @override
  String maximumTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hasta $count veces',
      one: 'Hasta 1 vez',
    );
    return '$_temp0';
  }

  @override
  String alarmsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmas',
      one: '1 alarma',
    );
    return '$_temp0';
  }

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionadas',
      one: '1 seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get alarmsDeleteQuestion => '¿Eliminar alarmas?';

  @override
  String alarmsDeleteMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se eliminarán permanentemente $count alarmas.',
      one: 'Se eliminará permanentemente 1 alarma.',
    );
    return '$_temp0';
  }

  @override
  String get pauseUntilDate => 'Pausar hasta una fecha';

  @override
  String get shiftToday => 'Desplazar hoy';

  @override
  String get pauseDateHelp => '¿HASTA CUÁNDO PAUSAR LAS ALARMAS?';

  @override
  String pauseSuccess(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmas pausadas hasta $date.',
      one: '1 alarma pausada hasta $date.',
    );
    return '$_temp0';
  }

  @override
  String get shiftTodayTitle => 'Desplazar las alarmas de hoy';

  @override
  String get shiftTodaySubtitle =>
      'El horario habitual no cambia; solo se modifican las horas de hoy.';

  @override
  String shiftSuccess(int count, int minutes, String direction) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmas movidas $minutes minutos hacia $direction hoy.',
      one: '1 alarma movida $minutes minutos hacia $direction hoy.',
    );
    return '$_temp0';
  }

  @override
  String get forward => 'adelante';

  @override
  String get backward => 'atrás';

  @override
  String get nextAlarm => 'Próxima alarma';

  @override
  String get once => 'Una vez';

  @override
  String get everyDay => 'Todos los días';

  @override
  String get weekdays => 'Entre semana';

  @override
  String get weekend => 'Fin de semana';

  @override
  String intervalEvery(int count) {
    return 'cada $count min';
  }

  @override
  String get paused => 'Pausada';

  @override
  String todayOffset(int count) {
    return '$count min hoy';
  }

  @override
  String get noHistory => 'Aún no hay historial de alarmas';

  @override
  String get clearHistory => 'Borrar historial';

  @override
  String get worldClock => 'Reloj mundial';

  @override
  String get searchCity => 'Buscar ciudad';

  @override
  String get cityNotFound => 'No se encontró ninguna ciudad';

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
  String get invalidDuration => 'Introduce una duración válida.';

  @override
  String get custom => 'Personalizado';

  @override
  String get start => 'Iniciar';

  @override
  String get pause => 'Pausar';

  @override
  String get reset => 'Restablecer';

  @override
  String get lap => 'Vuelta';

  @override
  String lapNumber(int count) {
    return 'Vuelta $count';
  }

  @override
  String get sleepSchedule => 'Horario de sueño';

  @override
  String get plannedSleepDuration => 'Duración de sueño prevista';

  @override
  String get sleepReminderAndWakeAlarm =>
      'Recordatorio para dormir y alarma de despertar';

  @override
  String get scheduleDays => 'Días del horario';

  @override
  String get atLeastOneSleepDay =>
      'Debe quedar seleccionado al menos un día para el horario de sueño.';

  @override
  String get sleepScheduleSubtitle =>
      'Recibe un aviso antes de dormir y mantén una hora de despertar constante';

  @override
  String get bedtime => 'Hora de dormir';

  @override
  String get wakeTime => 'Hora de despertar';

  @override
  String get windDownTime => 'Tiempo de relajación';

  @override
  String get windDownSubtitle => 'Se envía una notificación antes de dormir';

  @override
  String get addCity => 'Añadir ciudad';

  @override
  String get tryDifferentCity => 'Prueba con otro nombre de ciudad.';

  @override
  String get localTime => 'Hora local';

  @override
  String localTimeDifference(int hours, int minutes, String direction) {
    return '$hours h $minutes min por $direction de la hora local';
  }

  @override
  String get testAlarm => 'Alarma de prueba';

  @override
  String get testAlarmType => 'Tipo de alarma de prueba';

  @override
  String get dismissDirectly => 'Apagar la alarma directamente';

  @override
  String get verifyDismissTask => 'Comprobar también la tarea para apagar';

  @override
  String get alarmsReady => 'Las alarmas están listas';

  @override
  String get checkPermissions => 'Comprobar permisos';

  @override
  String get alarmsReadySubtitle =>
      'Los permisos de alarmas exactas y notificaciones están activos.';

  @override
  String get permissionsWarningSubtitle =>
      'La falta de permisos puede hacer que una alarma suene tarde o sin sonido.';

  @override
  String get exactAlarmCheckSubtitle =>
      'Permite que la alarma se ejecute en el segundo exacto programado.';

  @override
  String get grantPermission => 'Conceder permiso';

  @override
  String manufacturerSettingsSubtitle(String manufacturer) {
    return 'En $manufacturer, permite el inicio automático de Snoon y configura el uso en segundo plano y de batería como ‘Sin restricciones’.';
  }

  @override
  String get appSettings => 'Ajustes de la aplicación';

  @override
  String get notificationCheckSubtitle =>
      'Necesario para avisos previos y alarmas en la pantalla de bloqueo.';

  @override
  String get fullScreenCheckSubtitle =>
      'Muestra los controles de alarma en la pantalla de bloqueo y sobre otras aplicaciones.';

  @override
  String get alarmSoundLevel => 'Nivel de sonido de alarma';

  @override
  String get alarmSoundAudible => 'El canal de alarma de Android es audible.';

  @override
  String get alarmSoundMuted =>
      'El sonido de alarma del sistema está silenciado. Snoon lo subirá al nivel configurado mientras suena.';

  @override
  String get soundSettings => 'Ajustes de sonido';

  @override
  String get batteryUnrestricted =>
      'La aplicación no está afectada por restricciones de batería.';

  @override
  String get batteryMayDelay =>
      'Algunos teléfonos pueden retrasar las alarmas en segundo plano.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get runTenSecondTest => 'Iniciar alarma de prueba de 10 segundos';

  @override
  String get refreshChecks => 'Actualizar comprobaciones';

  @override
  String get notificationPermission => 'Permiso de notificaciones';

  @override
  String get batteryOptimization => 'Optimización de batería';

  @override
  String get manufacturerBackgroundSettings =>
      'Ajustes de segundo plano del fabricante';

  @override
  String testScheduled(String task) {
    return 'La alarma de prueba sonará en 10 segundos • $task';
  }

  @override
  String get sameStartEndError =>
      'La hora de inicio y fin no pueden ser iguales.';
}
