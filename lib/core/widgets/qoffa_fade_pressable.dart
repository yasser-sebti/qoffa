import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/qoffa_tokens.dart';

/// The quiet Qoffa interaction: opacity feedback only, without scale,
/// translation, ripple, elevation, or shadow.
class QoffaFadePressable extends StatefulWidget {
  const QoffaFadePressable({
    required this.child,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(QoffaTokens.radiusControls),
    ),
    this.enabled = true,
    this.enableHaptics = false,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final bool enabled;
  final bool enableHaptics;

  @override
  State<QoffaFadePressable> createState() => _QoffaFadePressableState();
}

class _QoffaFadePressableState extends State<QoffaFadePressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (mounted && _pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: widget.enabled,
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
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: AnimatedOpacity(
          duration: QoffaTokens.motionFast,
          opacity: !widget.enabled ? 0.5 : (_pressed ? 0.56 : 1),
          child: widget.child,
        ),
      ),
    ),
  );
}
