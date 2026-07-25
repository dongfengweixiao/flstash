import 'package:flutter/material.dart';

import '../../extensions/build_context_x.dart';

class Progress extends StatelessWidget {
  const Progress({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.strokeWidth = 3.0,
    this.padding,
    this.adaptive = true,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final double strokeWidth;
  final EdgeInsetsGeometry? padding;
  final bool adaptive;

  @override
  Widget build(BuildContext context) {
    final trackColor = backgroundColor ??
        context.theme.colorScheme.primary.withValues(alpha: 0.3);
    return Padding(
      padding: padding ?? const EdgeInsets.all(4),
      child: adaptive
          ? CircularProgressIndicator.adaptive(
              strokeWidth: strokeWidth,
              value: value,
              backgroundColor: value == null ? null : trackColor,
            )
          : CircularProgressIndicator(
              strokeWidth: strokeWidth,
              value: value,
              backgroundColor: value == null ? null : trackColor,
            ),
    );
  }
}

class LinearProgress extends StatelessWidget {
  const LinearProgress({
    super.key,
    this.color,
    this.trackHeight,
    this.value,
    this.backgroundColor,
  });

  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final double? trackHeight;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      minHeight: trackHeight,
      color: color,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(2),
    );
  }
}
