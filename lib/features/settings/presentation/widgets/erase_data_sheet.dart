import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/qoffa_colors.dart';
import '../../../../app/theme/qoffa_tokens.dart';
import '../../../../core/particles_and_effects/particle_effect_presets.dart';
import '../../../../core/particles_and_effects/qoffa_particle_overlay.dart';
import '../../../../core/widgets/qoffa_confirm_dialog.dart';
import '../../../../core/widgets/qoffa_pressable.dart';
import '../../../../core/widgets/qoffa_quantity_selector.dart';
import '../../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../../../core/widgets/qoffa_typing_box.dart';
import '../../../../core/widgets/top_toast_notification.dart';
import '../../data/settings_repository.dart';

class EraseDataSheet extends ConsumerStatefulWidget {
  const EraseDataSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.92,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(QoffaTokens.radiusMajor),
            ),
          ),
          child: const SafeArea(
            top: false,
            child: EraseDataSheet(),
          ),
        ),
      ),
    );
  }

  @override
  ConsumerState<EraseDataSheet> createState() => _EraseDataSheetState();
}

class _EraseDataSheetState extends ConsumerState<EraseDataSheet> {
  int _selectedTab = 0; // 0: purchases & activity, 1: later buy, 2: shops, 3: custom foods

  // Purchases & Activity state
  String _purchasesMode = 'all'; // 'all', 'date'
  String _purchasesDatePreset = 'last30days'; // 'today', 'last7days', 'last30days', 'older_than', 'custom'
  double _purchasesOlderThanDays = 30.0;
  DateTimeRange? _purchasesCustomRange;

  // Later Buy state
  String _laterBuyMode = 'all'; // 'all', 'date'
  String _laterBuyDatePreset = 'all'; // 'today', 'last7days', 'last30days', 'older_than', 'custom'
  double _laterBuyOlderThanDays = 30.0;
  DateTimeRange? _laterBuyCustomRange;

  // Shops state
  String _shopsMode = 'specific'; // 'all', 'specific'
  final TextEditingController _shopsSearchController = TextEditingController();
  final Set<String> _selectedStoreIds = {};

  // Custom Foods state
  String _foodsMode = 'specific'; // 'all', 'specific'
  final TextEditingController _foodsSearchController = TextEditingController();
  final Set<String> _selectedFoodIds = {};

  bool _isProcessing = false;

  @override
  void dispose() {
    _shopsSearchController.dispose();
    _foodsSearchController.dispose();
    super.dispose();
  }

  ({DateTime? from, DateTime? to}) _resolveDateRange({
    required String mode,
    required String preset,
    required double olderThanDays,
    required DateTimeRange? customRange,
  }) {
    if (mode == 'all') {
      return (from: null, to: null);
    }

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    switch (preset) {
      case 'today':
        return (from: todayStart, to: todayEnd);
      case 'last7days':
        return (
          from: todayStart.subtract(const Duration(days: 7)),
          to: todayEnd,
        );
      case 'last30days':
        return (
          from: todayStart.subtract(const Duration(days: 30)),
          to: todayEnd,
        );
      case 'older_than':
        return (
          from: null,
          to: todayStart.subtract(Duration(days: olderThanDays.toInt())),
        );
      case 'custom':
        if (customRange != null) {
          final s = customRange.start;
          final e = customRange.end;
          return (
            from: DateTime(s.year, s.month, s.day),
            to: DateTime(e.year, e.month, e.day, 23, 59, 59, 999),
          );
        }
        return (from: null, to: null);
      default:
        return (from: null, to: null);
    }
  }

