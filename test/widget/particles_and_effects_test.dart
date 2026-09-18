import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/theme/qoffa_colors.dart';
import 'package:qoffa/core/particles_and_effects/particle_effect_presets.dart';
import 'package:qoffa/core/particles_and_effects/particle_model.dart';
import 'package:qoffa/core/particles_and_effects/particle_splash_painter.dart';
import 'package:qoffa/core/particles_and_effects/qoffa_card_action_animator.dart';
import 'package:qoffa/core/particles_and_effects/qoffa_particle_overlay.dart';

void main() {
  group('Particle Physics Engine Tests', () {
    test('Particle updates position, velocity, and gravity correctly', () {
      final particle = Particle(
        position: const Offset(100, 100),
        velocity: const Offset(50, -50),
        gravity: 1000.0,
        drag: 0.0,
        rotation: 0.0,
        rotationSpeed: 2.0,
        size: 8.0,
        color: Colors.green,
        maxLifeSeconds: 1.0,
        shape: ParticleShape.confettiQuad,
        tumbleSpeed: 5.0,
      );

      expect(particle.isAlive, isTrue);
      expect(particle.progress, 0.0);

      // Advance by 0.1s
      particle.update(0.1);

      expect(particle.currentAgeSeconds, closeTo(0.1, 0.001));
      // Gravity pulls downward: -50 + (1000 * 0.1) = +50
      expect(particle.velocity.dy, closeTo(50.0, 0.01));
      // Position updated with velocity
      expect(particle.position.dx, closeTo(105.0, 0.1));
      expect(particle.rotation, closeTo(0.2, 0.01));

      // Advance past lifetime
      particle.update(1.0);
      expect(particle.isAlive, isFalse);
      expect(particle.progress, 1.0);
    });

    test('Particle air drag damps velocity over time', () {
      final particle = Particle(
        position: Offset.zero,
        velocity: const Offset(100, 0),
        gravity: 0.0,
        drag: 2.0,
        rotation: 0.0,
        rotationSpeed: 0.0,
        size: 6.0,
        color: Colors.blue,
        maxLifeSeconds: 2.0,
        shape: ParticleShape.circle,
      );

      particle.update(0.1);
      // Damped by (1 - 2.0 * 0.1) = 0.8 => 100 * 0.8 = 80
      expect(particle.velocity.dx, closeTo(80.0, 0.5));
    });

    test('ParticleEmitter spawns burst with expected count and properties', () {
      final particles = ParticleEmitter.spawnBurst(
        origin: const Offset(200, 200),
        count: 25,
        palette: [Colors.amber, Colors.green],
        shapes: [ParticleShape.circle, ParticleShape.confettiQuad],
      );

      expect(particles.length, 25);
      for (final p in particles) {
        expect(p.isAlive, isTrue);
        expect(p.maxLifeSeconds, greaterThan(0.5));
        expect([Colors.amber, Colors.green], contains(p.color));
        expect([ParticleShape.circle, ParticleShape.confettiQuad], contains(p.shape));
      }
    });

    test('ParticleEmitter spreads particles horizontally when spawnWidth is provided', () {
      final particles = ParticleEmitter.spawnBurst(
        origin: const Offset(200, 200),
        count: 30,
        palette: [QoffaColors.actionGreen],
        shapes: [ParticleShape.circle],
        spawnWidth: 300.0,
      );

      expect(particles.length, 30);
      final xPositions = particles.map((p) => p.position.dx).toList();
      final minX = xPositions.reduce(math.min);
      final maxX = xPositions.reduce(math.max);

      // Verify particles span a wide horizontal range (~300px centered around 200)
      expect(maxX - minX, greaterThan(150.0));
    });

    test('ParticleEffectPresets are strictly small circles and green-based palette', () {
      for (final preset in [
        ParticleEffectPresets.celebration,
        ParticleEffectPresets.dismissal,
        ParticleEffectPresets.revival,
      ]) {
        expect(preset.shapes, equals([ParticleShape.circle]));
        expect(preset.maxSize, lessThanOrEqualTo(4.5));
        expect(preset.palette, contains(QoffaColors.actionGreen));
      }
    });

    test('ParticleSplashPainter paints all particle shapes without throwing', () {
      final particles = [
        Particle(
          position: const Offset(50, 50),
          velocity: Offset.zero,
          gravity: 0,
          drag: 0,
          rotation: 0,
          rotationSpeed: 0,
          size: 8,
          color: Colors.red,
          maxLifeSeconds: 1,
          shape: ParticleShape.circle,
        ),
        Particle(
          position: const Offset(60, 60),
          velocity: Offset.zero,
          gravity: 0,
          drag: 0,
          rotation: 0,
          rotationSpeed: 0,
          size: 8,
          color: Colors.blue,
          maxLifeSeconds: 1,
          shape: ParticleShape.confettiQuad,
        ),
        Particle(
          position: const Offset(70, 70),
          velocity: Offset.zero,
          gravity: 0,
          drag: 0,
          rotation: 0,
          rotationSpeed: 0,
          size: 8,
          color: Colors.yellow,
          maxLifeSeconds: 1,
          shape: ParticleShape.sparkleStar,
        ),
        Particle(
          position: const Offset(80, 80),
          velocity: Offset.zero,
          gravity: 0,
          drag: 0,
          rotation: 0,
          rotationSpeed: 0,
          size: 8,
          color: Colors.cyan,
          maxLifeSeconds: 1,
          shape: ParticleShape.shimmerRing,
        ),
      ];

      final painter = ParticleSplashPainter(particles: particles);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      expect(() => painter.paint(canvas, const Size(200, 200)), returnsNormally);
    });
  });

  group('QoffaCardActionAnimator Widget Tests', () {
    testWidgets('Renders child card and executes onCommit callback when triggered',
        (tester) async {
      QoffaCardActionController? controller;
      var committed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaCardActionAnimator(
                controller: (c) => controller = c,
                child: const SizedBox(
                  width: 200,
                  height: 100,
                  child: Text('Card Content'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(controller, isNotNull);

      // Trigger dismissal with celebration preset
      controller!.trigger(
        config: ParticleEffectPresets.celebration,
        onCommit: () async {
          committed = true;
        },
      );

      // Settle frames through animation completion and commit
      await tester.pumpAndSettle();

      expect(committed, isTrue);
    });

    testWidgets('QoffaParticleOverlay maintains particles even after card is unmounted',
        (tester) async {
      bool showCard = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return QoffaParticleOverlay(
                  child: Center(
                    child: showCard
                        ? Builder(
                            builder: (childContext) => ElevatedButton(
                              onPressed: () {
                                QoffaParticleOverlay.spawn(
                                  childContext,
                                  globalOrigin: const Offset(150, 150),
                                  config: ParticleEffectPresets.celebration,
                                );
                                setState(() => showCard = false);
                              },
                              child: const Text('Tap to dismiss'),
                            ),
                          )
                        : const SizedBox(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Tap to dismiss'), findsOneWidget);

      final particleCanvasFinder = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is ParticleSplashPainter,
      );

      // Tap button: triggers overlay particles and unmounts the card
      await tester.tap(find.text('Tap to dismiss'));
      await tester.pump();

      // Card is immediately unmounted from tree
      expect(find.text('Tap to dismiss'), findsNothing);

      // But the CustomPaint with ParticleSplashPainter is actively rendering on the overlay!
      expect(particleCanvasFinder, findsOneWidget);

      // Advance animation through physical flight
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      // Everything completes cleanly
      expect(particleCanvasFinder, findsNothing);
    });
  });
}
