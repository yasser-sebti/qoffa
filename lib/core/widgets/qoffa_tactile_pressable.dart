import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';

enum QoffaTactileStyle { outline, fill }

/// QoffaTactilePressable: Qoffa's signature tactile click & hover interaction.
/// Provides physical micro-depression feedback on tap and clean border/fill
/// transitions on hover without any blurry shadows or glows.
///
/// Available styles:
/// - [QoffaTactilePressable.outline] for crisp outlined buttons / containers.
/// - [QoffaTactilePressable.filled] for vibrant solid fill action buttons.
class QoffaTactilePressable extends StatefulWidget {
  const QoffaTactilePressable({
    required this.onTap,
    this.child,
    this.label,
    this.icon,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.hoverBackgroundColor,
    this.hoverBorderColor,
    this.textColor,
    this.iconColor,
    this.borderWidth = 1.5,
    this.padding,
    this.height,
    this.width,
    this.enabled = true,
    this.enableHaptics = true,
    this.enableRepeatOnHold = false,
    this.pressDepression = 1.8,
    super.key,
  })  : style = QoffaTactileStyle.outline,
        assert(
          child != null || label != null || icon != null,
          'Either child, label, or icon must be provided',
        );

  const QoffaTactilePressable.outline({
    required this.onTap,
    this.child,
    this.label,
    this.icon,
    this.borderRadius,
    this.backgroundColor = QoffaColors.whiteSurface,
    this.borderColor = QoffaColors.softBorder,
    this.hoverBackgroundColor = QoffaColors.mintSurfaceTint,
    this.hoverBorderColor = QoffaColors.actionGreen,
    this.textColor = QoffaColors.primaryNavy,
    this.iconColor = QoffaColors.primaryNavy,
    this.borderWidth = 1.5,
    this.padding,
    this.height = 52.0,
    this.width,
    this.enabled = true,
    this.enableHaptics = true,
    this.enableRepeatOnHold = false,
    this.pressDepression = 1.8,
    super.key,
  })  : style = QoffaTactileStyle.outline,
        assert(
          child != null || label != null || icon != null,
          'Either child, label, or icon must be provided',
        );

  const QoffaTactilePressable.filled({
    required this.onTap,
    this.child,
    this.label,
    this.icon,
    this.borderRadius,
    this.backgroundColor = QoffaColors.actionGreen,
    this.borderColor = QoffaColors.actionGreen,
    this.hoverBackgroundColor = QoffaColors.pressedGreen,
    this.hoverBorderColor = QoffaColors.pressedGreen,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.borderWidth = 1.5,
    this.padding,
    this.height = 52.0,
    this.width,
    this.enabled = true,
    this.enableHaptics = true,
    this.enableRepeatOnHold = false,
    this.pressDepression = 1.8,
    super.key,
  })  : style = QoffaTactileStyle.fill,
        assert(
          child != null || label != null || icon != null,
          'Either child, label, or icon must be provided',
        );

  const QoffaTactilePressable.fill({
    required VoidCallback onTap,
    Widget? child,
    String? label,
    IconData? icon,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? borderColor,
    Color? hoverBackgroundColor,
    Color? hoverBorderColor,
    Color? textColor,
    Color? iconColor,
    double borderWidth = 1.5,
    EdgeInsetsGeometry? padding,
    double? height = 52.0,
    double? width,
    bool enabled = true,
    bool enableHaptics = true,
    bool enableRepeatOnHold = false,
    double pressDepression = 1.8,
    Key? key,
  }) : this.filled(
          onTap: onTap,
          child: child,
          label: label,
          icon: icon,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor ?? QoffaColors.actionGreen,
          borderColor: borderColor ?? QoffaColors.actionGreen,
          hoverBackgroundColor: hoverBackgroundColor ?? QoffaColors.pressedGreen,
          hoverBorderColor: hoverBorderColor ?? QoffaColors.pressedGreen,
          textColor: textColor ?? Colors.white,
          iconColor: iconColor ?? Colors.white,
          borderWidth: borderWidth,
          padding: padding,
          height: height,
          width: width,
          enabled: enabled,
          enableHaptics: enableHaptics,
          enableRepeatOnHold: enableRepeatOnHold,
          pressDepression: pressDepression,
          key: key,
        );

  final QoffaTactileStyle style;
  final Widget? child;
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? hoverBackgroundColor;
  final Color? hoverBorderColor;
  final Color? textColor;
  final Color? iconColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final bool enabled;
  final bool enableHaptics;
  final bool enableRepeatOnHold;
  final double pressDepression;

  @override
  State<QoffaTactilePressable> createState() => _QoffaTactilePressableState();
}

class _QoffaTactilePressableState extends State<QoffaTactilePressable> {
  bool _isPressed = false;
  bool _isHovered = false;
  Timer? _initialTimer;
  Timer? _periodicTimer;

