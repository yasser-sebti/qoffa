import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/utils/qoffa_number_format.dart';
import '../../../core/widgets/qoffa_animated_counter.dart';
import '../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../../insights/domain/services/was_it_worth_waiting_service.dart';
import '../data/later_buy_repository.dart';

/// Modal bottom sheet to resolve a Later Buy item as bought.
/// Modeled after [QoffaNewStoreSheet] with tactile buttons (Cancel + Confirm)
/// and full typography compliance.
class QoffaResolveLaterBuySheet extends ConsumerStatefulWidget {
  const QoffaResolveLaterBuySheet({
    super.key,
    required this.entry,
  });

  final LaterBuyListEntry entry;

  static Future<WasItWorthWaitingResult?> show(
    BuildContext context, {
    required LaterBuyListEntry entry,
  }) {
    return showModalBottomSheet<WasItWorthWaitingResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.90,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(QoffaTokens.radiusMajor),
            ),
          ),
          child: SafeArea(
            top: false,
            child: QoffaResolveLaterBuySheet(entry: entry),
          ),
        ),
      ),
    );
  }

  @override
  ConsumerState<QoffaResolveLaterBuySheet> createState() =>
      _QoffaResolveLaterBuySheetState();
}

class _QoffaResolveLaterBuySheetState
    extends ConsumerState<QoffaResolveLaterBuySheet> {
  late final TextEditingController _priceController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.entry.item;
    final initialPrice = item.observedPriceDzd;
    _priceController = TextEditingController(text: initialPrice.toString());
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final l10n = AppLocalizations.of(context);
    final raw = _priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    final finalPrice = int.tryParse(raw);
    if (finalPrice == null || finalPrice <= 0) {
      QoffaToast.show(
        message: l10n.errorMessage('Invalid price'),
        color: QoffaColors.warningCoral,
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final item = widget.entry.item;
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

      await ref.read(laterBuyRepositoryProvider).resolveAsBought(
            laterBuyId: item.id,
            quantity: item.observedQuantity,
            unitId: item.observedUnitId,
            finalPriceDzd: finalPrice,
            isUnitPrice: false,
            purchasedAt: DateTime.now(),
            storeId: item.storeId,
          );

      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        QoffaToast.show(
          message: l10n.errorMessage(e),
          color: QoffaColors.warningCoral,
        );
      }
    }
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
    return const Icon(
      Icons.shopping_bag_outlined,
      color: QoffaColors.actionGreen,
      size: 26,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = widget.entry;
    final item = entry.item;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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

          // Title
          Text(
            l10n.resolveBoughtTitle,
            style: const TextStyle(
              fontFamily: QoffaFontFamily.display,
              fontFamilyFallback: QoffaFontFamily.fallback,
              fontSize: QoffaFontSize.headlineSmall,
              fontWeight: FontWeight.w900,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 16),

          // Product Summary Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4FAF6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: QoffaColors.softBorder,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Thumbnail container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: QoffaColors.softBorder,
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Center(child: _buildProductPreview(entry.productName)),
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
                          fontFamily: QoffaFontFamily.display,
                          fontFamilyFallback: QoffaFontFamily.fallback,
                          fontSize: QoffaFontSize.titleSmall,
                          fontWeight: FontWeight.w900,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${item.observedQuantity} ${l10n.unitName(item.observedUnitId)}${entry.storeName != null ? ' · ${entry.storeName}' : ''}',
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
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Price reference chips
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7F4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: QoffaColors.softBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.observedPrice,
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.body,
                          fontSize: QoffaFontSize.caption,
                          fontWeight: FontWeight.w600,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${QoffaNumberFormat.format(item.observedPriceDzd, isArabic: l10n.isArabic)} DA',
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.display,
                          fontFamilyFallback: QoffaFontFamily.fallback,
                          fontSize: QoffaFontSize.bodyMedium,
                          fontWeight: FontWeight.w900,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (item.targetPriceDzd != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: QoffaColors.mintSurfaceTint,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: QoffaColors.actionGreen.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.targetPrice,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.body,
                            fontSize: QoffaFontSize.caption,
                            fontWeight: FontWeight.w600,
                            color: QoffaColors.actionGreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${QoffaNumberFormat.format(item.targetPriceDzd!, isArabic: l10n.isArabic)} DA',
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.display,
                            fontFamilyFallback: QoffaFontFamily.fallback,
                            fontSize: QoffaFontSize.bodyMedium,
                            fontWeight: FontWeight.w900,
                            color: QoffaColors.actionGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 18),

          // Total Price Input Field
          TextField(
            controller: _priceController,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontFamily: QoffaFontFamily.body,
              fontSize: QoffaFontSize.titleSmall,
              fontWeight: FontWeight.w700,
              color: QoffaColors.primaryNavy,
            ),
            cursorColor: QoffaColors.actionGreen,
            decoration: InputDecoration(
              labelText: l10n.totalPrice,
              prefixIcon: const Icon(
                Icons.payments_rounded,
                color: QoffaColors.actionGreen,
              ),
              suffixText: 'DA',
              suffixStyle: const TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: QoffaFontSize.bodySmall,
                fontWeight: FontWeight.w700,
                color: QoffaColors.primaryNavy,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),

          // Live dynamic savings feedback with smooth fade and swipe-up expansion
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Builder(
              builder: (context) {
                final raw = _priceController.text.replaceAll(RegExp(r'[^\d]'), '');
                final entered = int.tryParse(raw) ?? 0;
                final diff = entered > 0 ? item.observedPriceDzd - entered : 0;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.25),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: entered <= 0 || diff == 0
                      ? const SizedBox.shrink(key: ValueKey('empty_hint'))
                      : diff > 0
                          ? Padding(
                              key: const ValueKey('savings_hint'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.savings_rounded,
                                    color: QoffaColors.actionGreen,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.isArabic
                                        ? 'ستوفّر '
                                        : (l10n.isFrench
                                            ? 'Vous économisez '
                                            : 'You save '),
                                    style: const TextStyle(
                                      fontFamily: QoffaFontFamily.body,
                                      fontSize: QoffaFontSize.captionMedium,
                                      fontWeight: FontWeight.w700,
                                      color: QoffaColors.actionGreen,
                                    ),
                                  ),
                                  QoffaAnimatedCounter(
                                    value: diff,
                                    suffix: l10n.isArabic ? ' دج' : ' DA',
                                    style: const TextStyle(
                                      fontFamily: QoffaFontFamily.body,
                                      fontSize: QoffaFontSize.captionMedium,
                                      fontWeight: FontWeight.w800,
                                      color: QoffaColors.actionGreen,
                                    ),
                                  ),
                                  Text(
                                    l10n.isArabic
                                        ? ' مقارنة بالسعر المرصود!'
                                        : (l10n.isFrench
                                            ? ' par rapport au prix observé !'
                                            : ' vs observed price!'),
                                    style: const TextStyle(
                                      fontFamily: QoffaFontFamily.body,
                                      fontSize: QoffaFontSize.captionMedium,
                                      fontWeight: FontWeight.w700,
                                      color: QoffaColors.actionGreen,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              key: const ValueKey('higher_hint'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up_rounded,
                                    color: Color(0xFFF97316),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  QoffaAnimatedCounter(
                                    value: -diff,
                                    suffix: l10n.isArabic ? ' دج' : ' DA',
                                    style: const TextStyle(
                                      fontFamily: QoffaFontFamily.body,
                                      fontSize: QoffaFontSize.captionMedium,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFF97316),
                                    ),
                                  ),
                                  Text(
                                    l10n.isArabic
                                        ? ' أعلى من السعر المرصود'
                                        : (l10n.isFrench
                                            ? ' de plus que le prix observé'
                                            : ' higher than observed price'),
                                    style: const TextStyle(
                                      fontFamily: QoffaFontFamily.body,
                                      fontSize: QoffaFontSize.captionMedium,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFF97316),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons: Cancel & Confirm (using QoffaTactilePressable)
          Row(
            children: [
              Expanded(
                child: QoffaTactilePressable.outline(
                  height: 52,
                  label: l10n.cancel,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QoffaTactilePressable.filled(
                  height: 52,
                  label: l10n.confirm,
                  icon: Icons.check_circle_rounded,
                  enabled: !_isSaving,
                  onTap: _handleConfirm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
