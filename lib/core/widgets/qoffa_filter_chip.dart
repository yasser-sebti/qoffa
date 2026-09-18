import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';

/// Reusable template toggle chip for filtering and sorting, matching the Notebook screen styling.
class QoffaFilterChip extends StatelessWidget {
  const QoffaFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
        child: AnimatedContainer(
          duration: QoffaTokens.motionMedium,
          padding: padding,
          decoration: BoxDecoration(
            color: isSelected
                ? QoffaColors.actionGreen
                : QoffaColors.whiteSurface,
            borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
            border: Border.all(
              color: isSelected
                  ? QoffaColors.actionGreen
                  : QoffaColors.softBorder,
              width: 1.4,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected ? Colors.white : QoffaColors.primaryNavy,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : QoffaColors.primaryNavy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
