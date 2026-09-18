// ignore_for_file: unused_element, unused_field, unused_import, unused_local_variable
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/localization/locale_provider.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../core/units/unit_registry.dart';
import '../../../core/utils/qoffa_number_format.dart';
import '../../../core/widgets/barcode_scanner_modal.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_anchor_dropdown.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../../core/widgets/qoffa_dropdown.dart';
import '../../../core/widgets/qoffa_animated_counter.dart';
import '../../../core/widgets/qoffa_motion.dart';
import '../../../core/widgets/qoffa_pressable.dart';
import '../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../../later_buy/data/later_buy_repository.dart';
import '../../products/data/product_repository.dart';
import '../../settings/data/settings_repository.dart';
import '../../shopping_lists/data/shopping_list_repository.dart';
import '../../../core/money/thousands_separator_input_formatter.dart';
import '../../../core/widgets/qoffa_quantity_selector.dart';
import '../../../core/widgets/qoffa_typing_box.dart';
import '../../../core/widgets/qoffa_search_picker_sheet.dart';
import '../../stores/data/store_repository.dart';
import '../../stores/domain/store_type.dart';
import '../../stores/presentation/qoffa_new_store_sheet.dart';
import '../../../core/particles_and_effects/particle_effect_presets.dart';
import '../../../core/particles_and_effects/qoffa_particle_overlay.dart';
import '../data/purchase_repository.dart';

class AddPurchaseScreen extends ConsumerStatefulWidget {
  const AddPurchaseScreen({this.initialProductId, super.key});

  final String? initialProductId;

