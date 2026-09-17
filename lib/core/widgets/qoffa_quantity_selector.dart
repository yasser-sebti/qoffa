import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import 'qoffa_tactile_pressable.dart';

/// QoffaQuantitySelector: Reusable template widget for quantity increment/decrement.
///
/// Features:
/// - Square rounded buttons (plus & minus) with continuous on-hold repeat.
/// - Smooth vertical swipe up/down and fade animated number transitions with cropped bounds.
/// - Minimum and maximum threshold enforcement with disabled visual feedback.
/// - Fully styled according to Qoffa's tactile design system.
class QoffaQuantitySelector extends StatefulWidget {
  const QoffaQuantitySelector({
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 999.0,
    this.step = 1.0,
    this.label,
    this.height = 52.0,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFF4FAF6),
    this.borderColor = QoffaColors.softBorder,
    this.valueFormatter,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final double step;
  final String? label;
  final double height;
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final String Function(double value)? valueFormatter;

  @override
  State<QoffaQuantitySelector> createState() => _QoffaQuantitySelectorState();
}

class _QoffaQuantitySelectorState extends State<QoffaQuantitySelector> {
  bool _isIncreasing = true;

  @override
  void didUpdateWidget(covariant QoffaQuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value > oldWidget.value) {
      _isIncreasing = true;
    } else if (widget.value < oldWidget.value) {
      _isIncreasing = false;
    }
  }

  void _increment() {
    if (widget.value < widget.max) {
      _isIncreasing = true;
      final next = (widget.value + widget.step).clamp(widget.min, widget.max);
      widget.onChanged(next);
    }
  }

  void _decrement() {
    if (widget.value > widget.min) {
      _isIncreasing = false;
      final next = (widget.value - widget.step).clamp(widget.min, widget.max);
      widget.onChanged(next);
    }
  }

  String _formatValue(double val) {
    if (widget.valueFormatter != null) {
      return widget.valueFormatter!(val);
    }
    return val % 1 == 0 ? '${val.toInt()}' : val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isAtMin = widget.value <= widget.min;
    final isAtMax = widget.value >= widget.max;
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    Widget container = Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: radius,
        border: Border.all(
          color: widget.borderColor,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Square rounded minus button on left
          QoffaTactilePressable(
            onTap: _decrement,
            enabled: !isAtMin,
            enableRepeatOnHold: true,
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(11),
            backgroundColor: isAtMin
                ? const Color(0xFFE8EFEA)
                : QoffaColors.mintSurfaceTint,
            borderColor:
                isAtMin ? Colors.transparent : QoffaColors.softBorder,
            hoverBackgroundColor: QoffaColors.mintSurfaceTint,
            hoverBorderColor: QoffaColors.actionGreen,
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.remove_rounded,
              size: 20,
              color: isAtMin
                  ? QoffaColors.secondarySage.withValues(alpha: 0.4)
                  : QoffaColors.actionGreen,
            ),
          ),

          // Number display with vertical swipe up / down & fade animation
          Expanded(
            child: ClipRect(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ...previousChildren,
                        ?currentChild,
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    final isIncoming =
                        (child.key as ValueKey<double>?)?.value ==
                            widget.value;
                    final inOffset = _isIncreasing
                        ? const Offset(0.0, 1.0)
                        : const Offset(0.0, -1.0);
                    final outOffset = _isIncreasing
                        ? const Offset(0.0, -1.0)
                        : const Offset(0.0, 1.0);

                    final offsetTween = isIncoming
                        ? Tween<Offset>(begin: inOffset, end: Offset.zero)
                        : Tween<Offset>(begin: outOffset, end: Offset.zero);

                    return SlideTransition(
                      position: offsetTween.animate(animation),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    _formatValue(widget.value),
                    key: ValueKey<double>(widget.value),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Square rounded plus button on right
          QoffaTactilePressable.filled(
            onTap: _increment,
            enabled: !isAtMax,
            enableRepeatOnHold: true,
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(11),
            backgroundColor: isAtMax
                ? QoffaColors.actionGreen.withValues(alpha: 0.4)
                : QoffaColors.actionGreen,
            borderColor: isAtMax
                ? QoffaColors.actionGreen.withValues(alpha: 0.4)
                : QoffaColors.actionGreen,
            hoverBackgroundColor: QoffaColors.pressedGreen,
            hoverBorderColor: QoffaColors.pressedGreen,
            padding: EdgeInsets.zero,
            child: const Icon(
              Icons.add_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (widget.label != null && widget.label!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label!,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 6),
          container,
        ],
      );
    }

    return container;
  }
}
