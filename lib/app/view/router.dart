import 'package:go_router/go_router.dart';

import '../../settings/view/settings_page.dart';
import 'app_shell.dart';
import 'home_page.dart';

/// 全局路由单例。必须是顶层 final，不能在 widget build 内重建，
/// 否则主题切换重建 MaterialApp 时会丢失路由状态。
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
