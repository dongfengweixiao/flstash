import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../app_config.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../settings/settings_model.dart';
import 'router.dart';

class FlstashApp extends StatefulWidget {
  const FlstashApp({super.key});

  @override
  State<FlstashApp> createState() => _FlstashAppState();
}

class _FlstashAppState extends State<FlstashApp> {
  late final Future<void> _allReady;

  @override
  void initState() {
    super.initState();
    _allReady = di.allReady();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allReady,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: snapshot.hasError
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text('${snapshot.error}'),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          );
        }
        return const FlstashMaterialApp();
      },
    );
  }
}

class FlstashMaterialApp extends StatelessWidget with WatchItMixin {
  const FlstashMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeIndex = watchPropertyValue((SettingsModel m) => m.themeIndex);
    final useCustom =
        watchPropertyValue((SettingsModel m) => m.useCustomThemeColor);
    final customColor =
        watchPropertyValue((SettingsModel m) => m.customThemeColor);

    final accent = (useCustom && customColor != null)
        ? Color(customColor)
        : kFlstashDefaultColor;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appTitle,
      themeMode: ThemeMode.values[themeIndex],
      theme: _buildTheme(accent, Brightness.light),
      darkTheme: _buildTheme(accent, Brightness.dark),
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }

  ThemeData _buildTheme(Color accent, Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: brightness,
      ),
      useMaterial3: true,
    );
  }
}
