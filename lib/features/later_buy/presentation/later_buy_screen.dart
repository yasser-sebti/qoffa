import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/widgets/inventory_pill.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../insights/domain/services/was_it_worth_waiting_service.dart';
import '../data/later_buy_repository.dart';

class LaterBuyScreen extends ConsumerStatefulWidget {
  const LaterBuyScreen({super.key});

  @override
  ConsumerState<LaterBuyScreen> createState() => _LaterBuyScreenState();
}

class _LaterBuyScreenState extends ConsumerState<LaterBuyScreen> {
  String _activeTab = 'active'; // active, bought, skipped

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final laterBuyRepo = ref.watch(laterBuyRepositoryProvider);
    final itemsAsync = ref.watch(
      StreamProvider((ref) => laterBuyRepo.watchItemsByStatus(_activeTab)),
    );
    final pendingCountAsync = ref.watch(
      StreamProvider((ref) => laterBuyRepo.watchPendingCount()),
    );

    final pendingCount = pendingCountAsync.value ?? 0;

    return MintBackgroundScaffold(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.laterBuyTitle,
                        style: const TextStyle(
                          fontFamily: 'Hero Sandwich Pro',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.laterBuySubtitle,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                    ],
                  ),
                  // Pending count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: QoffaColors.whiteSurface,
                      borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
                      border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.watch_later_outlined, color: QoffaColors.actionGreen, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '$pendingCount ${l10n.pendingCount}',
                          style: const TextStyle(
                            fontFamily: 'Hero Sandwich Pro',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Segmented Tabs: Active, Bought, Skipped
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                ),
                child: Row(
                  children: [
                    _buildTab(
                      label: '${l10n.tabActive} ($pendingCount)',
                      status: 'active',
                    ),
                    _buildTab(
                      label: l10n.tabBought,
                      status: 'bought',
                    ),
                    _buildTab(
                      label: l10n.tabSkipped,
                      status: 'skipped',
                    ),
                  ],
                ),
              ),
            ),

            // List of items
            Expanded(
              child: itemsAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            size: 64,
                            color: QoffaColors.secondarySage,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _activeTab == 'active'
                                ? 'No postponed items right now'
                                : 'No items in this tab',
                            style: const TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: QoffaColors.secondarySage,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _LaterBuyCard(
                        item: item,
                        onResolveBought: () => _resolveBought(item),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({required String label, required String status}) {
    final isSelected = _activeTab == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? QoffaColors.actionGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(QoffaTokens.radiusControls - 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? QoffaColors.whiteSurface : QoffaColors.primaryNavy,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resolveBought(LaterBuyItem item) async {
    final l10n = AppLocalizations.of(context);
    final target = item.targetPriceDzd ?? (item.observedPriceDzd * 0.9).round();
    final finalPrice = target; // Resolution price

    final result = WasItWorthWaitingService.calculate(
      observedPrice: DzdAmount(item.observedPriceDzd),
      observedQuantity: Decimal.parse(item.observedQuantity.toString()),
      observedUnitId: item.observedUnitId,
      observedDate: item.createdAt,
      finalPrice: DzdAmount(finalPrice),
      finalQuantity: Decimal.parse(item.observedQuantity.toString()),
      finalUnitId: item.observedUnitId,
      purchaseDate: DateTime.now(),
    );

    // Show "Was It Worth Waiting?" explanation dialog
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
          ),
          title: Row(
            children: [
              const Icon(Icons.savings_outlined, color: QoffaColors.actionGreen),
              const SizedBox(width: 10),
              Text(
                l10n.wasItWorthWaiting,
                style: const TextStyle(
                  fontFamily: 'Hero Sandwich Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.explanation,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Observed: ${item.observedPriceDzd} DA'),
                  Text('Bought: $finalPrice DA'),
                ],
              ),
            ],
          ),
          actions: [
            QoffaButton(
              label: 'Confirm Purchase',
              onTap: () async {
                final laterBuyRepo = ref.read(laterBuyRepositoryProvider);
                await laterBuyRepo.resolveAsBought(
                  laterBuyId: item.id,
                  quantity: item.observedQuantity,
                  unitId: item.observedUnitId,
                  finalPriceDzd: finalPrice,
                  isUnitPrice: false,
                  purchasedAt: DateTime.now(),
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _LaterBuyCard extends StatelessWidget {
  const _LaterBuyCard({
    required this.item,
    required this.onResolveBought,
  });

  final LaterBuyItem item;
  final VoidCallback onResolveBought;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPending = item.status == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(color: QoffaColors.softBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: QoffaColors.primaryNavy.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Icon, Title, and Trend Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint,
                  borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
                ),
                child: const Icon(
                  Icons.local_mall_outlined,
                  color: QoffaColors.actionGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product ${item.productId.substring(0, 6)}',
                      style: const TextStyle(
                        fontFamily: 'Hero Sandwich Pro',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.observedQuantity} ${item.observedUnitId}',
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 13,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPending)
                const PriceChangeBadge(differenceDzd: 200),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: 3 Price Badges
          Row(
            children: [
              Expanded(
                child: _PriceColumn(
                  label: l10n.observedPrice,
                  price: '${item.observedPriceDzd} DA',
                ),
              ),
              if (item.targetPriceDzd != null)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: QoffaColors.mintSurfaceTint,
                      borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                    ),
                    child: _PriceColumn(
                      label: l10n.targetPrice,
                      price: '${item.targetPriceDzd} DA',
                      color: QoffaColors.actionGreen,
                    ),
                  ),
                ),
            ],
          ),

          if (isPending) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, color: QoffaColors.actionGreen, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${l10n.reminder}: Next week',
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onResolveBought,
                  icon: const Icon(Icons.check_circle_outline, size: 18, color: QoffaColors.actionGreen),
                  label: Text(
                    l10n.boughtAction,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: QoffaColors.actionGreen,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  const _PriceColumn({
    required this.label,
    required this.price,
    this.color = QoffaColors.primaryNavy,
  });

  final String label;
  final String price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 11,
            color: QoffaColors.secondarySage,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          price,
          style: TextStyle(
            fontFamily: 'Hero Sandwich Pro',
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
