import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/qoffa_colors.dart';
import '../../../../app/theme/qoffa_tokens.dart';
import '../../../../core/particles_and_effects/particle_effect_presets.dart';
import '../../../../core/particles_and_effects/qoffa_particle_overlay.dart';
import '../../../../core/widgets/top_toast_notification.dart';
import '../../data/market_price_repository.dart';

class EditFoodItemSheet extends ConsumerStatefulWidget {
  const EditFoodItemSheet({
    super.key,
    required this.item,
  });

  final MarketPriceItem item;

  static Future<void> show(BuildContext context, {required MarketPriceItem item}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditFoodItemSheet(item: item),
    );
  }

  @override
  ConsumerState<EditFoodItemSheet> createState() => _EditFoodItemSheetState();
}

class _EditFoodItemSheetState extends ConsumerState<EditFoodItemSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  String? _selectedStoreId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.productName);
    _priceController =
        TextEditingController(text: '${widget.item.latestPriceDzd}');
    _selectedStoreId = widget.item.latestStoreId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _deleteItem() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        ),
        title: Text(
          l10n.delete,
          style: const TextStyle(
            fontFamily: QoffaFontFamily.display,
            fontWeight: FontWeight.w800,
            color: QoffaColors.warningCoralDeep,
          ),
        ),
        content: Text(
          l10n.deleteItemConfirm,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: QoffaColors.warningCoralDeep,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.delete,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final screenSize = MediaQuery.sizeOf(context);
      QoffaParticleOverlay.spawn(
        context,
        globalOrigin: Offset(screenSize.width * 0.5, screenSize.height * 0.45),
        config: ParticleEffectPresets.deletion,
        spawnWidth: screenSize.width * 0.7,
      );
      final repo = ref.read(marketPriceRepositoryProvider);
      await repo.removeFoodItem(widget.item.productId);

      if (mounted) {
        Navigator.of(context).pop();
        QoffaToast.show(
          title: widget.item.productName,
          message: l10n.itemRemovedSuccess,
          type: QoffaNotificationType.approved,
        );
      }
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final price = int.tryParse(_priceController.text.trim()) ??
        widget.item.latestPriceDzd;

    final repo = ref.read(marketPriceRepositoryProvider);
    await repo.updateFoodItemPriceAndStore(
      productId: widget.item.productId,
      priceDzd: price,
      storeId: _selectedStoreId,
      name: widget.item.isPremade ? null : _nameController.text.trim(),
    );

    if (mounted) {
      Navigator.of(context).pop();
      QoffaToast.show(
        title: widget.item.productName,
        message: l10n.itemUpdatedSuccess,
        type: QoffaNotificationType.approved,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final storesAsync = ref.watch(marketStoresProvider);
    final isPremade = widget.item.isPremade;

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
        child: SingleChildScrollView(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.editFoodItem,
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.display,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: QoffaColors.primaryNavy,
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

              const Divider(height: 1, color: QoffaColors.softBorder),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Premade Item Lock Info Banner
                    if (isPremade) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: QoffaColors.paleMintBackground,
                          borderRadius:
                              BorderRadius.circular(QoffaTokens.radiusFields),
                          border: Border.all(
                            color: QoffaColors.brandGreen.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_rounded,
                              size: 18,
                              color: QoffaColors.brandGreen,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.lockedNameExplanation,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: QoffaColors.primaryNavy,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Food Name Field
                    Text(
                      isPremade
                          ? l10n.premadeItemLockedName
                          : l10n.productNameOrItem,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      enabled: !isPremade,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isPremade
                            ? QoffaColors.secondarySage
                            : QoffaColors.primaryNavy,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isPremade
                            ? const Color(0xFFF1F5F2)
                            : Colors.white,
                        prefixIcon: Icon(
                          isPremade
                              ? Icons.lock_outline_rounded
                              : Icons.shopping_bag_outlined,
                          color: isPremade
                              ? QoffaColors.secondarySage
                              : QoffaColors.brandGreen,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(QoffaTokens.radiusFields),
                          borderSide: const BorderSide(
                            color: QoffaColors.softBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(QoffaTokens.radiusFields),
                          borderSide: const BorderSide(
                            color: QoffaColors.softBorder,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(QoffaTokens.radiusFields),
                          borderSide: BorderSide(
                            color: QoffaColors.softBorder.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price Field
                    Text(
                      '${l10n.purchasePrice} (${l10n.currencySymbol})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: QoffaColors.primaryNavy,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        suffixText: l10n.currencySymbol,
                        suffixStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: QoffaColors.brandGreen,
                        ),
                        prefixIcon: const Icon(
                          Icons.monetization_on_outlined,
                          color: QoffaColors.brandGreen,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(QoffaTokens.radiusFields),
                          borderSide: const BorderSide(
                            color: QoffaColors.softBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(QoffaTokens.radiusFields),
                          borderSide: const BorderSide(
                            color: QoffaColors.softBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(QoffaTokens.radiusFields),
                          borderSide: const BorderSide(
                            color: QoffaColors.brandGreen,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Store / Shop Selector
                    Text(
                      l10n.purchaseStore,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                    const SizedBox(height: 6),
                    storesAsync.when(
                      data: (stores) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(QoffaTokens.radiusFields),
                            border: Border.all(color: QoffaColors.softBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              isExpanded: true,
                              value: _selectedStoreId,
                              hint: Text(l10n.selectStoreOptional),
                              items: [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text(l10n.unspecified),
                                ),
                                ...stores.map(
                                  (s) => DropdownMenuItem<String?>(
                                    value: s.id,
                                    child: Text(s.name),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() => _selectedStoreId = val);
                              },
                            ),
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 24),

                    // Buttons Row: Delete and Save
                    Row(
                      children: [
                        // Delete Button
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: QoffaColors.warningCoralDeep,
                              side: const BorderSide(
                                color: QoffaColors.warningCoralDeep,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  QoffaTokens.radiusPill,
                                ),
                              ),
                            ),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                            ),
                            label: Text(
                              l10n.delete,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _deleteItem,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Save Button
                        Expanded(
                          flex: 3,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: QoffaColors.brandGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  QoffaTokens.radiusPill,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 18),
                            label: Text(
                              l10n.save,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: _save,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
