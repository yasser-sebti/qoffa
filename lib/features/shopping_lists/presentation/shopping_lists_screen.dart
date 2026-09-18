import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_layout.dart';
import '../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../data/market_price_repository.dart';
import 'widgets/add_food_item_sheet.dart';
import 'widgets/edit_food_item_sheet.dart';
import 'widgets/food_grid_card.dart';
import 'widgets/market_filter_sheet.dart';

class ShoppingListsScreen extends ConsumerStatefulWidget {
  const ShoppingListsScreen({super.key});

  @override
  ConsumerState<ShoppingListsScreen> createState() =>
      _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends ConsumerState<ShoppingListsScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  bool _isSyncing = false;
  late final AnimationController _syncAnimController;

  @override
  void initState() {
    super.initState();
    _syncAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _syncAnimController.dispose();
    super.dispose();
  }

  Future<void> _handleSync() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    _syncAnimController.repeat();

    final l10n = AppLocalizations.of(context);
    final repo = ref.read(marketPriceRepositoryProvider);

    try {
      await repo.syncMarketData();
      await Future<void>.delayed(const Duration(milliseconds: 600));
    } finally {
      if (mounted) {
        _syncAnimController.stop();
        _syncAnimController.reset();
        setState(() => _isSyncing = false);
        QoffaToast.show(
          title: l10n.foodListTitle,
          message: l10n.dataUpdatedSuccess,
          type: QoffaNotificationType.approved,
        );
      }
    }
  }

  IconData _resolveCategoryIcon(String iconKey) {
    switch (iconKey) {
      case 'apple':
        return Icons.eco_rounded;
      case 'meat':
        return Icons.restaurant_rounded;
      case 'egg':
        return Icons.egg_outlined;
      case 'bread':
        return Icons.bakery_dining_rounded;
      case 'drop':
        return Icons.local_grocery_store_rounded;
      case 'coffee':
        return Icons.local_cafe_rounded;
      case 'sparkle':
        return Icons.cleaning_services_rounded;
      default:
        return Icons.shopping_basket_rounded;
    }
  }

  Color _resolveCategoryColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return QoffaColors.brandGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filter = ref.watch(marketFilterProvider);
    final filteredItems = ref.watch(filteredMarketItemsProvider);
    final categoriesAsync = ref.watch(marketCategoriesProvider);

    return MintBackgroundScaffold(
      child: SafeArea(
        child: QoffaContentWidth(
          child: Column(
            children: [
              // Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: QoffaColors.primaryNavy,
                        size: 22,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        l10n.foodListTitle,
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.display,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                    ),

                    // Top Action: Update Data Button (Cloud sync)
                    RotationTransition(
                      turns: _syncAnimController,
                      child: IconButton(
                        tooltip: l10n.updateData,
                        icon: const Icon(
                          Icons.cloud_sync_rounded,
                          color: QoffaColors.brandGreen,
                          size: 26,
                        ),
                        onPressed: _handleSync,
                      ),
                    ),

                    // Top Action: Filter Button
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          tooltip: l10n.filterAndSort,
                          icon: Icon(
                            Icons.tune_rounded,
                            color: filter.hasActiveFilters
                                ? QoffaColors.brandGreen
                                : QoffaColors.primaryNavy,
                            size: 24,
                          ),
                          onPressed: () => MarketFilterSheet.show(context),
                        ),
                        if (filter.hasActiveFilters)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: QoffaColors.brandGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${filter.activeFilterCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Top Action: Add Food Item Button
                    IconButton(
                      tooltip: l10n.addFoodItem,
                      icon: const Icon(
                        Icons.add_circle_rounded,
                        color: QoffaColors.brandGreen,
                        size: 28,
                      ),
                      onPressed: () => AddFoodItemSheet.show(context),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(QoffaTokens.radiusFields),
                    border: Border.all(color: QoffaColors.softBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        offset: const Offset(0, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      ref.read(marketFilterProvider.notifier).update(
                            (state) => state.copyWith(searchQuery: val),
                          );
                    },
                    decoration: InputDecoration(
                      hintText: l10n.searchFoodHint,
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: QoffaColors.secondarySage,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: QoffaColors.secondarySage,
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: QoffaColors.secondarySage,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(marketFilterProvider.notifier).update(
                                      (state) => state.copyWith(searchQuery: ''),
                                    );
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Category Filter Chips
              categoriesAsync.when(
                data: (categories) {
                  return SizedBox(
                    height: 38,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          final isSelected =
                              filter.selectedCategoryId == null;
                          return _buildCategoryChip(
                            label: l10n.all,
                            icon: Icons.all_inclusive_rounded,
                            isSelected: isSelected,
                            onTap: () {
                              ref.read(marketFilterProvider.notifier).update(
                                    (s) => s.copyWith(
                                      selectedCategoryId: () => null,
                                    ),
                                  );
                            },
                          );
                        }

                        final cat = categories[index - 1];
                        final isSelected =
                            filter.selectedCategoryId == cat.id;

                        return _buildCategoryChip(
                          label: cat.localizedName(l10n.languageCode),
                          icon: _resolveCategoryIcon(cat.iconKey),
                          colorHex: cat.colorHex,
                          isSelected: isSelected,
                          onTap: () {
                            ref.read(marketFilterProvider.notifier).update(
                                  (s) => s.copyWith(
                                    selectedCategoryId: () =>
                                        isSelected ? null : cat.id,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(height: 38),
                error: (_, _) => const SizedBox(height: 38),
              ),

              const SizedBox(height: 10),

              // Main Food Catalog Body: 2x2 Grid separated by Categories
              Expanded(
                child: filteredItems.isEmpty
                    ? _buildEmptyState(context, l10n, filter)
                    : categoriesAsync.when(
                        data: (categories) => _buildCategorizedFoodGrid(
                          context,
                          filteredItems,
                          categories,
                          filter.selectedCategoryId,
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: QoffaColors.brandGreen,
                          ),
                        ),
                        error: (_, _) => _buildCategorizedFoodGrid(
                          context,
                          filteredItems,
                          const [],
                          filter.selectedCategoryId,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required IconData icon,
    String? colorHex,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final chipColor = colorHex != null
        ? _resolveCategoryColor(colorHex)
        : QoffaColors.brandGreen;

    return QoffaTactilePressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.white,
          borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
          border: Border.all(
            color: isSelected ? chipColor : QoffaColors.softBorder,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: chipColor.withValues(alpha: 0.25),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : chipColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : QoffaColors.primaryNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorizedFoodGrid(
    BuildContext context,
    List<MarketPriceItem> items,
    List<Category> allCategories,
    String? selectedCategoryId,
  ) {
    final l10n = AppLocalizations.of(context);

    // If a specific category is selected, just show that category's items
    if (selectedCategoryId != null) {
      final category = allCategories.firstWhere(
        (c) => c.id == selectedCategoryId,
        orElse: () => Category(
          id: selectedCategoryId,
          nameAr: items.isNotEmpty ? items.first.categoryName : '',
          nameFr: items.isNotEmpty ? (items.first.categoryNameFr ?? '') : '',
          nameEn: items.isNotEmpty ? (items.first.categoryNameEn ?? '') : '',
          iconKey: 'basket',
          colorHex: '#0AA343',
          sortOrder: 0,
          isSystem: true,
        ),
      );

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildCategoryHeader(category.localizedName(l10n.languageCode), items.length, category.iconKey, category.colorHex),
          const SizedBox(height: 10),
          _build2x2Grid(context, items),
          const SizedBox(height: 40),
        ],
      );
    }

    // Group items by categoryId
    final grouped = <String, List<MarketPriceItem>>{};
    for (final item in items) {
      final catId = item.categoryId ?? 'other';
      grouped.putIfAbsent(catId, () => []).add(item);
    }

    final categoryMap = {for (final c in allCategories) c.id: c};

    // Sort categories according to their defined order
    final sortedCategoryIds = grouped.keys.toList()
      ..sort((a, b) {
        final catA = categoryMap[a];
        final catB = categoryMap[b];
        final orderA = catA?.sortOrder ?? 999;
        final orderB = catB?.sortOrder ?? 999;
        return orderA.compareTo(orderB);
      });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: sortedCategoryIds.length,
      itemBuilder: (context, index) {
        final catId = sortedCategoryIds[index];
        final catItems = grouped[catId] ?? const [];
        final cat = categoryMap[catId];
        final catName = cat != null
            ? cat.localizedName(l10n.languageCode)
            : (catItems.isNotEmpty
                ? catItems.first.localizedCategoryName(l10n.languageCode)
                : l10n.otherCategory);
        final catIconKey = cat?.iconKey ??
            (catItems.isNotEmpty ? catItems.first.categoryIconKey : 'basket');
        final catColorHex = cat?.colorHex ??
            (catItems.isNotEmpty ? catItems.first.categoryColorHex : '#0AA343');

        return Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCategoryHeader(catName, catItems.length, catIconKey, catColorHex),
              const SizedBox(height: 10),
              _build2x2Grid(context, catItems),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(
    String title,
    int count,
    String iconKey,
    String colorHex,
  ) {
    final catColor = _resolveCategoryColor(colorHex);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: catColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _resolveCategoryIcon(iconKey),
            size: 16,
            color: catColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: QoffaFontFamily.display,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: QoffaColors.primaryNavy,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: QoffaColors.paleMintBackground,
            borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: QoffaColors.brandGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _build2x2Grid(BuildContext context, List<MarketPriceItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.35,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return FoodGridCard(
          item: item,
          onTap: () => EditFoodItemSheet.show(context, item: item),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    MarketFilterState filter,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: QoffaColors.paleMintBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 36,
                color: QoffaColors.brandGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noMarketItemsFound,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.display,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: QoffaColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.noMarketItemsMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: QoffaColors.secondarySage,
              ),
            ),
            if (filter.hasActiveFilters || filter.searchQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: QoffaColors.brandGreen,
                  side: const BorderSide(color: QoffaColors.brandGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  l10n.resetFilters,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  _searchController.clear();
                  ref.read(marketFilterProvider.notifier).state =
                      const MarketFilterState();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
