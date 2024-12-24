// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';

import 'l10n/app_localizations.dart';
import 'l10n/app_localizations_delegate.dart';
import 'providers/providers.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Встановлюємо мінімальні розміри вікна
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    setWindowMinSize(const Size(600, 800));
    setWindowTitle('Stock Market Quotes (Test App)');
  }

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        localizationProvider.overrideWith(
          (ref) => AppLocalizations(const Locale('uk')),
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final l10n = ref.watch(localizationProvider);
          return MaterialApp(
            title: l10n.windowTitle,
            theme: ThemeData(
              colorScheme: ColorScheme.dark(
                primary: Colors.blue.shade300,
                secondary: Colors.tealAccent,
                surface: const Color(0xFF1E1E1E),
                background: const Color(0xFF121212),
                error: Colors.redAccent,
              ),
              cardTheme: CardTheme(
                color: const Color(0xFF1E1E1E),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1E1E1E),
                elevation: 0,
                centerTitle: true,
              ),
              scaffoldBackgroundColor: const Color(0xFF121212),
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('uk'),
              Locale('en'),
            ],
            debugShowCheckedModeBanner: false,
            home: LayoutBuilder(
              builder: (context, constraints) => HomeScreen(
                windowTitle: l10n.windowTitle,
                constraints: constraints,
              ),
            ),
          );
        },
      ),
    );
  }
}
