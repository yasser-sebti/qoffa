import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';
import 'qoffa_fade_pressable.dart';

/// The single dropdown treatment used throughout Qoffa.
class QoffaDropdown<T> extends StatelessWidget {
  const QoffaDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
    this.prefixIcon,
    this.enabled = true,
    super.key,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DropdownButtonFormField<T>(
      key: ValueKey(value),
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      isExpanded: true,
      elevation: 0,
      menuMaxHeight: 320,
      borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
      dropdownColor: colors.surface,
      focusColor: Colors.transparent,
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: QoffaColors.mintSurfaceTint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: QoffaColors.actionGreen,
          size: 22,
        ),
      ),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: colors.onSurface,
      ),
      hint: hint == null
          ? null
          : Text(hint!, maxLines: 1, overflow: TextOverflow.ellipsis),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: QoffaColors.actionGreen, size: 21),
        contentPadding: EdgeInsetsDirectional.only(
          start: prefixIcon == null ? 15 : 8,
          end: 10,
          top: 14,
          bottom: 14,
        ),
      ),
    );
  }
}

/// Dropdown-shaped field for values that open a custom picker or dialog.
class QoffaPickerField extends StatelessWidget {
  const QoffaPickerField({
    required this.value,
    required this.onTap,
    required this.prefixIcon,
    this.hint,
    super.key,
  });

  final String value;
  final String? hint;
  final IconData prefixIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return QoffaFadePressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
      child: InputDecorator(
        isEmpty: value.isEmpty,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: QoffaColors.actionGreen,
            size: 21,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: QoffaColors.mintSurfaceTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: QoffaColors.actionGreen,
                size: 22,
              ),
            ),
          ),
        ),
        child: Text(
          value.isEmpty ? (hint ?? '') : value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: value.isEmpty ? QoffaColors.secondarySage : colors.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Shared surface for autocomplete and custom dropdown result lists.
class QoffaDropdownMenuSurface extends StatelessWidget {
  const QoffaDropdownMenuSurface({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
        border: Border.all(color: QoffaColors.softBorder, width: 1.4),
      ),
      child: child,
    ),
  );
}
