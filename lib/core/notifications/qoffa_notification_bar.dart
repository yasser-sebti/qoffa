import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';

/// Supported notification types with semantic styling and iconography.
enum QoffaNotificationType {
  /// General information / standard notification.
  normal,

  /// Successful action / confirmed operation.
  approved,

  /// Error, rejection, or warning event.
  declined,
}

/// Represents an interactive, clickable word or phrase within a notification message.
class QoffaNotificationHighlight {
  const QoffaNotificationHighlight({
    required this.word,
    required this.onTap,
  });

  /// The exact word or phrase in the message to highlight and make clickable.
  final String word;

  /// Callback executed when the highlighted word is tapped.
  final VoidCallback onTap;
}

/// Data payload representing an in-app notification banner.
class QoffaNotificationData {
  const QoffaNotificationData({
    required this.id,
    required this.message,
    this.type = QoffaNotificationType.normal,
    this.title,
    this.icon,
    this.customColor,
    this.duration = const Duration(milliseconds: 3200),
    this.highlights = const [],
    this.actionLabel,
    this.onAction,
    this.showProgress = false,
  });

  /// Unique sequence identifier used for triggering breath animation on changes.
  final int id;

  /// Main notification message text.
  final String message;

  /// Visual notification type (normal, approved, declined).
  final QoffaNotificationType type;

  /// Optional bold title displayed above the message.
  final String? title;

  /// Optional icon override. If null, the icon is determined by [type].
  final IconData? icon;

  /// Optional custom filled color override.
  final Color? customColor;

  /// Display duration before automatic dismissal.
  final Duration duration;

  /// Clickable highlighted words within the message that redirect to actions.
  final List<QoffaNotificationHighlight> highlights;

  /// Optional dedicated action button label (e.g. "Undo", "View").
  final String? actionLabel;

  /// Optional callback executed when [actionLabel] is tapped.
  final VoidCallback? onAction;

  /// Whether to display an animated linear progress countdown bar at the bottom.
  final bool showProgress;

  /// Resolved filled background color for this notification.
  Color get backgroundColor {
    if (customColor != null) return customColor!;
    switch (type) {
      case QoffaNotificationType.approved:
        return QoffaColors.actionGreen; // Accessible app green (0xFF087D34)
      case QoffaNotificationType.declined:
        return const Color(0xFFDC2626); // High-visibility deep red (0xFFDC2626)
      case QoffaNotificationType.normal:
        return const Color(0xFF1D4ED8); // Vibrant Royal Blue (0xFF1D4ED8)
    }
  }

  /// Resolved icon based on notification type.
  IconData get resolvedIcon {
    if (icon != null) return icon!;
    switch (type) {
      case QoffaNotificationType.approved:
        return Icons.check_circle_rounded;
      case QoffaNotificationType.declined:
        return Icons.cancel_rounded;
      case QoffaNotificationType.normal:
        return Icons.info_rounded;
    }
  }
}

/// Standalone in-app notification bar template.
///
/// Features:
/// - Solid filled-color background with no outline border
/// - Smooth animated color transition when context updates
/// - Breath / pulse scale animation on new notifications and context changes
/// - Clean simple icon (no surrounding low-opacity circle)
/// - Clean simple X symbol exit button (no surrounding circle)
/// - Increased 'Inter' typography (15.5px body, 16.5px title) with no yellow underlines
/// - Clickable highlighted words that redirect to actions
class QoffaNotificationBar extends StatefulWidget {
  const QoffaNotificationBar({
    required this.data,
    required this.onDismiss,
    super.key,
  });

  final QoffaNotificationData data;
  final VoidCallback onDismiss;

  @override
  State<QoffaNotificationBar> createState() => _QoffaNotificationBarState();
}

class _QoffaNotificationBarState extends State<QoffaNotificationBar>
    with TickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;
  AnimationController? _progressController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 210),
    );

    // Fast, organic, ultra-smooth breath / pulse pop
    _breathScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.036)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 42,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.036, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 58,
      ),
    ]).animate(_breathController);

    _breathController.forward(from: 0.0);

    if (widget.data.showProgress) {
      _initProgressBar();
    }
  }

  void _initProgressBar() {
    _progressController?.dispose();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.data.duration,
    )..reverse(from: 1.0);
  }

  @override
  void didUpdateWidget(QoffaNotificationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When a new notification arrives or context updates, trigger breath pulse animation
    if (widget.data.id != oldWidget.data.id) {
      _breathController.forward(from: 0.0);
      if (widget.data.showProgress) {
        _initProgressBar();
      } else {
        _progressController?.dispose();
        _progressController = null;
      }
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _progressController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Material(
      type: MaterialType.transparency,
      child: ScaleTransition(
        scale: _breathScale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 210),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            color: data.backgroundColor,
            borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
            // Filled color only with gentle depth shadow, NO outline border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Simple state icon (clean symbol only, no low-opacity circle)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Icon(
                      data.resolvedIcon,
                      key: ValueKey(data.resolvedIcon),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content Column: Title, Message with Clickable Highlights
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data.title != null && data.title!.trim().isNotEmpty) ...[
                          Text(
                            data.title!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 3),
                        ],

                        // Body with interactive highlighted words
                        _buildMessageText(context),
                      ],
                    ),
                  ),

                  // Dedicated Action Pill (if present)
                  if (data.onAction != null && data.actionLabel != null) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        data.onAction?.call();
                        widget.onDismiss();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          data.actionLabel!,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: data.backgroundColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(width: 8),

                  // Dedicated 'X' Exit Button: simple X symbol only, no circle
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onDismiss,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              if (data.showProgress && _progressController != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: AnimatedBuilder(
                    animation: _progressController!,
                    builder: (context, _) => LinearProgressIndicator(
                      value: _progressController!.value,
                      minHeight: 3.0,
                      backgroundColor: Colors.white.withValues(alpha: 0.22),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds message text supporting clickable highlighted words without yellow underlines.
  Widget _buildMessageText(BuildContext context) {
    final message = widget.data.message;
    if (widget.data.highlights.isEmpty) {
      return Text(
        message,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.35,
          decoration: TextDecoration.none,
        ),
      );
    }

    // Parse message into spans for highlighted words
    final spans = <InlineSpan>[];
    var currentIndex = 0;

    while (currentIndex < message.length) {
      int earliestMatchIndex = -1;
      QoffaNotificationHighlight? matchedHighlight;

      for (final h in widget.data.highlights) {
        final idx = message.indexOf(h.word, currentIndex);
        if (idx != -1 && (earliestMatchIndex == -1 || idx < earliestMatchIndex)) {
          earliestMatchIndex = idx;
          matchedHighlight = h;
        }
      }

      if (earliestMatchIndex == -1 || matchedHighlight == null) {
        // No further matches, append remainder
        spans.add(
          TextSpan(
            text: message.substring(currentIndex),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.35,
              decoration: TextDecoration.none,
            ),
          ),
        );
        break;
      }

      // Append text preceding the match
      if (earliestMatchIndex > currentIndex) {
        spans.add(
          TextSpan(
            text: message.substring(currentIndex, earliestMatchIndex),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.35,
              decoration: TextDecoration.none,
            ),
          ),
        );
      }

      // Append clickable highlighted word badge without yellow underline
      final highlight = matchedHighlight;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () {
              highlight.onTap();
              widget.onDismiss();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                highlight.word,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      );

      currentIndex = earliestMatchIndex + highlight.word.length;
    }

    return Text.rich(
      TextSpan(children: spans),
      style: const TextStyle(
        fontFamily: 'Inter',
        decoration: TextDecoration.none,
      ),
    );
  }
}
