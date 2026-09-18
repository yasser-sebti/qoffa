import 'dart:async';
import 'package:flutter/material.dart';
import 'particle_effect_presets.dart';
import 'qoffa_particle_overlay.dart';

/// Controller interface to trigger particle pop and dismiss animations on a card.
abstract class QoffaCardActionController {
  Future<void> trigger({
    required ParticleEffectConfig config,
    Offset? burstOrigin,
    required Future<void> Function() onCommit,
  });
}

/// A versatile, high-performance wrapper widget that adds:
/// 1. Tactile card pop-up spring
/// 2. Screen-level decoupled particle splash with realistic physics
/// 3. Smooth upward swipe glide and fade
/// 4. Silky-smooth vertical height collapse that glides the list up effortlessly
class QoffaCardActionAnimator extends StatefulWidget {
  const QoffaCardActionAnimator({
    required this.child,
    this.controller,
    super.key,
  });

  final Widget child;
  final void Function(QoffaCardActionController controller)? controller;

  @override
  State<QoffaCardActionAnimator> createState() =>
      QoffaCardActionAnimatorState();
}

class QoffaCardActionAnimatorState extends State<QoffaCardActionAnimator>
    with SingleTickerProviderStateMixin
    implements QoffaCardActionController {
  late final AnimationController _cardAnimController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;

  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _initAnimations(ParticleEffectPresets.celebration);
    widget.controller?.call(this);
  }

  void _initAnimations(ParticleEffectConfig config) {
    // 1. Pop spring: quick scale pop up, then gentle taper
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: config.cardPopScale)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 24,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: config.cardPopScale, end: 0.90)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 76,
      ),
    ]).animate(_cardAnimController);

    // 2. Swipe up glide: slides noticeably upward as it dissolves
    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: ConstantTween<Offset>(Offset.zero),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -0.42),
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 82,
      ),
    ]).animate(_cardAnimController);

    // 3. Smooth fade out
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 22,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 78,
      ),
    ]).animate(_cardAnimController);

    // 4. Smooth size collapse: cards beneath glide up seamlessly
    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 26,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 74,
      ),
    ]).animate(_cardAnimController);
  }

  @override
  void dispose() {
    _cardAnimController.dispose();
    super.dispose();
  }

  /// Triggers the full realistic particle splash, swipe-up fade, and smooth collapse.
  @override
  Future<void> trigger({
    required ParticleEffectConfig config,
    Offset? burstOrigin,
    required Future<void> Function() onCommit,
  }) async {
    if (!mounted || _isDismissing) return;

    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      await onCommit();
      return;
    }

    _isDismissing = true;
    _initAnimations(config);

    // Spawn particles into the screen-level overlay so they continue their full
    // realistic flight and gravity fall even after the card is swiped up and gone
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final cardCenter = renderBox.localToGlobal(
        burstOrigin ??
            Offset(renderBox.size.width * 0.5, renderBox.size.height * 0.40),
      );

      QoffaParticleOverlay.spawn(
        context,
        globalOrigin: cardCenter,
        config: config,
        spawnWidth: renderBox.size.width * 0.85,
      );
    }

    // First: play tactile pop, upward swipe glide, fade out, and vertical size collapse
    // so the card visibly glides up and the list below smoothly slides up
    try {
      await _cardAnimController.forward(from: 0.0);
    } catch (_) {
      // Catch in case widget was disposed
    }

    // Second: now that the card is fully swiped up and collapsed to 0 height,
    // commit status change to the repository without causing any list jump
    await onCommit();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
