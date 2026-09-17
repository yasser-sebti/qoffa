import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';
import 'qoffa_fade_pressable.dart';
import 'qoffa_pressable.dart';
import 'qoffa_tactile_pressable.dart';

/// A reusable, premium swipe-up bottom sheet template for searchable entity picking.
///
/// Follows the established Qoffa design system:
/// - Smooth handle bar
/// - Bold typography header
/// - Live search field with instant clear chip
/// - Dropdown results card with soft border & elevation
/// - Optional inline "Add new..." action
/// - Recent picked items section with tactile cards
/// - Full keyboard avoidance
class QoffaSearchPickerSheet<T> extends StatefulWidget {
  const QoffaSearchPickerSheet({
    super.key,
    required this.title,
    required this.searchLabel,
    required this.onSearch,
    required this.itemBuilder,
    this.recentTitle,
    this.recentItems = const [],
    this.recentItemBuilder,
    this.canAddNew = false,
    this.addNewLabelBuilder,
    this.onAddNew,
    this.quickActionWidget,
    this.initialQuery = '',
    this.emptyResultsWidget,
  });

  final String title;
  final String searchLabel;
  final FutureOr<List<T>> Function(String query) onSearch;
  final Widget Function(BuildContext context, T item, VoidCallback onSelect)
      itemBuilder;
  final String? recentTitle;
  final List<T> recentItems;
  final Widget Function(BuildContext context, T item, VoidCallback onSelect)?
      recentItemBuilder;
  final bool canAddNew;
  final String Function(String query)? addNewLabelBuilder;
  final FutureOr<void> Function(BuildContext context, String query)? onAddNew;
  final Widget? quickActionWidget;
  final String initialQuery;
  final Widget? emptyResultsWidget;

  /// Convenience method to display the picker as a modal bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String searchLabel,
    required FutureOr<List<T>> Function(String query) onSearch,
    required Widget Function(BuildContext context, T item, VoidCallback onSelect)
        itemBuilder,
    String? recentTitle,
    List<T> recentItems = const [],
    Widget Function(BuildContext context, T item, VoidCallback onSelect)?
        recentItemBuilder,
    bool canAddNew = false,
    String Function(String query)? addNewLabelBuilder,
    FutureOr<void> Function(BuildContext context, String query)? onAddNew,
    Widget? quickActionWidget,
    String initialQuery = '',
    Widget? emptyResultsWidget,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(QoffaTokens.radiusMajor),
            ),
          ),
          child: SafeArea(
            top: false,
            child: QoffaSearchPickerSheet<T>(
              title: title,
              searchLabel: searchLabel,
              onSearch: onSearch,
              itemBuilder: itemBuilder,
              recentTitle: recentTitle,
              recentItems: recentItems,
              recentItemBuilder: recentItemBuilder,
              canAddNew: canAddNew,
              addNewLabelBuilder: addNewLabelBuilder,
              onAddNew: onAddNew,
              quickActionWidget: quickActionWidget,
              initialQuery: initialQuery,
              emptyResultsWidget: emptyResultsWidget,
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<QoffaSearchPickerSheet<T>> createState() =>
      _QoffaSearchPickerSheetState<T>();
}

class _QoffaSearchPickerSheetState<T> extends State<QoffaSearchPickerSheet<T>> {
  late final TextEditingController _searchController;
  List<T> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.trim().isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      final results = await widget.onSearch(trimmed);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasQuery = _searchController.text.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle pill
          Center(
            child: Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: QoffaColors.softBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Sheet Title
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 18),

          // Search Field
          TextField(
            controller: _searchController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: QoffaColors.primaryNavy,
            ),
            cursorColor: QoffaColors.actionGreen,
            decoration: InputDecoration(
              labelText: widget.searchLabel,
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: QoffaColors.actionGreen,
              ),
              suffixIcon: hasQuery
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: QoffaColors.mintSurfaceTint,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: QoffaColors.softBorder,
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: QoffaColors.actionGreen,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.cancel,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: QoffaColors.actionGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            onChanged: _performSearch,
          ),

          // Search results dropdown card
          if (hasQuery) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
                border: Border.all(
                  color: QoffaColors.softBorder,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: QoffaColors.actionGreen,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    ..._searchResults.take(5).map((item) {
                      return QoffaPressable(
                        borderRadius: BorderRadius.circular(
                          QoffaTokens.radiusFields,
                        ),
                        onTap: () => Navigator.pop(context, item),
                        child: widget.itemBuilder(
                          context,
                          item,
                          () => Navigator.pop(context, item),
                        ),
                      );
                    }),
                    if (widget.canAddNew && widget.onAddNew != null)
                      QoffaFadePressable(
                        onTap: () => widget.onAddNew!(
                          context,
                          _searchController.text.trim(),
                        ),
                        borderRadius: BorderRadius.circular(
                          QoffaTokens.radiusFields,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: QoffaColors.mintSurfaceTint
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(
                              QoffaTokens.radiusFields,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_circle_outline_rounded,
                                color: QoffaColors.actionGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.addNewLabelBuilder != null
                                      ? widget.addNewLabelBuilder!(
                                          _searchController.text.trim(),
                                        )
                                      : l10n.create,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: QoffaColors.actionGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],

          // Quick Action Widget if supplied (e.g. Add button when empty)
          if (widget.quickActionWidget != null) ...[
            const SizedBox(height: 12),
            widget.quickActionWidget!,
          ],

          // Recent Picked Items Section
          if (!hasQuery && widget.recentItems.isNotEmpty) ...[
            const SizedBox(height: 22),
            Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: QoffaColors.actionGreen,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.recentTitle ?? l10n.recentActivity,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...widget.recentItems.take(5).map((item) {
              if (widget.recentItemBuilder != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: widget.recentItemBuilder!(
                    context,
                    item,
                    () => Navigator.pop(context, item),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: widget.itemBuilder(
                  context,
                  item,
                  () => Navigator.pop(context, item),
                ),
              );
            }),
          ],

          const SizedBox(height: 16),
          // Cancel Bottom Button
          QoffaTactilePressable.outline(
            width: double.infinity,
            height: 52,
            label: l10n.cancel,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
