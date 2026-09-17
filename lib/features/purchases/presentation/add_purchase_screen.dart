import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/units/unit_registry.dart';
import '../../../core/widgets/barcode_scanner_modal.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../../core/widgets/qoffa_dropdown.dart';
import '../../../core/widgets/qoffa_icon_button.dart';
import '../../../core/widgets/qoffa_motion.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../../later_buy/data/later_buy_repository.dart';
import '../../products/data/product_repository.dart';
import '../../shopping_lists/data/shopping_list_repository.dart';
import '../data/purchase_repository.dart';

class AddPurchaseScreen extends ConsumerStatefulWidget {
  const AddPurchaseScreen({this.initialProductId, super.key});

  final String? initialProductId;

  @override
  ConsumerState<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends ConsumerState<AddPurchaseScreen> {
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  double _quantity = 1.0;
  String _selectedUnitId = 'piece';
  String _selectedStore = '';
  DateTime _selectedDate = DateTime.now();
  int? _lastPriceDzd;
  bool _isUnitPrice = false;
  String? _selectedProductId;
  List<Product> _matchingProducts = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialProductId != null) {
      Future<void>(() async {
        final product = await ref
            .read(productRepositoryProvider)
            .getProductById(widget.initialProductId!);
        if (product != null && mounted) _selectProduct(product);
      });
    }
  }

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
    final results = await ref
        .read(productRepositoryProvider)
        .searchProducts(trimmed);
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
    final l10n = AppLocalizations.of(context);
    final name = _productController.text.trim();
    if (name.isEmpty) {
      QoffaToast.show(
        message: l10n.productRequired,
        color: QoffaColors.warningCoral,
      );
      return;
    }

    final price = int.tryParse(_priceController.text) ?? 0;
    if (price <= 0) {
      QoffaToast.show(
        message: l10n.validPriceRequired,
        color: QoffaColors.warningCoral,
      );
      return;
    }

    final productRepo = ref.read(productRepositoryProvider);
    final purchaseRepo = ref.read(purchaseRepositoryProvider);

    // Get or create product
    var product = _selectedProductId != null
        ? await productRepo.getProductById(_selectedProductId!)
        : null;

    if (product == null) {
      final search = await productRepo.searchProducts(name);
      if (search.isNotEmpty &&
          search.first.name.toLowerCase() == name.toLowerCase()) {
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
      note: null,
    );

    // Show non-blocking confirmation toast with 5-second Undo
    final diff = _todayDiff;
    final message = diff != 0
        ? '$name · ${diff > 0 ? '+' : ''}$diff DA'
        : '$name · ${purchase.totalDzd} DA';

    QoffaToast.show(
      title: l10n.purchaseSaved,
      message: message,
      icon: Icons.check_circle_rounded,
      color: diff > 0 ? QoffaColors.warningCoral : QoffaColors.actionGreen,
      duration: const Duration(seconds: 5),
      actionLabel: l10n.undo,
      onAction: () async {
        await purchaseRepo.deletePurchase(purchase.id);
        QoffaToast.show(message: l10n.purchaseUndone, icon: Icons.undo_rounded);
      },
    );

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _handleBuyLater() async {
    final l10n = AppLocalizations.of(context);
    final name = _productController.text.trim();
    if (name.isEmpty) {
      QoffaToast.show(
        message: l10n.productRequired,
        color: QoffaColors.warningCoral,
      );
      return;
    }

    final price = int.tryParse(_priceController.text) ?? 0;
    if (price <= 0) {
      QoffaToast.show(
        message: l10n.validPriceRequired,
        color: QoffaColors.warningCoral,
      );
      return;
    }

    final productRepo = ref.read(productRepositoryProvider);
    final laterBuyRepo = ref.read(laterBuyRepositoryProvider);

    var product = _selectedProductId == null
        ? null
        : await productRepo.getProductById(_selectedProductId!);
    product ??= await productRepo.createProduct(
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
      title: l10n.addedToLaterBuy,
      message: '$name · $price DA',
      icon: Icons.watch_later_outlined,
      color: QoffaColors.warningCoral,
    );

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _handleAddToList() async {
    final l10n = AppLocalizations.of(context);
    final name = _productController.text.trim();
    if (name.isEmpty) {
      QoffaToast.show(
        message: l10n.productRequired,
        color: QoffaColors.warningCoral,
      );
      return;
    }

    final price = int.tryParse(_priceController.text);
    final shoppingRepo = ref.read(shoppingListRepositoryProvider);
    final list = await shoppingRepo.getOrCreateDefaultList(
      title: l10n.defaultShoppingList,
    );

    await shoppingRepo.addItem(
      listId: list.id,
      customName: name,
      quantity: _quantity,
      unitId: _selectedUnitId,
      estimatedPriceDzd: price,
    );

    QoffaToast.show(
      title: l10n.addedToShoppingList,
      message: name,
      icon: Icons.playlist_add_check_rounded,
    );

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _scanBarcode() async {
    final l10n = AppLocalizations.of(context);
    final scanned = await BarcodeScannerModal.show(context);
    if (scanned != null && scanned.isNotEmpty) {
      final productRepo = ref.read(productRepositoryProvider);
      final found = await productRepo.findByBarcode(scanned);
      if (found != null) {
        setState(() {
          _productController.text = found.name;
          _selectedProductId = found.id;
          if (found.lastPriceDzd != null) {
            _priceController.text = found.lastPriceDzd.toString();
            _lastPriceDzd = found.lastPriceDzd;
          }
          _selectedUnitId = found.preferredUnitId;
        });
        QoffaToast.show(
          title: l10n.productFound,
          message: found.name,
          icon: Icons.qr_code_scanner_rounded,
        );
      } else {
        setState(() {
          _productController.text = '${l10n.productFallback} ($scanned)';
        });
        QoffaToast.show(
          message: '${l10n.newBarcode}: $scanned',
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
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: _selectedStore);
    final chosen = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.store,
          style: const TextStyle(fontFamily: 'Hero Sandwich Pro'),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.storeHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: QoffaColors.brandGreen,
            ),
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(
              l10n.confirm,
              style: const TextStyle(color: Colors.white),
            ),
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
          key: const PageStorageKey('add-purchase-scroll'),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
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
                  Expanded(
                    child: Column(
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
                  ),
                  const SizedBox(width: 8),
                  QoffaIconButton(
                    icon: Icons.calendar_today_rounded,
                    iconColor: QoffaColors.actionGreen,
                    size: 44,
                    iconSize: 21,
                    tooltip: l10n.date,
                    onTap: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: QoffaColors.whiteSurface.withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
                    border: Border.all(color: QoffaColors.softBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.event_rounded,
                        size: 17,
                        color: QoffaColors.actionGreen,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        DateFormat.yMMMd(
                          l10n.languageCode,
                        ).format(_selectedDate),
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Main Transaction Form Card
              QoffaReveal(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: QoffaColors.whiteSurface,
                    borderRadius: BorderRadius.circular(
                      QoffaTokens.radiusMajor,
                    ),
                    border: Border.all(
                      color: QoffaColors.softBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Product Input Row
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: QoffaColors.mintSurfaceTint.withValues(
                            alpha: 0.4,
                          ),
                          borderRadius: BorderRadius.circular(
                            QoffaTokens.radiusFields,
                          ),
                          border: Border.all(
                            color: QoffaColors.softBorder,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_grocery_store_outlined,
                              color: QoffaColors.actionGreen,
                            ),
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
                                  _selectedProductId = null;
                                  _lastPriceDzd = null;
                                  _matchingProducts = [];
                                }),
                                child: const Icon(
                                  Icons.cancel_rounded,
                                  color: QoffaColors.secondarySage,
                                  size: 20,
                                ),
                              ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(
                                Icons.qr_code_scanner_rounded,
                                color: QoffaColors.actionGreen,
                              ),
                              tooltip: l10n.scanBarcode,
                              onPressed: _scanBarcode,
                            ),
                          ],
                        ),
                      ),
                      if (_matchingProducts.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        QoffaDropdownMenuSurface(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _matchingProducts.take(4).map((p) {
                              return Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  subtitle: p.lastPriceDzd != null
                                      ? Text(
                                          '${l10n.lastPrice}: ${p.lastPriceDzd} DA',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: QoffaColors.secondarySage,
                                          ),
                                        )
                                      : null,
                                  trailing: const Icon(
                                    Icons.north_west_rounded,
                                    size: 16,
                                    color: QoffaColors.actionGreen,
                                  ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6FBF8),
                          borderRadius: BorderRadius.circular(
                            QoffaTokens.radiusControls,
                          ),
                          border: Border.all(
                            color: QoffaColors.softBorder,
                            width: 1.0,
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) => Wrap(
                            spacing: 14,
                            runSpacing: 8,
                            children: [
                              _PriceContextItem(
                                icon: Icons.bar_chart_rounded,
                                color: QoffaColors.skyBlue,
                                text: _lastPriceDzd == null
                                    ? l10n.noPreviousPrice
                                    : '${l10n.lastPrice}: $_lastPriceDzd DA',
                              ),
                              if (_lastPriceDzd != null &&
                                  _priceController.text.isNotEmpty)
                                _PriceContextItem(
                                  icon: diff >= 0
                                      ? Icons.trending_up_rounded
                                      : Icons.trending_down_rounded,
                                  color: diff > 0
                                      ? QoffaColors.warningCoral
                                      : QoffaColors.actionGreen,
                                  text:
                                      '${l10n.todayDiff}: ${diff > 0 ? '+' : ''}$diff DA',
                                ),
                            ],
                          ),
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
                                    borderRadius: BorderRadius.circular(
                                      QoffaTokens.radiusControls,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_rounded,
                                          color: QoffaColors.actionGreen,
                                        ),
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
                                        icon: const Icon(
                                          Icons.add_rounded,
                                          color: QoffaColors.actionGreen,
                                        ),
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
                                QoffaDropdown<String>(
                                  value: _selectedUnitId,
                                  items: UnitRegistry.allUnits
                                      .map(
                                        (unit) => DropdownMenuItem(
                                          value: unit.id,
                                          child: Text(
                                            l10n.unitName(unit.id),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedUnitId = value);
                                    }
                                  },
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
                                    _isUnitPrice
                                        ? l10n.pricePerUnit
                                        : l10n.totalPrice,
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      QoffaTokens.radiusControls,
                                    ),
                                    border: Border.all(
                                      color: QoffaColors.softBorder,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.monetization_on_outlined,
                                        color: QoffaColors.actionGreen,
                                        size: 20,
                                      ),
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
                                          onChanged: (_) => setState(() {}),
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
                                QoffaPickerField(
                                  value: _selectedStore,
                                  hint: l10n.storeDefault,
                                  prefixIcon: Icons.storefront_outlined,
                                  onTap: _pickStore,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 3 Actions: Buy Later vs Add to List vs Bought
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final first = QoffaButton(
                            label: l10n.buyLaterAction,
                            icon: Icons.watch_later_outlined,
                            variant: QoffaButtonVariant.secondary,
                            fontSize: 13,
                            onTap: _handleBuyLater,
                          );
                          final second = QoffaButton(
                            label: l10n.addToListAction,
                            icon: Icons.playlist_add_rounded,
                            variant: QoffaButtonVariant.secondary,
                            fontSize: 13,
                            onTap: _handleAddToList,
                          );
                          if (constraints.maxWidth < 330 ||
                              MediaQuery.textScalerOf(context).scale(1) >
                                  1.25) {
                            return Column(
                              children: [
                                SizedBox(width: double.infinity, child: first),
                                const SizedBox(height: 10),
                                SizedBox(width: double.infinity, child: second),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(child: first),
                              const SizedBox(width: 8),
                              Expanded(child: second),
                            ],
                          );
                        },
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
                      label: l10n.quickProduct('eggs'),
                      icon: Icons.egg_outlined,
                      onTap: () => _selectQuickStaple('Eggs', 'tray', 550),
                    ),
                    const SizedBox(width: 10),
                    _QuickAddChip(
                      label: l10n.quickProduct('bread'),
                      icon: Icons.bakery_dining_outlined,
                      onTap: () =>
                          _selectQuickStaple('Baguette Bread', 'piece', 15),
                    ),
                    const SizedBox(width: 10),
                    _QuickAddChip(
                      label: l10n.quickProduct('tomatoes'),
                      icon: Icons.eco_outlined,
                      onTap: () => _selectQuickStaple('Tomatoes', 'kg', 120),
                    ),
                    const SizedBox(width: 10),
                    _QuickAddChip(
                      label: l10n.quickProduct('potatoes'),
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

class _PriceContextItem extends StatelessWidget {
  const _PriceContextItem({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color, size: 19),
      const SizedBox(width: 7),
      Text(
        text,
        style: TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: color == QoffaColors.skyBlue ? QoffaColors.primaryNavy : color,
        ),
      ),
    ],
  );
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
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
              const Icon(
                Icons.add_rounded,
                color: QoffaColors.actionGreen,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
