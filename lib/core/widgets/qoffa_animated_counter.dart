import 'package:flutter/material.dart';

/// QoffaAnimatedCounter: A reusable animated numeric counter template.
///
/// Smoothly animates number transitions (both increase and decrease)
/// using [Curves.easeOutCubic] over [duration].
/// Supports thousands comma grouping, custom prefixes/suffixes, and null states.
class QoffaAnimatedCounter extends StatefulWidget {
  const QoffaAnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.prefix = '',
    this.suffix = ' DA',
    this.nullPlaceholder = '— DA',
    this.formatThousands = true,
    this.duration = const Duration(milliseconds: 550),
    this.curve = Curves.easeOutCubic,
  });

  /// The target number to display. If null, displays [nullPlaceholder].
  final num? value;

  /// The typography style applied to the counter text.
  final TextStyle style;

  /// Optional prefix string prepended to the number (e.g. `+`, `~`).
  final String prefix;

  /// Optional suffix string appended to the number (defaults to ` DA`).
  final String suffix;

  /// String displayed when [value] is null.
  final String nullPlaceholder;

  /// Whether to format with comma thousands grouping (e.g. `12,500`).
  final bool formatThousands;

  /// The animation duration.
  final Duration duration;

  /// The animation curve.
  final Curve curve;

  @override
  State<QoffaAnimatedCounter> createState() => _QoffaAnimatedCounterState();
}

class _QoffaAnimatedCounterState extends State<QoffaAnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final initial = (widget.value ?? 0).toDouble();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = AlwaysStoppedAnimation<double>(initial);
  }

  @override
  void didUpdateWidget(covariant QoffaAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value == null) {
        _controller.stop();
        _animation = const AlwaysStoppedAnimation<double>(0.0);
        setState(() {});
      } else {
        final double from = _animation.value;
        final double to = widget.value!.toDouble();
        _controller.duration = widget.duration;
        _animation = Tween<double>(begin: from, end: to).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
        _controller.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    final str = number.abs().toString();
    final formatted = widget.formatThousands
        ? str.replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (match) => '${match[1]},',
          )
        : str;
    final sign = number < 0
        ? '-'
        : (number > 0 && widget.prefix.isNotEmpty ? widget.prefix : '');
    return '$sign$formatted${widget.suffix}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value == null) {
      return Text(widget.nullPlaceholder, style: widget.style);
    }

    // If animations are globally disabled, render immediately
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return Text(
        _formatNumber(widget.value!.round()),
        style: widget.style,
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _formatNumber(_animation.value.round()),
          style: widget.style,
        );
      },
    );
  }
}
