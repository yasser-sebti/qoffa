import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_icon_button.dart';
import '../../../core/widgets/qoffa_layout.dart';
import '../../../core/widgets/qoffa_motion.dart';
import '../../../core/widgets/raised_pressable.dart';
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

    final monthlyTotal = ref.watch(
      StreamProvider(
        (ref) => purchaseRepo.watchMonthlyTotal(now.year, now.month),
      ),
    );
    final recentPurchases = ref.watch(
      StreamProvider(
        (ref) => purchaseRepo.watchRecentPurchaseEntries(limit: 5),
      ),
    );
    final profile = ref.watch(
      StreamProvider((ref) => settingsRepo.watchProfile()),
    );

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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: QoffaReveal(
                    child: _HomeHeader(l10n: l10n, now: now),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: QoffaReveal(
                    delay: QoffaTokens.stagger * 2,
                    child: _QuickActions(l10n: l10n),
                  ),
                ),
              ),
              if (!spent.isZero)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: QoffaReveal(
                      delay: QoffaTokens.stagger * 3,
                      child: _PaceInsight(
                        isOverPace: projection.projectedMonthEnd > budget,
                        projected: projection.projectedMonthEnd,
                        locale: l10n.languageCode,
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.recentActivity,
                          style: const TextStyle(
                            fontFamily: 'Hero Sandwich Pro',
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => context.go('/calendar'),
                        iconAlignment: IconAlignment.end,
                        icon: Icon(
                          Directionality.of(context) == TextDirection.rtl
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                          size: 19,
                        ),
                        label: Text(l10n.seeAll),
                      ),
                    ],
                  ),
                ),
              ),
              recentPurchases.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      sliver: SliverToBoxAdapter(
                        child: QoffaReveal(
                          delay: QoffaTokens.stagger * 4,
                          child: QoffaEmptyState(
                            icon: Icons.shopping_basket_outlined,
                            title: l10n.noPurchasesYet,
                            message: l10n.noPurchasesMessage,
                            actionLabel: l10n.addFirstPurchase,
                            onAction: () => context.push('/add-purchase'),
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    sliver: SliverList.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) => QoffaReveal(
                        delay: QoffaTokens.stagger * (index.clamp(0, 4) + 1),
                        child: _RecentPurchaseTile(
                          entry: entries[index],
                          locale: l10n.languageCode,
                          onTap: () => ProductDetailsModal.show(
                            context,
                            productId: entries[index].purchase.productId,
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
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.greetingFor(now),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Hero Sandwich Pro',
                fontSize: 31,
                fontWeight: FontWeight.w900,
                height: 1.05,
                color: QoffaColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              l10n.subtitleHome,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w500,
                color: QoffaColors.secondarySage,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 8),
      QoffaIconButton(
        icon: Icons.checklist_rounded,
        tooltip: l10n.shoppingListsTitle,
        onTap: () => context.push('/shopping-lists'),
      ),
      const SizedBox(width: 8),
      QoffaIconButton(
        icon: Icons.settings_outlined,
        tooltip: l10n.settingsTitle,
        onTap: () => context.push('/settings'),
      ),
    ],
  );
}

class _BudgetHero extends StatelessWidget {
  const _BudgetHero({
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
    final fraction = projection.budgetProgressFraction.clamp(0.0, 1.0);
    final percent = (projection.budgetProgressFraction * 100).round();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(color: QoffaColors.softBorder, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: QoffaColors.actionGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.monthlyBudget,
                  style: const TextStyle(
                    fontFamily: 'Hero Sandwich Pro',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: percent > 100
                      ? const Color(0xFFFFECEC)
                      : QoffaColors.mintSurfaceTint,
                  borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
                ),
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    fontFamily: 'Hero Sandwich Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: percent > 100
                        ? QoffaColors.warningCoralDeep
                        : QoffaColors.actionGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact =
                  constraints.maxWidth < QoffaTokens.compactBreakpoint;
              final metrics = [
                _BudgetMetric(label: l10n.spent, amount: spent, locale: locale),
                _BudgetMetric(
                  label: remaining.isNegative
                      ? l10n.overBudget
                      : l10n.remaining,
                  amount: remaining.isNegative
                      ? DzdAmount(-remaining.dinars)
                      : remaining,
                  locale: locale,
                  accent: remaining.isNegative
                      ? QoffaColors.warningCoralDeep
                      : QoffaColors.actionGreen,
                  alignEnd: !compact,
                ),
              ];
              return compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        metrics.first,
                        const SizedBox(height: 12),
                        metrics.last,
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: metrics.first),
                        Expanded(child: metrics.last),
                      ],
                    );
            },
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: fraction),
              duration: QoffaTokens.motionSlow,
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                minHeight: 13,
                value: value,
                backgroundColor: QoffaColors.mintSurfaceTint,
                valueColor: AlwaysStoppedAnimation(
                  projection.budgetProgressFraction > 1
                      ? QoffaColors.warningCoral
                      : QoffaColors.actionGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          Text.rich(
            TextSpan(
              text: '${l10n.projected} ',
              children: [
                TextSpan(
                  text: projection.projectedMonthEnd.format(locale: locale),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
              ],
            ),
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 12.5,
              color: QoffaColors.secondarySage,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetMetric extends StatelessWidget {
  const _BudgetMetric({
    required this.label,
    required this.amount,
    required this.locale,
    this.accent = QoffaColors.primaryNavy,
    this.alignEnd = false,
  });
  final String label;
  final DzdAmount amount;
  final String locale;
  final Color accent;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: alignEnd
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start,
    children: [
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          amount.format(locale: locale),
          style: TextStyle(
            fontFamily: 'Hero Sandwich Pro',
            fontSize: 31,
            height: 1,
            fontWeight: FontWeight.w900,
            color: accent,
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 13,
          color: QoffaColors.secondarySage,
        ),
      ),
    ],
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.quickActions,
        style: const TextStyle(
          fontFamily: 'Hero Sandwich Pro',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: QoffaColors.primaryNavy,
        ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: _QuickAction(
              icon: Icons.add_shopping_cart_rounded,
              label: l10n.navAdd,
              color: QoffaColors.actionGreen,
              onTap: () => context.push('/add-purchase'),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: _QuickAction(
              icon: Icons.watch_later_outlined,
              label: l10n.navLaterBuy,
              color: QoffaColors.warningCoral,
              onTap: () => context.go('/later-buy'),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: _QuickAction(
              icon: Icons.edit_note_rounded,
              label: l10n.navNotebook,
              color: QoffaColors.noteYellowDeep,
              onTap: () => context.go('/notebook'),
            ),
          ),
        ],
      ),
    ],
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(QoffaTokens.radiusCompact);
    return RaisedPressable(
      onTap: onTap,
      height: 86,
      radius: radius,
      shadowOffset: 5,
      shadowColor: color,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
        decoration: BoxDecoration(
          color: QoffaColors.whiteSurface,
          borderRadius: radius,
          border: Border.all(color: QoffaColors.softBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 7),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: QoffaColors.primaryNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaceInsight extends StatelessWidget {
  const _PaceInsight({
    required this.isOverPace,
    required this.projected,
    required this.locale,
  });
  final bool isOverPace;
  final DzdAmount projected;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = isOverPace
        ? QoffaColors.warningCoralDeep
        : QoffaColors.actionGreen;
    return QoffaCard(
      padding: const EdgeInsets.all(15),
      radius: QoffaTokens.radiusCompact,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOverPace ? Icons.trending_up_rounded : Icons.auto_graph_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOverPace ? l10n.watchYourPace : l10n.onTrack,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.projected} ${projected.format(locale: locale)}',
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 12,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: QoffaCard(
        onTap: onTap,
        radius: QoffaTokens.radiusCompact,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: QoffaColors.mintSurfaceTint,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: QoffaColors.actionGreen,
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      '${p.quantity.toStringAsFixed(p.quantity % 1 == 0 ? 0 : 2)} ${p.unitId}',
                      if (entry.storeName != null) entry.storeName!,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 12,
                      color: QoffaColors.secondarySage,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              DzdAmount(p.totalDzd).format(locale: locale),
              style: const TextStyle(
                fontFamily: 'Hero Sandwich Pro',
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: QoffaColors.primaryNavy,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              color: QoffaColors.secondarySage,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
