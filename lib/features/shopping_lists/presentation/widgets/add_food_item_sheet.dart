import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/qoffa_colors.dart';
import '../../../../app/theme/qoffa_tokens.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../../../core/widgets/top_toast_notification.dart';
import '../../data/market_price_repository.dart';

class AddFoodItemSheet extends ConsumerStatefulWidget {
  const AddFoodItemSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddFoodItemSheet(),
    );
  }

  @override
  ConsumerState<AddFoodItemSheet> createState() => _AddFoodItemSheetState();
}

class _AddFoodItemSheetState extends ConsumerState<AddFoodItemSheet> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedStoreId;
  String _selectedUnit = 'piece';

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    final catId = _selectedCategoryId ?? 'cat_pantry';

    final repo = ref.read(marketPriceRepositoryProvider);
    await repo.addFoodItem(
      name: name,
      categoryId: catId,
      priceDzd: price,
      storeId: _selectedStoreId,
      unitId: _selectedUnit,
    );

    if (mounted) {
      Navigator.of(context).pop();
      QoffaToast.show(
        title: name,
        message: l10n.itemAddedSuccess,
        type: QoffaNotificationType.approved,
      );
    }
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

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    l10n.addFoodItem,
                    style: const TextStyle(
                      fontFamily: QoffaFontFamily.display,
                      fontFamilyFallback: QoffaFontFamily.fallback,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                  const Spacer(),
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
                    // Name Field
                    Text(
                      l10n.productName,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.productSearchPlaceholder,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: QoffaColors.softBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: QoffaColors.softBorder),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price & Unit Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l10n.purchasePrice} (${l10n.currencySymbol}) *',
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.body,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.display,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                                decoration: InputDecoration(
                                  hintText: '140',
                                  suffixText: l10n.currencySymbol,
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: QoffaColors.softBorder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: QoffaColors.softBorder),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.unit,
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.body,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: QoffaColors.softBorder),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedUnit,
                                    isExpanded: true,
                                    items: [
                                      DropdownMenuItem(value: 'piece', child: Text(l10n.unitName('piece'))),
                                      DropdownMenuItem(value: 'kg', child: Text(l10n.unitName('kg'))),
                                      DropdownMenuItem(value: 'l', child: Text(l10n.unitName('l'))),
                                      DropdownMenuItem(value: 'pack', child: Text(l10n.unitName('pack'))),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => _selectedUnit = val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Category Selector
                    Text(
                      l10n.departmentCategory,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    categoriesAsync.when(
                      data: (categories) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final cat in categories)
                              InkWell(
                                onTap: () => setState(() => _selectedCategoryId = cat.id),
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedCategoryId == cat.id
                                        ? QoffaColors.actionGreen
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _selectedCategoryId == cat.id
                                          ? QoffaColors.actionGreen
                                          : QoffaColors.softBorder,
                                    ),
                                  ),
                                  child: Text(
                                    cat.localizedName(l10n.languageCode),
                                    style: TextStyle(
                                      fontFamily: QoffaFontFamily.body,
                                      fontSize: 12.5,
                                      fontWeight: _selectedCategoryId == cat.id
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      color: _selectedCategoryId == cat.id
                                          ? Colors.white
                                          : QoffaColors.primaryNavy,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => const SizedBox(),
                    ),

                    const SizedBox(height: 16),

                    // Store Selector
                    Text(
                      l10n.store,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    storesAsync.when(
                      data: (stores) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final store in stores)
                              InkWell(
                                onTap: () => setState(() => _selectedStoreId = store.id),
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedStoreId == store.id
                                        ? QoffaColors.actionGreen
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _selectedStoreId == store.id
                                          ? QoffaColors.actionGreen
                                          : QoffaColors.softBorder,
                                    ),
                                  ),
                                  child: Text(
                                    store.name,
                                    style: TextStyle(
                                      fontFamily: QoffaFontFamily.body,
                                      fontSize: 12.5,
                                      fontWeight: _selectedStoreId == store.id
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      color: _selectedStoreId == store.id
                                          ? Colors.white
                                          : QoffaColors.primaryNavy,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),

            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: QoffaTactilePressable.filled(
                height: 50,
                label: l10n.addFoodItem,
                backgroundColor: QoffaColors.actionGreen,
                onTap: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
