import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../common/view/selectable_card.dart';
import '../../common/view/settings_section.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/build_context_x.dart';
import '../../extensions/theme_mode_x.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';
import 'theme_tile.dart';

class ThemeSection extends StatelessWidget with WatchItMixin {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final model = di<SettingsModel>();
    final themeIndex = watchPropertyValue((SettingsModel m) => m.themeIndex);
    final useCustomThemeColor =
        watchPropertyValue((SettingsModel m) => m.useCustomThemeColor);
    final customThemeColor =
        watchPropertyValue((SettingsModel m) => m.customThemeColor);

    final color = customThemeColor == null
        ? kFlstashDefaultColor
        : Color(customThemeColor);

    return SettingsSection(
      headline: Text(l10n.theme),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: kLargestSpace),
              child: Wrap(
                spacing: kLargestSpace,
                children: [
                  for (var i = 0; i < ThemeMode.values.length; i++)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SelectableCard(
                          selected: themeIndex == i,
                          onTap: () => model.setThemeIndex(i),
                          child: ThemeTile(ThemeMode.values[i]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(ThemeMode.values[i].localize(l10n)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(l10n.useCustomThemeColorTitle),
            subtitle: Text(l10n.useCustomThemeColorDescription),
            trailing: Switch(
              value: useCustomThemeColor,
              onChanged: model.setUseCustomThemeColor,
            ),
          ),
          if (useCustomThemeColor)
            ListTile(
              title: const SizedBox.shrink(),
              trailing: ElevatedButton.icon(
                icon: const Icon(Icons.palette),
                label: Text(l10n.selectColor),
                onPressed: () => ColorPicker(
                  color: color,
                  onColorChanged: (Color c) =>
                      model.setCustomThemeColor(c.toARGB32()),
                  width: 40,
                  height: 40,
                  borderRadius: 4,
                  spacing: 5,
                  runSpacing: 5,
                  wheelDiameter: 155,
                  heading: Text(l10n.selectColor, style: theme.textTheme.titleMedium),
                  subheading:
                      Text(l10n.selectColorShade, style: theme.textTheme.titleMedium),
                  wheelSubheading: Text(l10n.selectColorAndItsShades,
                      style: theme.textTheme.titleMedium),
                  showMaterialName: true,
                  showColorName: true,
                  showColorCode: true,
                  copyPasteBehavior:
                      const ColorPickerCopyPasteBehavior(longPressMenu: true),
                  materialNameTextStyle: theme.textTheme.bodySmall,
                  colorNameTextStyle: theme.textTheme.bodySmall,
                  colorCodeTextStyle: theme.textTheme.bodyMedium,
                  colorCodePrefixStyle: theme.textTheme.bodySmall,
                  selectedPickerTypeColor: theme.colorScheme.primary,
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.both: false,
                    ColorPickerType.primary: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.bw: false,
                    ColorPickerType.custom: true,
                    ColorPickerType.wheel: true,
                  },
                ).showPickerDialog(
                  context,
                  actionsPadding: const EdgeInsets.all(16),
                  constraints: const BoxConstraints(
                    minHeight: 480,
                    minWidth: 300,
                    maxWidth: 320,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
