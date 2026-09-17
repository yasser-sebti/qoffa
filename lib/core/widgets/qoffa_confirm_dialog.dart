import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';
import 'qoffa_tactile_pressable.dart';

/// A universal confirmation dialog for Qoffa.
///
/// Shows a modal [AlertDialog] styled with the Qoffa design system.
/// The confirm button uses a destructive red fill by default (for delete
/// actions) and can be overridden with [confirmColor] for non-destructive
/// confirmations. The cancel button always uses the outline tactile style.
///
/// Usage:
/// ```dart
/// final confirmed = await QoffaConfirmDialog.show(
///   context: context,
///   title: 'Delete Note',
///   message: 'Are you sure? This action cannot be undone.',
///   confirmLabel: 'Delete',
///   cancelLabel: 'Cancel',
/// );
/// if (confirmed == true) { /* proceed */ }
/// ```
class QoffaConfirmDialog extends StatelessWidget {
  const QoffaConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.confirmColor = QoffaColors.warningCoral,
    this.icon,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// Fill color for the confirm button. Defaults to [QoffaColors.warningCoral]
  /// (red) for destructive actions. Pass [QoffaColors.actionGreen] for safe
  /// confirmations.
  final Color confirmColor;

  /// Optional leading icon shown next to the title.
  final IconData? icon;

  /// Convenience static method – shows the dialog and returns `true` if the
  /// user confirmed, `false` if they cancelled, or `null` if dismissed.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    Color confirmColor = QoffaColors.warningCoral,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => QoffaConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        side: const BorderSide(color: QoffaColors.softBorder),
      ),
      backgroundColor: QoffaColors.whiteSurface,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: confirmColor, size: 22),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Hero Sandwich Pro',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: QoffaColors.primaryNavy,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.5,
          height: 1.5,
          color: QoffaColors.secondarySage,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: QoffaTactilePressable.outline(
                label: cancelLabel,
                height: 48,
                onTap: () => Navigator.pop(context, false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QoffaTactilePressable.filled(
                label: confirmLabel,
                height: 48,
                backgroundColor: confirmColor,
                borderColor: confirmColor,
                hoverBackgroundColor: QoffaColors.smartShadow(confirmColor),
                hoverBorderColor: QoffaColors.smartShadow(confirmColor),
                onTap: () => Navigator.pop(context, true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
