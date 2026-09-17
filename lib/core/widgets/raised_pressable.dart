import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/qoffa_tokens.dart';

/// Qoffa's tactile interaction, adapted from Prism's two-layer buttons.
/// A solid darker base stays fixed while the face travels down into it.
class RaisedPressable extends StatefulWidget {
  const RaisedPressable({
    required this.child,
    required this.onTap,
    this.width,
    this.height,
    this.radius = const BorderRadius.all(
      Radius.circular(QoffaTokens.radiusCompact),
    ),
    this.shadowOffset = QoffaTokens.buttonShadowOffset,
    this.shadowColor = const Color(0xFF056629),
    this.enabled = true,
    this.enableHaptics = true,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final BorderRadius radius;
  final double shadowOffset;
  final Color shadowColor;
  final bool enabled;
  final bool enableHaptics;

  @override
  State<RaisedPressable> createState() => _RaisedPressableState();
}

class _RaisedPressableState extends State<RaisedPressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: QoffaTokens.pressDuration,
      reverseDuration: QoffaTokens.pressDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _press() {
    if (!mounted || !widget.enabled) return;
    if (widget.enableHaptics) HapticFeedback.selectionClick();
    _controller.forward();
  }

  void _release() {
    if (!mounted) return;
    _controller.reverse();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    widget.onTap();
  }

  void _handleTapCancel() {
    _release();
  }

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: widget.width,
      height: widget.height == null
          ? null
          : widget.height! + widget.shadowOffset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0.5,
            right: 0.5,
            top: widget.shadowOffset,
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.shadowColor,
                borderRadius: widget.radius,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: widget.height,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final eased = Curves.easeOutCubic.transform(_controller.value);
                return Transform.translate(
                  offset: Offset(0, widget.shadowOffset * eased),
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: widget.radius,
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      enabled: widget.enabled,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleTap();
              return null;
            },
          ),
        },
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => _press(),
          onPointerUp: (_) => _release(),
          onPointerCancel: (_) => _handleTapCancel(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            child: AnimatedOpacity(
              duration: QoffaTokens.motionFast,
              opacity: widget.enabled ? 1 : 0.58,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
