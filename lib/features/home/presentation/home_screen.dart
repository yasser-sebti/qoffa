import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
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
    final purchaseRepo = ref.watch(purchaseRepositoryProvider);
    final settingsRepo = ref.watch(settingsRepositoryProvider);

    final monthlyTotalAsync = ref.watch(
      StreamProvider((ref) => purchaseRepo.watchMonthlyTotal(now.year, now.month)),
    );
    final recentPurchasesAsync = ref.watch(
      StreamProvider((ref) => purchaseRepo.watchRecentPurchases(limit: 6)),
    );
    final profileAsync = ref.watch(
      StreamProvider((ref) => settingsRepo.watchProfile()),
    );

    final spentAmount = monthlyTotalAsync.value ?? DzdAmount.zero;
    final budgetDzd = profileAsync.value?.monthlyBudgetDzd ?? 60000;
    final budgetAmount = DzdAmount(budgetDzd);

    final projection = ProjectionEngine.calculate(
      spentSoFar: spentAmount,
      budget: budgetAmount,
      currentDate: now,
    );

    return MintBackgroundScaffold(
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Top App Bar / Greeting
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.greetingMorning,
                            style: const TextStyle(
                              fontFamily: 'Hero Sandwich Pro',
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: QoffaColors.primaryNavy,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.subtitleHome,
                            style: const TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: QoffaColors.secondarySage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.checklist_rounded,
                        color: QoffaColors.primaryNavy,
                        size: 28,
                      ),
                      tooltip: 'قوائم التسوق',
                      onPressed: () => context.push('/shopping-lists'),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: QoffaColors.primaryNavy,
                        size: 28,
                      ),
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
              ),
            ),

            // Hero Monthly Budget Card
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: _MonthlyBudgetCard(
                  spent: spentAmount,
                  remaining: projection.remainingBudget,
                  progressFraction: projection.budgetProgressFraction,
                  projected: projection.projectedMonthEnd,
                ),
              ),
            ),

            // 2 Micro-Insight Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: _InsightTile(
                        icon: Icons.trending_up_rounded,
                        iconColor: QoffaColors.actionGreen,
                        iconBgColor: QoffaColors.mintSurfaceTint,
                        headline: '${projection.pacePercentageVsBudget >= 0 ? '+' : ''}${projection.pacePercentageVsBudget.toStringAsFixed(0)}%',
                        subtitle: l10n.fasterThanLastMonth,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _InsightTile(
                        icon: Icons.pie_chart_rounded,
                        iconColor: QoffaColors.warningCoral,
                        iconBgColor: const Color(0xFFFFECEC),
                        headline: l10n.highestCategory,
                        subtitle: l10n.ofYourSpending,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Activity Section
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.recentActivity,
                      style: const TextStyle(
                        fontFamily: 'Hero Sandwich Pro',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/calendar'),
                      child: Text(
                        l10n.seeAll,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: QoffaColors.actionGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Purchases List or Empty State
            recentPurchasesAsync.when(
              data: (purchases) {
                if (purchases.isEmpty) {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: QoffaColors.whiteSurface,
                          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
                          border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.shopping_basket_outlined,
                              size: 54,
                              color: QoffaColors.secondarySage,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              l10n.noPurchasesYet,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: QoffaColors.secondarySage,
                              ),
                            ),
                            const SizedBox(height: 16),
                            QoffaButton(
                              label: l10n.addFirstPurchase,
                              icon: Icons.add_rounded,
                              onTap: () => context.push('/add-purchase'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final p = purchases[index];
                        return _RecentPurchaseTile(
                          purchase: p,
                          onTap: () => ProductDetailsModal.show(context, productId: p.productId),
                        );
                      },
                      childCount: purchases.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyBudgetCard extends StatelessWidget {
  const _MonthlyBudgetCard({
    required this.spent,
    required this.remaining,
    required this.progressFraction,
    required this.projected,
  });

  final DzdAmount spent;
  final DzdAmount remaining;
  final double progressFraction;
  final DzdAmount projected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pct = (progressFraction * 100).clamp(0, 100).toInt();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(color: QoffaColors.softBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: QoffaColors.primaryNavy.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.monthlyBudget,
            style: const TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spent.format(showSymbol: true),
                      style: const TextStyle(
                        fontFamily: 'Hero Sandwich Pro',
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.spent,
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    remaining.format(showSymbol: true),
                    style: TextStyle(
                      fontFamily: 'Hero Sandwich Pro',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: remaining.isNegative ? QoffaColors.warningCoral : QoffaColors.actionGreen,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.remaining,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: QoffaColors.secondarySage,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Stack(
            children: [
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progressFraction.clamp(0.0, 1.0),
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: progressFraction > 1.0 ? QoffaColors.warningCoral : QoffaColors.actionGreen,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n.projected} ${projected.format()}',
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: QoffaColors.secondarySage,
                ),
              ),
              Text(
                '$pct%',
                style: const TextStyle(
                  fontFamily: 'Hero Sandwich Pro',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: QoffaColors.primaryNavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.headline,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String headline;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(color: QoffaColors.softBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Hero Sandwich Pro',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: QoffaColors.secondarySage,
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

class _RecentPurchaseTile extends StatelessWidget {
  const _RecentPurchaseTile({
    required this.purchase,
    required this.onTap,
  });

  final dynamic purchase;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
        child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: QoffaColors.mintSurfaceTint,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: QoffaColors.actionGreen,
            size: 22,
          ),
        ),
        title: Text(
          purchase.note != null && purchase.note!.isNotEmpty
              ? purchase.note!
              : 'Product ${purchase.productId.substring(0, 6)}',
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: QoffaColors.primaryNavy,
          ),
        ),
        subtitle: Text(
          '${purchase.quantity} ${purchase.unitId} · ${purchase.localDate}',
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 13,
            color: QoffaColors.secondarySage,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${purchase.totalDzd} DA',
              style: const TextStyle(
                fontFamily: 'Hero Sandwich Pro',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: QoffaColors.primaryNavy,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: QoffaColors.secondarySage,
              size: 20,
            ),
          ],
        ),
      ),
      ),
    );
  }
}
