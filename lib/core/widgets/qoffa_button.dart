import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';
import 'raised_pressable.dart';

enum QoffaButtonVariant {
  primary, // Solid green face, white text
  secondary, // Outline or muted face
  coral, // Coral face for Later Buy / Danger
  white, // White face with colored text and shadow
}

class QoffaButton extends StatelessWidget {
  const QoffaButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.variant = QoffaButtonVariant.primary,
    this.height = 56.0,
    this.width,
    this.enabled = true,
    this.isLoading = false,
    this.fontSize = 18.0,
    this.shadowOffset = 5.0,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final QoffaButtonVariant variant;
  final double height;
  final double? width;
  final bool enabled;
  final bool isLoading;
  final double fontSize;
  final double shadowOffset;

  @override
  Widget build(BuildContext context) {
    Color faceColor;
    Color textColor;
    Color shadowColor;
    Border? border;

    switch (variant) {
      case QoffaButtonVariant.primary:
        faceColor = QoffaColors.actionGreen;
        textColor = QoffaColors.whiteSurface;
        shadowColor = QoffaColors.pressedGreen;
        break;
      case QoffaButtonVariant.secondary:
        faceColor = QoffaColors.mintSurfaceTint;
        textColor = QoffaColors.actionGreen;
        shadowColor = QoffaColors.softBorder;
        border = Border.all(color: QoffaColors.actionGreen, width: 2);
        break;
      case QoffaButtonVariant.coral:
        faceColor = QoffaColors.warningCoral;
        textColor = QoffaColors.whiteSurface;
        shadowColor = QoffaColors.warningCoralDeep;
        break;
      case QoffaButtonVariant.white:
        faceColor = QoffaColors.whiteSurface;
        textColor = QoffaColors.actionGreen;
        shadowColor = QoffaColors.softBorder;
        border = Border.all(color: QoffaColors.softBorder, width: 1.5);
        break;
    }

    if (!enabled) {
      faceColor = faceColor.withValues(alpha: 0.5);
      shadowColor = shadowColor.withValues(alpha: 0.45);
    }

    final radius = BorderRadius.circular(QoffaTokens.radiusCompact);

    return RaisedPressable(
      onTap: enabled && !isLoading ? onTap : () {},
      enabled: enabled && !isLoading,
      width: width ?? double.infinity,
      height: height,
      radius: radius,
      shadowOffset: shadowOffset,
      shadowColor: shadowColor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: faceColor,
          borderRadius: radius,
          border: border,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(textColor),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: textColor, size: 24),
                      const SizedBox(width: 10),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: fontSize,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          height: 1.1,
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
