import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../../core/widgets/qoffa_layout.dart';
import '../../../core/widgets/qoffa_motion.dart';
import '../../insights/domain/services/was_it_worth_waiting_service.dart';
import '../data/later_buy_repository.dart';

class LaterBuyScreen extends ConsumerStatefulWidget {
  const LaterBuyScreen({super.key});

  @override
  ConsumerState<LaterBuyScreen> createState() => _LaterBuyScreenState();
}

class _LaterBuyScreenState extends ConsumerState<LaterBuyScreen> {
  String _activeTab = 'active';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(laterBuyEntriesProvider(_activeTab));
    final pendingAsync = ref.watch(laterBuyPendingCountProvider);
    final pendingCount = pendingAsync.value ?? 0;

    return MintBackgroundScaffold(
      child: SafeArea(
        bottom: false,
        child: QoffaContentWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: QoffaReveal(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 390),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.laterBuyTitle,
                              style: const TextStyle(
                                fontFamily: 'Hero Sandwich Pro',
                                fontSize: 31,
                                height: 1,
                                fontWeight: FontWeight.w900,
                                color: QoffaColors.primaryNavy,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              l10n.laterBuySubtitle,
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 13,
                                color: QoffaColors.secondarySage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: QoffaColors.whiteSurface,
                          borderRadius: BorderRadius.circular(
                            QoffaTokens.radiusPill,
                          ),
                          border: Border.all(color: QoffaColors.softBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              color: QoffaColors.actionGreen,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            AnimatedSwitcher(
                              duration: QoffaTokens.motionMedium,
                              child: Text(
                                '$pendingCount ${l10n.pendingCount}',
                                key: ValueKey(pendingCount),
                                style: const TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: _StatusTabs(
                  activeTab: _activeTab,
                  pendingCount: pendingCount,
                  onChanged: (status) => setState(() => _activeTab = status),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: QoffaAnimatedSwap(
                  layoutKey: _activeTab,
                  child: entriesAsync.when(
                    data: (entries) {
                      if (entries.isEmpty) {
                        return ListView(
                          key: ValueKey('empty-$_activeTab'),
                          padding: const EdgeInsets.fromLTRB(20, 34, 20, 120),
                          children: [
                            QoffaEmptyState(
                              icon: _activeTab == 'active'
                                  ? Icons.savings_outlined
                                  : Icons.inventory_2_outlined,
                              title: _activeTab == 'active'
                                  ? l10n.noLaterBuyActive
                                  : l10n.noItemsInTab,
                              message: _activeTab == 'active'
                                  ? l10n.noLaterBuyActiveMessage
                                  : l10n.noItemsInTab,
                              actionLabel: _activeTab == 'active'
                                  ? l10n.navAdd
                                  : null,
                              onAction: _activeTab == 'active'
                                  ? () => context.push('/add-purchase')
                                  : null,
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        key: ValueKey('list-$_activeTab'),
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                        itemCount: entries.length,
                        itemBuilder: (context, index) => QoffaReveal(
                          delay: QoffaTokens.stagger * index.clamp(0, 5),
                          child: _LaterBuyCard(
                            entry: entries[index],
                            onResolveBought: () =>
                                _resolveBought(entries[index]),
                          ),
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: QoffaEmptyState(
                        icon: Icons.sync_problem_rounded,
                        title: l10n.errorTitle,
                        message: l10n.errorMessage(error),
                      ),
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

  Future<void> _resolveBought(LaterBuyListEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final item = entry.item;
    final controller = TextEditingController(
      text: (item.targetPriceDzd ?? item.observedPriceDzd).toString(),
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(QoffaTokens.radiusMajor),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: QoffaColors.softBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  entry.productName,
                  style: const TextStyle(
                    fontFamily: 'Hero Sandwich Pro',
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${l10n.observedPrice}: ${item.observedPriceDzd} DA',
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: QoffaColors.secondarySage,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.totalPrice,
                    suffixText: 'DA',
                  ),
                ),
                const SizedBox(height: 16),
                QoffaButton(
                  label: l10n.confirmPurchase,
                  icon: Icons.check_circle_outline_rounded,
                  onTap: () async {
                    final finalPrice = int.tryParse(controller.text);
                    if (finalPrice == null || finalPrice <= 0) return;
                    final result = WasItWorthWaitingService.calculate(
                      observedPrice: DzdAmount(item.observedPriceDzd),
                      observedQuantity: Decimal.parse(
                        item.observedQuantity.toString(),
                      ),
                      observedUnitId: item.observedUnitId,
                      observedDate: item.createdAt,
                      finalPrice: DzdAmount(finalPrice),
                      finalQuantity: Decimal.parse(
                        item.observedQuantity.toString(),
                      ),
                      finalUnitId: item.observedUnitId,
                      purchaseDate: DateTime.now(),
                    );
                    await ref
                        .read(laterBuyRepositoryProvider)
                        .resolveAsBought(
                          laterBuyId: item.id,
                          quantity: item.observedQuantity,
                          unitId: item.observedUnitId,
                          finalPriceDzd: finalPrice,
                          isUnitPrice: false,
                          purchasedAt: DateTime.now(),
                        );
                    if (!sheetContext.mounted) return;
                    Navigator.pop(sheetContext);
                    if (mounted) _showOutcome(result);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    controller.dispose();
  }

  Future<void> _showOutcome(WasItWorthWaitingResult result) {
    final l10n = AppLocalizations.of(context);
    final saved = result.absoluteDifferenceDzd.dinars >= 0;
    final explanation = result.isComparable
        ? l10n.waitedResult(
            result.daysWaited,
            result.absoluteDifferenceDzd.dinars,
            saved,
          )
        : l10n.noPreviousPrice;
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        ),
        icon: Icon(
          saved ? Icons.savings_outlined : Icons.trending_up_rounded,
          color: saved ? QoffaColors.actionGreen : QoffaColors.warningCoral,
          size: 34,
        ),
        title: Text(l10n.wasItWorthWaiting),
        content: Text(explanation, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({
    required this.activeTab,
    required this.pendingCount,
    required this.onChanged,
  });

  final String activeTab;
  final int pendingCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabs = [
      ('active', '${l10n.tabActive} ($pendingCount)'),
      ('bought', l10n.tabBought),
      ('skipped', l10n.tabSkipped),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: QoffaColors.mintSurfaceTint,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
      ),
      child: Row(
        children: tabs.map((tab) {
          final selected = activeTab == tab.$1;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(tab.$1),
              borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
              child: AnimatedContainer(
                duration: QoffaTokens.motionMedium,
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? QoffaColors.actionGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    QoffaTokens.radiusControls,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tab.$2,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : QoffaColors.primaryNavy,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LaterBuyCard extends StatelessWidget {
  const _LaterBuyCard({required this.entry, required this.onResolveBought});
  final LaterBuyListEntry entry;
  final VoidCallback onResolveBought;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = entry.item;
    final pending = item.status == 'active';
    final dateLocale = l10n.languageCode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: QoffaCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: QoffaColors.mintSurfaceTint,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.local_mall_outlined,
                    color: QoffaColors.actionGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Hero Sandwich Pro',
                          fontSize: 20,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.observedQuantity} ${l10n.unitName(item.observedUnitId)}${entry.storeName == null ? '' : ' · ${entry.storeName}'}',
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
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PriceMetric(
                    label: l10n.observedPrice,
                    value: '${item.observedPriceDzd} DA',
                  ),
                ),
                if (item.targetPriceDzd != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: QoffaColors.mintSurfaceTint,
                        borderRadius: BorderRadius.circular(
                          QoffaTokens.radiusControls,
                        ),
                      ),
                      child: _PriceMetric(
                        label: l10n.targetPrice,
                        value: '${item.targetPriceDzd} DA',
                        color: QoffaColors.actionGreen,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (pending) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (item.reminderAt != null) ...[
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: QoffaColors.actionGreen,
                      size: 19,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        DateFormat.yMMMd(
                          dateLocale,
                        ).format(item.reminderAt!.toLocal()),
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 12,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                    ),
                  ] else
                    const Spacer(),
                  TextButton.icon(
                    onPressed: onResolveBought,
                    icon: const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                    ),
                    label: Text(l10n.boughtAction),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PriceMetric extends StatelessWidget {
  const _PriceMetric({
    required this.label,
    required this.value,
    this.color = QoffaColors.primaryNavy,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 11,
          color: QoffaColors.secondarySage,
        ),
      ),
      const SizedBox(height: 3),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          style: TextStyle(
            fontFamily: 'Hero Sandwich Pro',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    ],
  );
}
