import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:github/github.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app_model.dart';
import 'app_config.dart';
import 'settings/settings_model.dart';
import 'settings/settings_service.dart';
import 'settings/view/licenses_dialog.dart';

/// Registers all Services, ViewModels and external dependencies.
void registerDependencies() {
  if (AppConfig.windowManagerImplemented) {
    di.registerSingletonAsync<WindowManager>(() async {
      final wm = WindowManager.instance;
      await wm.ensureInitialized();
      await wm.waitUntilReadyToShow(
        const WindowOptions(
          backgroundColor: Colors.transparent,
          minimumSize: Size(800, 600),
          size: Size(1280, 800),
          skipTaskbar: false,
          titleBarStyle: TitleBarStyle.hidden,
          title: AppConfig.appTitle,
        ),
        () async {
          await windowManager.show();
          await windowManager.focus();
        },
      );
      return wm;
    });
  }

  di
    ..registerSingletonAsync<SharedPreferences>(SharedPreferences.getInstance)
    ..registerSingletonAsync<PackageInfo>(PackageInfo.fromPlatform)
    ..registerSingletonAsync<SettingsService>(
      () async => SettingsService(sharedPreferences: di<SharedPreferences>()),
      dependsOn: [SharedPreferences],
      dispose: (s) async => s.dispose(),
    )
    ..registerSingletonWithDependencies<SettingsModel>(
      () => SettingsModel(service: di<SettingsService>()),
      dependsOn: [SettingsService],
      dispose: (s) async => s.dispose(),
    )
    ..registerSingletonAsync<AppModel>(
      () async => AppModel(
        packageInfo: di<PackageInfo>(),
        gitHub: GitHub(),
      ),
      dependsOn: [PackageInfo],
      dispose: (s) async => s.dispose(),
    )
    ..registerSingleton<LicenseStore>(LicenseStore());
}
