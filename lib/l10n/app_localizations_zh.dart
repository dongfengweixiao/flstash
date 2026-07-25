// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get home => '首页';

  @override
  String get settings => '设置';

  @override
  String get about => '关于';

  @override
  String get theme => '主题';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get system => '跟随系统';

  @override
  String get useCustomThemeColorTitle => '使用自定义强调色';

  @override
  String get useCustomThemeColorDescription => '为应用主题使用自定义强调色。';

  @override
  String get selectColor => '选择颜色';

  @override
  String get selectColorShade => '选择颜色色阶';

  @override
  String get selectColorAndItsShades => '选择颜色及其色阶';

  @override
  String get version => '版本';

  @override
  String get contributors => '贡献者';

  @override
  String get license => '许可证';

  @override
  String get dependencies => '依赖';

  @override
  String get acknowledgementsTitle => '致谢';

  @override
  String get copyrightNotice => '版权所有 Dee HY - 保留所有权利。';

  @override
  String get welcomeTitle => '欢迎使用 flstash';

  @override
  String get welcomeMessage => '一个使用 Flutter 构建的 stashapp 客户端。';
}
