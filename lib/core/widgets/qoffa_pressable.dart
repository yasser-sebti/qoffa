import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/qoffa_tokens.dart';

/// QoffaPressable: A tactile click-press interaction template.
///
/// Features:
/// - Same physical micro-depression and scale animation as [QoffaTactilePressable] on click/press.
/// - **Zero hover or highlight animation**: no background color changes, no border color shifts,
///   and no material ink ripples on hover.
/// - Crisp tactile feedback on press down and instant bounce back on release.
class QoffaPressable extends StatefulWidget {
  const QoffaPressable({
    required this.onTap,
    required this.child,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height,
    this.enabled = true,
    this.enableHaptics = true,
    this.pressDepression = 1.8,
    this.scaleDown = 0.98,
    super.key,
  });

  final VoidCallback onTap;
  final Widget child;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool enabled;
  final bool enableHaptics;
  final double pressDepression;
  final double scaleDown;

  @override
  State<QoffaPressable> createState() => _QoffaPressableState();
}

class _QoffaPressableState extends State<QoffaPressable> {
  bool _isPressed = false;

  void _setPressed(bool pressed) {
    if (mounted && _isPressed != pressed) {
      setState(() => _isPressed = pressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ??
        BorderRadius.circular(QoffaTokens.radiusControls);

    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
        onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
        onTapCancel: widget.enabled ? () => _setPressed(false) : null,
        onTap: widget.enabled
            ? () {
                if (widget.enableHaptics) HapticFeedback.selectionClick();
                widget.onTap();
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
            scale: _isPressed ? widget.scaleDown : 1.0,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: radius,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
