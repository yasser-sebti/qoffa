import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'particle_effect_presets.dart';
import 'particle_model.dart';
import 'particle_splash_painter.dart';

/// Screen-level overlay that manages and renders high-performance particle bursts
/// independently from disappearing card widgets.
///
/// Ensures particles continue their full ballistic trajectory, gravity fall,
/// and graceful fade even after cards are completely swiped up and removed from the list.
class QoffaParticleOverlay extends StatefulWidget {
  const QoffaParticleOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  /// Global key for the shell-level particle overlay, ensuring particles can always
  /// be spawned even from routes, modals, or contexts that are not descendants of local overlays.
  static final GlobalKey<QoffaParticleOverlayState> shellKey =
      GlobalKey<QoffaParticleOverlayState>(debugLabel: 'qoffa_particle_shell');

  /// Spawns a particle burst at [globalOrigin] using the provided [config], optionally spread over [spawnWidth].
  static void spawn(
    BuildContext context, {
    required Offset globalOrigin,
    required ParticleEffectConfig config,
    double spawnWidth = 0.0,
  }) {
    final state = context.findAncestorStateOfType<QoffaParticleOverlayState>() ??
        shellKey.currentState;
    state?.spawnBurst(
      globalOrigin: globalOrigin,
      config: config,
      spawnWidth: spawnWidth,
    );
  }

  static QoffaParticleOverlayState? of(BuildContext context) {
    return context.findAncestorStateOfType<QoffaParticleOverlayState>() ??
        shellKey.currentState;
  }

  @override
  State<QoffaParticleOverlay> createState() => QoffaParticleOverlayState();
}

class QoffaParticleOverlayState extends State<QoffaParticleOverlay>
    with TickerProviderStateMixin {
  final List<Particle> _activeParticles = [];
  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  /// Spawns a new burst of particles from screen-space [globalOrigin], spread across [spawnWidth].
  void spawnBurst({
    required Offset globalOrigin,
    required ParticleEffectConfig config,
    double spawnWidth = 0.0,
  }) {
    if (!mounted) return;

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final localOrigin =
        box != null ? box.globalToLocal(globalOrigin) : globalOrigin;

    // Add new particles to the persistent overlay simulation
    _activeParticles.addAll(config.spawn(localOrigin, spawnWidth: spawnWidth));

    if (_ticker != null && !_ticker!.isActive) {
      _lastElapsed = Duration.zero;
      _ticker!.start();
    }
    setState(() {});
  }

  void _onTick(Duration elapsed) {
    if (!mounted) {
      _ticker?.stop();
      return;
    }

    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }

    final dtSeconds = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    // Prune particles that have already died
    _activeParticles.removeWhere((p) => !p.isAlive);

    // Update remaining particles by frame delta
    for (var i = 0; i < _activeParticles.length; i++) {
      _activeParticles[i].update(dtSeconds);
    }

    // Prune newly expired particles
    _activeParticles.removeWhere((p) => !p.isAlive);

    if (_activeParticles.isEmpty) {
      _ticker?.stop();
      _lastElapsed = Duration.zero;
      if (mounted) setState(() {});
      return;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _ticker?.stop();
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (_activeParticles.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: ParticleSplashPainter(
                    particles: _activeParticles,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
