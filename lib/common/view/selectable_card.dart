import 'package:flutter/material.dart';

/// 可选中的卡片容器（替代 starter 的 `YaruSelectableContainer`）。
///
/// 选中时外边框变为 [ColorScheme.primary] 并加粗，用于主题切换卡片。
class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.all(1),
    this.borderRadius = 15.0,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: selected ? primary : Colors.transparent,
            width: selected ? 3 : 0,
          ),
        ),
        child: child,
      ),
    );
  }
}
