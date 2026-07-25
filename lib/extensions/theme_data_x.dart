import 'package:flutter/material.dart';

extension ThemeDataX on ThemeData {
  bool get isLight => brightness == Brightness.light;

  TextStyle? get pageHeaderStyle => textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        leadingDistribution: TextLeadingDistribution.proportional,
        fontSize: 25,
        color: colorScheme.onSurface.withValues(alpha: 0.9),
      );

  TextStyle? get pageHeaderDescription =>
      textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500);

  TextStyle? get pageHeaderSubtitleStyle =>
      textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500);
}
