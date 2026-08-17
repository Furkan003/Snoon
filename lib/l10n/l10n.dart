import 'package:flutter/widgets.dart';

import 'app_localizations.dart';
import '../models/alarm_models.dart';

extension SnoonLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String languageNativeName(String code) => switch (code) {
  'tr' => 'Türkçe',
  'en' => 'English',
  'de' => 'Deutsch',
  'es' => 'Español',
  'fr' => 'Français',
  'it' => 'Italiano',
  'pt' => 'Português',
  _ => code.toUpperCase(),
};

String localizedWorkGroupName(String code) => switch (code) {
  'tr' => 'İş',
  'de' => 'Arbeit',
  'es' => 'Trabajo',
  'fr' => 'Travail',
  'it' => 'Lavoro',
  'pt' => 'Trabalho',
  _ => 'Work',
};

String localizedPersonalGroupName(String code) => switch (code) {
  'tr' => 'Kişisel',
  'de' => 'Persönlich',
  'es' => 'Personal',
  'fr' => 'Personnel',
  'it' => 'Personale',
  'pt' => 'Pessoal',
  _ => 'Personal',
};

String localizedSleepScheduleName(String code) => switch (code) {
  'tr' => 'Uyku programı',
  'de' => 'Schlafplan',
  'es' => 'Horario de sueño',
  'fr' => 'Programme de sommeil',
  'it' => 'Programma sonno',
  'pt' => 'Horário de sono',
  _ => 'Sleep schedule',
};

String localizedSleepReminderName(String code) => switch (code) {
  'tr' => 'Uykuya hazırlanma zamanı',
  'de' => 'Zeit, sich auf den Schlaf vorzubereiten',
  'es' => 'Hora de prepararse para dormir',
  'fr' => 'Il est temps de se préparer à dormir',
  'it' => 'È ora di prepararsi per dormire',
  'pt' => 'Hora de se preparar para dormir',
  _ => 'Time to prepare for sleep',
};

String localizedThemeLabel(AppLocalizations l10n, SnoonThemeMode mode) =>
    switch (mode) {
      SnoonThemeMode.system => l10n.systemTheme,
      SnoonThemeMode.dark => l10n.darkTheme,
      SnoonThemeMode.light => l10n.lightTheme,
    };

String localizedVolumeButtonLabel(
  AppLocalizations l10n,
  VolumeButtonAction action,
) => switch (action) {
  VolumeButtonAction.volume => l10n.volumeChange,
  VolumeButtonAction.snooze => l10n.snoozeAlarm,
  VolumeButtonAction.dismiss => l10n.dismissAlarm,
};

String localizedDismissTaskLabel(AppLocalizations l10n, DismissTask task) =>
    switch (task) {
      DismissTask.none => l10n.noTask,
      DismissTask.math => l10n.mathTask,
      DismissTask.shake => l10n.shakeTask,
    };
