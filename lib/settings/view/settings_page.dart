import 'package:flutter/material.dart';

import '../../common/view/adaptive_container.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'about_section.dart';
import 'theme_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          padding: getAdaptiveHorizontalPadding(
            constraints: constraints,
            limit: 600,
            min: 0,
          ).copyWith(bottom: kLargestSpace),
          children: const [
            ThemeSection(),
            AboutSection(),
          ],
        ),
      ),
    );
  }
}
