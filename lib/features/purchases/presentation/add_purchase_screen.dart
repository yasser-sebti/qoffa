import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/units/unit_registry.dart';
import '../../../core/widgets/barcode_scanner_modal.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../../core/widgets/qoffa_icon_button.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../../later_buy/data/later_buy_repository.dart';
import '../../products/data/product_repository.dart';
import '../../shopping_lists/data/shopping_list_repository.dart';
import '../data/purchase_repository.dart';

class AddPurchaseScreen extends ConsumerStatefulWidget {
  const AddPurchaseScreen({super.key});

  @override
  ConsumerState<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends ConsumerState<AddPurchaseScreen> {
  final _productController = TextEditingController(text: 'Candia Milk 1L');
  final _priceController = TextEditingController(text: '165');
  double _quantity = 1.0;
  String _selectedUnitId = 'bottle';
  String _selectedStore = 'Local shop';
  DateTime _selectedDate = DateTime.now();
  int? _lastPriceDzd = 145;
  bool _isUnitPrice = true;
  String? _selectedProductId;
  List<Product> _matchingProducts = [];

  @override
  void dispose() {
    _productController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _onProductSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      if (mounted) setState(() => _matchingProducts = []);
      return;
    }
    final results = await ref.read(productRepositoryProvider).searchProducts(trimmed);
    if (mounted) {
      setState(() {
        _matchingProducts = results;
      });
    }
  }

  void _selectProduct(Product product) {
    setState(() {
      _productController.text = product.name;
      _selectedProductId = product.id;
      _selectedUnitId = product.preferredUnitId;
      _lastPriceDzd = product.lastPriceDzd;
      _matchingProducts = [];
      _priceController.clear();
    });
  }

  int get _todayDiff {
    final currentPrice = int.tryParse(_priceController.text) ?? 0;
    if (_lastPriceDzd == null || currentPrice == 0) return 0;
    return currentPrice - _lastPriceDzd!;
  }

  void _incrementQty() {
    setState(() {
      _quantity += 1.0;
    });
  }

  void _decrementQty() {
    if (_quantity > 1.0) {
      setState(() {
        _quantity -= 1.0;
      });
    }
  }