  String _formatDate(DateTime date, String langCode) {
    if (langCode == 'ar') {
      final months = [
        'جانفي',
        'فيفري',
        'مارس',
        'أفريل',
        'ماي',
        'جوان',
        'جويلية',
        'أوت',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
      final mIndex = date.month - 1;
      final mName = (mIndex >= 0 && mIndex < months.length)
          ? months[mIndex]
          : '${date.month}';
      return '${date.day} $mName ${date.year}';
    } else if (langCode == 'fr') {
      final months = [
        'janv.',
        'févr.',
        'mars',
        'avr.',
        'mai',
        'juin',
        'juil.',
        'août',
        'sept.',
        'oct.',
        'nov.',
        'déc.',
      ];
      final mIndex = date.month - 1;
      final mName = (mIndex >= 0 && mIndex < months.length)
          ? months[mIndex]
          : '${date.month}';
      return '${date.day} $mName ${date.year}';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final mIndex = date.month - 1;
      final mName = (mIndex >= 0 && mIndex < months.length)
          ? months[mIndex]
          : '${date.month}';
      return '$mName ${date.day}, ${date.year}';
    }
  }

  Future<void> _handleEraseAll() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await QoffaConfirmDialog.show(
      context: context,
      title: l10n.eraseAllConfirmTitle,
      message: l10n.eraseAllConfirmMessage,
      confirmLabel: l10n.eraseNow,
      cancelLabel: l10n.cancel,
      confirmColor: QoffaColors.warningCoral,
      icon: Icons.warning_amber_rounded,
    );

    if (confirmed != true || !mounted) return;

    final screenSize = MediaQuery.sizeOf(context);
    QoffaParticleOverlay.spawn(
      context,
      globalOrigin: Offset(screenSize.width * 0.5, screenSize.height * 0.5),
      config: ParticleEffectPresets.deletion,
      spawnWidth: screenSize.width * 0.75,
    );

    setState(() => _isProcessing = true);
    try {
      final repo = ref.read(settingsRepositoryProvider);
      await repo.eraseAllData();
      if (mounted) {
        QoffaToast.show(
          message: l10n.eraseSuccessToast,
          icon: Icons.check_circle_rounded,
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleErasePurchases() async {
    final l10n = AppLocalizations.of(context);
    final range = _resolveDateRange(
      mode: _purchasesMode,
      preset: _purchasesDatePreset,
      olderThanDays: _purchasesOlderThanDays,
      customRange: _purchasesCustomRange,
    );

    final confirmed = await QoffaConfirmDialog.show(
      context: context,
      title: l10n.confirmEraseTitle,
      message: l10n.confirmEraseMessage,
      confirmLabel: l10n.eraseNow,
      cancelLabel: l10n.cancel,
      confirmColor: QoffaColors.warningCoral,
    );

    if (confirmed != true || !mounted) return;

    final screenSize = MediaQuery.sizeOf(context);
    QoffaParticleOverlay.spawn(
      context,
      globalOrigin: Offset(screenSize.width * 0.5, screenSize.height * 0.5),
      config: ParticleEffectPresets.deletion,
      spawnWidth: screenSize.width * 0.75,
    );

    setState(() => _isProcessing = true);
    try {
      final repo = ref.read(settingsRepositoryProvider);
      await repo.erasePurchasesAndActivity(from: range.from, to: range.to);
      if (mounted) {
        QoffaToast.show(
          message: l10n.eraseSuccessToast,
          icon: Icons.check_circle_rounded,
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleEraseLaterBuy() async {
    final l10n = AppLocalizations.of(context);
    final range = _resolveDateRange(
      mode: _laterBuyMode,
      preset: _laterBuyDatePreset,
      olderThanDays: _laterBuyOlderThanDays,
      customRange: _laterBuyCustomRange,
    );

    final confirmed = await QoffaConfirmDialog.show(
      context: context,
      title: l10n.confirmEraseTitle,
      message: l10n.confirmEraseMessage,
      confirmLabel: l10n.eraseNow,
      cancelLabel: l10n.cancel,
      confirmColor: QoffaColors.warningCoral,
    );

    if (confirmed != true || !mounted) return;

    final screenSize = MediaQuery.sizeOf(context);
    QoffaParticleOverlay.spawn(
      context,
      globalOrigin: Offset(screenSize.width * 0.5, screenSize.height * 0.5),
      config: ParticleEffectPresets.deletion,
      spawnWidth: screenSize.width * 0.75,
    );

    setState(() => _isProcessing = true);
    try {
      final repo = ref.read(settingsRepositoryProvider);
      await repo.eraseLaterBuyItems(from: range.from, to: range.to);
      if (mounted) {
        QoffaToast.show(
          message: l10n.eraseSuccessToast,
          icon: Icons.check_circle_rounded,
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleEraseStores() async {
    final l10n = AppLocalizations.of(context);
    final isAll = _shopsMode == 'all';

    if (!isAll && _selectedStoreIds.isEmpty) {
      QoffaToast.show(
        message: l10n.noDataSelectedToast,
        icon: Icons.info_outline_rounded,
        color: QoffaColors.warningCoral,
      );
      return;
    }

    final confirmed = await QoffaConfirmDialog.show(
      context: context,
      title: l10n.confirmEraseTitle,
      message: l10n.confirmEraseMessage,
      confirmLabel: l10n.eraseNow,
      cancelLabel: l10n.cancel,
      confirmColor: QoffaColors.warningCoral,
      icon: Icons.storefront_outlined,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isProcessing = true);
    try {
      final repo = ref.read(settingsRepositoryProvider);
      await repo.eraseStores(
        specificStoreIds: isAll ? null : _selectedStoreIds.toList(),
        all: isAll,
      );
      if (mounted) {
        QoffaToast.show(
          message: l10n.eraseSuccessToast,
          icon: Icons.check_circle_rounded,
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleEraseFoods() async {
    final l10n = AppLocalizations.of(context);
    final isAll = _foodsMode == 'all';

    if (!isAll && _selectedFoodIds.isEmpty) {
      QoffaToast.show(
        message: l10n.noDataSelectedToast,
        icon: Icons.info_outline_rounded,
        color: QoffaColors.warningCoral,
      );
      return;
    }

    final confirmed = await QoffaConfirmDialog.show(
      context: context,
      title: l10n.confirmEraseTitle,
      message: l10n.confirmEraseMessage,
      confirmLabel: l10n.eraseNow,
      cancelLabel: l10n.cancel,
      confirmColor: QoffaColors.warningCoral,
      icon: Icons.restaurant_menu_rounded,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isProcessing = true);
    try {
      final repo = ref.read(settingsRepositoryProvider);
      await repo.eraseCustomFoods(
        specificProductIds: isAll ? null : _selectedFoodIds.toList(),
        all: isAll,
      );
      if (mounted) {
        QoffaToast.show(
          message: l10n.eraseSuccessToast,
          icon: Icons.check_circle_rounded,
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: QoffaColors.softBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: QoffaColors.warningCoral.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  color: QoffaColors.warningCoral,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.eraseDataSheetTitle,
                      style: const TextStyle(
                        fontFamily: 'Hero Sandwich Pro',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.eraseDataDesc,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Warning Notice Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: QoffaColors.warningCoral.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
              border: Border.all(
                color: QoffaColors.warningCoral.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: QoffaColors.warningCoral,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.eraseDataWarning,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: QoffaColors.primaryNavy.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 1. Full Reset (Erase All Data) Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
              border: Border.all(
                color: QoffaColors.warningCoral.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: QoffaColors.warningCoral,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.eraseAllData,
                        style: const TextStyle(
                          fontFamily: 'Hero Sandwich Pro',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: QoffaColors.warningCoral,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.eraseAllDataSubtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: QoffaColors.secondarySage,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                QoffaTactilePressable.filled(
                  width: double.infinity,
                  height: 44,
                  label: l10n.eraseAllData,
                  icon: Icons.delete_forever_rounded,
                  backgroundColor: QoffaColors.warningCoral,
                  borderColor: QoffaColors.warningCoral,
                  hoverBackgroundColor: QoffaColors.warningCoralDeep,
                  hoverBorderColor: QoffaColors.warningCoralDeep,
                  enabled: !_isProcessing,
                  onTap: _handleEraseAll,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Granular Category Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabPill(
                  index: 0,
                  icon: Icons.shopping_basket_outlined,
                  label: l10n.tabBoughtAndActivity,
                ),
                const SizedBox(width: 8),
                _buildTabPill(
                  index: 1,
                  icon: Icons.schedule_rounded,
                  label: l10n.tabLaterBuy,
                ),
                const SizedBox(width: 8),
                _buildTabPill(
                  index: 2,
                  icon: Icons.storefront_outlined,
                  label: l10n.tabShops,
                ),
                const SizedBox(width: 8),
                _buildTabPill(
                  index: 3,
                  icon: Icons.restaurant_menu_rounded,
                  label: l10n.tabCustomFoods,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Tab Content View
          IndexedStack(
            index: _selectedTab,
            children: [
              _buildPurchasesTab(l10n),
              _buildLaterBuyTab(l10n),
              _buildShopsTab(l10n),
              _buildCustomFoodsTab(l10n),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedTab == index;

    return QoffaPressable(
      onTap: () => setState(() => _selectedTab = index),
      backgroundColor: isSelected ? QoffaColors.primaryNavy : Colors.white,
      borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? QoffaColors.primaryNavy : QoffaColors.softBorder,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : QoffaColors.primaryNavy,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : QoffaColors.primaryNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Tab 1: Bought Food & Activity ---
  Widget _buildPurchasesTab(AppLocalizations l10n) {
    final range = _resolveDateRange(
      mode: _purchasesMode,
      preset: _purchasesDatePreset,
      olderThanDays: _purchasesOlderThanDays,
      customRange: _purchasesCustomRange,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFDFB),
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tabBoughtAndActivity,
            style: const TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 12),

          // Mode Switcher: All Time vs Date Range
          Row(
            children: [
              Expanded(
                child: _buildSegmentButton(
                  selected: _purchasesMode == 'all',
                  label: l10n.allTime,
                  icon: Icons.all_inclusive_rounded,
                  onTap: () => setState(() => _purchasesMode = 'all'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSegmentButton(
                  selected: _purchasesMode == 'date',
                  label: l10n.pickDateRange,
                  icon: Icons.calendar_today_rounded,
                  onTap: () => setState(() => _purchasesMode = 'date'),
                ),
              ),
            ],
          ),

          if (_purchasesMode == 'date') ...[
            const SizedBox(height: 14),
            // Date Presets
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPresetChip(
                  label: l10n.todayOnly,
                  selected: _purchasesDatePreset == 'today',
                  onTap: () => setState(() => _purchasesDatePreset = 'today'),
                ),
                _buildPresetChip(
                  label: l10n.last7Days,
                  selected: _purchasesDatePreset == 'last7days',
                  onTap: () =>
                      setState(() => _purchasesDatePreset = 'last7days'),
                ),
                _buildPresetChip(
                  label: l10n.last30Days,
                  selected: _purchasesDatePreset == 'last30days',
                  onTap: () =>
                      setState(() => _purchasesDatePreset = 'last30days'),
                ),
                _buildPresetChip(
                  label: l10n.customDateRange,
                  selected: _purchasesDatePreset == 'custom',
                  onTap: () async {
                    setState(() => _purchasesDatePreset = 'custom');
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: _purchasesCustomRange ??
                          DateTimeRange(
                            start: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            end: DateTime.now(),
                          ),
                    );
                    if (picked != null) {
                      setState(() => _purchasesCustomRange = picked);
                    }
                  },
                ),
                _buildPresetChip(
                  label: l10n.deleteOlderThanDays,
                  selected: _purchasesDatePreset == 'older_than',
                  onTap: () =>
                      setState(() => _purchasesDatePreset = 'older_than'),
                ),
              ],
            ),

            if (_purchasesDatePreset == 'older_than') ...[
              const SizedBox(height: 14),
              QoffaQuantitySelector(
                value: _purchasesOlderThanDays,
                min: 1.0,
                max: 365.0,
                step: 1.0,
                label: l10n.deleteOlderThanDays,
                valueFormatter: (v) => '${v.toInt()} ${l10n.daysUnit}',
                onChanged: (val) =>
                    setState(() => _purchasesOlderThanDays = val),
              ),
            ],

            if (_purchasesDatePreset == 'custom' &&
                _purchasesCustomRange != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint,
                  borderRadius:
                      BorderRadius.circular(QoffaTokens.radiusControls),
                  border: Border.all(color: QoffaColors.softBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      size: 18,
                      color: QoffaColors.brandGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_formatDate(_purchasesCustomRange!.start, l10n.languageCode)} → ${_formatDate(_purchasesCustomRange!.end, l10n.languageCode)}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          const SizedBox(height: 16),

          // Dynamic live count preview
          FutureBuilder<({int purchasesCount, int notesCount})>(
            future: ref
                .watch(settingsRepositoryProvider)
                .countPurchasesAndActivity(from: range.from, to: range.to),
            builder: (context, snapshot) {
              final counts = snapshot.data ?? (purchasesCount: 0, notesCount: 0);
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(QoffaTokens.radiusControls),
                  border: Border.all(color: QoffaColors.softBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${counts.purchasesCount}',
                          style: const TextStyle(
                            fontFamily: 'Hero Sandwich Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                        Text(
                          l10n.recordsCountPurchases,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: QoffaColors.secondarySage,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: QoffaColors.softBorder,
                    ),
                    Column(
                      children: [
                        Text(
                          '${counts.notesCount}',
                          style: const TextStyle(
                            fontFamily: 'Hero Sandwich Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                        Text(
                          l10n.recordsCountNotes,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: QoffaColors.secondarySage,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Delete Action Button
          QoffaTactilePressable.filled(
            width: double.infinity,
            height: 48,
            label: l10n.erasePurchasesBtn,
            icon: Icons.delete_outline_rounded,
            backgroundColor: QoffaColors.warningCoral,
            borderColor: QoffaColors.warningCoral,
            hoverBackgroundColor: QoffaColors.warningCoralDeep,
            hoverBorderColor: QoffaColors.warningCoralDeep,
            enabled: !_isProcessing,
            onTap: _handleErasePurchases,
          ),
        ],
      ),
    );
  }

  // --- Tab 2: Later Buy (all 3 tabs) ---
  Widget _buildLaterBuyTab(AppLocalizations l10n) {
    final range = _resolveDateRange(
      mode: _laterBuyMode,
      preset: _laterBuyDatePreset,
      olderThanDays: _laterBuyOlderThanDays,
      customRange: _laterBuyCustomRange,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFDFB),
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tabLaterBuy,
            style: const TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.laterBuyThreeTabsNote,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: QoffaColors.secondarySage,
            ),
          ),
          const SizedBox(height: 14),

          // Mode Switcher: All Time vs Date Range
          Row(
            children: [
              Expanded(
                child: _buildSegmentButton(
                  selected: _laterBuyMode == 'all',
                  label: l10n.allTime,
                  icon: Icons.all_inclusive_rounded,
                  onTap: () => setState(() => _laterBuyMode = 'all'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSegmentButton(
                  selected: _laterBuyMode == 'date',
                  label: l10n.pickDateRange,
                  icon: Icons.calendar_today_rounded,
                  onTap: () => setState(() => _laterBuyMode = 'date'),
                ),
              ),
            ],
          ),

          if (_laterBuyMode == 'date') ...[
            const SizedBox(height: 14),
            // Date Presets
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPresetChip(
                  label: l10n.todayOnly,
                  selected: _laterBuyDatePreset == 'today',
                  onTap: () => setState(() => _laterBuyDatePreset = 'today'),
                ),
                _buildPresetChip(
                  label: l10n.last7Days,
                  selected: _laterBuyDatePreset == 'last7days',
                  onTap: () => setState(() => _laterBuyDatePreset = 'last7days'),
                ),
                _buildPresetChip(
                  label: l10n.last30Days,
                  selected: _laterBuyDatePreset == 'last30days',
                  onTap: () => setState(() => _laterBuyDatePreset = 'last30days'),
                ),
                _buildPresetChip(
                  label: l10n.customDateRange,
                  selected: _laterBuyDatePreset == 'custom',
                  onTap: () async {
                    setState(() => _laterBuyDatePreset = 'custom');
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: _laterBuyCustomRange ??
                          DateTimeRange(
                            start: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            end: DateTime.now(),
                          ),
                    );
                    if (picked != null) {
                      setState(() => _laterBuyCustomRange = picked);
                    }
                  },
                ),
                _buildPresetChip(
                  label: l10n.deleteOlderThanDays,
                  selected: _laterBuyDatePreset == 'older_than',
                  onTap: () =>
                      setState(() => _laterBuyDatePreset = 'older_than'),
                ),
              ],
            ),

            if (_laterBuyDatePreset == 'older_than') ...[
              const SizedBox(height: 14),
              QoffaQuantitySelector(
                value: _laterBuyOlderThanDays,
                min: 1.0,
                max: 365.0,
                step: 1.0,
                label: l10n.deleteOlderThanDays,
                valueFormatter: (v) => '${v.toInt()} ${l10n.daysUnit}',
                onChanged: (val) =>
                    setState(() => _laterBuyOlderThanDays = val),
              ),
            ],

            if (_laterBuyDatePreset == 'custom' &&
                _laterBuyCustomRange != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint,
                  borderRadius:
                      BorderRadius.circular(QoffaTokens.radiusControls),
                  border: Border.all(color: QoffaColors.softBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      size: 18,
                      color: QoffaColors.brandGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_formatDate(_laterBuyCustomRange!.start, l10n.languageCode)} → ${_formatDate(_laterBuyCustomRange!.end, l10n.languageCode)}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          const SizedBox(height: 16),

          // Dynamic live count preview
          FutureBuilder<int>(
            future: ref
                .watch(settingsRepositoryProvider)
                .countLaterBuyItems(from: range.from, to: range.to),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(QoffaTokens.radiusControls),
                  border: Border.all(color: QoffaColors.softBorder),
                ),
                child: Column(
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontFamily: 'Hero Sandwich Pro',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    Text(
                      l10n.recordsCountLater,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: QoffaColors.secondarySage,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Delete Action Button
          QoffaTactilePressable.filled(
            width: double.infinity,
            height: 48,
            label: l10n.eraseLaterBuyBtn,
            icon: Icons.delete_outline_rounded,
            backgroundColor: QoffaColors.warningCoral,
            borderColor: QoffaColors.warningCoral,
            hoverBackgroundColor: QoffaColors.warningCoralDeep,
            hoverBorderColor: QoffaColors.warningCoralDeep,
            enabled: !_isProcessing,
            onTap: _handleEraseLaterBuy,
          ),
        ],
      ),
    );
  }

  // --- Tab 3: Shops ---
  Widget _buildShopsTab(AppLocalizations l10n) {
    final storesAsync = ref.watch(eraseStoresProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFDFB),
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tabShops,
            style: const TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 12),

          // Mode Switcher: All vs Specific
          Row(
            children: [
              Expanded(
                child: _buildSegmentButton(
                  selected: _shopsMode == 'all',
                  label: l10n.allShopsOption,
                  icon: Icons.select_all_rounded,
                  onTap: () => setState(() => _shopsMode = 'all'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSegmentButton(
                  selected: _shopsMode == 'specific',
                  label: l10n.specificShopsOption,
                  icon: Icons.check_box_outlined,
                  onTap: () => setState(() => _shopsMode = 'specific'),
                ),
              ),
            ],
          ),

          if (_shopsMode == 'specific') ...[
            const SizedBox(height: 14),

            // Search Box
            QoffaTypingBox(
              controller: _shopsSearchController,
              hintText: l10n.searchShopsPlaceholder,
              prefixIcon: Icons.search_rounded,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 10),

            storesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: QoffaColors.brandGreen,
                  ),
                ),
              ),
              error: (err, _) => Text(
                l10n.errorMessage(err),
                style: const TextStyle(color: QoffaColors.warningCoral),
              ),
              data: (stores) {
                final query = _shopsSearchController.text.trim().toLowerCase();
                final filtered = stores.where((s) {
                  if (query.isEmpty) return true;
                  final nameMatches = s.name.toLowerCase().contains(query);
                  final areaMatches =
                      s.area?.toLowerCase().contains(query) ?? false;
                  return nameMatches || areaMatches;
                }).toList();

                if (stores.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        l10n.noStoresFound,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Quick Action: Select All / Deselect All
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${l10n.selectedCountLabel}: ${_selectedStoreIds.length} / ${filtered.length}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: QoffaColors.primaryNavy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedStoreIds
                                      .addAll(filtered.map((s) => s.id));
                                });
                              },
                              child: Text(
                                l10n.selectAll,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: QoffaColors.actionGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedStoreIds.removeAll(
                                    filtered.map((s) => s.id),
                                  );
                                });
                              },
                              child: Text(
                                l10n.deselectAll,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: QoffaColors.secondarySage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Store Items List
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (context, idx) {
                          final store = filtered[idx];
                          final isChecked =
                              _selectedStoreIds.contains(store.id);

                          return QoffaPressable(
                            onTap: () {
                              setState(() {
                                if (isChecked) {
                                  _selectedStoreIds.remove(store.id);
                                } else {
                                  _selectedStoreIds.add(store.id);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(
                              QoffaTokens.radiusControls,
                            ),
                            backgroundColor: isChecked
                                ? QoffaColors.mintSurfaceTint
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isChecked
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                  color: isChecked
                                      ? QoffaColors.actionGreen
                                      : QoffaColors.secondarySage,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        store.name,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: QoffaColors.primaryNavy,
                                        ),
                                      ),
                                      if (store.area != null &&
                                          store.area!.isNotEmpty)
                                        Text(
                                          store.area!,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            color: QoffaColors.secondarySage,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],

          const SizedBox(height: 16),

          // Delete Action Button
          QoffaTactilePressable.filled(
            width: double.infinity,
            height: 48,
            label: l10n.eraseShopsBtn,
            icon: Icons.delete_outline_rounded,
            backgroundColor: QoffaColors.warningCoral,
            borderColor: QoffaColors.warningCoral,
            hoverBackgroundColor: QoffaColors.warningCoralDeep,
            hoverBorderColor: QoffaColors.warningCoralDeep,
            enabled: !_isProcessing,
            onTap: _handleEraseStores,
          ),
        ],
      ),
    );
  }

  // --- Tab 4: Custom Foods ---
  Widget _buildCustomFoodsTab(AppLocalizations l10n) {
    final prodsAsync = ref.watch(eraseCustomProductsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFDFB),
        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tabCustomFoods,
            style: const TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: QoffaColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 12),

          // Mode Switcher: All vs Specific
          Row(
            children: [
              Expanded(
                child: _buildSegmentButton(
                  selected: _foodsMode == 'all',
                  label: l10n.allCustomFoodsOption,
                  icon: Icons.select_all_rounded,
                  onTap: () => setState(() => _foodsMode = 'all'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSegmentButton(
                  selected: _foodsMode == 'specific',
                  label: l10n.specificCustomFoodsOption,
                  icon: Icons.check_box_outlined,
                  onTap: () => setState(() => _foodsMode = 'specific'),
                ),
              ),
            ],
          ),

          if (_foodsMode == 'specific') ...[
            const SizedBox(height: 14),

            // Search Box
            QoffaTypingBox(
              controller: _foodsSearchController,
              hintText: l10n.searchCustomFoodsPlaceholder,
              prefixIcon: Icons.search_rounded,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 10),

            prodsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: QoffaColors.brandGreen,
                  ),
                ),
              ),
              error: (err, _) => Text(
                l10n.errorMessage(err),
                style: const TextStyle(color: QoffaColors.warningCoral),
              ),
              data: (products) {
                final query = _foodsSearchController.text.trim().toLowerCase();
                final filtered = products.where((p) {
                  if (query.isEmpty) return true;
                  final nameMatches = p.name.toLowerCase().contains(query);
                  final brandMatches =
                      p.brand?.toLowerCase().contains(query) ?? false;
                  return nameMatches || brandMatches;
                }).toList();

                if (products.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        l10n.noCustomFoodsFound,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Quick Action: Select All / Deselect All
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${l10n.selectedCountLabel}: ${_selectedFoodIds.length} / ${filtered.length}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: QoffaColors.primaryNavy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedFoodIds
                                      .addAll(filtered.map((p) => p.id));
                                });
                              },
                              child: Text(
                                l10n.selectAll,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: QoffaColors.actionGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedFoodIds.removeAll(
                                    filtered.map((p) => p.id),
                                  );
                                });
                              },
                              child: Text(
                                l10n.deselectAll,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: QoffaColors.secondarySage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Foods Items List
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (context, idx) {
                          final product = filtered[idx];
                          final isChecked =
                              _selectedFoodIds.contains(product.id);

                          return QoffaPressable(
                            onTap: () {
                              setState(() {
                                if (isChecked) {
                                  _selectedFoodIds.remove(product.id);
                                } else {
                                  _selectedFoodIds.add(product.id);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(
                              QoffaTokens.radiusControls,
                            ),
                            backgroundColor: isChecked
                                ? QoffaColors.mintSurfaceTint
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isChecked
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                  color: isChecked
                                      ? QoffaColors.actionGreen
                                      : QoffaColors.secondarySage,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: QoffaColors.primaryNavy,
                                        ),
                                      ),
                                      if (product.brand != null &&
                                          product.brand!.isNotEmpty)
                                        Text(
                                          product.brand!,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            color: QoffaColors.secondarySage,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],

          const SizedBox(height: 16),

          // Delete Action Button
          QoffaTactilePressable.filled(
            width: double.infinity,
            height: 48,
            label: l10n.eraseFoodsBtn,
            icon: Icons.delete_outline_rounded,
            backgroundColor: QoffaColors.warningCoral,
            borderColor: QoffaColors.warningCoral,
            hoverBackgroundColor: QoffaColors.warningCoralDeep,
            hoverBorderColor: QoffaColors.warningCoralDeep,
            enabled: !_isProcessing,
            onTap: _handleEraseFoods,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required bool selected,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return QoffaPressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
      backgroundColor: selected ? QoffaColors.mintSurfaceTint : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? QoffaColors.actionGreen : QoffaColors.softBorder,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? QoffaColors.actionGreen
                  : QoffaColors.secondarySage,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected
                      ? QoffaColors.actionGreen
                      : QoffaColors.primaryNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return QoffaPressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      backgroundColor: selected ? QoffaColors.brandGreen : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? QoffaColors.brandGreen : QoffaColors.softBorder,
            width: 1.1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : QoffaColors.primaryNavy,
          ),
        ),
      ),
    );
  }
}
