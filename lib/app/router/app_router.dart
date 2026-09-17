import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/raised_pressable.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/later_buy/presentation/later_buy_screen.dart';
import '../../features/notebook/presentation/notebook_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/purchases/presentation/add_purchase_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shopping_lists/presentation/shopping_lists_screen.dart';
import '../localization/app_localizations.dart';
import '../theme/qoffa_colors.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return QoffaShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/later-buy',
                builder: (context, state) => const LaterBuyScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notebook',
                builder: (context, state) => const NotebookScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/add-purchase',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddPurchaseScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/shopping-lists',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ShoppingListsScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
});

class QoffaShellScaffold extends StatelessWidget {
  const QoffaShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: QoffaColors.softBorder, width: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0C000000),
              offset: Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 1. Home
                _NavBarItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: l10n.navHome,
                  isSelected: currentIndex == 0,
                  onTap: () => navigationShell.goBranch(0),
                ),

                // 2. Calendar
                _NavBarItem(
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month_rounded,
                  label: l10n.navCalendar,
                  isSelected: currentIndex == 1,
                  onTap: () => navigationShell.goBranch(1),
                ),

                // 3. Center Elevated Add Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RaisedPressable(
                        onTap: () => context.push('/add-purchase'),
                        width: 48,
                        height: 48,
                        radius: BorderRadius.circular(24),
                        shadowOffset: 4,
                        shadowColor: QoffaColors.pressedGreen,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: QoffaColors.brandGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.navAdd,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: QoffaColors.brandGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Later Buy
                _NavBarItem(
                  icon: Icons.bookmark_border_rounded,
                  activeIcon: Icons.bookmark_rounded,
                  label: l10n.navLaterBuy,
                  isSelected: currentIndex == 2,
                  onTap: () => navigationShell.goBranch(2),
                ),

                // 5. Notebook
                _NavBarItem(
                  icon: Icons.article_outlined,
                  activeIcon: Icons.article_rounded,
                  label: l10n.navNotebook,
                  isSelected: currentIndex == 3,
                  onTap: () => navigationShell.goBranch(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? QoffaColors.brandGreen : QoffaColors.secondarySage;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
