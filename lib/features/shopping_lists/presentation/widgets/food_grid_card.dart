import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/qoffa_colors.dart';
import '../../../../app/theme/qoffa_tokens.dart';
import '../../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../data/market_price_repository.dart';

class FoodGridCard extends StatelessWidget {
  const FoodGridCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final MarketPriceItem item;
  final VoidCallback onTap;

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

  Color _resolveCategoryColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return QoffaColors.brandGreen;
    }
  }

  String _formatDate(DateTime date, String langCode) {
    if (langCode == 'ar') {
      final months = [
        'جانفي',
        'فيفري',
        'مارس',
        'أفريل',
        'ماي',
        'جوان',
        'جويلية',
        'أوت',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
      final mIndex = date.month - 1;
      final mName = (mIndex >= 0 && mIndex < months.length)
          ? months[mIndex]
          : '${date.month}';
      return '${date.day} $mName';
    } else if (langCode == 'fr') {
      final months = [
        'janv.',
        'févr.',
        'mars',
        'avr.',
        'mai',
        'juin',
        'juil.',
        'août',
        'sept.',
        'oct.',
        'nov.',
        'déc.',
      ];
      final mIndex = date.month - 1;
      final mName = (mIndex >= 0 && mIndex < months.length)
          ? months[mIndex]
          : '${date.month}';
      return '${date.day} $mName';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final mIndex = date.month - 1;
      final mName = (mIndex >= 0 && mIndex < months.length)
          ? months[mIndex]
          : '${date.month}';
      return '$mName ${date.day}';
    }
  }

  bool get _isCandiaMilk {
    final lower = item.productName.toLowerCase();
    final idLower = item.productId.toLowerCase();
    return lower.contains('كانديا') ||
        lower.contains('candia') ||
        idLower.contains('candia');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catColor = _resolveCategoryColor(item.categoryColorHex);
    final dateStr = _formatDate(item.latestPurchasedAt, l10n.languageCode);

    return QoffaTactilePressable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
          border: Border.all(
            color: QoffaColors.softBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            // Left: Image Preview
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 44,
                height: 44,
                color: catColor.withValues(alpha: 0.12),
                child: _isCandiaMilk
                    ? Image.asset(
                        'assets/images/candia_milk.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.local_drink_rounded,
                          size: 22,
                          color: catColor,
                        ),
                      )
                    : Icon(
                        _resolveIcon(item.categoryIconKey),
                        size: 22,
                        color: catColor,
                      ),
              ),
            ),

            const SizedBox(width: 8),

            // Middle: Name header + Date added subheader
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: QoffaColors.secondarySage,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            // Right: Price
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${item.latestPriceDzd}',
                  style: const TextStyle(
                    fontFamily: QoffaFontFamily.display,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: QoffaColors.brandGreen,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  l10n.currencySymbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 9.5,
                    color: QoffaColors.secondarySage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
