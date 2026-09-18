import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme/qoffa_colors.dart';
import '../notifications/qoffa_notification_bar.dart';

export '../notifications/qoffa_notification_bar.dart';

/// Backward-compatible alias for existing codebase references.
typedef ToastNotificationData = QoffaNotificationData;

/// Global Toast / In-App Notification overlay controller.
class QoffaToast {
  static final ValueNotifier<QoffaNotificationData?> activeToast =
      ValueNotifier<QoffaNotificationData?>(null);

  static Timer? _timer;
  static int _sequenceId = 0;

  /// Shows an in-app notification with solid filled-color styling, state icons,
  /// increased Inter typography, X exit button, and clickable word highlights.
  static void show({
    required String message,
    String? title,
    IconData? icon,
    QoffaNotificationType? type,
    Color? color,
    Duration duration = const Duration(milliseconds: 3200),
    List<QoffaNotificationHighlight> highlights = const [],
    String? actionLabel,
    VoidCallback? onAction,
    bool showProgress = false,
  }) {
    _timer?.cancel();
    _sequenceId++;

    final resolvedType = type ?? _inferType(color);

    activeToast.value = QoffaNotificationData(
      id: _sequenceId,
      message: message,
      title: title,
      icon: icon,
      type: resolvedType,
      customColor: (color != null && !_isStandardColor(color)) ? color : null,
      duration: duration,
      highlights: highlights,
      actionLabel: actionLabel,
      onAction: onAction,
      showProgress: showProgress,
    );

    _timer = Timer(duration, () {
      activeToast.value = null;
    });
  }

  /// Template function for showing an in-app notification with an animated countdown progress bar.
  /// Defaults to a 10-second duration suitable for undoable actions.
  static void showWithProgress({
    required String message,
    String? title,
    IconData? icon,
    QoffaNotificationType? type,
    Color? color,
    Duration duration = const Duration(seconds: 7),
    List<QoffaNotificationHighlight> highlights = const [],
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      message: message,
      title: title,
      icon: icon,
      type: type,
      color: color,
      duration: duration,
      highlights: highlights,
      actionLabel: actionLabel,
      onAction: onAction,
      showProgress: true,
    );
  }

  static QoffaNotificationType _inferType(Color? color) {
    if (color == null) return QoffaNotificationType.normal;
    final argb = color.toARGB32();
    if (color == QoffaColors.actionGreen ||
        color == QoffaColors.brandGreen ||
        argb == 0xFF087D34 ||
        argb == 0xFF0AA343) {
      return QoffaNotificationType.approved;
    }
    if (color == QoffaColors.warningCoral ||
        color == QoffaColors.warningCoralDeep ||
        argb == 0xFFFF6264 ||
        argb == 0xFFD94547 ||
        argb == 0xFFDC2626) {
      return QoffaNotificationType.declined;
    }
    return QoffaNotificationType.normal;
  }

  static bool _isStandardColor(Color color) {
    final argb = color.toARGB32();
    return color == QoffaColors.actionGreen ||
        color == QoffaColors.brandGreen ||
        color == QoffaColors.warningCoral ||
        color == QoffaColors.warningCoralDeep ||
        color == QoffaColors.skyBlue ||
        argb == 0xFFDC2626 ||
        argb == 0xFF1D4ED8;
  }

  /// Immediately dismisses the active notification with an upward exit animation.
  static void hide() {
    _timer?.cancel();
    activeToast.value = null;
  }

  /// Alias for hide.
  static void dismiss() => hide();
}

/// Global top overlay layer providing smooth slide-in, crossfading between
/// notifications, and slide-out dismiss animations.
class TopToastLayer extends StatefulWidget {
  const TopToastLayer({required this.child, super.key});

  final Widget child;

  @override
  State<TopToastLayer> createState() => _TopToastLayerState();
}

class _TopToastLayerState extends State<TopToastLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  QoffaNotificationData? _currentToast;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed &&
          QoffaToast.activeToast.value == null) {
        if (mounted) {
          setState(() {
            _currentToast = null;
          });
        }
      }
    });

    QoffaToast.activeToast.addListener(_handleToastChanged);
    final initial = QoffaToast.activeToast.value;
    if (initial != null) {
      _currentToast = initial;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    QoffaToast.activeToast.removeListener(_handleToastChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleToastChanged() {
    final next = QoffaToast.activeToast.value;
    if (next != null) {
      setState(() {
        _currentToast = next;
      });
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final toast = _currentToast;

    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (toast == null || (_controller.value == 0.0 && !_controller.isAnimating)) {
              return const SizedBox.shrink();
            }

            final safeTop = MediaQuery.of(context).padding.top;

            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _offsetAnimation,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, safeTop + 10, 16, 0),
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.primaryDelta! < -4) {
                          QoffaToast.hide();
                        }
                      },
                      child: QoffaNotificationBar(
                        data: toast,
                        onDismiss: QoffaToast.hide,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