  @override
  ConsumerState<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends ConsumerState<AddPurchaseScreen>
    with SingleTickerProviderStateMixin {
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _priceFocusNode = FocusNode();
  double _quantity = 1.0;
  String _selectedUnitId = 'piece';
  static const double _maxQuantity = 999.0;
  bool _isQtyIncreasing = true;
  String _selectedStore = '';
  String? _selectedStoreId;
  String _selectedStoreName = '';
  String? _selectedStoreType;
  DateTime _selectedDate = DateTime.now();
  int? _lastPriceDzd;
  bool _isUnitPrice = true;
  String? _selectedProductId;
  List<Product> _matchingProducts = [];
  int _itemPickEpoch = 0;
  List<Product> _quickAddSuggestions = [];
  late final AnimationController _refreshAnimController;
  late final Animation<double> _refreshRotation;
  bool _isBoughtAnimating = false;
  final GlobalKey _actionRowKey = GlobalKey();

  int get _parsedPrice =>
      QoffaNumberFormat.tryParseInt(_priceController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    _refreshAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      value: 1.0,
    );
    _refreshRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _refreshAnimController,
        curve: Curves.easeInOutCubic,
      ),
    );
    final initialPrice = QoffaNumberFormat.clean(_priceController.text);
    if (initialPrice.isNotEmpty && int.tryParse(initialPrice) != null) {
      final isArabic = (ref.read(localeNotifierProvider).languageCode) == 'ar';
      _unitPriceController.text = QoffaNumberFormat.format(
        int.parse(initialPrice),
        isArabic: isArabic,
      );
    } else {
      _unitPriceController.text = initialPrice;
    }
    _priceFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    _priceController.addListener(() {
      final isArabic = (ref.read(localeNotifierProvider).languageCode) == 'ar';
      final raw = QoffaNumberFormat.clean(_priceController.text);
      final formatted = raw.isEmpty
          ? ''
          : (int.tryParse(raw) != null
              ? QoffaNumberFormat.format(int.parse(raw), isArabic: isArabic)
              : raw);
      if (_unitPriceController.text != formatted) {
        _unitPriceController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
      if (mounted) setState(() {});
    });
    if (widget.initialProductId != null) {
      Future<void>(() async {
        final product = await ref
            .read(productRepositoryProvider)
            .getProductById(widget.initialProductId!);
        if (product != null && mounted) _selectProduct(product);
      });
    }
    _loadQuickAddSuggestions();
  }

  @override
  void dispose() {
    _refreshAnimController.dispose();
    _productController.dispose();
    _priceController.dispose();
    _unitPriceController.dispose();
    _priceFocusNode.dispose();
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
      _itemPickEpoch++;
      _productController.text = product.name;
      _selectedProductId =
          product.id.startsWith('staple_') ? null : product.id;
      _selectedUnitId = product.preferredUnitId;
      _lastPriceDzd = product.lastPriceDzd;
      _matchingProducts = [];
      if (product.lastPriceDzd != null) {
        _priceController.text = product.lastPriceDzd.toString();
        _unitPriceController.text = product.lastPriceDzd.toString();
      } else {
        _priceController.clear();
        _unitPriceController.clear();
      }
    });
  }

  void _selectCustomProduct(String name) {
    setState(() {
      _itemPickEpoch++;
      _productController.text = name.trim();
      _selectedProductId = null;
      _lastPriceDzd = null;
      _matchingProducts = [];
      _priceController.clear();
      _unitPriceController.clear();
    });
  }

  void _clearSelectedProduct() {
    setState(() {
      _itemPickEpoch++;
      _productController.clear();
      _selectedProductId = null;
      _lastPriceDzd = null;
      _matchingProducts = [];
      _priceController.clear();
      _unitPriceController.clear();
    });
  }

  int get _todayDiff {
    if (_lastPriceDzd == null || _parsedPrice == 0) return 0;
    return _parsedPrice - _lastPriceDzd!;
  }

  void _incrementQty() {
    if (_quantity < _maxQuantity) {
      setState(() {
        _isQtyIncreasing = true;
        _quantity += 1.0;
      });
    }
  }

  void _decrementQty() {
    if (_quantity > 0.0) {
      setState(() {
        _isQtyIncreasing = false;
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

    final price = _parsedPrice;
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
      isUnitPrice: true,
      purchasedAt: _selectedDate,
      storeId: _selectedStoreId,
      note: null,
    );

    if (!mounted) return;

    setState(() => _isBoughtAnimating = true);

    final renderBox =
        _actionRowKey.currentContext?.findRenderObject() as RenderBox?;
    final spawnOrigin = renderBox != null
        ? renderBox.localToGlobal(
            Offset(renderBox.size.width / 2, renderBox.size.height / 2),
          )
        : MediaQuery.sizeOf(context).center(Offset.zero);

    QoffaParticleOverlay.spawn(
      _actionRowKey.currentContext ?? context,
      globalOrigin: spawnOrigin,
      config: ParticleEffectPresets.celebration,
      spawnWidth: 80.0,
    );

    // Show non-blocking confirmation toast with 7-second Undo and progress timer bar
    final diff = _todayDiff;
    final priceStr = diff != 0
        ? '${diff > 0 ? '+' : ''}$diff DA'
        : '${purchase.totalDzd} DA';
    final message = '\u2068$name\u2069 \u2066\u200E$priceStr\u2069';

    QoffaToast.showWithProgress(
      title: l10n.purchaseSaved,
      message: message,
      icon: Icons.check_circle_rounded,
      color: QoffaColors.actionGreen,
      duration: const Duration(seconds: 7),
      actionLabel: l10n.undo,
      onAction: () async {
        await purchaseRepo.deletePurchase(purchase.id);
        QoffaToast.show(message: l10n.purchaseUndone, icon: Icons.undo_rounded);
      },
    );

    // Reset everything to default empty state
    _productController.clear();
    _priceController.clear();
    _unitPriceController.clear();
    _selectedProductId = null;
    _selectedStore = '';
    _selectedStoreId = null;
    _selectedStoreName = '';
    _selectedStoreType = null;
    _quantity = 1.0;
    _selectedUnitId = 'piece';
    _lastPriceDzd = null;

    await Future<void>.delayed(const Duration(milliseconds: 750));
    if (mounted) {
      setState(() => _isBoughtAnimating = false);
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

    final price = _parsedPrice;
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
      storeId: _selectedStoreId,
    );

    if (!mounted) return;
    QoffaToast.show(
      title: l10n.addedToLaterBuy,
      message: '\u2068$name\u2069 \u2066\u200E$price DA\u2069',
      icon: Icons.watch_later_outlined,
      type: QoffaNotificationType.normal,
      color: QoffaColors.skyBlue,
    );

    if (mounted) {
      context.go('/later-buy');
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

    final price = _parsedPrice > 0 ? _parsedPrice : null;
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
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
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
      _itemPickEpoch++;
      _productController.text = name;
      _selectedUnitId = unit;
      _lastPriceDzd = lastPrice;
      _priceController.text = lastPrice.toString();
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
          style: const TextStyle(
            fontFamily: QoffaFontFamily.display,
            fontFamilyFallback: QoffaFontFamily.fallback,
          ),
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
      child: QoffaParticleOverlay(
        child: SafeArea(
          child: Column(
          children: [
            // Top App Bar matching Settings styling and position
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: QoffaColors.primaryNavy,
                    ),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/');
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.addPurchaseTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontFamilyFallback: QoffaFontFamily.fallback,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  QoffaTactilePressable(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
                    backgroundColor:
                        QoffaColors.whiteSurface.withValues(alpha: 0.92),
                    borderColor: QoffaColors.softBorder,
                    borderWidth: 1.2,
                    hoverBackgroundColor: QoffaColors.mintSurfaceTint,
                    hoverBorderColor: QoffaColors.actionGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 130),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.event_rounded,
                            size: 16,
                            color: QoffaColors.actionGreen,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                DateFormat.yMMMd(
                                  l10n.languageCode,
                                ).format(_selectedDate),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.body,
                                  fontSize: QoffaFontSize.captionMedium,
                                  fontWeight: FontWeight.w700,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Spend / Budget Card at the very top
                    _buildBudgetProgressCard(l10n),
                    const SizedBox(height: 16),

                    // Main Container with standard white background, radius, outline
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_productController.text.trim().isEmpty)
                            _buildAddItemRowButton(l10n)
                          else
                            _buildSelectedItemRow(),
                          const SizedBox(height: 12),
                          _buildPriceCalculatorCard(l10n),
                          const SizedBox(height: 14),
                          _buildQuantityAndUnitRow(l10n),
                          const SizedBox(height: 14),
                          _buildPricePerUnitAndStoreRow(l10n),
                          const SizedBox(height: 16),
                          _buildActionButtonsRow(l10n),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAddSomethingElseSection(l10n),
                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildAddItemRowButton(AppLocalizations l10n) {
    return QoffaTactilePressable(
      height: 58.0,
      width: double.infinity,
      borderRadius: BorderRadius.circular(16),
      backgroundColor: const Color(0xFFF4FAF6),
      borderColor: QoffaColors.softBorder,
      hoverBackgroundColor: QoffaColors.mintSurfaceTint,
      hoverBorderColor: QoffaColors.actionGreen,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      onTap: _openPickItemBottomSheet,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: QoffaColors.mintSurfaceTint,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.add_rounded,
              color: QoffaColors.actionGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.addItem,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: QoffaColors.primaryNavy,
              ),
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: QoffaColors.mintSurfaceTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: QoffaColors.actionGreen,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedItemRow() {
    return QoffaTactilePressable(
      height: 58.0,
      width: double.infinity,
      borderRadius: BorderRadius.circular(16),
      backgroundColor: const Color(0xFFF4FAF6),
      borderColor: QoffaColors.softBorder,
      hoverBackgroundColor: QoffaColors.mintSurfaceTint,
      hoverBorderColor: QoffaColors.actionGreen,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      onTap: _openPickItemBottomSheet,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: QoffaColors.mintSurfaceTint.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: _buildProductImagePreview(
              _productController.text,
              size: 34,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _productController.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: QoffaFontSize.titleSmall,
                fontWeight: FontWeight.w800,
                color: QoffaColors.primaryNavy,
              ),
            ),
          ),
          const SizedBox(width: 8),
          QoffaTactilePressable(
            width: 28,
            height: 28,
            borderRadius: BorderRadius.circular(14),
            backgroundColor: QoffaColors.actionGreen,
            borderColor: QoffaColors.actionGreen,
            hoverBackgroundColor: QoffaColors.pressedGreen,
            hoverBorderColor: QoffaColors.pressedGreen,
            onTap: _clearSelectedProduct,
            child: const Icon(
              Icons.close_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCalculatorCard(AppLocalizations l10n) {
    final currentPrice = _parsedPrice > 0 ? _parsedPrice : null;
    final bool hasCurrentPrice = currentPrice != null && currentPrice > 0;
    final bool hasLastPrice = _lastPriceDzd != null;

    final int? todayAnimatedValue;
    final String todayPrefix;
    final Color todayColor;
    final IconData todayIcon;

    if (!hasCurrentPrice) {
      todayAnimatedValue = null;
      todayPrefix = '';
      todayColor = QoffaColors.secondarySage;
      todayIcon = Icons.trending_flat_rounded;
    } else if (!hasLastPrice) {
      todayAnimatedValue = currentPrice;
      todayPrefix = '';
      todayColor = QoffaColors.actionGreen;
      todayIcon = Icons.trending_flat_rounded;
    } else {
      final diff = currentPrice - _lastPriceDzd!;
      if (diff > 0) {
        todayAnimatedValue = diff;
        todayPrefix = '+';
        todayColor = QoffaColors.warningCoral;
        todayIcon = Icons.trending_up_rounded;
      } else if (diff < 0) {
        todayAnimatedValue = diff;
        todayPrefix = '';
        todayColor = QoffaColors.actionGreen;
        todayIcon = Icons.trending_down_rounded;
      } else {
        todayAnimatedValue = 0;
        todayPrefix = '';
        todayColor = QoffaColors.primaryNavy;
        todayIcon = Icons.trending_flat_rounded;
      }
    }

    return Container(
      height: 58.0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: QoffaColors.softBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Left side: Last price
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.bar_chart_rounded,
                  size: 26,
                  color: QoffaColors.actionGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.lastPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.body,
                          fontSize: QoffaFontSize.caption,
                          fontWeight: FontWeight.w600,
                          color: QoffaColors.secondarySage,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: QoffaAnimatedCounter(
                          key: const ValueKey<String>(
                            'add-screen-last-price-counter',
                          ),
                          value: _lastPriceDzd,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.body,
                            fontSize: 18.5,
                            fontWeight: FontWeight.w900,
                            color: QoffaColors.primaryNavy,
                            letterSpacing: -0.3,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Subtle divider in middle
          Container(
            height: 32,
            width: 1.2,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: QoffaColors.softBorder,
          ),

          // Right side: Today's Price Difference Calculator
          Expanded(
            child: InkWell(
              onTap: () => _openEditTodayPriceDialog(context, l10n),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  Icon(
                    todayIcon,
                    size: 26,
                    color: todayColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.today,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.body,
                            fontSize: QoffaFontSize.caption,
                            fontWeight: FontWeight.w600,
                            color: QoffaColors.secondarySage,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: QoffaAnimatedCounter(
                            key: ValueKey<String>(
                              'today-$_itemPickEpoch',
                            ),
                            value: todayAnimatedValue,
                            prefix: todayPrefix,
                            style: TextStyle(
                              fontFamily: QoffaFontFamily.body,
                              fontSize: 18.5,
                              fontWeight: FontWeight.w900,
                              color: todayColor,
                              letterSpacing: -0.3,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditTodayPriceDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final editController = TextEditingController(text: _priceController.text);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (sheetContext, setDialogState) {
          final val = int.tryParse(editController.text.trim()) ?? 0;
          final diff = (_lastPriceDzd != null && val > 0)
              ? val - _lastPriceDzd!
              : 0;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(ctx).bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(QoffaTokens.radiusMajor),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: QoffaColors.softBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      l10n.today,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontFamilyFallback: QoffaFontFamily.fallback,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: editController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontFamilyFallback: QoffaFontFamily.fallback,
                        fontSize: 23.5,
                        fontWeight: FontWeight.w800,
                        color: QoffaColors.primaryNavy,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.today,
                        suffixText: 'DA',
                        suffixStyle: const TextStyle(
                          fontFamily: QoffaFontFamily.body,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: QoffaColors.secondarySage,
                        ),
                        prefixIcon: const Icon(
                          Icons.payments_outlined,
                          color: QoffaColors.actionGreen,
                        ),
                      ),
                      onChanged: (text) => setDialogState(() {}),
                    ),
                    if (_lastPriceDzd != null && val > 0) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            diff > 0
                                ? Icons.trending_up_rounded
                                : (diff < 0
                                    ? Icons.trending_down_rounded
                                    : Icons.trending_flat_rounded),
                            size: 20,
                            color: diff > 0
                                ? QoffaColors.warningCoral
                                : (diff < 0
                                    ? QoffaColors.actionGreen
                                    : QoffaColors.secondarySage),
                          ),
                          const SizedBox(width: 6),
                          QoffaAnimatedCounter(
                            value: diff,
                            prefix: diff > 0 ? '+' : '',
                            suffix: ' DA (${l10n.todayDiff})',
                            style: TextStyle(
                              fontFamily: QoffaFontFamily.body,
                              fontSize: QoffaFontSize.body,
                              fontWeight: FontWeight.w700,
                              color: diff > 0
                                  ? QoffaColors.warningCoral
                                  : (diff < 0
                                      ? QoffaColors.actionGreen
                                      : QoffaColors.secondarySage),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    QoffaTactilePressable.filled(
                      width: double.infinity,
                      height: 52,
                      label: l10n.confirm,
                      icon: Icons.check_rounded,
                      onTap: () {
                        setState(() {
                          _itemPickEpoch++;
                          _priceController.text = editController.text.trim();
                          _unitPriceController.text = editController.text.trim();
                        });
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImagePreview(String name, {double size = 40}) {
    final lower = name.toLowerCase();
    if (lower.contains('candia') ||
        lower.contains('milk') ||
        lower.contains('حليب') ||
        lower.contains('lait')) {
      return Image.asset(
        'assets/images/candia_milk.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallbackIcon(name, size),
      );
    }
    return _buildFallbackIcon(name, size);
  }

  Widget _buildFallbackIcon(String name, double size) {
    final lower = name.toLowerCase();
    IconData icon = Icons.shopping_basket_rounded;
    Color color = QoffaColors.actionGreen;
    if (lower.contains('bread') ||
        lower.contains('خبز') ||
        lower.contains('pain') ||
        lower.contains('baguette')) {
      icon = Icons.bakery_dining_rounded;
      color = QoffaColors.goldAccent;
    } else if (lower.contains('egg') ||
        lower.contains('بيض') ||
        lower.contains('oeuf')) {
      icon = Icons.egg_rounded;
      color = QoffaColors.goldAccent;
    } else if (lower.contains('potato') ||
        lower.contains('بطاطا') ||
        lower.contains('pomme de terre')) {
      icon = Icons.grass_rounded;
      color = QoffaColors.actionGreen;
    } else if (lower.contains('tomato') ||
        lower.contains('طماطم') ||
        lower.contains('tomate')) {
      icon = Icons.eco_rounded;
      color = Colors.redAccent;
    } else if (lower.contains('water') ||
        lower.contains('ماء') ||
        lower.contains('eau') ||
        lower.contains('drink') ||
        lower.contains('juice') ||
        lower.contains('عصير')) {
      icon = Icons.water_drop_rounded;
      color = QoffaColors.skyBlue;
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: size * 0.6),
    );
  }

  Future<List<String>> _fetchTop3RecentFoods() async {
    try {
      final db = ref.read(databaseProvider);
      final query = db.select(db.purchases).join([
        innerJoin(
          db.products,
          db.products.id.equalsExp(db.purchases.productId),
        ),
      ])
        ..where(db.purchases.deletedAt.isNull())
        ..orderBy([OrderingTerm.desc(db.purchases.purchasedAt)])
        ..limit(25);

      final rows = await query.get();
      final unique = <String>[];
      for (final r in rows) {
        final name = r.readTable(db.products).name.trim();
        if (name.isNotEmpty && !unique.contains(name)) {
          unique.add(name);
          if (unique.length == 3) break;
        }
      }

      if (unique.length < 3) {
        final frequent = await ref
            .read(productRepositoryProvider)
            .getFrequentProducts(limit: 5);
        for (final p in frequent) {
          if (!unique.contains(p.name)) {
            unique.add(p.name);
            if (unique.length == 3) break;
          }
        }
      }

      // Default staple foods fallback if new user
      const defaults = ['Candia Milk 1L', 'Baguette Bread', 'Fresh Eggs'];
      for (final d in defaults) {
        if (unique.length < 3 && !unique.contains(d)) {
          unique.add(d);
        }
      }
      return unique.take(3).toList();
    } catch (_) {
      return const ['Candia Milk 1L', 'Baguette Bread', 'Fresh Eggs'];
    }
  }

  Future<void> _openPickItemBottomSheet() async {
    final l10n = AppLocalizations.of(context);
    final searchController = TextEditingController();
    List<Product> searchResults = [];
    final recentFoods = await _fetchTop3RecentFoods();

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.85,
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(QoffaTokens.radiusMajor),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      l10n.addItem,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.display,
                        fontFamilyFallback: QoffaFontFamily.fallback,
                        fontSize: QoffaFontSize.headlineSmall,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Food name bar with typing animation box like new note
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                      cursorColor: QoffaColors.actionGreen,
                      decoration: InputDecoration(
                        labelText: l10n.foodName,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: QoffaColors.actionGreen,
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      searchController.clear();
                                      setSheetState(() => searchResults = []);
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
                                              fontFamily: QoffaFontFamily.body,
                                              fontSize: QoffaFontSize.micro,
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
                      onChanged: (val) async {
                        final trimmed = val.trim();
                        if (trimmed.isEmpty) {
                          setSheetState(() => searchResults = []);
                          return;
                        }
                        final results = await ref
                            .read(productRepositoryProvider)
                            .searchProducts(trimmed);
                        setSheetState(() => searchResults = results);
                      },
                    ),

                    // Search results dropdown
                    if (searchController.text.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            QoffaTokens.radiusFields,
                          ),
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
                            ...searchResults.take(4).map((p) => ListTile(
                                  dense: true,
                                  leading: _buildProductImagePreview(
                                    p.name,
                                    size: 30,
                                  ),
                                  title: Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontFamily: QoffaFontFamily.body,
                                      fontSize: QoffaFontSize.body,
                                      fontWeight: FontWeight.w700,
                                      color: QoffaColors.primaryNavy,
                                    ),
                                  ),
                                  subtitle: p.lastPriceDzd != null
                                      ? Text(
                                          '${p.lastPriceDzd} DA',
                                          style: const TextStyle(
                                            fontFamily: QoffaFontFamily.body,
                                            fontSize: QoffaFontSize.captionMedium,
                                            fontWeight: FontWeight.w600,
                                            color: QoffaColors.actionGreen,
                                          ),
                                        )
                                      : null,
                                  trailing: const Icon(
                                    Icons.north_west_rounded,
                                    size: 16,
                                    color: QoffaColors.actionGreen,
                                  ),
                                  onTap: () {
                                    _selectProduct(p);
                                    Navigator.pop(sheetContext);
                                  },
                                )),
                            if (!searchResults.any((p) =>
                                p.name.toLowerCase() ==
                                searchController.text.trim().toLowerCase()))
                              InkWell(
                                onTap: () {
                                  _selectCustomProduct(
                                    searchController.text.trim(),
                                  );
                                  Navigator.pop(sheetContext);
                                },
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
                                          l10n.addNewGroceryItem(
                                            searchController.text.trim(),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: QoffaFontFamily.body,
                                            fontSize: QoffaFontSize.bodySmall,
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
                        ),
                      ),
                    ],

                    // Recent picked foods underneath food name bar
                    if (recentFoods.isNotEmpty) ...[
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
                            l10n.recentPickedFoods,
                            style: const TextStyle(
                              fontFamily: QoffaFontFamily.body,
                              fontSize: QoffaFontSize.body,
                              fontWeight: FontWeight.w800,
                              color: QoffaColors.primaryNavy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...recentFoods.take(3).map((foodName) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: QoffaTactilePressable(
                              height: 52.0,
                              borderRadius: BorderRadius.circular(14.0),
                              backgroundColor: QoffaColors.whiteSurface,
                              borderColor: QoffaColors.softBorder,
                              hoverBackgroundColor: QoffaColors.mintSurfaceTint,
                              hoverBorderColor: QoffaColors.actionGreen,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              onTap: () async {
                                final matching = await ref
                                    .read(productRepositoryProvider)
                                    .searchProducts(foodName);
                                if (matching.isNotEmpty) {
                                  _selectProduct(matching.first);
                                } else {
                                  _selectCustomProduct(foodName);
                                }
                                if (sheetContext.mounted) {
                                  Navigator.pop(sheetContext);
                                }
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: QoffaColors.mintSurfaceTint
                                          .withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: _buildProductImagePreview(
                                      foodName,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      foodName,
                                      style: const TextStyle(
                                        fontFamily: QoffaFontFamily.body,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                        color: QoffaColors.primaryNavy,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: QoffaColors.mintSurfaceTint,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: QoffaColors.softBorder,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: QoffaColors.actionGreen,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                    const SizedBox(height: 16),
                    QoffaTactilePressable.outline(
                      width: double.infinity,
                      height: 52,
                      label: l10n.cancel,
                      onTap: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityAndUnitRow(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildQuantitySelector(l10n),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildUnitSelector(l10n),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(AppLocalizations l10n) {
    return QoffaQuantitySelector(
      label: l10n.quantity,
      value: _quantity,
      min: 0.0,
      max: _maxQuantity,
      onChanged: (newVal) {
        setState(() {
          _isQtyIncreasing = newVal > _quantity;
          _quantity = newVal;
        });
      },
    );
  }

  Widget _buildUnitSelector(AppLocalizations l10n) {
    final currentUnit = UnitRegistry.fromIdOrFallback(_selectedUnitId);
    final displayName = currentUnit.localizedName(l10n.languageCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.unit,
          style: const TextStyle(
            fontFamily: QoffaFontFamily.body,
            fontSize: QoffaFontSize.bodySmall,
            fontWeight: FontWeight.w700,
            color: QoffaColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 6),
        QoffaAnchorDropdown<String>(
          selectedValue: _selectedUnitId,
          items: UnitRegistry.allUnits.map((unit) {
            return QoffaDropdownMenuItem<String>(
              value: unit.id,
              label: unit.localizedName(l10n.languageCode),
            );
          }).toList(),
          onSelected: (unitId) {
            setState(() {
              _selectedUnitId = unitId;
            });
          },
          builder: (context, showDropdown) => QoffaTactilePressable.outline(
            onTap: showDropdown,
            height: 52.0,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16),
            backgroundColor: const Color(0xFFF4FAF6),
            borderColor: QoffaColors.softBorder,
            hoverBackgroundColor: QoffaColors.mintSurfaceTint,
            hoverBorderColor: QoffaColors.actionGreen,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: QoffaFontFamily.body,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: QoffaColors.actionGreen,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildPricePerUnitAndStoreRow(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildPricePerUnitField(l10n),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStoreSelector(l10n),
        ),
      ],
    );
  }

  Widget _buildPricePerUnitField(AppLocalizations l10n) {
    return QoffaTypingBox.currency(
      label: l10n.pricePerUnit,
      controller: _unitPriceController,
      focusNode: _priceFocusNode,
      isArabic: l10n.isArabic,
      hintText: l10n.isArabic ? '000،000 ...' : '000,000 ...',
      onChanged: (val) {
        final clean = QoffaNumberFormat.clean(val);
        if (_priceController.text != clean) {
          _priceController.text = clean;
        }
      },
    );
  }

  Widget _buildStoreSelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.store,
          style: const TextStyle(
            fontFamily: QoffaFontFamily.body,
            fontSize: QoffaFontSize.bodySmall,
            fontWeight: FontWeight.w700,
            color: QoffaColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 6),
        QoffaTactilePressable.outline(
          onTap: _openPickStoreBottomSheet,
          height: 52.0,
          width: double.infinity,
          borderRadius: BorderRadius.circular(16),
          backgroundColor: const Color(0xFFF4FAF6),
          borderColor: QoffaColors.softBorder,
          hoverBackgroundColor: QoffaColors.mintSurfaceTint,
          hoverBorderColor: QoffaColors.actionGreen,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(
                _selectedStoreType != null
                    ? (StoreType.fromId(_selectedStoreType)?.icon ??
                        Icons.storefront_rounded)
                    : Icons.storefront_rounded,
                color: QoffaColors.actionGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedStoreName.isEmpty
                      ? l10n.selectStore
                      : _selectedStoreName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: QoffaFontFamily.body,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _selectedStoreName.isEmpty
                        ? QoffaColors.secondarySage
                        : QoffaColors.primaryNavy,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: QoffaColors.actionGreen,
                size: 22,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsRow(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final buyLaterWidth =
            _isBoughtAnimating ? 0.0 : (availableWidth - 12) / 2;

        return SizedBox(
          key: _actionRowKey,
          height: 52.0,
          child: Row(
            children: [
              // Left button: Buy later (collapses and fades out during bought animation)
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                width: buyLaterWidth,
                child: buyLaterWidth == 0.0
                    ? const SizedBox.shrink()
                    : ClipRect(
                        child: OverflowBox(
                          minWidth: (availableWidth - 12) / 2,
                          maxWidth: (availableWidth - 12) / 2,
                          alignment: Alignment.centerLeft,
                          child: QoffaTactilePressable.outline(
                            enabled: !_isBoughtAnimating,
                            onTap: () {
                              if (_isBoughtAnimating) return;
                              _handleBuyLater();
                            },
                            height: 52.0,
                            borderRadius: BorderRadius.circular(16),
                            backgroundColor: const Color(0xFFF4FAF6),
                            borderColor: QoffaColors.softBorder,
                            hoverBackgroundColor: QoffaColors.mintSurfaceTint,
                            hoverBorderColor: QoffaColors.actionGreen,
                            textColor: QoffaColors.primaryNavy,
                            iconColor: QoffaColors.actionGreen,
                            icon: Icons.schedule_rounded,
                            label: l10n.buyLaterAction,
                          ),
                        ),
                      ),
              ),
              if (!_isBoughtAnimating) const SizedBox(width: 12),
              // Right button: Bought (expands on whole row with checkmark and particle burst)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOutCubic,
                  height: 52.0,
                  decoration: BoxDecoration(
                    color: QoffaColors.actionGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isBoughtAnimating ? null : _handleBought,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                          child: _isBoughtAnimating
                              ? const Icon(
                                  Icons.check_rounded,
                                  key: ValueKey('checkmark_anim'),
                                  color: Colors.white,
                                  size: 28,
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    key: const ValueKey('normal_bought_content'),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.shopping_cart_rounded,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            l10n.boughtAction,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: QoffaFontFamily.body,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
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
            ],
          ),
        );
      },
    );
  }

  Future<void> _openPickStoreBottomSheet() async {
    final l10n = AppLocalizations.of(context);
    final storeRepo = ref.read(storeRepositoryProvider);
    final recentStores = await storeRepo.getRecentStores(limit: 5);

    if (!mounted) return;

    final selected = await QoffaSearchPickerSheet.show<Store>(
      context: context,
      title: l10n.selectStore,
      searchLabel: l10n.searchOrAddStore,
      canAddNew: true,
      addNewLabelBuilder: (query) => l10n.addNewStoreNamed(query),
      onSearch: (query) => storeRepo.searchStores(query),
      itemBuilder: (ctx, store, onSelect) {
        final type = StoreType.fromId(store.storeType);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  type?.icon ?? Icons.storefront_rounded,
                  size: 20,
                  color: QoffaColors.actionGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    if (store.area != null || store.rating != null || type != null)
                      Row(
                        children: [
                          if (type != null) ...[
                            Text(
                              type.localizedName(l10n.languageCode),
                              style: const TextStyle(
                                fontFamily: QoffaFontFamily.body,
                                fontSize: QoffaFontSize.captionMedium,
                                fontWeight: FontWeight.w600,
                                color: QoffaColors.actionGreen,
                              ),
                            ),
                            if (store.area != null || store.rating != null)
                              const Text(' · ',
                                  style: TextStyle(color: QoffaColors.secondarySage)),
                          ],
                          if (store.area != null) ...[
                            Flexible(
                              child: Text(
                                store.area!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.body,
                                  fontSize: QoffaFontSize.captionMedium,
                                  fontWeight: FontWeight.w500,
                                  color: QoffaColors.secondarySage,
                                ),
                              ),
                            ),
                            if (store.rating != null)
                              const Text(' · ',
                                  style: TextStyle(color: QoffaColors.secondarySage)),
                          ],
                          if (store.rating != null)
                            Text(
                              '★ ${store.rating}',
                              style: const TextStyle(
                                fontFamily: QoffaFontFamily.body,
                                fontSize: QoffaFontSize.captionMedium,
                                fontWeight: FontWeight.w700,
                                color: QoffaColors.goldAccent,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.north_west_rounded,
                size: 16,
                color: QoffaColors.actionGreen,
              ),
            ],
          ),
        );
      },
      onAddNew: (sheetContext, query) async {
        Navigator.pop(sheetContext);
        final newStore = await QoffaNewStoreSheet.show(
          context,
          initialName: query,
        );
        if (newStore != null && mounted) {
          setState(() {
            _selectedStore = newStore.name;
            _selectedStoreId = newStore.id;
            _selectedStoreName = newStore.name;
            _selectedStoreType = newStore.storeType;
          });
        }
      },
      quickActionWidget: Builder(
        builder: (sheetCtx) => QoffaTactilePressable.filled(
          height: 48,
          width: double.infinity,
          borderRadius: BorderRadius.circular(14),
          backgroundColor: QoffaColors.actionGreen,
          label: l10n.newStore,
          icon: Icons.add_rounded,
          onTap: () async {
            Navigator.pop(sheetCtx);
            final newStore = await QoffaNewStoreSheet.show(context);
            if (newStore != null && mounted) {
              setState(() {
                _selectedStore = newStore.name;
                _selectedStoreId = newStore.id;
                _selectedStoreName = newStore.name;
                _selectedStoreType = newStore.storeType;
              });
            }
          },
        ),
      ),
      recentTitle: l10n.recentPickedStores,
      recentItems: recentStores,
      recentItemBuilder: (ctx, store, onSelect) {
        final type = StoreType.fromId(store.storeType);
        return QoffaTactilePressable(
          height: 52.0,
          borderRadius: BorderRadius.circular(14.0),
          backgroundColor: QoffaColors.whiteSurface,
          borderColor: QoffaColors.softBorder,
          hoverBackgroundColor: QoffaColors.mintSurfaceTint,
          hoverBorderColor: QoffaColors.actionGreen,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          onTap: onSelect,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  type?.icon ?? Icons.storefront_rounded,
                  size: 20,
                  color: QoffaColors.actionGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    if (store.area != null || type != null || store.rating != null)
                      Row(
                        children: [
                          if (type != null || store.area != null)
                            Flexible(
                              child: Text(
                                store.area ?? type!.localizedName(l10n.languageCode),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.body,
                                  fontSize: QoffaFontSize.caption,
                                  fontWeight: FontWeight.w500,
                                  color: QoffaColors.secondarySage,
                                ),
                              ),
                            ),
                          if ((type != null || store.area != null) && store.rating != null)
                            const Text(
                              ' · ',
                              style: TextStyle(
                                color: QoffaColors.secondarySage,
                                fontSize: QoffaFontSize.caption,
                              ),
                            ),
                          if (store.rating != null)
                            Text(
                              '★ ${store.rating}',
                              style: const TextStyle(
                                fontFamily: QoffaFontFamily.body,
                                fontSize: QoffaFontSize.caption,
                                fontWeight: FontWeight.w700,
                                color: QoffaColors.goldAccent,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: QoffaColors.softBorder,
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: QoffaColors.actionGreen,
                  size: 18,
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedStore = selected.name;
        _selectedStoreId = selected.id;
        _selectedStoreName = selected.name;
        _selectedStoreType = selected.storeType;
      });
    }
  }

  Future<void> _loadQuickAddSuggestions({bool animate = false}) async {
    if (animate && mounted) {
      _refreshAnimController.forward(from: 0.0);
    }
    final purchaseRepo = ref.read(purchaseRepositoryProvider);
    final productRepo = ref.read(productRepositoryProvider);

    // 1. Fetch top most used products from purchases
    final mostUsed = await purchaseRepo.getMostUsedProducts(limit: 12);
    final pool = <Product>[...mostUsed];

    // 2. Supplement with frequent products if pool is small
    if (pool.length < 6) {
      final frequent = await productRepo.getFrequentProducts(limit: 12);
      for (final p in frequent) {
        if (!pool.any((item) => item.id == p.id)) {
          pool.add(p);
        }
      }
    }

    // 3. Fallback staples if still fewer than 4
    if (pool.length < 4) {
      final staples = [
        (name: 'Eggs', unit: 'piece', price: 25),
        (name: 'Bread', unit: 'piece', price: 15),
        (name: 'Tomatoes', unit: 'kg', price: 90),
        (name: 'Milk', unit: 'liter', price: 130),
        (name: 'Potatoes', unit: 'kg', price: 75),
        (name: 'Cheese', unit: 'piece', price: 220),
        (name: 'Chicken', unit: 'kg', price: 480),
        (name: 'Apples', unit: 'kg', price: 250),
        (name: 'Coffee', unit: 'piece', price: 280),
        (name: 'Oil', unit: 'liter', price: 125),
      ];

      for (final staple in staples) {
        if (pool.length >= 8) break;
        if (!pool.any((item) => item.name.toLowerCase() == staple.name.toLowerCase())) {
          final existing = await productRepo.searchProducts(staple.name);
          final match = existing.cast<Product?>().firstWhere(
                (p) => p!.name.toLowerCase() == staple.name.toLowerCase(),
                orElse: () => null,
              );
          if (match != null) {
            pool.add(match);
          } else {
            pool.add(
              Product(
                id: 'staple_${staple.name.toLowerCase()}',
                name: staple.name,
                normalizedName: staple.name.toLowerCase(),
                preferredUnitId: staple.unit,
                lastPriceDzd: staple.price,
                isArchived: false,
                createdAt: DateTime.now().toUtc(),
                updatedAt: DateTime.now().toUtc(),
              ),
            );
          }
        }
      }
    }

    // 4. Randomly pick 3 from the pool for 1x1x1 vertical list
    final shuffled = List<Product>.from(pool)..shuffle(Random());
    if (mounted) {
      setState(() {
        _quickAddSuggestions = shuffled.take(3).toList();
      });
    }
  }

  String _productEmoji(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('egg') || lower.contains('بيض') || lower.contains('oeuf')) {
      return '🥚';
    }
    if (lower.contains('bread') || lower.contains('خبز') || lower.contains('pain')) {
      return '🍞';
    }
    if (lower.contains('tomato') || lower.contains('طماطم') || lower.contains('tomate')) {
      return '🍅';
    }
    if (lower.contains('milk') || lower.contains('حليب') || lower.contains('lait')) {
      return '🥛';
    }
    if (lower.contains('cheese') || lower.contains('جبن') || lower.contains('fromage')) {
      return '🧀';
    }
    if (lower.contains('meat') || lower.contains('لحم') || lower.contains('viande')) {
      return '🥩';
    }
    if (lower.contains('chicken') || lower.contains('دجاج') || lower.contains('poulet')) {
      return '🍗';
    }
    if (lower.contains('apple') || lower.contains('تفاح') || lower.contains('pomme')) {
      return '🍎';
    }
    if (lower.contains('banana') || lower.contains('موز') || lower.contains('banane')) {
      return '🍌';
    }
    if (lower.contains('potato') || lower.contains('بطاطا') || lower.contains('pomme de terre')) {
      return '🥔';
    }
    if (lower.contains('onion') || lower.contains('بصل') || lower.contains('oignon')) {
      return '🧅';
    }
    if (lower.contains('coffee') || lower.contains('قهوة') || lower.contains('café')) {
      return '☕';
    }
    if (lower.contains('tea') || lower.contains('شاي') || lower.contains('thé')) {
      return '🫖';
    }
    if (lower.contains('oil') || lower.contains('زيت') || lower.contains('huile')) {
      return '🫒';
    }
    return '🛍️';
  }

  Widget _buildAddSomethingElseSection(AppLocalizations l10n) {
    if (_quickAddSuggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(
          color: QoffaColors.softBorder,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.addSomethingElse,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: QoffaFontFamily.body,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              QoffaPressable(
                onTap: () => _loadQuickAddSuggestions(animate: true),
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RotationTransition(
                      turns: _refreshRotation,
                      child: const Icon(
                        Icons.refresh_rounded,
                        size: 16,
                        color: QoffaColors.actionGreen,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.refresh,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: QoffaColors.actionGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              for (int i = 0; i < _quickAddSuggestions.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                _buildAnimatedQuickAddCard(
                  _quickAddSuggestions[i],
                  index: i,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedQuickAddCard(Product product, {required int index}) {
    final start = (index * 0.08).clamp(0.0, 0.35);
    final scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _refreshAnimController,
        curve: Interval(start, 1.0, curve: Curves.easeOutBack),
      ),
    );
    final fadeAnim = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(
        parent: _refreshAnimController,
        curve: Interval(start, 1.0, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: _refreshAnimController,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnim.value,
          child: Opacity(
            opacity: fadeAnim.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: _buildQuickAddItemCard(product),
    );
  }

  Widget _buildQuickAddItemCard(Product product) {
    final isSelected = (_selectedProductId != null &&
            _selectedProductId == product.id) ||
        (_productController.text.trim().toLowerCase() ==
                product.name.trim().toLowerCase() &&
            _productController.text.trim().isNotEmpty);

    return QoffaTactilePressable(
      onTap: () {
        _selectProduct(product);
      },
      height: 52.0,
      borderRadius: BorderRadius.circular(14),
      backgroundColor: isSelected
          ? QoffaColors.mintSurfaceTint
          : const Color(0xFFF4FAF6),
      borderColor: isSelected ? QoffaColors.actionGreen : QoffaColors.softBorder,
      hoverBackgroundColor: QoffaColors.mintSurfaceTint,
      hoverBorderColor: QoffaColors.actionGreen,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Text(
            _productEmoji(product.name),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: QoffaColors.primaryNavy,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isSelected
                  ? QoffaColors.actionGreen
                  : QoffaColors.mintSurfaceTint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSelected ? Icons.check_rounded : Icons.add_rounded,
              size: 16,
              color: isSelected ? Colors.white : QoffaColors.actionGreen,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBudgetProgressCard(AppLocalizations l10n) {
    final now = DateTime.now();
    final localDateStr =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final recordedTodayDzd =
        ref.watch(dailyTotalProvider(localDateStr)).value?.dinars ?? 0;
    final monthlyTotalDzd = ref
            .watch(monthlyTotalProvider((year: now.year, month: now.month)))
            .value
            ?.dinars ??
        0;
    final profile = ref.watch(userProfileProvider).value;
    final monthlyBudget = profile?.monthlyBudgetDzd ?? 60000;

    final pendingItemCost =
        (_parsedPrice > 0) ? (_parsedPrice * _quantity).round() : 0;
    final currentTodaySpent = recordedTodayDzd + pendingItemCost;
    final currentMonthlySpent = monthlyTotalDzd + pendingItemCost;
    final remainingBudget = max(0, monthlyBudget - currentMonthlySpent);
    final progressFraction = monthlyBudget > 0
        ? (currentMonthlySpent / monthlyBudget).clamp(0.0, 1.0)
        : 0.0;
    final percentUsed = (progressFraction * 100).round();
    final isOverLimit = currentMonthlySpent >= monthlyBudget;
    final isNearLimit = progressFraction >= 0.85;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(
          color: QoffaColors.softBorder,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 20,
                  color: QoffaColors.actionGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.todaySpent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: QoffaFontSize.captionMedium,
                        fontWeight: FontWeight.w600,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: QoffaAnimatedCounter(
                        value: currentTodaySpent,
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.display,
                          fontFamilyFallback: QoffaFontFamily.fallback,
                          fontSize: 20.5,
                          fontWeight: FontWeight.w900,
                          color: QoffaColors.primaryNavy,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.2,
                height: 34,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: QoffaColors.softBorder,
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isOverLimit
                      ? const Color(0xFFFDE8E8)
                      : (isNearLimit
                          ? const Color(0xFFFFF3E8)
                          : QoffaColors.mintSurfaceTint),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isOverLimit
                      ? Icons.warning_amber_rounded
                      : (isNearLimit
                          ? Icons.warning_rounded
                          : Icons.savings_outlined),
                  size: 20,
                  color: isOverLimit
                      ? QoffaColors.warningCoral
                      : (isNearLimit
                          ? const Color(0xFFF97316)
                          : QoffaColors.actionGreen),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.remainingBudget,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: QoffaFontSize.captionMedium,
                        fontWeight: FontWeight.w600,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: QoffaAnimatedCounter(
                        value: remainingBudget,
                        style: TextStyle(
                          fontFamily: QoffaFontFamily.display,
                          fontFamilyFallback: QoffaFontFamily.fallback,
                          fontSize: 20.5,
                          fontWeight: FontWeight.w900,
                          color: isOverLimit
                              ? QoffaColors.warningCoral
                              : (isNearLimit
                                  ? const Color(0xFFF97316)
                                  : QoffaColors.actionGreen),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final barWidth =
                  (totalWidth * progressFraction).clamp(0.0, totalWidth);
              final barColor = isOverLimit
                  ? QoffaColors.warningCoral
                  : (isNearLimit
                      ? const Color(0xFFF97316)
                      : QoffaColors.actionGreen);

              return Stack(
                children: [
                  Container(
                    height: 8.0,
                    width: totalWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F2EC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: barWidth),
                    duration: const Duration(milliseconds: 550),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedWidth, child) {
                      return Container(
                        height: 8.0,
                        width: animatedWidth,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '$percentUsed% ${l10n.budgetUsed}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: QoffaFontFamily.body,
                    fontSize: QoffaFontSize.captionMedium,
                    fontWeight: FontWeight.w700,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${QoffaNumberFormat.format(monthlyBudget, isArabic: l10n.isArabic)} DA',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: QoffaFontFamily.body,
                    fontSize: QoffaFontSize.captionMedium,
                    fontWeight: FontWeight.w600,
                    color: QoffaColors.secondarySage,
                  ),
                ),
              ),
            ],
          ),
        ],
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
      Flexible(
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: QoffaFontFamily.body,
            fontSize: QoffaFontSize.captionMedium,
            fontWeight: FontWeight.w700,
            color: color == QoffaColors.skyBlue ? QoffaColors.primaryNavy : color,
          ),
        ),
      ),
    ],
  );
}


