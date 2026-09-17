import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';
import 'raised_pressable.dart';

class QoffaIconButton extends StatelessWidget {
  const QoffaIconButton({
    required this.icon,
    required this.onTap,
    this.size = 52.0,
    this.iconSize = 26.0,
    this.faceColor = QoffaColors.whiteSurface,
    this.iconColor = QoffaColors.primaryNavy,
    this.shadowColor,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color faceColor;
  final Color iconColor;
  final Color? shadowColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final effectiveShadow = shadowColor ?? QoffaColors.smartShadow(faceColor);
    final radius = BorderRadius.circular(QoffaTokens.radiusControls);

    final button = RaisedPressable(
      onTap: onTap,
      width: size,
      height: size,
      radius: radius,
      shadowOffset: 4.0,
      shadowColor: effectiveShadow,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: faceColor,
          borderRadius: radius,
          border: Border.all(color: QoffaColors.softBorder, width: 1.5),
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: iconSize),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
