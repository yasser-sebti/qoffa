import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';

class MintBackgroundScaffold extends StatelessWidget {
  const MintBackgroundScaffold({
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    super.key,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QoffaColors.paleMintBackground,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _MintGeometricBackgroundPainter(),
            ),
          ),
          child,
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class _MintGeometricBackgroundPainter extends CustomPainter {
  const _MintGeometricBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFD6F5DE).withValues(alpha: 0.55);

    // Subtle soft geometric ambient shapes (inspired by the screenshot contours)
    // Top right soft arc
    canvas.drawCircle(
      Offset(size.width * 0.95, -size.height * 0.05),
      size.width * 0.45,
      paint,
    );

    // Mid left subtle cloud arc
    final paintMid = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFDDF7E5).withValues(alpha: 0.45);

    canvas.drawCircle(
      Offset(-size.width * 0.2, size.height * 0.35),
      size.width * 0.4,
      paintMid,
    );

    // Bottom soft undulating silhouette
    final bottomPath = Path();
    final h = size.height;
    final w = size.width;

    bottomPath.moveTo(0, h);
    bottomPath.lineTo(0, h - 80);
    bottomPath.quadraticBezierTo(w * 0.25, h - 120, w * 0.5, h - 85);
    bottomPath.quadraticBezierTo(w * 0.75, h - 50, w, h - 95);
    bottomPath.lineTo(w, h);
    bottomPath.close();

    final paintBottom = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFCEF0D7).withValues(alpha: 0.35);

    canvas.drawPath(bottomPath, paintBottom);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
