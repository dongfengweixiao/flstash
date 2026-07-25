import 'dart:async';

import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'settings_service.dart';
import 'shared_preferences_keys.dart';

class SettingsModel extends SafeChangeNotifier {
  SettingsModel({
    required SettingsService service,
  }) : _service = service {
    _propertiesChangedSub ??= _service.propertiesChanged.listen(
      (_) => notifyListeners(),
    );
  }

  final SettingsService _service;

  StreamSubscription<bool>? _propertiesChangedSub;

  /// 0 = system, 1 = light, 2 = dark（对应 [ThemeMode.values] 下标）。
  int get themeIndex => _service.getInt(SPKeys.themeIndex) ?? 0;
  void setThemeIndex(int value) => _service.setValue(SPKeys.themeIndex, value);

  int? get customThemeColor => _service.getInt(SPKeys.customThemeColor);
  void setCustomThemeColor(int? value) =>
      _service.setValue(SPKeys.customThemeColor, value);
  bool get useCustomThemeColor =>
      _service.getBool(SPKeys.useCustomThemeColor) ?? false;
  void setUseCustomThemeColor(bool value) =>
      _service.setValue(SPKeys.useCustomThemeColor, value);

  @override
  Future<void> dispose() async {
    await _propertiesChangedSub?.cancel();
    super.dispose();
  }
}
