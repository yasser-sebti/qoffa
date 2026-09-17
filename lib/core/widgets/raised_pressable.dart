import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme/qoffa_tokens.dart';

/// A tactile 3D pressable widget inspired by physical arcade buttons.
///
/// On pointer down, the top face translates downward by [shadowOffset]
/// into the solid shadow layer base, providing immediate visual and physical feedback.
class RaisedPressable extends StatefulWidget {
  const RaisedPressable({
    required this.child,
    required this.onTap,
    this.width,
    this.height,
    this.radius = const BorderRadius.all(Radius.circular(QoffaTokens.radiusCompact)),
    this.shadowOffset = QoffaTokens.buttonShadowOffset,
    this.shadowColor = const Color(0xFF056629),
    this.enabled = true,
    this.actionDelay = const Duration(milliseconds: 60),
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
  final Duration actionDelay;

  @override
  State<RaisedPressable> createState() => _RaisedPressableState();
}

class _RaisedPressableState extends State<RaisedPressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _tapTimer;
  bool _isDisposed = false;

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
    _isDisposed = true;
    _cancelPendingTap();
    _controller.dispose();
    super.dispose();
  }

  void _cancelPendingTap() {
    _tapTimer?.cancel();
    _tapTimer = null;
  }

  void _press() {
    if (_isDisposed || !mounted || !widget.enabled) return;
    _controller.forward();
  }

  void _release() {
    if (_isDisposed || !mounted) return;
    _controller.reverse();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    _cancelPendingTap();
    _tapTimer = Timer(widget.actionDelay, () {
      _tapTimer = null;
      if (mounted && widget.enabled) {
        widget.onTap();
      }
    });
  }

  void _handleTapCancel() {
    _cancelPendingTap();
    _release();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = widget.height;

    final content = SizedBox(
      width: widget.width,
      height: effectiveHeight != null
          ? effectiveHeight + widget.shadowOffset
          : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom physical shadow slab
          Positioned(
            left: 0.5,
            right: 0.5,
            top: widget.shadowOffset,
            bottom: 0,
            child: Container(
              height: effectiveHeight,
              decoration: BoxDecoration(
                color: widget.shadowColor,
                borderRadius: widget.radius,
              ),
            ),
          ),
          // Top face that translates downwards on press
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final eased = Curves.easeOutCubic.transform(_controller.value);
              return Transform.translate(
                offset: Offset(0, widget.shadowOffset * eased),
                child: child,
              );
            },
            child: Container(
              width: widget.width,
              height: effectiveHeight,
              decoration: BoxDecoration(
                borderRadius: widget.radius,
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {
        _cancelPendingTap();
        _press();
      },
      onPointerUp: (_) => _release(),
      onPointerCancel: (_) => _handleTapCancel(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: content,
      ),
    );
  }
}
