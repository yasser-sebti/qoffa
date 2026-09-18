import 'package:flutter/material.dart';
import 'particle_model.dart';

/// High-performance custom painter for rendering a collection of active particles.
///
/// Designed with zero allocations during paint iterations to achieve a solid 60/120 FPS.
class ParticleSplashPainter extends CustomPainter {
  ParticleSplashPainter({
    required this.particles,
  }) : super(repaint: null);

  final List<Particle> particles;

  // Pre-allocated reusable paint instances to avoid per-frame GC overhead
  static final Paint _fillPaint = Paint()..isAntiAlias = true;
  static final Paint _strokePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.6;

  static final Path _starPath = Path();

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;

    for (var i = 0; i < particles.length; i++) {
      final p = particles[i];
      if (!p.isAlive) continue;

      final progress = p.progress;

      // Alpha curve: full opacity until 45% lifetime, then smooth quadratic fade
      final double alpha;
      if (progress < 0.45) {
        alpha = 1.0;
      } else {
        final fadeProgress = (progress - 0.45) / 0.55;
        alpha = (1.0 - fadeProgress).clamp(0.0, 1.0);
      }

      if (alpha <= 0.005) continue;

      // Scale curve: quick pop in (0.0 to 0.1), then steady size
      final double scale;
      if (progress < 0.12) {
        scale = progress / 0.12;
      } else {
        scale = (1.0 - (progress - 0.12) * 0.25).clamp(0.4, 1.0);
      }

      final colorWithAlpha = p.color.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      canvas.rotate(p.rotation);

      switch (p.shape) {
        case ParticleShape.circle:
          _fillPaint.color = colorWithAlpha;
          _fillPaint.style = PaintingStyle.fill;
          canvas.drawCircle(Offset.zero, p.size * scale * 0.5, _fillPaint);
          break;

        case ParticleShape.confettiQuad:
          _fillPaint.color = colorWithAlpha;
          _fillPaint.style = PaintingStyle.fill;
          // Apply 3D tumble flip along local X axis
          final halfW = (p.size * 1.2 * scale * p.tumbleScale) * 0.5;
          final halfH = (p.size * 0.7 * scale) * 0.5;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(-halfW, -halfH, halfW, halfH),
              const Radius.circular(1.5),
            ),
            _fillPaint,
          );
          break;

        case ParticleShape.sparkleStar:
          _fillPaint.color = colorWithAlpha;
          _fillPaint.style = PaintingStyle.fill;
          _drawStar(canvas, p.size * scale, _fillPaint);
          break;

        case ParticleShape.shimmerRing:
          _strokePaint.color = colorWithAlpha;
          _strokePaint.strokeWidth = 1.5 * scale;
          canvas.drawCircle(Offset.zero, p.size * scale * 0.6, _strokePaint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final half = size * 0.5;
    final inner = half * 0.26;

    _starPath.reset();
    _starPath.moveTo(0, -half);
    _starPath.lineTo(inner, -inner);
    _starPath.lineTo(half, 0);
    _starPath.lineTo(inner, inner);
    _starPath.lineTo(0, half);
    _starPath.lineTo(-inner, inner);
    _starPath.lineTo(-half, 0);
    _starPath.lineTo(-inner, -inner);
    _starPath.close();

    canvas.drawPath(_starPath, paint);
  }

  @override
  bool shouldRepaint(covariant ParticleSplashPainter oldDelegate) => true;
}
