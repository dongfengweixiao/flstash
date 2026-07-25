import 'package:flutter/material.dart';

import 'ui_constants.dart';

/// Material 版本的设置区块容器（替代 starter 的 `YaruSection`）。
///
/// 上方为标题（headline），下方为一个 [Card] 包裹的内容区域。
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.headline,
    required this.child,
    this.margin,
  });

  final Widget headline;
  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: margin ?? const EdgeInsets.all(kLargestSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: kSmallestSpace,
              bottom: kMediumSpace,
            ),
            child: DefaultTextStyle(
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              child: headline,
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
