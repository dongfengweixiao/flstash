import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../app_config.dart';

/// 自绘窗口标题栏（无边框窗口），由 [window_manager] 驱动。
///
/// 整条标题栏可拖动移动窗口、双击切换最大化；右侧为最小化/最大化/关闭按钮。
class TitleBar extends StatefulWidget {
  const TitleBar({super.key, this.title});

  final String? title;

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> with WindowListener {
  bool _maximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.isMaximized().then((v) {
      if (mounted) setState(() => _maximized = v);
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() => setState(() => _maximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _maximized = false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => windowManager.startDragging(),
      onDoubleTap: () async {
        if (await windowManager.isMaximized()) {
          windowManager.unmaximize();
        } else {
          windowManager.maximize();
        }
      },
      child: Container(
        height: 32,
        color: theme.colorScheme.surface,
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              Icons.video_library,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              widget.title ?? AppConfig.appTitle,
              style: theme.textTheme.bodySmall,
            ),
            const Spacer(),
            _WinButton(
              icon: Icons.horizontal_rule,
              onTap: () => windowManager.minimize(),
            ),
            _WinButton(
              icon: _maximized ? Icons.filter_none : Icons.crop_square,
              onTap: () => _maximized
                  ? windowManager.unmaximize()
                  : windowManager.maximize(),
            ),
            _WinButton(
              icon: Icons.close,
              onTap: () => windowManager.close(),
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _WinButton extends StatelessWidget {
  const _WinButton({
    required this.icon,
    required this.onTap,
    this.isClose = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 32,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: isClose
              ? Colors.red
              : Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.08),
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }
}
