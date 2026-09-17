import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../../core/widgets/qoffa_tactile_pressable.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute(
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) {
          return QoffaShellScaffold(
            navigationShell: navigationShell,
            children: children,
          );
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
                path: '/add-purchase',
                builder: (context, state) => AddPurchaseScreen(
                  initialProductId: state.uri.queryParameters['productId'],
                ),
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

class _QoffaAnimatedBranchContainer extends StatelessWidget {
  const _QoffaAnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Stack(
      fit: StackFit.expand,
      children: [
        for (int i = 0; i < children.length; i++)
          _buildBranch(context, i, reduceMotion),
      ],
    );
  }

  Widget _buildBranch(BuildContext context, int index, bool reduceMotion) {
    final isActive = index == currentIndex;

    if (reduceMotion) {
      return IgnorePointer(
        ignoring: !isActive,
        child: Opacity(
          opacity: isActive ? 1.0 : 0.0,
          child: children[index],
        ),
      );
    }

    return IgnorePointer(
      ignoring: !isActive,
      child: AnimatedOpacity(
        duration: QoffaTokens.motionMedium,
        curve: Curves.easeOutCubic,
        opacity: isActive ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: QoffaTokens.motionMedium,
          curve: Curves.easeOutCubic,
          offset: isActive ? Offset.zero : const Offset(0, 0.025),
          child: children[index],
        ),
      ),
    );
  }
}

