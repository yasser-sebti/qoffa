import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';

/// Single item for [QoffaAnchorDropdown].
class QoffaDropdownMenuItem<T> {
  const QoffaDropdownMenuItem({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

typedef QoffaAnchorDropdownBuilder = Widget Function(
  BuildContext context,
  VoidCallback showDropdown,
);

/// A clean, robust anchor-positioned dropdown menu that pops up directly
/// near the trigger button without using a full-screen or bottom-sheet modal.
///
/// Follows Qoffa's minimalist aesthetic:
/// - Clean text-only items (no icons)
/// - Solid green highlight ([QoffaColors.actionGreen]) for the active item
///   that fills edge-to-edge without gaps
/// - Instant, discrete hover highlight without ghosting/lagging artifacts
/// - Zero desktop scrollbar interference or gray focus glitches
/// - Clean border and soft shadow
/// - Dismissible barrier
class QoffaAnchorDropdown<T> extends StatefulWidget {
  const QoffaAnchorDropdown({
    required this.items,
    required this.onSelected,
    this.builder,
    this.child,
    this.selectedValue,
    this.menuWidth,
    this.maxMenuHeight = 280.0,
    this.itemHeight = 46.0,
    this.enabled = true,
    super.key,
  }) : assert(
          builder != null || child != null,
          'Either builder or child must be provided',
        );

  final List<QoffaDropdownMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final QoffaAnchorDropdownBuilder? builder;
  final Widget? child;
  final T? selectedValue;
  final double? menuWidth;
  final double maxMenuHeight;
  final double itemHeight;
  final bool enabled;

  @override
  State<QoffaAnchorDropdown<T>> createState() => _QoffaAnchorDropdownState<T>();
}

class _QoffaAnchorDropdownState<T> extends State<QoffaAnchorDropdown<T>> {
  final GlobalKey _anchorKey = GlobalKey();

  void _showDropdown() {
    if (!widget.enabled || widget.items.isEmpty) return;

    final renderBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final width = widget.menuWidth ?? size.width;
    final itemH = widget.itemHeight;
    final totalContentHeight = widget.items.length * itemH;

    final spaceBelow = screenHeight -
        (offset.dy + size.height) -
        mediaQuery.padding.bottom -
        16.0;
    final spaceAbove = offset.dy - mediaQuery.padding.top - 16.0;

    final showAbove =
        spaceBelow < widget.maxMenuHeight && spaceAbove > spaceBelow;
    final availableSpace = showAbove ? spaceAbove : spaceBelow;

    // Calculate maximum full items that fit within maxMenuHeight and available space
    final maxAllowedItems =
        (widget.maxMenuHeight / itemH).floor().clamp(1, widget.items.length);
    final maxFitInSpace =
        (availableSpace / itemH).floor().clamp(1, widget.items.length);
    final visibleItemsCount = min(maxAllowedItems, maxFitInSpace);

    // Size exactly to an integer multiple of itemHeight so no item is awkwardly sliced
    final menuHeight = (widget.items.length <= visibleItemsCount)
        ? totalContentHeight
        : (visibleItemsCount * itemH);

    final left = offset.dx
        .clamp(12.0, (screenWidth - width - 12.0).clamp(12.0, screenWidth));

    final top = showAbove
        ? (offset.dy - 6.0 - menuHeight)
            .clamp(mediaQuery.padding.top + 12.0, screenHeight)
        : (offset.dy + size.height + 6.0);

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Dropdown',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 140),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return FocusScope(
          canRequestFocus: false,
          child: Theme(
            data: Theme.of(dialogContext).copyWith(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              scrollbarTheme: const ScrollbarThemeData(
                thumbColor: WidgetStatePropertyAll(Colors.transparent),
                trackColor: WidgetStatePropertyAll(Colors.transparent),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: left,
                  top: top,
                  width: width,
                  child: Material(
                    color: Colors.transparent,
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        alignment: showAbove
                            ? Alignment.bottomCenter
                            : Alignment.topCenter,
                        child: Container(
                          height: menuHeight + 3.0, // accounts for 1.5 border width top + bottom
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: QoffaColors.softBorder,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.5),
                            child: MediaQuery.removePadding(
                              context: dialogContext,
                              removeTop: true,
                              removeBottom: true,
                              removeLeft: true,
                              removeRight: true,
                              child: ScrollConfiguration(
                                behavior: const _NoScrollbarBehavior(),
                                child: SingleChildScrollView(
                                  primary: false,
                                  padding: EdgeInsets.zero,
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int i = 0;
                                          i < widget.items.length;
                                          i++)
                                        _QoffaDropdownItem<T>(
                                          key: ValueKey(widget.items[i].value),
                                          item: widget.items[i],
                                          isSelected: widget.items[i].value ==
                                              widget.selectedValue,
                                          height: itemH,
                                          onTap: () {
                                            Navigator.pop(dialogContext);
                                            widget.onSelected(
                                                widget.items[i].value);
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return KeyedSubtree(
        key: _anchorKey,
        child: widget.builder!(context, _showDropdown),
      );
    }
    return GestureDetector(
      key: _anchorKey,
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? _showDropdown : null,
      child: widget.child!,
    );
  }
}

class _NoScrollbarBehavior extends ScrollBehavior {
  const _NoScrollbarBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}

class _QoffaDropdownItem<T> extends StatefulWidget {
  const _QoffaDropdownItem({
    required this.item,
    required this.isSelected,
    required this.height,
    required this.onTap,
    super.key,
  });

  final QoffaDropdownMenuItem<T> item;
  final bool isSelected;
  final double height;
  final VoidCallback onTap;

  @override
  State<_QoffaDropdownItem<T>> createState() => _QoffaDropdownItemState<T>();
}

class _QoffaDropdownItemState<T> extends State<_QoffaDropdownItem<T>> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;

    if (widget.isSelected) {
      textColor = Colors.white;
      if (_isPressed) {
        bgColor = QoffaColors.pressedGreen;
      } else if (_isHovered) {
        bgColor = const Color(0xFF07702F);
      } else {
        bgColor = QoffaColors.actionGreen;
      }
    } else {
      textColor = QoffaColors.primaryNavy;
      if (_isPressed) {
        bgColor = const Color(0xFFE5E7EB);
      } else if (_isHovered) {
        bgColor = const Color(0xFFF3F4F6);
      } else {
        bgColor = Colors.transparent;
      }
    }

    return MouseRegion(
      opaque: true,
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (mounted && !_isHovered) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (mounted && _isHovered) {
          setState(() => _isHovered = false);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          if (mounted && !_isPressed) {
            setState(() => _isPressed = true);
          }
        },
        onTapUp: (_) {
          if (mounted && _isPressed) {
            setState(() => _isPressed = false);
          }
        },
        onTapCancel: () {
          if (mounted && _isPressed) {
            setState(() => _isPressed = false);
          }
        },
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: Container(
          height: widget.height,
          width: double.infinity,
          color: bgColor,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: AnimatedScale(
            scale: _isPressed ? 0.985 : 1.0,
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeOutCubic,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: 15.5,
                fontWeight:
                    widget.isSelected ? FontWeight.w700 : FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
