import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../app/app_model.dart';
import '../../app_config.dart';
import '../../common/view/settings_section.dart';
import '../../l10n/l10n.dart';
import 'about_dialog.dart';
import 'licenses_dialog.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      headline: Text('${context.l10n.about} ${AppConfig.appTitle}'),
      child: const Column(
        children: [_AboutTile(), _LicenseTile()],
      ),
    );
  }
}

class _AboutTile extends StatelessWidget with WatchItMixin {
  const _AboutTile();

  @override
  Widget build(BuildContext context) {
    final version = watchPropertyValue((AppModel m) => m.version);
    return ListTile(
      title: Text('${context.l10n.version}: $version'),
      trailing: OutlinedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const ContributorsDialog(),
        ),
        child: Text(context.l10n.contributors),
      ),
    );
  }
}

class _LicenseTile extends StatelessWidget {
  const _LicenseTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${context.l10n.license}: GPL3'),
      trailing: OutlinedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const LicensesDialog(),
        ),
        child: Text(context.l10n.dependencies),
      ),
    );
  }
}
