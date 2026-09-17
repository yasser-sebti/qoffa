import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';

class ToastNotificationData {
  const ToastNotificationData({
    required this.message,
    this.title,
    this.icon,
    this.color = QoffaColors.actionGreen,
    this.duration = const Duration(milliseconds: 3000),
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? title;
  final IconData? icon;
  final Color color;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
}

/// Global Toast / Banner overlay controller for non-blocking feedback
class QoffaToast {
  static final ValueNotifier<ToastNotificationData?> activeToast =
      ValueNotifier<ToastNotificationData?>(null);

  static Timer? _timer;

  static void show({
    required String message,
    String? title,
    IconData? icon,
    Color color = QoffaColors.actionGreen,
    Duration duration = const Duration(milliseconds: 3000),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _timer?.cancel();
    activeToast.value = ToastNotificationData(
      message: message,
      title: title,
      icon: icon,
      color: color,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
    _timer = Timer(duration, () {
      activeToast.value = null;
    });
  }

  static void hide() {
    _timer?.cancel();
    activeToast.value = null;
  }
}

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, -1.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInBack,
          ),
        );

    QoffaToast.activeToast.addListener(_handleToastChanged);
  }

  @override
  void dispose() {
    QoffaToast.activeToast.removeListener(_handleToastChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleToastChanged() {
    if (QoffaToast.activeToast.value != null) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ValueListenableBuilder<ToastNotificationData?>(
          valueListenable: QoffaToast.activeToast,
          builder: (context, toast, _) {
            if (toast == null && !_controller.isAnimating) {
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: QoffaColors.whiteSurface,
                          borderRadius: BorderRadius.circular(
                            QoffaTokens.radiusFields,
                          ),
                          border: Border.all(
                            color: toast?.color ?? QoffaColors.actionGreen,
                            width: 2.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (toast?.icon != null) ...[
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color:
                                      (toast?.color ?? QoffaColors.actionGreen)
                                          .withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  toast!.icon,
                                  color: toast.color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (toast?.title != null) ...[
                                    Text(
                                      toast!.title!,
                                      style: TextStyle(
                                        fontFamily: 'Hero Sandwich Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: toast.color,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                  Text(
                                    toast?.message ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: QoffaColors.primaryNavy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (toast?.onAction != null) ...[
                              const SizedBox(width: 8),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: QoffaColors.mintSurfaceTint,
                                  foregroundColor: QoffaColors.actionGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                ),
                                onPressed: () {
                                  toast?.onAction?.call();
                                  QoffaToast.hide();
                                },
                                child: Text(
                                  toast?.actionLabel ??
                                      AppLocalizations.of(context).undo,
                                  style: const TextStyle(
                                    fontFamily: 'Alexandria',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
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
