import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/qoffa_colors.dart';
import '../../../../app/theme/qoffa_tokens.dart';
import '../../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../data/market_price_repository.dart';

class MarketPriceCard extends StatelessWidget {
  const MarketPriceCard({
    required this.item,
    required this.onAddToList,
    super.key,
  });

  final MarketPriceItem item;
  final VoidCallback onAddToList;

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return QoffaColors.actionGreen;
    }
  }

  IconData _resolveIcon(String iconKey) {
    switch (iconKey) {
      case 'apple':
        return Icons.eco_rounded;
      case 'meat':
        return Icons.restaurant_rounded;
      case 'egg':
        return Icons.egg_outlined;
      case 'bread':
        return Icons.bakery_dining_rounded;
      case 'drop':
        return Icons.local_grocery_store_rounded;
      case 'coffee':
        return Icons.local_cafe_rounded;
      case 'sparkle':
        return Icons.cleaning_services_rounded;
      default:
        return Icons.shopping_basket_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catColor = _parseColor(item.categoryColorHex);
    final dateStr = intl.DateFormat.yMMMd(l10n.languageCode).format(item.latestPurchasedAt.toLocal());
    final hasBetterPrice = item.minPriceDzd != null &&
        item.cheapestStoreName != null &&
        item.minPriceDzd! < item.latestPriceDzd;
    final diff = item.priceDiff;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: QoffaColors.primaryNavy.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Department Badge & Barcode
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _resolveIcon(item.categoryIconKey),
                      size: 13,
                      color: catColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item.categoryName,
                      style: TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: QoffaFontSize.caption,
                        fontWeight: FontWeight.w700,
                        color: catColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (item.barcode != null && item.barcode!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.qr_code_rounded,
                        size: 13,
                        color: QoffaColors.secondarySage,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Product Name & Brand
          Text(
            item.productName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: QoffaFontFamily.display,
              fontFamilyFallback: QoffaFontFamily.fallback,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: QoffaColors.primaryNavy,
            ),
          ),
          if (item.brand != null && item.brand!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              item.brand!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: QoffaFontSize.caption,
                color: QoffaColors.secondarySage,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Price & Add to List Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${item.latestPriceDzd} دج',
                style: const TextStyle(
                  fontFamily: QoffaFontFamily.display,
                  fontFamilyFallback: QoffaFontFamily.fallback,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/ ${item.preferredUnitId}',
                style: const TextStyle(
                  fontFamily: QoffaFontFamily.body,
                  fontSize: QoffaFontSize.caption,
                  color: QoffaColors.secondarySage,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              QoffaTactilePressable.filled(
                height: 38,
                width: 38,
                icon: Icons.add_rounded,
                backgroundColor: QoffaColors.actionGreen,
                onTap: onAddToList,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFEDF4EF)),
          const SizedBox(height: 8),

          // Store & Date Metadata Row
          Row(
            children: [
              const Icon(
                Icons.storefront_rounded,
                size: 14,
                color: QoffaColors.secondarySage,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.latestStoreName ?? l10n.allStores,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: QoffaFontFamily.body,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: QoffaColors.secondarySage,
                  ),
                ),
              ),
              const Icon(
                Icons.schedule_rounded,
                size: 13,
                color: QoffaColors.secondarySage,
              ),
              const SizedBox(width: 4),
              Text(
                dateStr,
                style: const TextStyle(
                  fontFamily: QoffaFontFamily.body,
                  fontSize: 12,
                  color: QoffaColors.secondarySage,
                ),
              ),
            ],
          ),

          // Comparison tag if better price available or price trend
          if (hasBetterPrice) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: QoffaColors.mintSurfaceTint,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: QoffaColors.actionGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_down_rounded,
                    size: 14,
                    color: QoffaColors.actionGreen,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${l10n.cheapestAt} ${item.cheapestStoreName} (${item.minPriceDzd} دج)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.actionGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (diff != null && diff != 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: diff < 0
                    ? QoffaColors.mintSurfaceTint
                    : const Color(0xFFFFECEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    diff < 0
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                    size: 13,
                    color: diff < 0
                        ? QoffaColors.actionGreen
                        : const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    diff < 0
                        ? 'انخفض ${diff.abs()} دج'
                        : 'ارتفع $diff دج',
                    style: TextStyle(
                      fontFamily: QoffaFontFamily.body,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: diff < 0
                          ? QoffaColors.actionGreen
                          : const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
