import 'package:flutter/material.dart';

import '../../app_config.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/build_context_x.dart';
import '../../l10n/l10n.dart';
import 'nav_item.dart';

/// 左侧导航栏：顶部 logo/标题，中间主导航项，底部钉一个设置项。
///
/// 导航项索引与 [router] 的 branch 顺序一一对应（0 = home，1 = settings）。
class SideNav extends StatelessWidget {
  const SideNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final compact = !context.showSideNav;
    final width = compact ? kCompactSideNavWidth : kSideNavWidth;
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: width,
      color: cs.surfaceContainerLow,
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 16),
              child: Row(
                mainAxisAlignment: compact
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Icon(Icons.video_library, color: cs.primary, size: 22),
                  if (!compact) ...[
                    const SizedBox(width: 12),
                    Text(
                      AppConfig.appTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                NavTile(
                  compact: compact,
                  selected: currentIndex == 0,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: context.l10n.home,
                  onTap: () => onDestinationSelected(0),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: NavTile(
              compact: compact,
              selected: currentIndex == 1,
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              label: context.l10n.settings,
              onTap: () => onDestinationSelected(1),
            ),
          ),
        ],
      ),
    );
  }
}
