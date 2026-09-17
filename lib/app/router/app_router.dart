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
import '../theme/qoffa_tokens.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

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
        pageBuilder: (context, state) => _qoffaPage(
          state,
          AddPurchaseScreen(
            initialProductId: state.uri.queryParameters['productId'],
          ),
        ),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            _qoffaPage(state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/shopping-lists',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            _qoffaPage(state, const ShoppingListsScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            _qoffaPage(state, const OnboardingScreen()),
      ),
    ],
  );
});

CustomTransitionPage<void> _qoffaPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: QoffaTokens.motionMedium,
    reverseTransitionDuration: QoffaTokens.motionMedium,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return child;
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        ),
      );
    },
  );
}

class QoffaShellScaffold extends StatefulWidget {
  const QoffaShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<QoffaShellScaffold> createState() => _QoffaShellScaffoldState();
}

class _QoffaShellScaffoldState extends State<QoffaShellScaffold> {
  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 520) return;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final direction = rtl ? -velocity.sign : velocity.sign;
    final current = widget.navigationShell.currentIndex;
    final target = direction < 0 ? current + 1 : current - 1;
    if (target >= 0 && target < 4) _goToBranch(target);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      extendBody: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: _handleSwipe,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(10, 0, 10, 8),
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border(
              top: BorderSide(color: QoffaColors.softBorder, width: 1.5),
              left: BorderSide(color: QoffaColors.softBorder, width: 1.2),
              right: BorderSide(color: QoffaColors.softBorder, width: 1.2),
              bottom: BorderSide(color: QoffaColors.softBorder, width: 1.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home
              _NavBarItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: l10n.navHome,
                isSelected: currentIndex == 0,
                onTap: () => _goToBranch(0),
              ),

              // 2. Calendar
              _NavBarItem(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month_rounded,
                label: l10n.navCalendar,
                isSelected: currentIndex == 1,
                onTap: () => _goToBranch(1),
              ),

              // 3. Center Elevated Add Button
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -11),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RaisedPressable(
                        onTap: () => context.push('/add-purchase'),
                        width: 56,
                        height: 56,
                        radius: BorderRadius.circular(28),
                        shadowOffset: 5,
                        shadowColor: QoffaColors.pressedGreen,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: QoffaColors.brandGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 31,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.navAdd,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: QoffaColors.brandGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Later Buy
              _NavBarItem(
                icon: Icons.bookmark_border_rounded,
                activeIcon: Icons.bookmark_rounded,
                label: l10n.navLaterBuy,
                isSelected: currentIndex == 2,
                onTap: () => _goToBranch(2),
              ),

              // 5. Notebook
              _NavBarItem(
                icon: Icons.article_outlined,
                activeIcon: Icons.article_rounded,
                label: l10n.navNotebook,
                isSelected: currentIndex == 3,
                onTap: () => _goToBranch(3),
              ),
            ],
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
    final color = isSelected
        ? QoffaColors.brandGreen
        : QoffaColors.secondarySage;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Semantics(
          selected: isSelected,
          label: label,
          child: RaisedPressable(
            onTap: onTap,
            height: 61,
            radius: BorderRadius.circular(18),
            shadowOffset: 4,
            shadowColor: isSelected
                ? QoffaColors.softBorder
                : QoffaColors.softBorder.withValues(alpha: 0.72),
            enableHaptics: true,
            child: AnimatedContainer(
              duration: QoffaTokens.motionMedium,
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? QoffaColors.mintSurfaceTint
                    : QoffaColors.whiteSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? QoffaColors.actionGreen.withValues(alpha: 0.24)
                      : QoffaColors.softBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: QoffaTokens.motionFast,
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      key: ValueKey(isSelected),
                      color: color,
                      size: 23,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