  void _startRepeatTimer() {
    _stopRepeatTimer();
    _initialTimer = Timer(const Duration(milliseconds: 260), () {
      _periodicTimer = Timer.periodic(const Duration(milliseconds: 75), (_) {
        if (!widget.enabled || !mounted) {
          _stopRepeatTimer();
          return;
        }
        if (widget.enableHaptics) HapticFeedback.selectionClick();
        widget.onTap();
      });
    });
  }

  void _stopRepeatTimer() {
    _initialTimer?.cancel();
    _initialTimer = null;
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  @override
  void dispose() {
    _stopRepeatTimer();
    super.dispose();
  }

  void _setPressed(bool pressed) {
    if (mounted && _isPressed != pressed) {
      setState(() => _isPressed = pressed);
    }
  }

  void _setHovered(bool hovered) {
    if (mounted && _isHovered != hovered) {
      setState(() => _isHovered = hovered);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFill = widget.style == QoffaTactileStyle.fill;
    final defaultBg =
        isFill ? QoffaColors.actionGreen : const Color(0xFFF4FAF6);
    final defaultBr =
        isFill ? QoffaColors.actionGreen : QoffaColors.softBorder;
    final defaultHBg =
        isFill ? QoffaColors.pressedGreen : QoffaColors.mintSurfaceTint;
    final defaultHBr =
        isFill ? QoffaColors.pressedGreen : QoffaColors.actionGreen;

    final radius = widget.borderRadius ??
        BorderRadius.circular(QoffaTokens.radiusControls);
    final bgColor = widget.backgroundColor ?? defaultBg;
    final brColor = widget.borderColor ?? defaultBr;
    final hBgColor = widget.hoverBackgroundColor ?? defaultHBg;
    final hBrColor = widget.hoverBorderColor ?? defaultHBr;

    final resolvedTextColor =
        widget.textColor ?? (isFill ? Colors.white : QoffaColors.primaryNavy);
    final resolvedIconColor =
        widget.iconColor ?? (isFill ? Colors.white : QoffaColors.primaryNavy);

    Widget innerContent;
    if (widget.child != null) {
      innerContent = widget.child!;
    } else if (widget.label != null) {
      innerContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 20, color: resolvedIconColor),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              widget.label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: QoffaFontSize.bodyMedium,
                fontWeight: FontWeight.w700,
                color: resolvedTextColor,
              ),
            ),
          ),
        ],
      );
    } else if (widget.icon != null) {
      innerContent = Icon(widget.icon, size: 24, color: resolvedIconColor);
    } else {
      innerContent = const SizedBox.shrink();
    }

    final finalBgColor =
        widget.enabled ? (_isHovered ? hBgColor : bgColor) : bgColor.withValues(alpha: 0.5);
    final finalBrColor =
        widget.enabled ? (_isHovered ? hBrColor : brColor) : brColor.withValues(alpha: 0.5);

    return MouseRegion(
      onEnter: widget.enabled ? (_) => _setHovered(true) : null,
      onExit: widget.enabled ? (_) => _setHovered(false) : null,
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled
            ? (_) {
                _setPressed(true);
                if (widget.enableRepeatOnHold) {
                  if (widget.enableHaptics) HapticFeedback.selectionClick();
                  widget.onTap();
                  _startRepeatTimer();
                }
              }
            : null,
        onTapUp: widget.enabled
            ? (_) {
                _setPressed(false);
                if (widget.enableRepeatOnHold) {
                  _stopRepeatTimer();
                }
              }
            : null,
        onTapCancel: widget.enabled
            ? () {
                _setPressed(false);
                if (widget.enableRepeatOnHold) {
                  _stopRepeatTimer();
                }
              }
            : null,
        onTap: widget.enabled
            ? () {
                if (!widget.enableRepeatOnHold) {
                  if (widget.enableHaptics) HapticFeedback.selectionClick();
                  widget.onTap();
                }
              }
            : null,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 60),
          curve: Curves.easeOutCubic,
          offset:
              _isPressed ? Offset(0, widget.pressDepression / 30) : Offset.zero,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 60),
            curve: Curves.easeOutCubic,
            scale: _isPressed ? 0.98 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOutCubic,
              width: widget.width,
              height: widget.height,
              padding: widget.padding ??
                  (widget.child == null
                      ? const EdgeInsets.symmetric(horizontal: 16)
                      : null),
              decoration: BoxDecoration(
                color: finalBgColor,
                borderRadius: radius,
                border: Border.all(
                  color: finalBrColor,
                  width: widget.borderWidth,
                ),
              ),
              alignment: Alignment.center,
              child: innerContent,
            ),
          ),
        ),
      ),
    );
  }
}
