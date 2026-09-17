import 'package:flutter/material.dart';
import '../../app/theme/qoffa_tokens.dart';

/// A restrained entrance animation shared by cards, sections, and empty states.
class QoffaReveal extends StatefulWidget {
  const QoffaReveal({
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.035),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  State<QoffaReveal> createState() => _QoffaRevealState();
}

class _QoffaRevealState extends State<QoffaReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) return widget.child;
    return AnimatedSlide(
      duration: QoffaTokens.motionSlow,
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : widget.offset,
      child: AnimatedOpacity(
        duration: QoffaTokens.motionSlow,
        curve: Curves.easeOutCubic,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}

class QoffaAnimatedSwap extends StatelessWidget {
  const QoffaAnimatedSwap({required this.child, this.layoutKey, super.key});

  final Widget child;
  final Object? layoutKey;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return child;
    return AnimatedSwitcher(
      duration: QoffaTokens.motionMedium,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.985, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(key: ValueKey(layoutKey), child: child),
    );
  }
}
