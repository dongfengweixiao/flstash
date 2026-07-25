import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../extensions/target_platform_x.dart';
import 'side_nav.dart';
import 'title_bar.dart';

/// 应用外壳：顶部通栏标题栏 + 左侧导航 + 右侧内容区。
///
/// 右侧内容由 go_router 的 [StatefulNavigationShell] 提供，各 branch
/// 状态在切换间保留。
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (isDesktop) const TitleBar(),
          Expanded(
            child: Row(
              children: [
                SideNav(
                  currentIndex: navigationShell.currentIndex,
                  onDestinationSelected: (i) => navigationShell.goBranch(
                    i,
                    initialLocation: i == navigationShell.currentIndex,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
