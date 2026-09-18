import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import 'particle_model.dart';

/// Configuration profile defining visual characteristics and physical behavior of an effect.
class ParticleEffectConfig {
  const ParticleEffectConfig({
    required this.name,
    required this.palette,
    required this.shapes,
    this.particleCount = 38,
    this.minSpeed = 160.0,
    this.maxSpeed = 460.0,
    this.minAngleRad = 0.0,
    this.maxAngleRad = 2 * math.pi,
    this.gravity = 1150.0,
    this.drag = 1.35,
    this.minSize = 4.5,
    this.maxSize = 9.5,
    this.minLifeSeconds = 0.65,
    this.maxLifeSeconds = 1.05,
    this.upwardBias = 140.0,
    this.cardPopScale = 1.035,
    this.cardPopDuration = const Duration(milliseconds: 140),
    this.cardDismissDuration = const Duration(milliseconds: 280),
  });

  final String name;
  final List<Color> palette;
  final List<ParticleShape> shapes;
  final int particleCount;
  final double minSpeed;
  final double maxSpeed;
  final double minAngleRad;
  final double maxAngleRad;
  final double gravity;
  final double drag;
  final double minSize;
  final double maxSize;
  final double minLifeSeconds;
  final double maxLifeSeconds;
  final double upwardBias;

  /// Card popup scale factor during initial tactile burst
  final double cardPopScale;

  /// Duration of card pop spring phase
  final Duration cardPopDuration;

  /// Duration of card fade & size collapse phase
  final Duration cardDismissDuration;

  /// Spawns particles matching this configuration at [origin], optionally spread over [spawnWidth].
  List<Particle> spawn(Offset origin, {double spawnWidth = 0.0}) {
    return ParticleEmitter.spawnBurst(
      origin: origin,
      count: particleCount,
      palette: palette,
      shapes: shapes,
      spawnWidth: spawnWidth,
      minSpeed: minSpeed,
      maxSpeed: maxSpeed,
      minAngleRad: minAngleRad,
      maxAngleRad: maxAngleRad,
      gravity: gravity,
      drag: drag,
      minSize: minSize,
      maxSize: maxSize,
      minLifeSeconds: minLifeSeconds,
      maxLifeSeconds: maxLifeSeconds,
      upwardBias: upwardBias,
    );
  }
}

/// Standardized effect presets tuned for Qoffa interactions.
///
/// Features very small circles only and subtle green shades derived
/// directly from the default app green (QoffaColors.actionGreen).
class ParticleEffectPresets {
  ParticleEffectPresets._();

  /// Cohesive green palette centered around the default app green.
  static const List<Color> _appGreenShades = [
    QoffaColors.actionGreen, // Default app green (0xFF087D34)
    QoffaColors.brandGreen,  // Primary brand green (0xFF0AA343)
    Color(0xFF0F9D47),       // Vibrant emerald tone
    Color(0xFF22B75F),       // Fresh green accent
    Color(0xFF34D399),       // Soft mint glow
  ];

  /// Celebratory burst triggered when an item is bought:
  /// Very small sparkling green circles in fine celebratory fountain.
  static const ParticleEffectConfig celebration = ParticleEffectConfig(
    name: 'celebration',
    palette: _appGreenShades,
    shapes: [
      ParticleShape.circle,
    ],
    particleCount: 46,
    minSize: 2.0,
    maxSize: 4.4,
    minSpeed: 170.0,
    maxSpeed: 460.0,
    gravity: 1100.0,
    drag: 1.25,
    upwardBias: 190.0,
    cardPopScale: 1.042,
    cardPopDuration: Duration(milliseconds: 150),
    cardDismissDuration: Duration(milliseconds: 300),
  );

  /// Gentle dismissal flutter triggered when an item is skipped:
  /// Small calm green circles gliding upward and outward.
  static const ParticleEffectConfig dismissal = ParticleEffectConfig(
    name: 'dismissal',
    palette: [
      QoffaColors.actionGreen,
      Color(0xFF0AA343),
      Color(0xFF1E824C),
      Color(0xFF48BB78),
    ],
    shapes: [
      ParticleShape.circle,
    ],
    particleCount: 30,
    minSize: 1.8,
    maxSize: 3.8,
    minSpeed: 120.0,
    maxSpeed: 340.0,
    gravity: 1250.0,
    drag: 1.6,
    upwardBias: 85.0,
    cardPopScale: 1.028,
    cardPopDuration: Duration(milliseconds: 130),
    cardDismissDuration: Duration(milliseconds: 260),
  );

  /// Energizing fountain burst triggered when a skipped item is reactivated:
  /// Small vibrant green circle dots radiating up and out.
  static const ParticleEffectConfig revival = ParticleEffectConfig(
    name: 'revival',
    palette: _appGreenShades,
    shapes: [
      ParticleShape.circle,
    ],
    particleCount: 38,
    minSize: 2.0,
    maxSize: 4.2,
    minSpeed: 150.0,
    maxSpeed: 400.0,
    gravity: 1050.0,
    drag: 1.3,
    upwardBias: 200.0,
    cardPopScale: 1.036,
    cardPopDuration: Duration(milliseconds: 140),
    cardDismissDuration: Duration(milliseconds: 280),
  );

  /// Cohesive red palette centered around the app warning/danger colors.
  static const List<Color> _appRedShades = [
    QoffaColors.warningCoral,     // Primary warning coral (0xFFFF6264)
    QoffaColors.warningCoralDeep, // Deep crimson tone (0xFFD94547)
    Color(0xFFE53935),            // Vibrant red tone
    Color(0xFFFF5252),            // Bright ruby accent
    Color(0xFFFF8A80),            // Soft red coral glow
  ];

  /// Destructive/deletion burst triggered when an item or card is deleted:
  /// Small sparkling red circles special for deletion functions across the app.
  static const ParticleEffectConfig deletion = ParticleEffectConfig(
    name: 'deletion',
    palette: _appRedShades,
    shapes: [
      ParticleShape.circle,
    ],
    particleCount: 38,
    minSize: 2.0,
    maxSize: 4.4,
    minSpeed: 160.0,
    maxSpeed: 440.0,
    gravity: 1150.0,
    drag: 1.3,
    upwardBias: 180.0,
    cardPopScale: 1.036,
    cardPopDuration: Duration(milliseconds: 140),
    cardDismissDuration: Duration(milliseconds: 280),
  );
}
