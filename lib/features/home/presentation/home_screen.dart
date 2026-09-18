import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_layout.dart';
import '../../../core/widgets/qoffa_motion.dart';
import '../../insights/domain/services/projection_engine.dart';
import '../../products/presentation/product_details_modal.dart';
import '../../purchases/data/purchase_repository.dart';
import '../../settings/data/settings_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final monthlyTotal = ref.watch(
      monthlyTotalProvider((year: now.year, month: now.month)),
    );
    final previousMonthDate = DateTime(now.year, now.month - 1, 1);
    final previousMonthTotal = ref.watch(
      monthlyTotalProvider((year: previousMonthDate.year, month: previousMonthDate.month)),
    ).value;
    final mostUsedProduct = ref.watch(mostUsedProductProvider).value;
    final recentPurchases = ref.watch(
      recentPurchaseEntriesProvider(5),
    );
    final profile = ref.watch(userProfileProvider);

    final spent = monthlyTotal.value ?? DzdAmount.zero;
    final budget = DzdAmount(profile.value?.monthlyBudgetDzd ?? 60000);
    final projection = ProjectionEngine.calculate(
      spentSoFar: spent,
      budget: budget,
      currentDate: now,
    );

    return MintBackgroundScaffold(
      child: SafeArea(
        bottom: false,
        child: QoffaContentWidth(
          child: CustomScrollView(
            key: const PageStorageKey('home-scroll'),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                sliver: SliverToBoxAdapter(
                  child: QoffaReveal(
                    child: _HomeHeader(l10n: l10n, now: now),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                sliver: SliverToBoxAdapter(
                  child: QoffaReveal(
                    delay: QoffaTokens.stagger,
                    child: _BudgetHero(
                      spent: spent,
                      projection: projection,
                      locale: l10n.languageCode,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: QoffaReveal(
                    delay: QoffaTokens.stagger * 2,
                    child: _HomeStatsRow(
                      projection: projection,
                      spent: spent,
                      previousMonthTotal: previousMonthTotal,
                      mostUsedProduct: mostUsedProduct,
                      l10n: l10n,
                      locale: l10n.languageCode,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.recentActivity,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.display,
                            fontFamilyFallback: QoffaFontFamily.fallback,
                            fontSize: QoffaFontSize.headlineSmall,
                            fontWeight: FontWeight.w800,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/calendar'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.seeAll,
                              style: const TextStyle(
                                fontFamily: QoffaFontFamily.body,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF008744),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Directionality.of(context) == TextDirection.rtl
                                  ? Icons.chevron_left_rounded
                                  : Icons.chevron_right_rounded,
                              size: 18,
                              color: const Color(0xFF008744),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              recentPurchases.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
                      sliver: SliverToBoxAdapter(
                        child: QoffaReveal(
                          delay: QoffaTokens.stagger * 3,
                          child: QoffaEmptyState(
                            icon: Icons.remove_shopping_cart_rounded,
                            title: l10n.noPurchasesYet,
                            message: l10n.noPurchasesMessage,
                            actionLabel: l10n.addFirstPurchase,
                            onAction: () => context.go('/add-purchase'),
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
                    sliver: SliverToBoxAdapter(
                      child: QoffaReveal(
                        delay: QoffaTokens.stagger * 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: QoffaColors.softBorder,
                              width: 1.2,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              for (int i = 0; i < entries.length; i++) ...[
                                if (i > 0)
                                  const Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    color: Color(0xFFEDF4EF),
                                    indent: 14,
                                    endIndent: 14,
                                  ),
                                _RecentPurchaseRow(
                                  entry: entries[i],
                                  locale: l10n.languageCode,
                                  onTap: () => ProductDetailsModal.show(
                                    context,
                                    productId: entries[i].purchase.productId,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, _) => SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: QoffaEmptyState(
                      icon: Icons.sync_problem_rounded,
                      title: l10n.errorTitle,
                      message: l10n.errorMessage(error),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 36)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.l10n, required this.now});
  final AppLocalizations l10n;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.greetingFor(now),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: QoffaFontFamily.display,
                      fontFamilyFallback: QoffaFontFamily.fallback,
                      fontSize: isCompact ? 25 : 29,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _HeaderActionButton(
                  icon: Icons.tune_rounded,
                  tooltip: l10n.shoppingListsTitle,
                  size: isCompact ? 34 : 38,
                  onTap: () => context.push('/shopping-lists'),
                ),
                const SizedBox(width: 8),
                _HeaderActionButton(
                  icon: Icons.settings_outlined,
                  tooltip: l10n.settingsTitle,
                  size: isCompact ? 34 : 38,
                  onTap: () => context.push('/settings'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.subtitleHome,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: QoffaFontSize.bodySmall,
                height: 1.3,
                fontWeight: FontWeight.w500,
                color: QoffaColors.secondarySage,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 38,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: QoffaColors.softBorder, width: 1.2),
          ),
          child: Icon(
            icon,
            color: QoffaColors.primaryNavy,
            size: size * 0.52,
          ),
        ),
      ),
    );
  }
}

class _ConnectedBudgetHero extends StatelessWidget {
  const _ConnectedBudgetHero({
    required this.spent,
    required this.projection,
    required this.locale,
  });
  final DzdAmount spent;
  final MonthlyProjectionResult projection;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final remaining = projection.remainingBudget;
    final percent = (projection.budgetProgressFraction * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: QoffaColors.softBorder, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Upper Section: Rich emerald-green filled area with background image
          Container(
            color: const Color(0xFF008744),
            child: Stack(
              children: [
                // Subtle flat decorative grocery shapes behind information
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/green-card-background.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const CustomPaint(
                      painter: _BudgetCardBackgroundPainter(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Larger white circular wallet container
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Color(0xFF008744),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Currency and remaining aligned to the left with monthly budget
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row: Monthly budget + status container
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      l10n.monthlyBudget,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: QoffaFontFamily.display,
                                        fontFamilyFallback:
                                            QoffaFontFamily.fallback,
                                        fontSize: QoffaFontSize.titleMedium,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$percent%',
                                        style: const TextStyle(
                                          fontFamily: QoffaFontFamily.display,
                                          fontFamilyFallback:
                                              QoffaFontFamily.fallback,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          height: 1.0,
                                          color: Color(0xFF008744),
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        l10n.used,
                                        style: const TextStyle(
                                          fontFamily: QoffaFontFamily.body,
                                          fontSize: QoffaFontSize.micro,
                                          fontWeight: FontWeight.w700,
                                          height: 1.0,
                                          color: Color(0xFF008744),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Main Amount: Large white rounded typography, aligned with monthly budget
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                remaining.isNegative
                                    ? '-${DzdAmount(-remaining.dinars).format(locale: locale)}'
                                    : remaining.format(locale: locale),
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.display,
                                  fontFamilyFallback: QoffaFontFamily.fallback,
                                  fontSize: QoffaFontSize.display,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            // "remaining", aligned with monthly budget
                            Text(
                              remaining.isNegative
                                  ? l10n.overBudget
                                  : l10n.remaining,
                              style: TextStyle(
                                fontFamily: QoffaFontFamily.body,
                                fontSize: QoffaFontSize.body,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.94),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Lower Section: White lower panel
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    // Left: spent
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spent.format(locale: locale),
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.display,
                            fontFamilyFallback: QoffaFontFamily.fallback,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.spent,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.body,
                            fontSize: QoffaFontSize.captionMedium,
                            fontWeight: FontWeight.w600,
                            color: QoffaColors.secondarySage,
                          ),
                        ),
                      ],
                    ),
                    // Right: Projected
                    Text.rich(
                      TextSpan(
                        text: '${l10n.projected} ',
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.body,
                          fontSize: QoffaFontSize.bodySmall,
                          fontWeight: FontWeight.w600,
                          color: QoffaColors.secondarySage,
                        ),
                        children: [
                          TextSpan(
                            text: projection.projectedMonthEnd.format(locale: locale),
                            style: const TextStyle(
                              fontFamily: QoffaFontFamily.display,
                              fontFamilyFallback: QoffaFontFamily.fallback,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                              color: QoffaColors.primaryNavy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Thin horizontal budget progress bar (~2% usage representation)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: spent.isZero
                          ? 0.0
                          : projection.budgetProgressFraction.clamp(0.02, 1.0),
                    ),
                    duration: QoffaTokens.motionSlow,
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => LinearProgressIndicator(
                      minHeight: 11,
                      value: value,
                      backgroundColor: const Color(0xFFE2F7E8),
                      valueColor: AlwaysStoppedAnimation(
                        projection.budgetProgressFraction > 1
                            ? QoffaColors.warningCoralDeep
                            : const Color(0xFF008744),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef _BudgetHero = _ConnectedBudgetHero;

class _BudgetCardBackgroundPainter extends CustomPainter {
  const _BudgetCardBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Layered green organic curves along the bottom
    final wave1 = Path()
      ..moveTo(0, h)
      ..lineTo(0, h - 36)
      ..quadraticBezierTo(w * 0.28, h - 58, w * 0.52, h - 36)
      ..quadraticBezierTo(w * 0.78, h - 14, w, h - 42)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      wave1,
      Paint()..color = const Color(0xFF006733).withValues(alpha: 0.50),
    );

    final wave2 = Path()
      ..moveTo(0, h)
      ..lineTo(0, h - 18)
      ..quadraticBezierTo(w * 0.35, h - 40, w * 0.68, h - 18)
      ..quadraticBezierTo(w * 0.88, h - 6, w, h - 22)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      wave2,
      Paint()..color = const Color(0xFF03934B).withValues(alpha: 0.38),
    );

    // 2. Botanical leaves on bottom-left corner
    _drawLeaf(
      canvas,
      origin: Offset(w * 0.08, h - 14),
      length: 44,
      angle: -0.65,
      color: const Color(0xFF026D37).withValues(alpha: 0.65),
    );
    _drawLeaf(
      canvas,
      origin: Offset(w * 0.16, h - 10),
      length: 36,
      angle: -1.15,
      color: const Color(0xFF058544).withValues(alpha: 0.55),
    );

    // 3. Flat lime / citrus slice on the mid-right edge
    final limeCenter = Offset(w * 0.96, h * 0.66);
    const limeRadius = 72.0;

    // Outer rind circle
    final rindPaint = Paint()
      ..color = const Color(0xFF8AE06C).withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.5;
    canvas.drawCircle(limeCenter, limeRadius, rindPaint);

    // Inner pale pith ring
    final pithPaint = Paint()
      ..color = const Color(0xFFE2FBD7).withValues(alpha: 0.60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(limeCenter, limeRadius - 4.5, pithPaint);

    // Lime pulp wedges radiating outward
    final wedgePaint = Paint()
      ..color = const Color(0xFF90E872).withValues(alpha: 0.50)
      ..style = PaintingStyle.fill;

    const wedgeCount = 9;
    const sweep = 0.50; // radians
    for (int i = 0; i < wedgeCount; i++) {
      final startAngle = i * (2 * math.pi / wedgeCount) + 0.14;
      final wedgePath = Path();
      const innerR = 9.0;
      final outerR = limeRadius - 7.5;

      final p1 = limeCenter + Offset(math.cos(startAngle) * innerR, math.sin(startAngle) * innerR);
      final p2 = limeCenter + Offset(math.cos(startAngle) * outerR, math.sin(startAngle) * outerR);
      final p3 = limeCenter + Offset(math.cos(startAngle + sweep) * outerR, math.sin(startAngle + sweep) * outerR);
      final p4 = limeCenter + Offset(math.cos(startAngle + sweep) * innerR, math.sin(startAngle + sweep) * innerR);

      wedgePath.moveTo(p1.dx, p1.dy);
      wedgePath.lineTo(p2.dx, p2.dy);
      wedgePath.arcToPoint(p3, radius: Radius.circular(outerR));
      wedgePath.lineTo(p4.dx, p4.dy);
      wedgePath.close();

      canvas.drawPath(wedgePath, wedgePaint);
    }

    // Lime center core
    canvas.drawCircle(
      limeCenter,
      6.5,
      Paint()..color = const Color(0xFFE2FBD7).withValues(alpha: 0.75),
    );

    // 4. Botanical leaves flanking the lime slice and upper right
    _drawLeaf(
      canvas,
      origin: Offset(w * 0.76, h * 0.38),
      length: 50,
      angle: -2.35,
      color: const Color(0xFF45B262).withValues(alpha: 0.70),
    );
    _drawLeaf(
      canvas,
      origin: Offset(w * 0.70, h * 0.65),
      length: 42,
      angle: -1.70,
      color: const Color(0xFF56C473).withValues(alpha: 0.60),
    );
    _drawLeaf(
      canvas,
      origin: Offset(w * 0.83, h * 0.80),
      length: 46,
      angle: -0.45,
      color: const Color(0xFF38A155).withValues(alpha: 0.65),
    );
  }

  void _drawLeaf(
    Canvas canvas, {
    required Offset origin,
    required double length,
    required double angle,
    required Color color,
  }) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(angle);

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(length * 0.45, -length * 0.38, length, 0)
      ..quadraticBezierTo(length * 0.45, length * 0.38, 0, 0)
      ..close();

    canvas.drawPath(path, Paint()..color = color);

    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(length * 0.82, 0), veinPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HomeStatsRow extends StatelessWidget {
  const _HomeStatsRow({
    required this.projection,
    required this.spent,
    required this.previousMonthTotal,
    required this.mostUsedProduct,
    required this.l10n,
    required this.locale,
  });

  final MonthlyProjectionResult projection;
  final DzdAmount spent;
  final DzdAmount? previousMonthTotal;
  final MostUsedProductResult? mostUsedProduct;
  final AppLocalizations l10n;
  final String locale;

  @override
  Widget build(BuildContext context) {
    // Left card: real-time pace/spending statistics based on user data
    String statValue;
    String statLabel;
    bool isFaster = false;

    if (spent.isZero) {
      statValue = '0%';
      statLabel = l10n.onBudgetPace;
      isFaster = false;
    } else if (previousMonthTotal != null && !previousMonthTotal!.isZero) {
      final diff = (((projection.projectedMonthEnd.dinars - previousMonthTotal!.dinars) / previousMonthTotal!.dinars) * 100).round();
      if (diff > 0) {
        statValue = '+$diff%';
        statLabel = l10n.fasterThanLastMonth;
        isFaster = true;
      } else if (diff < 0) {
        statValue = '$diff%';
        statLabel = l10n.slowerThanLastMonth;
        isFaster = false;
      } else {
        statValue = '0%';
        statLabel = l10n.onBudgetPace;
        isFaster = false;
      }
    } else {
      final pace = projection.pacePercentageVsBudget.round();
      if (pace > 0) {
        statValue = '+$pace%';
        statLabel = l10n.fasterThanBudget;
        isFaster = true;
      } else if (pace < 0) {
        statValue = '$pace%';
        statLabel = l10n.slowerThanBudget;
        isFaster = false;
      } else {
        statValue = '0%';
        statLabel = l10n.onBudgetPace;
        isFaster = false;
      }
    }

    final statColor = isFaster && projection.isOverBudgetRisk
        ? QoffaColors.warningCoralDeep
        : const Color(0xFF008744);
    final statCircleBg = isFaster && projection.isOverBudgetRisk
        ? const Color(0xFFFFECEC)
        : const Color(0xFFE8F7ED);

    // Right card: most used item (header + subheader, simple, no percentage)
    final topProductName = mostUsedProduct?.productName ?? l10n.noItemsYet;
    final topProductSubheader = l10n.mostBoughtItem;

    return Row(
      children: [
        // Left Card: Real-time user statistics
        Expanded(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () => context.go('/calendar'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: QoffaColors.softBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: statCircleBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFaster ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        color: statColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              statValue,
                              style: TextStyle(
                                fontFamily: QoffaFontFamily.display,
                                fontFamilyFallback: QoffaFontFamily.fallback,
                                fontSize: QoffaFontSize.titleLarge,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                color: statColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            statLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: QoffaFontFamily.body,
                              fontSize: QoffaFontSize.captionMedium,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              color: QoffaColors.secondarySage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Right Card: Most used item
        Expanded(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {
                if (mostUsedProduct != null) {
                  ProductDetailsModal.show(
                    context,
                    productId: mostUsedProduct!.productId,
                  );
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: QoffaColors.softBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: mostUsedProduct != null
                            ? const Color(0xFFFFF0EC)
                            : QoffaColors.mintSurfaceTint,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        mostUsedProduct != null
                            ? Icons.restaurant_rounded
                            : Icons.inventory_2_outlined,
                        color: mostUsedProduct != null
                            ? const Color(0xFFE74C3C)
                            : QoffaColors.mutedText,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (mostUsedProduct == null)
                            Text(
                              topProductName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: QoffaFontFamily.display,
                                fontFamilyFallback: QoffaFontFamily.fallback,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                color: QoffaColors.primaryNavy,
                              ),
                            )
                          else
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                topProductName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.display,
                                  fontFamilyFallback: QoffaFontFamily.fallback,
                                  fontSize: QoffaFontSize.titleMedium,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                            ),
                          if (mostUsedProduct != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              topProductSubheader,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: QoffaFontFamily.body,
                                fontSize: QoffaFontSize.captionMedium,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                                color: QoffaColors.secondarySage,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentPurchaseRow extends StatelessWidget {
  const _RecentPurchaseRow({
    required this.entry,
    required this.locale,
    required this.onTap,
  });

  final PurchaseListEntry entry;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = entry.purchase;
    final l10n = AppLocalizations.of(context);

    final now = DateTime.now();
    final pDate = p.purchasedAt;
    final isToday = pDate.year == now.year &&
        pDate.month == now.month &&
        pDate.day == now.day;
    final yesterdayDate = now.subtract(const Duration(days: 1));
    final isYesterday = pDate.year == yesterdayDate.year &&
        pDate.month == yesterdayDate.month &&
        pDate.day == yesterdayDate.day;

    final String dateLabel;
    if (isToday) {
      dateLabel = l10n.today;
    } else if (isYesterday) {
      dateLabel = l10n.yesterday;
    } else {
      dateLabel = intl.DateFormat.MMMd(locale).format(pDate);
    }

    final subtitle = entry.storeName != null && entry.storeName!.trim().isNotEmpty
        ? '$dateLabel • ${entry.storeName}'
        : dateLabel;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Square rectangle item preview on the left
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F8F4),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(8),
                child: Center(child: _buildProductPreview(entry.productName)),
              ),
              const SizedBox(width: 14),
              // Header as name, subheader as date purchased + place
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontFamilyFallback: QoffaFontFamily.fallback,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: QoffaFontSize.bodySmall,
                        fontWeight: FontWeight.w500,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // On the very right: bold text item price with the right arrow dropdown show
              Text(
                DzdAmount(p.totalDzd).format(locale: locale),
                style: const TextStyle(
                  fontFamily: QoffaFontFamily.display,
                  fontFamilyFallback: QoffaFontFamily.fallback,
                  fontSize: 18.5,
                  fontWeight: FontWeight.w900,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                size: 20,
                color: QoffaColors.secondarySage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductPreview(String productName) {
    final lower = productName.toLowerCase();
    if (lower.contains('candia') ||
        lower.contains('milk') ||
        lower.contains('lait') ||
        productName.contains('حليب')) {
      return Image.asset(
        'assets/images/candia_milk.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.local_drink_rounded,
          color: Color(0xFF008744),
          size: 26,
        ),
      );
    }
    if (lower.contains('egg') ||
        lower.contains('oeuf') ||
        productName.contains('بيض')) {
      return const Icon(
        Icons.egg_rounded,
        color: Color(0xFFD9822B),
        size: 26,
      );
    }
    if (lower.contains('tomat') ||
        lower.contains('طماطم') ||
        lower.contains('pomme') ||
        lower.contains('fruit') ||
        lower.contains('legume')) {
      return const Icon(
        Icons.eco_rounded,
        color: Color(0xFFE74C3C),
        size: 26,
      );
    }
    if (lower.contains('bread') ||
        lower.contains('pain') ||
        productName.contains('خبز')) {
      return const Icon(
        Icons.bakery_dining_rounded,
        color: Color(0xFFD9822B),
        size: 26,
      );
    }
    if (lower.contains('meat') ||
        lower.contains('viande') ||
        productName.contains('لحم') ||
        lower.contains('poulet') ||
        productName.contains('دجاج')) {
      return const Icon(
        Icons.restaurant_rounded,
        color: Color(0xFFE74C3C),
        size: 26,
      );
    }
    return const Icon(
      Icons.shopping_bag_outlined,
      color: Color(0xFF008744),
      size: 26,
    );
  }
}
