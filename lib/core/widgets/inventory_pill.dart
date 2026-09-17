import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';

class InventoryPill extends StatelessWidget {
  const InventoryPill({
    required this.label,
    this.value,
    this.icon,
    this.backgroundColor = QoffaColors.whiteSurface,
    this.borderColor = QoffaColors.softBorder,
    this.textColor = QoffaColors.primaryNavy,
    this.height = 42.0,
    this.fontSize = 14.0,
    this.onTap,
    super.key,
  });

  final String label;
  final String? value;
  final IconData? icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double height;
  final double fontSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
        border: Border.all(color: borderColor, width: 2.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize * 1.3, color: textColor),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 1.0,
            ),
          ),
          if (value != null && value!.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              value!,
              style: TextStyle(
                fontFamily: 'Hero Sandwich Pro',
                fontSize: fontSize * 1.15,
                fontWeight: FontWeight.w800,
                color: textColor,
                height: 1.0,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: pill);
    }
    return pill;
  }
}

/// A compact status pill specifically for price changes (e.g., +20 DA, -15 DA)
class PriceChangeBadge extends StatelessWidget {
  const PriceChangeBadge({
    required this.differenceDzd,
    this.fontSize = 14.0,
    super.key,
  });

  final int differenceDzd;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final isIncrease = differenceDzd > 0;
    final isDecrease = differenceDzd < 0;

    final bgColor = isIncrease
        ? QoffaColors.warningCoral
        : isDecrease
        ? QoffaColors.brandGreen
        : QoffaColors.softBorder;

    final textColor = (isIncrease || isDecrease)
        ? QoffaColors.whiteSurface
        : QoffaColors.primaryNavy;

    final sign = isIncrease ? '+' : '';
    final text = '$sign$differenceDzd DA';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isIncrease
                ? Icons.arrow_outward_rounded
                : isDecrease
                ? Icons.arrow_downward_rounded
                : Icons.remove_rounded,
            color: textColor,
            size: fontSize * 1.1,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: textColor,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
