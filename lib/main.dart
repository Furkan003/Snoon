import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as timezone_data;

import 'models/alarm_models.dart';
import 'l10n/app_localizations.dart';
import 'screens/language_selection_page.dart';
import 'screens/home_shell.dart';
import 'services/app_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_data.initializeTimeZones();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0B10),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  final store = AppStore();
  await store.load();
  runApp(SnoonApp(store: store));
}

class SnoonApp extends StatelessWidget {
  const SnoonApp({super.key, required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        locale: Locale(store.localeCode),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        themeMode: switch (store.settings.themeMode) {
          SnoonThemeMode.system => ThemeMode.system,
          SnoonThemeMode.dark => ThemeMode.dark,
          SnoonThemeMode.light => ThemeMode.light,
        },
        builder: (context, child) {
          final dark = Theme.of(context).brightness == Brightness.dark;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: dark
                  ? Brightness.light
                  : Brightness.dark,
              systemNavigationBarColor: dark
                  ? const Color(0xFF0A0B10)
                  : const Color(0xFFF6F5FA),
              systemNavigationBarIconBrightness: dark
                  ? Brightness.light
                  : Brightness.dark,
            ),
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              bottom: true,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        home: store.languageSelected
            ? HomeShell(store: store)
            : LanguageSelectionPage(store: store),
      ),
    );
  }

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final primary = dark ? const Color(0xFFA78BFA) : const Color(0xFF6542B5);
    final background = dark ? const Color(0xFF0A0B10) : const Color(0xFFF6F5FA);
    final surface = dark ? const Color(0xFF15171F) : Colors.white;
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      surface: surface,
    );
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      fontFamily: 'Roboto',
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dark ? const Color(0xFF101119) : Colors.white,
        indicatorColor: primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? primary
                : scheme.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF1B1D27) : const Color(0xFFF0EDF7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: dark ? const Color(0xFF2A2C36) : const Color(0xFFE3DFEA),
        thickness: 1,
      ),
    );
  }
}
