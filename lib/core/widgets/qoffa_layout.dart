import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';
import 'qoffa_tactile_pressable.dart';

class QoffaContentWidth extends StatelessWidget {
  const QoffaContentWidth({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: QoffaTokens.contentMaxWidth),
      child: child,
    ),
  );
}

class QoffaCard extends StatelessWidget {
  const QoffaCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = QoffaTokens.radiusMajor,
    this.color,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      ),
    );
  }
}

class QoffaEmptyState extends StatelessWidget {
  const QoffaEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => QoffaCard(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: QoffaColors.mintSurfaceTint,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 36, color: QoffaColors.actionGreen),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Hero Sandwich Pro',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: QoffaColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            height: 1.45,
            color: QoffaColors.secondarySage,
          ),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 18),
          QoffaTactilePressable.filled(label: actionLabel!, onTap: onAction!),
        ],
      ],
    ),
  );
}
