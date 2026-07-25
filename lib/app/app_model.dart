import 'package:github/github.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../app_config.dart';

class AppModel extends SafeChangeNotifier {
  AppModel({
    required PackageInfo packageInfo,
    required GitHub gitHub,
  })  : _packageInfo = packageInfo,
        _gitHub = gitHub;

  final PackageInfo _packageInfo;
  String get version => _packageInfo.version;

  final GitHub _gitHub;

  Future<List<Contributor>> getContributors() async {
    final list = await _gitHub.repositories
        .listContributors(RepositorySlug.full(AppConfig.gitHubShortLink))
        .where((c) => c.type == 'User')
        .toList();
    return list;
  }
}
