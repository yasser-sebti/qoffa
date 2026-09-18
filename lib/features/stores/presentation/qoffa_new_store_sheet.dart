import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../data/store_repository.dart';
import '../domain/store_type.dart';

/// Modal bottom sheet to create a new store with rich metadata:
/// - Store name
/// - Algerian store type
/// - Location / Neighborhood
/// - 1–5 star rating system
class QoffaNewStoreSheet extends ConsumerStatefulWidget {
  const QoffaNewStoreSheet({
    super.key,
    this.initialName,
  });

  final String? initialName;

  static Future<Store?> show(
    BuildContext context, {
    String? initialName,
  }) {
    return showModalBottomSheet<Store>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.90,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(QoffaTokens.radiusMajor),
            ),
          ),
          child: SafeArea(
            top: false,
            child: QoffaNewStoreSheet(initialName: initialName),
          ),
        ),
      ),
    );
  }

  @override
  ConsumerState<QoffaNewStoreSheet> createState() => _QoffaNewStoreSheetState();
}

class _QoffaNewStoreSheetState extends ConsumerState<QoffaNewStoreSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _areaController;
  StoreType _selectedStoreType = StoreType.grocery;
  int? _rating = 5; // Default 5 stars or user selectable
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _areaController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      QoffaToast.show(
        message: l10n.storeNameRequired,
        color: QoffaColors.warningCoral,
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final store = await ref.read(storeRepositoryProvider).createStore(
            name: name,
            area: _areaController.text.trim(),
            storeType: _selectedStoreType.id,
            rating: _rating,
          );
      if (mounted) {
        Navigator.pop(context, store);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        QoffaToast.show(
          message: l10n.errorMessage(e),
          color: QoffaColors.warningCoral,
        );
      }
    }
  }

  String _ratingLabel(int? rating, AppLocalizations l10n) {
    if (rating == null || rating == 0) {
      return l10n.isArabic ? 'بدون تقييم' : 'Unrated';
    }
    switch (rating) {
      case 5:
        return l10n.isArabic ? '5.0 ★ ممتاز' : '5.0 ★ Excellent';
      case 4:
        return l10n.isArabic ? '4.0 ★ جيد جداً' : '4.0 ★ Very Good';
      case 3:
        return l10n.isArabic ? '3.0 ★ جيد' : '3.0 ★ Good';
      case 2:
        return l10n.isArabic ? '2.0 ★ مقبول' : '2.0 ★ Fair';
      case 1:
        return l10n.isArabic ? '1.0 ★ ضعيف' : '1.0 ★ Poor';
      default:
        return '$rating ★';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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

          // Title
          Text(
            l10n.newStoreDetails,
            style: const TextStyle(
              fontFamily: QoffaFontFamily.display,
              fontFamilyFallback: QoffaFontFamily.fallback,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 18),

          // 1. Store Name Field
          TextField(
            controller: _nameController,
            autofocus: widget.initialName?.isEmpty ?? true,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontFamily: QoffaFontFamily.body,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: QoffaColors.primaryNavy,
            ),
            cursorColor: QoffaColors.actionGreen,
            decoration: InputDecoration(
              labelText: l10n.storeName,
              prefixIcon: const Icon(
                Icons.storefront_rounded,
                color: QoffaColors.actionGreen,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 2. Store Type Selector (Algerian Retail Types)
          Row(
            children: [
              const Icon(
                Icons.category_rounded,
                size: 18,
                color: QoffaColors.actionGreen,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.storeType,
                style: const TextStyle(
                  fontFamily: QoffaFontFamily.body,
                  fontSize: QoffaFontSize.bodySmall,
                  fontWeight: FontWeight.w700,
                  color: QoffaColors.primaryNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: StoreType.values.map((type) {
              final isSelected = type == _selectedStoreType;
              return QoffaTactilePressable(
                onTap: () => setState(() => _selectedStoreType = type),
                height: 38,
                borderRadius: BorderRadius.circular(12),
                backgroundColor: isSelected
                    ? QoffaColors.mintSurfaceTint
                    : QoffaColors.whiteSurface,
                borderColor: isSelected
                    ? QoffaColors.actionGreen
                    : QoffaColors.softBorder,
                borderWidth: isSelected ? 1.5 : 1.2,
                hoverBackgroundColor: QoffaColors.mintSurfaceTint,
                hoverBorderColor: QoffaColors.actionGreen,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type.icon,
                      size: 17,
                      color: isSelected
                          ? QoffaColors.actionGreen
                          : QoffaColors.secondarySage,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        type.localizedName(l10n.languageCode),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: QoffaFontFamily.body,
                          fontSize: QoffaFontSize.captionMedium,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? QoffaColors.actionGreen
                              : QoffaColors.primaryNavy,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          // 3. Location / Area Field
          TextField(
            controller: _areaController,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontFamily: QoffaFontFamily.body,
              fontSize: QoffaFontSize.bodyMedium,
              fontWeight: FontWeight.w600,
              color: QoffaColors.primaryNavy,
            ),
            cursorColor: QoffaColors.actionGreen,
            decoration: InputDecoration(
              labelText: l10n.storeLocation,
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: QoffaColors.actionGreen,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 4. Rating System (1–5 Stars)
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: QoffaColors.goldAccent,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.storeRating,
                style: const TextStyle(
                  fontFamily: QoffaFontFamily.body,
                  fontSize: QoffaFontSize.bodySmall,
                  fontWeight: FontWeight.w700,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _ratingLabel(_rating, l10n),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: QoffaFontFamily.body,
                    fontSize: QoffaFontSize.bodySmall,
                    fontWeight: FontWeight.w700,
                    color: QoffaColors.goldAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              final starVal = index + 1;
              final isFilled = _rating != null && starVal <= _rating!;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _StarRatingButton(
                  starVal: starVal,
                  isFilled: isFilled,
                  onTap: () {
                    setState(() {
                      if (_rating == starVal) {
                        _rating = null; // Toggle unrated
                      } else {
                        _rating = starVal;
                      }
                    });
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Actions: Confirm & Cancel
          Row(
            children: [
              Expanded(
                child: QoffaTactilePressable.outline(
                  height: 52,
                  label: l10n.cancel,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QoffaTactilePressable.filled(
                  height: 52,
                  label: l10n.save,
                  icon: Icons.check_rounded,
                  enabled: !_isSaving,
                  onTap: _handleSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StarRatingButton extends StatefulWidget {
  const _StarRatingButton({
    required this.starVal,
    required this.isFilled,
    required this.onTap,
  });

  final int starVal;
  final bool isFilled;
  final VoidCallback onTap;

  @override
  State<_StarRatingButton> createState() => _StarRatingButtonState();
}

class _StarRatingButtonState extends State<_StarRatingButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.isFilled;
    final isHighlighted = isFilled || _isHovered;

    final Color bgColor;
    final Color borderColor;
    final Color iconColor;
    final IconData iconData;

    if (isFilled) {
      bgColor = QoffaColors.goldAccent.withValues(alpha: 0.14);
      borderColor = QoffaColors.goldAccent;
      iconColor = QoffaColors.goldAccent;
      iconData = Icons.star_rounded;
    } else if (_isHovered) {
      bgColor = const Color(0xFFFEF3C7);
      borderColor = const Color(0xFFD97706);
      iconColor = const Color(0xFFD97706);
      iconData = Icons.star_rounded;
    } else {
      bgColor = const Color(0xFFF2F7F4);
      borderColor = const Color(0xFFB4CEBE);
      iconColor = const Color(0xFF4A6154);
      iconData = Icons.star_outline_rounded;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: QoffaTactilePressable(
        width: 44,
        height: 44,
        borderRadius: BorderRadius.circular(12),
        backgroundColor: bgColor,
        borderColor: borderColor,
        borderWidth: isHighlighted ? 1.5 : 1.2,
        hoverBackgroundColor: bgColor,
        hoverBorderColor: borderColor,
        padding: EdgeInsets.zero,
        onTap: widget.onTap,
        child: Icon(
          iconData,
          size: 24,
          color: iconColor,
        ),
      ),
    );
  }
}

