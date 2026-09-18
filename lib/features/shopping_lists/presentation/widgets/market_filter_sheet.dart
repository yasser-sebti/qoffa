import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/qoffa_colors.dart';
import '../../../../app/theme/qoffa_tokens.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../data/market_price_repository.dart';

class MarketFilterSheet extends ConsumerStatefulWidget {
  const MarketFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MarketFilterSheet(),
    );
  }

  @override
  ConsumerState<MarketFilterSheet> createState() => _MarketFilterSheetState();
}

class _MarketFilterSheetState extends ConsumerState<MarketFilterSheet> {
  late MarketSortOption _sortOption;
  String? _selectedCategoryId;
  String? _selectedStoreId;

  @override
  void initState() {
    super.initState();
    final current = ref.read(marketFilterProvider);
    _sortOption = current.sortOption;
    _selectedCategoryId = current.selectedCategoryId;
    _selectedStoreId = current.selectedStoreId;
  }

  void _reset() {
    setState(() {
      _sortOption = MarketSortOption.dateDesc;
      _selectedCategoryId = null;
      _selectedStoreId = null;
    });
  }

  void _apply() {
    ref.read(marketFilterProvider.notifier).update(
          (state) => state.copyWith(
            sortOption: _sortOption,
            selectedCategoryId: () => _selectedCategoryId,
            selectedStoreId: () => _selectedStoreId,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(marketCategoriesProvider);
    final storesAsync = ref.watch(marketStoresProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(QoffaTokens.radiusMajor),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: QoffaColors.softBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),

            // Title Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    l10n.filterAndSort,
                    style: const TextStyle(
                      fontFamily: QoffaFontFamily.display,
                      fontFamilyFallback: QoffaFontFamily.fallback,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _reset,
                    child: Text(
                      l10n.resetFilters,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.warningCoralDeep,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEDF4EF)),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort By Section
                    Text(
                      l10n.filterAndSort,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SortChip(
                          label: l10n.sortDateNewest,
                          selected: _sortOption == MarketSortOption.dateDesc,
                          onSelected: () => setState(
                            () => _sortOption = MarketSortOption.dateDesc,
                          ),
                        ),
                        _SortChip(
                          label: l10n.sortPriceLowToHigh,
                          selected: _sortOption == MarketSortOption.priceAsc,
                          onSelected: () => setState(
                            () => _sortOption = MarketSortOption.priceAsc,
                          ),
                        ),
                        _SortChip(
                          label: l10n.sortPriceHighToLow,
                          selected: _sortOption == MarketSortOption.priceDesc,
                          onSelected: () => setState(
                            () => _sortOption = MarketSortOption.priceDesc,
                          ),
                        ),
                        _SortChip(
                          label: l10n.sortMostBought,
                          selected: _sortOption == MarketSortOption.mostBought,
                          onSelected: () => setState(
                            () => _sortOption = MarketSortOption.mostBought,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Universal Grocery Departments
                    Text(
                      l10n.allDepartments,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    categoriesAsync.when(
                      data: (categories) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _ChoiceChip(
                              label: l10n.allDepartments,
                              selected: _selectedCategoryId == null,
                              onSelected: () => setState(() => _selectedCategoryId = null),
                            ),
                            for (final cat in categories)
                              _ChoiceChip(
                                label: cat.localizedName(l10n.languageCode),
                                selected: _selectedCategoryId == cat.id,
                                onSelected: () => setState(() => _selectedCategoryId = cat.id),
                              ),
                          ],
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (err, stack) => const SizedBox(),
                    ),

                    const SizedBox(height: 22),

                    // Stores
                    Text(
                      l10n.allStores,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    storesAsync.when(
                      data: (stores) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _ChoiceChip(
                              label: l10n.allStores,
                              selected: _selectedStoreId == null,
                              onSelected: () => setState(() => _selectedStoreId = null),
                            ),
                            for (final store in stores)
                              _ChoiceChip(
                                label: store.name,
                                selected: _selectedStoreId == store.id,
                                onSelected: () => setState(() => _selectedStoreId = store.id),
                              ),
                          ],
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (err, stack) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),

            // Apply Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: QoffaTactilePressable.filled(
                height: 50,
                label: l10n.applyFilters,
                backgroundColor: QoffaColors.actionGreen,
                onTap: _apply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? QoffaColors.actionGreen : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? QoffaColors.actionGreen : QoffaColors.softBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: QoffaFontFamily.body,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? Colors.white : QoffaColors.primaryNavy,
          ),
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? QoffaColors.actionGreen : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? QoffaColors.actionGreen : QoffaColors.softBorder,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: QoffaFontFamily.body,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? Colors.white : QoffaColors.primaryNavy,
          ),
        ),
      ),
    );
  }
}