class QoffaShellScaffold extends StatefulWidget {
  const QoffaShellScaffold({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

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

    // Do not swipe away when interacting on Add Purchase form
    if (current == 2) return;

    // Content browsing tabs: 0: Home, 1: Calendar, 3: Later Buy, 4: Notebook
    final contentTabs = [0, 1, 3, 4];
    final currentPos = contentTabs.indexOf(current);
    if (currentPos == -1) return;

    final targetPos = direction < 0 ? currentPos + 1 : currentPos - 1;
    if (targetPos >= 0 && targetPos < contentTabs.length) {
      _goToBranch(contentTabs[targetPos]);
    }
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
        child: _QoffaAnimatedBranchContainer(
          currentIndex: currentIndex,
          children: widget.children,
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final bottomInset = MediaQuery.paddingOf(context).bottom;
          // Ensure breathing space at the bottom edge even when bottomInset is 0 (desktop/window)
          final bottomBreathing = math.max(bottomInset, 18.0);
          final totalHeight = 92.0 + bottomBreathing;

          // Slot 0: Home, 1: Calendar, 2: Add, 3: Later Buy, 4: Notebook
          final slot = currentIndex;
          final isRtl = Directionality.of(context) == TextDirection.rtl;
          final targetSlot = isRtl ? 4 - slot : slot;
          final slotWidth = constraints.maxWidth / 5;
          const indicatorWidth = 26.0;
          final targetLeft =
              (targetSlot + 0.5) * slotWidth - (indicatorWidth / 2);

          return SizedBox(
            height: totalHeight,
            width: constraints.maxWidth,
            child: CustomPaint(
              painter: const _CurvedNavBarBackgroundPainter(
                barTop: 26.0,
                bulbTop: 5.0,
                cornerRadius: 24.0,
                domeRadius: 32.0,
                filletRadius: 10.0,
                backgroundColor: Colors.white,
                borderColor: QoffaColors.softBorder,
                borderWidth: 1.3,
              ),
              child: Stack(
                children: [
                  // Smooth sliding horizontal indicator bar below the active label
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    left: targetLeft,
                    bottom: bottomBreathing + 4.0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: currentIndex == 2 ? 0.0 : 1.0,
                      child: Container(
                        width: indicatorWidth,
                        height: 3.2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF008744),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  // 5 equal columns: Home, Calendar, Add, Later Buy, Notebook
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomBreathing + 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _NavTabItem(
                            icon: Icons.home_rounded,
                            label: l10n.navHome,
                            isSelected: currentIndex == 0,
                            onTap: () => _goToBranch(0),
                          ),
                          _NavTabItem(
                            icon: Icons.calendar_month_rounded,
                            label: l10n.navCalendar,
                            isSelected: currentIndex == 1,
                            onTap: () => _goToBranch(1),
                          ),
                          _AddNavItem(
                            label: l10n.navAdd,
                            isCurrentPage: currentIndex == 2,
                            onTap: () => _goToBranch(2),
                          ),
                          _NavTabItem(
                            icon: Icons.shopping_cart_rounded,
                            label: l10n.navLaterBuy,
                            isSelected: currentIndex == 3,
                            onTap: () => _goToBranch(3),
                          ),
                          _NavTabItem(
                            icon: Icons.description_rounded,
                            label: l10n.navNotebook,
                            isSelected: currentIndex == 4,
                            onTap: () => _goToBranch(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CurvedNavBarBackgroundPainter extends CustomPainter {
  const _CurvedNavBarBackgroundPainter({
    required this.barTop,
    required this.bulbTop,
    required this.cornerRadius,
    required this.domeRadius,
    required this.filletRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
  });

  final double barTop;
  final double bulbTop;
  final double cornerRadius;
  final double domeRadius;
  final double filletRadius;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  Path _buildClosedPath(Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = bulbTop + domeRadius;
    final cyFillet = barTop - filletRadius;
    final dy = cy - cyFillet;
    final rSum = domeRadius + filletRadius;
    final deltaX = math.sqrt(math.max(0.0, rSum * rSum - dy * dy));

    final ux = deltaX / rSum;
    final uy = dy / rSum;

    final pTouchLeft = Offset(
      cx - deltaX + filletRadius * ux,
      cyFillet + filletRadius * uy,
    );
    final pTouchRight = Offset(
      cx + deltaX - filletRadius * ux,
      cyFillet + filletRadius * uy,
    );

    return Path()
      ..moveTo(0, h)
      ..lineTo(0, barTop + cornerRadius)
      ..arcToPoint(
        Offset(cornerRadius, barTop),
        radius: Radius.circular(cornerRadius),
      )
      ..lineTo(cx - deltaX, barTop)
      // 1. Left concave circular fillet transitioning into the dome
      ..arcToPoint(
        pTouchLeft,
        radius: Radius.circular(filletRadius),
        clockwise: false,
      )
      // 2. Exact circular dome arc
      ..arcToPoint(
        pTouchRight,
        radius: Radius.circular(domeRadius),
        clockwise: true,
      )
      // 3. Right concave circular fillet transitioning into the horizontal line
      ..arcToPoint(
        Offset(cx + deltaX, barTop),
        radius: Radius.circular(filletRadius),
        clockwise: false,
      )
      ..lineTo(w - cornerRadius, barTop)
      ..arcToPoint(
        Offset(w, barTop + cornerRadius),
        radius: Radius.circular(cornerRadius),
      )
      ..lineTo(w, h)
      ..close();
  }

  Path _buildBorderPath(Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = bulbTop + domeRadius;
    final cyFillet = barTop - filletRadius;
    final dy = cy - cyFillet;
    final rSum = domeRadius + filletRadius;
    final deltaX = math.sqrt(math.max(0.0, rSum * rSum - dy * dy));

    final ux = deltaX / rSum;
    final uy = dy / rSum;

    final pTouchLeft = Offset(
      cx - deltaX + filletRadius * ux,
      cyFillet + filletRadius * uy,
    );
    final pTouchRight = Offset(
      cx + deltaX - filletRadius * ux,
      cyFillet + filletRadius * uy,
    );

    return Path()
      ..moveTo(0, h)
      ..lineTo(0, barTop + cornerRadius)
      ..arcToPoint(
        Offset(cornerRadius, barTop),
        radius: Radius.circular(cornerRadius),
      )
      ..lineTo(cx - deltaX, barTop)
      ..arcToPoint(
        pTouchLeft,
        radius: Radius.circular(filletRadius),
        clockwise: false,
      )
      ..arcToPoint(
        pTouchRight,
        radius: Radius.circular(domeRadius),
        clockwise: true,
      )
      ..arcToPoint(
        Offset(cx + deltaX, barTop),
        radius: Radius.circular(filletRadius),
        clockwise: false,
      )
      ..lineTo(w - cornerRadius, barTop)
      ..arcToPoint(
        Offset(w, barTop + cornerRadius),
        radius: Radius.circular(cornerRadius),
      )
      ..lineTo(w, h);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(_buildClosedPath(size), fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(_buildBorderPath(size), borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CurvedNavBarBackgroundPainter oldDelegate) {
    return oldDelegate.barTop != barTop ||
        oldDelegate.bulbTop != bulbTop ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.domeRadius != domeRadius ||
        oldDelegate.filletRadius != filletRadius ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}

class _NavTabItem extends StatelessWidget {
  const _NavTabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _selectedColor = Color(0xFF008744);
  static const Color _unselectedColor = Color(0xFF8FA397);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? _selectedColor : _unselectedColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          selected: isSelected,
          label: label,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                icon,
                size: 25,
                color: color,
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddNavItem extends StatelessWidget {
  const _AddNavItem({
    required this.label,
    required this.isCurrentPage,
    required this.onTap,
  });

  final String label;
  final bool isCurrentPage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const unselectedColor = Color(0xFF8FA397);
    final isAddActive = isCurrentPage;

    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isAddActive ? null : onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              QoffaTactilePressable(
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
                enabled: !isAddActive,
                backgroundColor: isAddActive
                    ? const Color(0xFFD6E2DB)
                    : QoffaColors.actionGreen,
                borderColor: isAddActive
                    ? const Color(0xFFCAD8D1)
                    : QoffaColors.actionGreen,
                hoverBackgroundColor: isAddActive
                    ? const Color(0xFFD6E2DB)
                    : QoffaColors.pressedGreen,
                hoverBorderColor: isAddActive
                    ? const Color(0xFFCAD8D1)
                    : QoffaColors.pressedGreen,
                onTap: onTap,
                child: Center(
                  child: Icon(
                    Icons.add_rounded,
                    color: isAddActive ? unselectedColor : Colors.white,
                    size: 29,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isAddActive ? unselectedColor : QoffaColors.actionGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
