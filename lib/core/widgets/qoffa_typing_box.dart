import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';
import '../money/thousands_separator_input_formatter.dart';

/// QoffaTypingBox: Reusable typing value template widget for Qoffa.
///
/// Features:
/// - Tactile mint-tinted container with smooth focus border transitions.
/// - Prominent value number typography (17pt, FontWeight.w800, Inter).
/// - Clean transparent input background (no inner white bars or lines).
/// - Pinned prefix icon (e.g. coin stack) and pinned right suffix (e.g. 'DA').
/// - Muted placeholder support (e.g. '000,000 ...').
/// - Optional automatic thousands separator (comma grouping) as user types.
/// - Full-box hit testing (tapping anywhere in the box focuses the input).
class QoffaTypingBox extends StatefulWidget {
  const QoffaTypingBox({
    this.label,
    this.controller,
    this.focusNode,
    this.hintText,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixText,
    this.suffixWidget,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textStyle,
    this.hintStyle,
    this.suffixStyle,
    this.height = 52.0,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFF4FAF6),
    this.borderColor = QoffaColors.softBorder,
    this.focusedBorderColor = QoffaColors.actionGreen,
    this.prefixIconColor = QoffaColors.actionGreen,
    this.prefixIconSize = 20.0,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  /// Specialized constructor for price / monetary inputs with currency ticker.
  factory QoffaTypingBox.currency({
    Key? key,
    String? label,
    TextEditingController? controller,
    FocusNode? focusNode,
    String hintText = '000،000 ...',
    String suffixText = 'DA',
    IconData prefixIcon = Icons.paid_rounded,
    double height = 52.0,
    BorderRadius? borderRadius,
    bool enabled = true,
    bool readOnly = false,
    bool? isArabic,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return QoffaTypingBox(
      key: key,
      label: label,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixText: suffixText,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [ThousandsSeparatorInputFormatter(isArabic: isArabic)],
      height: height,
      borderRadius: borderRadius,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  final String? label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final String? suffixText;
  final Widget? suffixWidget;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? suffixStyle;
  final double height;
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color prefixIconColor;
  final double prefixIconSize;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<QoffaTypingBox> createState() => _QoffaTypingBoxState();
}

class _QoffaTypingBoxState extends State<QoffaTypingBox> {
  FocusNode? _internalFocusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant QoffaTypingBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _effectiveFocusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = _effectiveFocusNode.hasFocus;
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    final effectiveTextStyle = widget.textStyle ??
        const TextStyle(
          fontFamily: QoffaFontFamily.body,
          fontSize: QoffaFontSize.titleSmall,
          fontWeight: FontWeight.w800,
          color: QoffaColors.primaryNavy,
        );

    final effectiveHintStyle = widget.hintStyle ??
        TextStyle(
          fontFamily: QoffaFontFamily.body,
          fontSize: QoffaFontSize.bodyMedium,
          fontWeight: FontWeight.w700,
          color: QoffaColors.secondarySage.withValues(alpha: 0.6),
        );

    final effectiveSuffixStyle = widget.suffixStyle ??
        const TextStyle(
          fontFamily: QoffaFontFamily.body,
          fontSize: QoffaFontSize.bodySmall,
          fontWeight: FontWeight.w700,
          color: QoffaColors.secondarySage,
        );

    Widget box = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.enabled && !widget.readOnly) {
          _effectiveFocusNode.requestFocus();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: radius,
          border: Border.all(
            color: hasFocus ? widget.focusedBorderColor : widget.borderColor,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Left prefix
            if (widget.prefixWidget != null) ...[
              widget.prefixWidget!,
              const SizedBox(width: 8),
            ] else if (widget.prefixIcon != null) ...[
              Icon(
                widget.prefixIcon,
                color: widget.prefixIconColor,
                size: widget.prefixIconSize,
              ),
              const SizedBox(width: 8),
            ],

            // Middle input area
            Expanded(
              child: TextField(
                focusNode: _effectiveFocusNode,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                cursorColor: widget.focusedBorderColor,
                cursorWidth: 2,
                cursorRadius: const Radius.circular(1),
                style: effectiveTextStyle,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: effectiveHintStyle,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: false,
                  fillColor: Colors.transparent,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
              ),
            ),

            // Right suffix
            if (widget.suffixWidget != null) ...[
              const SizedBox(width: 8),
              widget.suffixWidget!,
            ] else if (widget.suffixText != null &&
                widget.suffixText!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                widget.suffixText!,
                style: effectiveSuffixStyle,
              ),
            ],
          ],
        ),
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
              fontFamily: QoffaFontFamily.body,
              fontSize: QoffaFontSize.bodySmall,
              fontWeight: FontWeight.w700,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 6),
          box,
        ],
      );
    }

    return box;
  }
}
