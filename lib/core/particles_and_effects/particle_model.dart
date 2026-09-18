import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Supported particle geometry shapes.
enum ParticleShape {
  circle,
  confettiQuad,
  sparkleStar,
  shimmerRing,
}

/// Represents a single particle governed by realistic 2D kinematics.
class Particle {
  Particle({
    required this.position,
    required this.velocity,
    required this.gravity,
    required this.drag,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    required this.color,
    required this.maxLifeSeconds,
    required this.shape,
    this.tumbleSpeed = 0.0,
    this.tumblePhase = 0.0,
  })  : currentAgeSeconds = 0.0,
        isAlive = true;

  Offset position;
  Offset velocity;
  final double gravity;
  final double drag;
  double rotation;
  final double rotationSpeed;
  final double size;
  final Color color;
  final double maxLifeSeconds;
  final ParticleShape shape;
  final double tumbleSpeed;
  double tumblePhase;

  double currentAgeSeconds;
  bool isAlive;

  /// Progress from 0.0 (birth) to 1.0 (death).
  double get progress => (currentAgeSeconds / maxLifeSeconds).clamp(0.0, 1.0);

  /// 3D flip width factor simulating planar confetti flutter in space.
  double get tumbleScale => math.cos(tumblePhase).abs().clamp(0.15, 1.0);

  /// Advances the physics simulation by time delta [dt] (seconds).
  void update(double dt) {
    if (!isAlive) return;

    currentAgeSeconds += dt;
    if (currentAgeSeconds >= maxLifeSeconds) {
      isAlive = false;
      return;
    }

    // Semi-implicit Euler integration:
    // 1. Gravity acceleration (downward)
    velocity = Offset(
      velocity.dx,
      velocity.dy + (gravity * dt),
    );

    // 2. Aerodynamic air drag deceleration
    final dragFactor = (1.0 - (drag * dt)).clamp(0.0, 1.0);
    velocity = Offset(
      velocity.dx * dragFactor,
      velocity.dy * dragFactor,
    );

    // 3. Position update
    position += velocity * dt;

    // 4. Angular 2D rotation & 3D flutter tumble
    rotation += rotationSpeed * dt;
    tumblePhase += tumbleSpeed * dt;
  }
}

/// Helper to generate bursts of realistic particles from an origin.
class ParticleEmitter {
  ParticleEmitter._();

  static final math.Random _random = math.Random();

  /// Emits a list of initialized particles with natural random variances.
  static List<Particle> spawnBurst({
    required Offset origin,
    required int count,
    required List<Color> palette,
    required List<ParticleShape> shapes,
    double spawnWidth = 0.0,
    double minSpeed = 160.0,
    double maxSpeed = 440.0,
    double minAngleRad = 0.0,
    double maxAngleRad = 2 * math.pi,
    double gravity = 1100.0,
    double drag = 1.35,
    double minSize = 2.0,
    double maxSize = 4.5,
    double minLifeSeconds = 0.65,
    double maxLifeSeconds = 1.05,
    double upwardBias = 0.0,
  }) {
    final particles = <Particle>[];

    final halfWidth = spawnWidth > 0 ? spawnWidth * 0.5 : 6.0;

    for (var i = 0; i < count; i++) {
      // Angular trajectory with optional upward fountain bias
      final angle = minAngleRad + (_random.nextDouble() * (maxAngleRad - minAngleRad));
      final speed = minSpeed + (_random.nextDouble() * (maxSpeed - minSpeed));

      // Wide horizontal positioning across the card width
      final spreadFactor = (_random.nextDouble() * 2.0) - 1.0; // -1.0 to +1.0
      final posX = origin.dx + (spreadFactor * halfWidth);
      final posY = origin.dy + ((_random.nextDouble() - 0.5) * 14.0);

      // Natural lateral fanning: particles on the outer edges fan outward
      final lateralBias = spawnWidth > 0 ? (spreadFactor * 65.0) : 0.0;
      final vx = (math.cos(angle) * speed) + lateralBias;
      // Subtract upward bias to give natural lift
      final vy = (math.sin(angle) * speed) - upwardBias;

      final color = palette[_random.nextInt(palette.length)];
      final shape = shapes[_random.nextInt(shapes.length)];
      final size = minSize + (_random.nextDouble() * (maxSize - minSize));
      final life = minLifeSeconds + (_random.nextDouble() * (maxLifeSeconds - minLifeSeconds));

      final rotSpeed = (_random.nextDouble() * 12.0 - 6.0); // -6 to +6 rad/s
      final tumbleSpeed = (_random.nextDouble() * 14.0 + 4.0); // 4 to 18 rad/s

      particles.add(
        Particle(
          position: Offset(posX, posY),
          velocity: Offset(vx, vy),
          gravity: gravity * (0.85 + _random.nextDouble() * 0.3),
          drag: drag * (0.9 + _random.nextDouble() * 0.2),
          rotation: _random.nextDouble() * 2 * math.pi,
          rotationSpeed: rotSpeed,
          size: size,
          color: color,
          maxLifeSeconds: life,
          shape: shape,
          tumbleSpeed: tumbleSpeed,
          tumblePhase: _random.nextDouble() * math.pi,
        ),
      );
    }

    return particles;
  }
}