  Future<void> _handleBought() async {
    final name = _productController.text.trim();
    if (name.isEmpty) return;

    final price = int.tryParse(_priceController.text) ?? 0;
    if (price <= 0) return;

    final productRepo = ref.read(productRepositoryProvider);
    final purchaseRepo = ref.read(purchaseRepositoryProvider);

    // Get or create product
    var product = _selectedProductId != null
        ? await productRepo.getProductById(_selectedProductId!)
        : null;

    if (product == null) {
      final search = await productRepo.searchProducts(name);
      if (search.isNotEmpty && search.first.name.toLowerCase() == name.toLowerCase()) {
        product = search.first;
      } else {
        product = await productRepo.createProduct(
          name: name,
          preferredUnitId: _selectedUnitId,
          initialPriceDzd: price,
        );
      }
    }

    final purchase = await purchaseRepo.createPurchase(
      productId: product.id,
      quantity: _quantity,
      unitId: _selectedUnitId,
      priceDzd: price,
      isUnitPrice: _isUnitPrice,
      purchasedAt: _selectedDate,
      note: name,
    );

    // Show non-blocking confirmation toast with 5-second Undo
    final diff = _todayDiff;
    final message = diff != 0
        ? '${diff > 0 ? '+' : ''}$diff DA vs last price ($name)'
        : '$name (${price * _quantity.toInt()} DA)';

    QoffaToast.show(
      title: 'تم تسجيل الشراء بنجاح',
      message: message,
      icon: Icons.check_circle_rounded,
      color: diff > 0 ? QoffaColors.warningCoral : QoffaColors.actionGreen,
      duration: const Duration(seconds: 5),
      actionLabel: 'تراجع',
      onAction: () async {
        await purchaseRepo.deletePurchase(purchase.id);
        QoffaToast.show(
          message: 'تم التراجع عن الشراء بنجاح',
          icon: Icons.undo_rounded,
        );
      },
    );

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _handleBuyLater() async {
    final name = _productController.text.trim();
    if (name.isEmpty) return;

    final price = int.tryParse(_priceController.text) ?? 0;
    if (price <= 0) return;

    final productRepo = ref.read(productRepositoryProvider);
    final laterBuyRepo = ref.read(laterBuyRepositoryProvider);

    final product = await productRepo.createProduct(
      name: name,
      preferredUnitId: _selectedUnitId,
      initialPriceDzd: price,
    );

    await laterBuyRepo.createLaterBuyItem(
      productId: product.id,
      observedPriceDzd: price,
      observedQuantity: _quantity,
      observedUnitId: _selectedUnitId,
      targetPriceDzd: _lastPriceDzd ?? (price * 0.85).round(),
    );

    QoffaToast.show(
      title: 'أُضيف إلى قائمة الانتظار',
      message: '$name بسعر مرصود $price دج',
      icon: Icons.watch_later_outlined,
      color: QoffaColors.warningCoral,
    );

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _handleAddToList() async {
    final name = _productController.text.trim();
    if (name.isEmpty) return;

    final price = int.tryParse(_priceController.text);
    final shoppingRepo = ref.read(shoppingListRepositoryProvider);
    final list = await shoppingRepo.getOrCreateDefaultList();

    await shoppingRepo.addItem(
      listId: list.id,
      customName: name,
      quantity: _quantity,
      unitId: _selectedUnitId,
      estimatedPriceDzd: price,
    );

    QoffaToast.show(
      title: 'أُضيف إلى قائمة التسوق',
      message: name,
      icon: Icons.playlist_add_check_rounded,
    );

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _scanBarcode() async {
    final scanned = await BarcodeScannerModal.show(context);
    if (scanned != null && scanned.isNotEmpty) {
      final productRepo = ref.read(productRepositoryProvider);
      final found = await productRepo.findByBarcode(scanned);
      if (found != null) {
        setState(() {
          _productController.text = found.name;
          if (found.lastPriceDzd != null) {
            _priceController.text = found.lastPriceDzd.toString();
            _lastPriceDzd = found.lastPriceDzd;
          }
          _selectedUnitId = found.preferredUnitId;
        });
        QoffaToast.show(
          title: 'تم العثور على المنتج بالباركود',
          message: found.name,
          icon: Icons.qr_code_scanner_rounded,
        );
      } else {
        setState(() {
          _productController.text = 'منتج جديد ($scanned)';
        });
        QoffaToast.show(
          message: 'باركود جديد: $scanned',
          icon: Icons.qr_code_rounded,
        );
      }
    }
  }

  void _selectQuickStaple(String name, String unit, int lastPrice) {
    setState(() {
      _productController.text = name;
      _selectedUnitId = unit;
      _lastPriceDzd = lastPrice;
      _priceController.clear();
    });
  }

  Future<void> _pickStore() async {
    final controller = TextEditingController(text: _selectedStore);
    final chosen = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('المحل / السوق', style: TextStyle(fontFamily: 'Hero Sandwich Pro')),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'اسم المحل أو السوق'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: QoffaColors.brandGreen),
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (chosen != null && chosen.trim().isNotEmpty) {
      setState(() => _selectedStore = chosen.trim());
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _toggleUnitPrice() {
    setState(() => _isUnitPrice = !_isUnitPrice);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final diff = _todayDiff;

    return MintBackgroundScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back button & Title
              Row(
                children: [
                  QoffaIconButton(
                    icon: Icons.arrow_back_rounded,
                    size: 44,
                    iconSize: 22,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addPurchaseTitle,
                        style: const TextStyle(
                          fontFamily: 'Hero Sandwich Pro',
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: QoffaColors.primaryNavy,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        l10n.addPurchaseSubtitle,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_today_rounded, color: QoffaColors.actionGreen),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Main Transaction Form Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: QoffaColors.whiteSurface,
                  borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
                  border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: QoffaColors.primaryNavy.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Product Input Row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: QoffaColors.mintSurfaceTint.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
                        border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_grocery_store_outlined, color: QoffaColors.actionGreen),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _productController,
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: QoffaColors.primaryNavy,
                              ),
                              onChanged: _onProductSearch,
                              decoration: InputDecoration(
                                hintText: l10n.productSearchPlaceholder,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_productController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () => setState(() {
                                _productController.clear();
                                _matchingProducts = [];
                              }),
                              child: const Icon(Icons.cancel_rounded, color: QoffaColors.secondarySage, size: 20),
                            ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.qr_code_scanner_rounded, color: QoffaColors.actionGreen),
                            tooltip: 'مسح الباركود',
                            onPressed: _scanBarcode,
                          ),
                        ],
                      ),
                    ),
                    if (_matchingProducts.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                          border: Border.all(color: QoffaColors.softBorder),
                          boxShadow: [
                            BoxShadow(
                              color: QoffaColors.primaryNavy.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _matchingProducts.take(4).map((p) {
                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                dense: true,
                                title: Text(p.name, style: const TextStyle(fontFamily: 'Alexandria', fontWeight: FontWeight.bold, fontSize: 13)),
                                subtitle: p.lastPriceDzd != null ? Text('آخر سعر: ${p.lastPriceDzd} DA', style: const TextStyle(fontSize: 11, color: QoffaColors.secondarySage)) : null,
                                trailing: const Icon(Icons.north_west_rounded, size: 16, color: QoffaColors.actionGreen),
                                onTap: () => _selectProduct(p),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),

                    // Price Context Badge Sub-row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6FBF8),
                        borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                        border: Border.all(color: QoffaColors.softBorder, width: 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bar_chart_rounded, color: QoffaColors.skyBlue, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${l10n.lastPrice}: ${_lastPriceDzd ?? 0} DA',
                                style: const TextStyle(
                                  fontFamily: 'Hero Sandwich Pro',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                diff >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                color: diff >= 0 ? QoffaColors.warningCoral : QoffaColors.actionGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${l10n.todayDiff}: ${diff >= 0 ? '+' : ''}$diff DA',
                                style: TextStyle(
                                  fontFamily: 'Hero Sandwich Pro',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: diff >= 0 ? QoffaColors.warningCoral : QoffaColors.actionGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Quantity Stepper & Unit Dropdown
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.quantity,
                                style: const TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: QoffaColors.secondarySage,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: QoffaColors.mintSurfaceTint,
                                  borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_rounded, color: QoffaColors.actionGreen),
                                      onPressed: _decrementQty,
                                    ),
                                    Text(
                                      _quantity.toInt().toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Hero Sandwich Pro',
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: QoffaColors.primaryNavy,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_rounded, color: QoffaColors.actionGreen),
                                      onPressed: _incrementQty,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.unit,
                                style: const TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: QoffaColors.secondarySage,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                                  border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedUnitId,
                                    isExpanded: true,
                                    items: UnitRegistry.allUnits.map((u) {
                                      return DropdownMenuItem(
                                        value: u.id,
                                        child: Text(
                                          u.nameEn,
                                          style: const TextStyle(
                                            fontFamily: 'Alexandria',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: QoffaColors.primaryNavy,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _selectedUnitId = val);
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

                    // Price Input & Store Dropdown
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _toggleUnitPrice,
                                child: Text(
                                  _isUnitPrice ? l10n.pricePerUnit : l10n.totalPrice,
                                  style: const TextStyle(
                                    fontFamily: 'Alexandria',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: QoffaColors.secondarySage,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                                  border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.monetization_on_outlined, color: QoffaColors.actionGreen, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _priceController,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                          fontFamily: 'Hero Sandwich Pro',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: QoffaColors.primaryNavy,
                                        ),
                                        decoration: const InputDecoration(
                                          suffixText: 'DA',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.store,
                                style: const TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: QoffaColors.secondarySage,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: _pickStore,
                                borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                                    border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.storefront_outlined, color: QoffaColors.actionGreen, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedStore,
                                          style: const TextStyle(
                                            fontFamily: 'Alexandria',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: QoffaColors.primaryNavy,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3 Actions: Buy Later vs Add to List vs Bought
                    Row(
                      children: [
                        Expanded(
                          child: QoffaButton(
                            label: l10n.buyLaterAction,
                            icon: Icons.watch_later_outlined,
                            variant: QoffaButtonVariant.secondary,
                            fontSize: 14,
                            onTap: _handleBuyLater,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: QoffaButton(
                            label: l10n.addToListAction,
                            icon: Icons.playlist_add_rounded,
                            variant: QoffaButtonVariant.secondary,
                            fontSize: 14,
                            onTap: _handleAddToList,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    QoffaButton(
                      label: l10n.boughtAction,
                      icon: Icons.shopping_cart_rounded,
                      variant: QoffaButtonVariant.primary,
                      onTap: _handleBought,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Section: Add something else? Quick add
              Text(
                l10n.quickAddStaples,
                style: const TextStyle(
                  fontFamily: 'Hero Sandwich Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _QuickAddChip(
                      label: 'Eggs',
                      icon: Icons.egg_outlined,
                      onTap: () => _selectQuickStaple('Eggs', 'tray', 550),
                    ),
                    const SizedBox(width: 10),
                    _QuickAddChip(
                      label: 'Bread',
                      icon: Icons.bakery_dining_outlined,
                      onTap: () => _selectQuickStaple('Baguette Bread', 'piece', 15),
                    ),
                    const SizedBox(width: 10),
                    _QuickAddChip(
                      label: 'Tomatoes',
                      icon: Icons.eco_outlined,
                      onTap: () => _selectQuickStaple('Tomatoes', 'kg', 120),
                    ),
                    const SizedBox(width: 10),
                    _QuickAddChip(
                      label: 'Potatoes',
                      icon: Icons.grass_outlined,
                      onTap: () => _selectQuickStaple('Potatoes', 'kg', 80),
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

class _QuickAddChip extends StatelessWidget {
  const _QuickAddChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: QoffaColors.whiteSurface,
          borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
          border: Border.all(color: QoffaColors.softBorder, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: QoffaColors.actionGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: QoffaColors.primaryNavy,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.add_rounded, color: QoffaColors.actionGreen, size: 18),
          ],
        ),
      ),
    );
  }
}
