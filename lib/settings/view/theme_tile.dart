import 'package:flutter/material.dart';

import '../../common/view/ui_constants.dart';

/// 主题切换的迷你窗口预览卡片（Material 重写版）。
///
/// system 模式用对角 ClipPath 切成左下深色 + 右上浅色；右上角三个圆点
/// 代表窗口控制按钮（替代 starter 中使用的 YaruIcons）。
class ThemeTile extends StatelessWidget {
  const ThemeTile(this.themeMode, {super.key});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    const height = 100.0;
    const width = 150.0;
    final borderRadius = BorderRadius.circular(12);
    final lightContainer = Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius),
    );
    final darkContainer = Container(
      decoration: BoxDecoration(
        color: kDarkPreviewColor,
        borderRadius: borderRadius,
      ),
    );
    final titleBar = Container(
      height: kLargestSpace,
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.dark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
    );

    final dotColor =
        themeMode == ThemeMode.dark ? Colors.white54 : Colors.black54;

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          elevation: 5,
          child: SizedBox(
            height: height,
            width: width,
            child: themeMode == ThemeMode.system
                ? Stack(
                    children: [
                      ClipPath(
                        clipper: _LightClipper(height: height, width: width),
                        child: lightContainer,
                      ),
                      ClipPath(
                        clipper: _DarkClipper(height: height, width: width),
                        child: darkContainer,
                      ),
                      titleBar,
                    ],
                  )
                : (themeMode == ThemeMode.light
                    ? Stack(children: [lightContainer, titleBar])
                    : Stack(children: [darkContainer, titleBar])),
          ),
        ),
        Positioned(
          right: 8,
          top: 6,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LightClipper extends CustomClipper<Path> {
  const _LightClipper({required this.height, required this.width});

  final double height;
  final double width;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(width, 0);
    path.lineTo(width, height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DarkClipper extends CustomClipper<Path> {
  const _DarkClipper({required this.height, required this.width});

  final double height;
  final double width;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, width);
    path.lineTo(width, height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
