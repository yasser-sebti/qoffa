import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_confirm_dialog.dart';
import '../../../core/widgets/qoffa_layout.dart';
import '../../../core/widgets/qoffa_motion.dart';
import '../../../core/widgets/qoffa_pressable.dart';
import '../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../../../core/particles_and_effects/particle_effect_presets.dart';
import '../../../core/particles_and_effects/qoffa_card_action_animator.dart';
import '../../../core/particles_and_effects/qoffa_particle_overlay.dart';
import '../../insights/domain/services/was_it_worth_waiting_service.dart';
import '../data/later_buy_repository.dart';
import '../../../core/widgets/qoffa_filter_chip.dart';
import 'qoffa_resolve_later_buy_sheet.dart';

enum LaterBuySortOption {
  newest,
  oldest,
  priceLowToHigh,
  priceHighToLow,
}

class LaterBuyScreen extends ConsumerStatefulWidget {
  const LaterBuyScreen({super.key});

  @override
  ConsumerState<LaterBuyScreen> createState() => _LaterBuyScreenState();
}

class _LaterBuyScreenState extends ConsumerState<LaterBuyScreen> {
  String _activeTab = 'active';
  DateTime _selectedDate = DateTime.now();
  bool _filterByDate = false;
  LaterBuySortOption _sortOption = LaterBuySortOption.newest;
  final Set<String> _expandedCardIds = {};

  final Map<String, ScrollController> _scrollControllers = {
    'active': ScrollController(),
    'bought': ScrollController(),
    'skipped': ScrollController(),
  };

  @override
  void deactivate() {
    _expandedCardIds.clear();
    super.deactivate();
  }

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Object get _filterSortKey => Object.hash(
        _sortOption,
        _filterByDate,
        _filterByDate ? _selectedDate : 0,
      );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _filterByDate = true;
      });
    }
  }

  Future<void> _resolveBought(
    LaterBuyListEntry entry, [
    QoffaCardActionController? animator,
  ]) async {
    final result = await QoffaResolveLaterBuySheet.show(context, entry: entry);
    if (result != null && mounted) {
      final l10n = AppLocalizations.of(context);
      QoffaToast.show(
        title: l10n.purchaseSaved,
        message: entry.productName,
        icon: Icons.check_circle_rounded,
        type: QoffaNotificationType.approved,
        color: QoffaColors.actionGreen,
      );
      final screenSize = MediaQuery.sizeOf(context);
      QoffaParticleOverlay.spawn(
        context,
        globalOrigin: Offset(screenSize.width * 0.5, screenSize.height * 0.40),
        config: ParticleEffectPresets.celebration,
        spawnWidth: screenSize.width * 0.85,
      );
      if (animator != null) {
        animator.trigger(
          config: ParticleEffectPresets.celebration,
          onCommit: () async {},
        );
      }
      _showOutcome(result);
    }
  }

  Future<void> _handleSkip(
    LaterBuyListEntry entry, [
    QoffaCardActionController? animator,
  ]) async {
    final l10n = AppLocalizations.of(context);
    if (animator != null) {
      QoffaToast.show(
        message: l10n.skippedSuccess,
        type: QoffaNotificationType.normal,
      );
      await animator.trigger(
        config: ParticleEffectPresets.dismissal,
        onCommit: () async {
          try {
            await ref
                .read(laterBuyRepositoryProvider)
                .updateStatus(entry.item.id, 'skipped');
          } catch (e) {
            if (mounted) {
              QoffaToast.show(
                message: l10n.errorMessage(e),
                type: QoffaNotificationType.declined,
              );
            }
          }
        },
      );
    } else {
      try {
        QoffaToast.show(
          message: l10n.skippedSuccess,
          type: QoffaNotificationType.normal,
        );
        await ref
            .read(laterBuyRepositoryProvider)
            .updateStatus(entry.item.id, 'skipped');
      } catch (e) {
        if (mounted) {
          QoffaToast.show(
            message: l10n.errorMessage(e),
            type: QoffaNotificationType.declined,
          );
        }
      }
    }
  }

  Future<void> _handleReactivate(
    LaterBuyListEntry entry, [
    QoffaCardActionController? animator,
  ]) async {
    final l10n = AppLocalizations.of(context);
    if (animator != null) {
      QoffaToast.show(
        message: l10n.reactivatedSuccess,
        color: QoffaColors.actionGreen,
      );
      await animator.trigger(
        config: ParticleEffectPresets.revival,
        onCommit: () async {
          try {
            await ref
                .read(laterBuyRepositoryProvider)
                .updateStatus(entry.item.id, 'active');
          } catch (e) {
            if (mounted) {
              QoffaToast.show(
                message: l10n.errorMessage(e),
                color: QoffaColors.warningCoral,
              );
            }
          }
        },
      );
    } else {
      try {
        QoffaToast.show(
          message: l10n.reactivatedSuccess,
          color: QoffaColors.actionGreen,
        );
        await ref
            .read(laterBuyRepositoryProvider)
            .updateStatus(entry.item.id, 'active');
      } catch (e) {
        if (mounted) {
          QoffaToast.show(
            message: l10n.errorMessage(e),
            color: QoffaColors.warningCoral,
          );
        }
      }
    }
  }

  Future<void> _confirmDeleteItem(
    LaterBuyListEntry entry, [
    QoffaCardActionController? animator,
  ]) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await QoffaConfirmDialog.show(
      context: context,
      title: l10n.deleteItemConfirmTitle,
      message: l10n.deleteItemConfirmMessage,
      confirmLabel: l10n.deleteItemConfirmTitle,
      cancelLabel: l10n.cancel,
    );
    if (!mounted) return;
    if (confirmed == true) {
      if (animator != null) {
        await animator.trigger(
          config: ParticleEffectPresets.deletion,
          onCommit: () async {
            await ref
                .read(laterBuyRepositoryProvider)
                .deleteLaterBuyItem(entry.item.id);
          },
        );
      } else {
        final screenSize = MediaQuery.sizeOf(context);
        QoffaParticleOverlay.spawn(
          context,
          globalOrigin: Offset(screenSize.width * 0.5, screenSize.height * 0.45),
          config: ParticleEffectPresets.deletion,
          spawnWidth: screenSize.width * 0.7,
        );
        await ref
            .read(laterBuyRepositoryProvider)
            .deleteLaterBuyItem(entry.item.id);
      }
      if (mounted) {
        QoffaToast.show(
          message: l10n.itemDeleted,
          color: QoffaColors.warningCoral,
        );
      }
    }
  }

  Future<void> _showOutcome(WasItWorthWaitingResult result) {
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => _OutcomeDialog(
        result: result,
        l10n: l10n,
      ),
    );
  }

  static Widget _buildOutcomeContent(
    WasItWorthWaitingResult result,
    AppLocalizations l10n,
  ) {
    if (!result.isComparable) {
      return Text(
        l10n.noPreviousPrice,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: QoffaFontFamily.body,
          fontSize: QoffaFontSize.bodyMedium,
          fontWeight: FontWeight.w500,
          color: QoffaColors.primaryNavy,
        ),
      );
    }

    final diff = result.absoluteDifferenceDzd.dinars;
    final days = result.daysWaited;
    final currency = l10n.isArabic ? 'دج' : 'DA';

    const baseStyle = TextStyle(
      fontFamily: QoffaFontFamily.body,
      fontSize: QoffaFontSize.bodyMedium,
      fontWeight: FontWeight.w500,
      color: QoffaColors.primaryNavy,
    );

    final numberStyle = TextStyle(
      fontFamily: QoffaFontFamily.body,
      fontSize: QoffaFontSize.bodyMedium + 1.0,
      fontWeight: diff == 0 ? FontWeight.w500 : FontWeight.w900,
      color: diff > 0
          ? QoffaColors.actionGreen
          : (diff < 0 ? QoffaColors.warningCoral : QoffaColors.primaryNavy),
    );

    final String prefix;
    final String amountText;
    final String suffix;

    if (diff > 0) {
      amountText = '$diff $currency';
      if (l10n.isArabic) {
        prefix = 'وفّرت ';
        suffix = days > 0 ? ' بعد انتظار $days يوم' : ' اليوم';
      } else if (l10n.isFrench) {
        prefix = 'Vous avez économisé ';
        suffix = days > 0 ? ' après $days jours' : " aujourd'hui";
      } else {
        prefix = 'You saved ';
        suffix = days > 0 ? ' after waiting $days days' : ' today';
      }
    } else if (diff < 0) {
      amountText = '${diff.abs()} $currency';
      if (l10n.isArabic) {
        prefix = 'دفعت ';
        suffix = days > 0 ? ' إضافية بعد $days يوم' : ' إضافية اليوم';
      } else if (l10n.isFrench) {
        prefix = 'Vous avez payé ';
        suffix = days > 0 ? ' de plus après $days jours' : " de plus aujourd'hui";
      } else {
        prefix = 'You paid ';
        suffix = days > 0 ? ' more after $days days' : ' more today';
      }
    } else {
      amountText = '0 $currency';
      if (l10n.isArabic) {
        prefix = 'لم يتغير السعر (';
        suffix = days > 0 ? ') بعد انتظار $days يوم' : ') اليوم';
      } else if (l10n.isFrench) {
        prefix = 'Le prix n\'a pas changé (';
        suffix = days > 0 ? ') après $days jours' : ") aujourd'hui";
      } else {
        prefix = 'Price did not change (';
        suffix = days > 0 ? ') after waiting $days days' : ') today';
      }
    }

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: prefix),
          TextSpan(text: amountText, style: numberStyle),
          TextSpan(text: suffix),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Future<void> _editActiveItemPrice(LaterBuyListEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: entry.item.observedPriceDzd.toString(),
    );

    final newPrice = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 128,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: QoffaColors.softBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              l10n.enterNewObservedPrice,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.display,
                fontSize: QoffaFontSize.titleMedium,
                fontWeight: FontWeight.w900,
                color: QoffaColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              entry.productName,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: QoffaFontSize.bodySmall,
                color: QoffaColors.secondarySage,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontFamily: QoffaFontFamily.body,
                fontSize: QoffaFontSize.titleSmall,
                fontWeight: FontWeight.w700,
                color: QoffaColors.primaryNavy,
              ),
              cursorColor: QoffaColors.actionGreen,
              decoration: InputDecoration(
                labelText: l10n.observedPrice,
                prefixIcon: const Icon(
                  Icons.payments_rounded,
                  color: QoffaColors.actionGreen,
                ),
                suffixText: 'DA',
                suffixStyle: const TextStyle(
                  fontFamily: QoffaFontFamily.body,
                  fontSize: QoffaFontSize.bodySmall,
                  fontWeight: FontWeight.w700,
                  color: QoffaColors.primaryNavy,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: QoffaTactilePressable.outline(
                    height: 48,
                    label: l10n.cancel,
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QoffaTactilePressable.filled(
                    height: 48,
                    label: l10n.save,
                    icon: Icons.check_rounded,
                    onTap: () {
                      final val = int.tryParse(controller.text.trim());
                      if (val != null && val > 0) {
                        Navigator.pop(sheetContext, val);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (newPrice != null && mounted && newPrice != entry.item.observedPriceDzd) {
      try {
        await ref
            .read(laterBuyRepositoryProvider)
            .updateObservedPrice(entry.item.id, newPrice);
        if (mounted) {
          QoffaToast.show(
            message: l10n.observedPriceUpdated,
            type: QoffaNotificationType.approved,
            color: QoffaColors.actionGreen,
            icon: Icons.check_circle_rounded,
          );
        }
      } catch (e) {
        if (mounted) {
          QoffaToast.show(
            message: l10n.errorMessage(e),
            type: QoffaNotificationType.declined,
          );
        }
      }
    }
  }

  Widget _buildSortChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return QoffaFilterChip(
      label: label,
      isSelected: selected,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(laterBuyEntriesProvider(_activeTab));
    final pendingAsync = ref.watch(laterBuyPendingCountProvider);
    final pendingCount = pendingAsync.value ?? 0;
    final currentController =
        _scrollControllers[_activeTab] ?? _scrollControllers['active']!;

    return MintBackgroundScaffold(
      child: QoffaParticleOverlay(
        child: SafeArea(
          bottom: false,
          child: QoffaContentWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title placed & styled identically to Food Notebook, with Pending & Date badges
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: QoffaReveal(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.laterBuyTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.display,
                            fontFamilyFallback: QoffaFontFamily.fallback,
                            fontSize: 31,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Pending Count Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: QoffaColors.whiteSurface,
                          borderRadius: BorderRadius.circular(
                            QoffaTokens.radiusPill,
                          ),
                          border: Border.all(color: QoffaColors.softBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              color: QoffaColors.actionGreen,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            AnimatedSwitcher(
                              duration: QoffaTokens.motionMedium,
                              child: Text(
                                '$pendingCount ${l10n.pendingCount}',
                                key: ValueKey(pendingCount),
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.body,
                                  fontSize: QoffaFontSize.captionMedium,
                                  fontWeight: FontWeight.w800,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Date Badge (identical to AddPurchaseScreen)
                      QoffaTactilePressable(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(
                          QoffaTokens.radiusPill,
                        ),
                        backgroundColor:
                            QoffaColors.whiteSurface.withValues(alpha: 0.92),
                        borderColor: _filterByDate
                            ? QoffaColors.actionGreen
                            : QoffaColors.softBorder,
                        borderWidth: 1.2,
                        hoverBackgroundColor: QoffaColors.mintSurfaceTint,
                        hoverBorderColor: QoffaColors.actionGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
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
              ),

              // Status Tabs
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: _StatusTabs(
                  activeTab: _activeTab,
                  pendingCount: pendingCount,
                  onChanged: (status) {
                    setState(() {
                      _activeTab = status;
                      _expandedCardIds.clear();
                    });
                  },
                ),
              ),

              // Filter & Sort Row across Active, Bought, and Skipped tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    _buildSortChip(
                      label: l10n.sortDateNewest,
                      selected: _sortOption == LaterBuySortOption.newest,
                      onTap: () => setState(() => _sortOption = LaterBuySortOption.newest),
                    ),
                    const SizedBox(width: 8),
                    _buildSortChip(
                      label: l10n.sortDateOldest,
                      selected: _sortOption == LaterBuySortOption.oldest,
                      onTap: () => setState(() => _sortOption = LaterBuySortOption.oldest),
                    ),
                    const SizedBox(width: 8),
                    _buildSortChip(
                      label: l10n.sortPriceLowToHigh,
                      selected: _sortOption == LaterBuySortOption.priceLowToHigh,
                      onTap: () => setState(() => _sortOption = LaterBuySortOption.priceLowToHigh),
                    ),
                    const SizedBox(width: 8),
                    _buildSortChip(
                      label: l10n.sortPriceHighToLow,
                      selected: _sortOption == LaterBuySortOption.priceHighToLow,
                      onTap: () => setState(() => _sortOption = LaterBuySortOption.priceHighToLow),
                    ),
                  ],
                ),
              ),

              // Date Filter Active Indicator
              if (_filterByDate)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.filter_alt_outlined,
                        size: 16,
                        color: QoffaColors.actionGreen,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat.yMMMd(l10n.languageCode).format(_selectedDate),
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.body,
                          fontSize: QoffaFontSize.caption,
                          fontWeight: FontWeight.w700,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _filterByDate = false),
                        child: Text(
                          l10n.allDates,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.body,
                            fontSize: QoffaFontSize.caption,
                            fontWeight: FontWeight.w700,
                            color: QoffaColors.actionGreen,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 4),

              // List View
              Expanded(
                child: Builder(
                  builder: (context) {
                    final entries =
                        entriesAsync.valueOrNull ?? entriesAsync.asData?.value;
                    if (entries == null && entriesAsync.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (entries == null && entriesAsync.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: QoffaEmptyState(
                          icon: Icons.sync_problem_rounded,
                          title: l10n.errorTitle,
                          message: l10n.errorMessage(entriesAsync.error!),
                        ),
                      );
                    }
                    final currentEntries = entries ?? const <LaterBuyListEntry>[];

                    // Filter by selected calendar date if enabled
                    final filtered = _filterByDate
                        ? currentEntries.where((entry) {
                            final item = entry.item;
                            final DateTime itemDate;
                            if (_activeTab == 'bought') {
                              itemDate = (item.resolvedAt ?? item.updatedAt)
                                  .toLocal();
                            } else if (_activeTab == 'skipped') {
                              itemDate = item.updatedAt.toLocal();
                            } else {
                              itemDate = item.createdAt.toLocal();
                            }
                            return itemDate.year == _selectedDate.year &&
                                itemDate.month == _selectedDate.month &&
                                itemDate.day == _selectedDate.day;
                          }).toList()
                        : List<LaterBuyListEntry>.from(currentEntries);

                    // Sort according to selected sort option
                    final displayEntries = filtered..sort((a, b) {
                      switch (_sortOption) {
                        case LaterBuySortOption.newest:
                          final dateA = (a.item.resolvedAt ?? a.item.updatedAt);
                          final dateB = (b.item.resolvedAt ?? b.item.updatedAt);
                          return dateB.compareTo(dateA);
                        case LaterBuySortOption.oldest:
                          final dateA = (a.item.resolvedAt ?? a.item.updatedAt);
                          final dateB = (b.item.resolvedAt ?? b.item.updatedAt);
                          return dateA.compareTo(dateB);
                        case LaterBuySortOption.priceLowToHigh:
                          return a.item.observedPriceDzd.compareTo(b.item.observedPriceDzd);
                        case LaterBuySortOption.priceHighToLow:
                          return b.item.observedPriceDzd.compareTo(a.item.observedPriceDzd);
                      }
                    });

                    final isEmpty = displayEntries.isEmpty;

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                      child: isEmpty
                          ? Scrollbar(
                              key: ValueKey('empty-$_activeTab'),
                              controller: currentController,
                              interactive: true,
                              child: ListView(
                                key: ValueKey('empty-lv-$_activeTab'),
                                controller: currentController,
                                primary: false,
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                padding: const EdgeInsets.fromLTRB(20, 34, 20, 140),
                                children: [
                                  QoffaEmptyState(
                                    icon: _activeTab == 'active'
                                        ? Icons.savings_outlined
                                        : (_activeTab == 'bought'
                                            ? Icons.inventory_2_outlined
                                            : Icons.skip_next_outlined),
                                    title: _activeTab == 'active'
                                        ? l10n.noLaterBuyActive
                                        : l10n.noItemsInTab,
                                    message: _filterByDate
                                        ? (_activeTab == 'active'
                                            ? l10n.noLaterBuyActiveMessage
                                            : l10n.noItemsInTab)
                                        : (_activeTab == 'active'
                                            ? l10n.noLaterBuyActiveMessage
                                            : l10n.noItemsInTab),
                                    actionLabel: _filterByDate
                                        ? l10n.allDates
                                        : null,
                                    onAction: _filterByDate
                                        ? () => setState(() => _filterByDate = false)
                                        : null,
                                  ),
                                ],
                              ),
                            )
                          : Scrollbar(
                              key: ValueKey('list-$_activeTab'),
                              controller: currentController,
                              interactive: true,
                              child: ListView.builder(
                                key: ValueKey('list-lv-$_activeTab'),
                                controller: currentController,
                                primary: false,
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                                itemCount: displayEntries.length,
                                itemBuilder: (context, index) =>
                                    _SmartAnimatedPositionCard(
                                  key: ValueKey(
                                      'smart-pos-${displayEntries[index].item.id}'),
                                  index: index,
                                  filterKey: _filterSortKey,
                                  child: _LaterBuyCard(
                                    key: ValueKey(
                                        'card-${displayEntries[index].item.id}'),
                                    entry: displayEntries[index],
                                    isPricesExpanded: _expandedCardIds
                                        .contains(displayEntries[index].item.id),
                                    onTogglePrices: () {
                                      final id = displayEntries[index].item.id;
                                      setState(() {
                                        if (_expandedCardIds.contains(id)) {
                                          _expandedCardIds.remove(id);
                                        } else {
                                          _expandedCardIds.add(id);
                                        }
                                      });
                                    },
                                    onResolveBought: (ctrl) =>
                                        _resolveBought(displayEntries[index], ctrl),
                                    onSkip: (ctrl) =>
                                        _handleSkip(displayEntries[index], ctrl),
                                    onReactivate: (ctrl) =>
                                        _handleReactivate(displayEntries[index], ctrl),
                                    onDelete: (ctrl) =>
                                        _confirmDeleteItem(displayEntries[index], ctrl),
                                    onEditPrice: () =>
                                        _editActiveItemPrice(displayEntries[index]),
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

class _OutcomeDialog extends StatefulWidget {
  const _OutcomeDialog({
    required this.result,
    required this.l10n,
  });

  final WasItWorthWaitingResult result;
  final AppLocalizations l10n;

  @override
  State<_OutcomeDialog> createState() => _OutcomeDialogState();
}

class _OutcomeDialogState extends State<_OutcomeDialog> {
  final GlobalKey<QoffaParticleOverlayState> _particleKey =
      GlobalKey<QoffaParticleOverlayState>();
  final GlobalKey _dialogCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final renderBox =
          _dialogCardKey.currentContext?.findRenderObject() as RenderBox?;
      final screenSize = MediaQuery.sizeOf(context);
      final origin = renderBox != null
          ? renderBox.localToGlobal(
              Offset(renderBox.size.width * 0.5, renderBox.size.height * 0.28),
            )
          : Offset(screenSize.width * 0.5, screenSize.height * 0.38);

      _particleKey.currentState?.spawnBurst(
        globalOrigin: origin,
        config: ParticleEffectPresets.celebration,
        spawnWidth: (renderBox?.size.width ?? screenSize.width) * 0.80,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final saved = widget.result.absoluteDifferenceDzd.dinars >= 0;
    return QoffaParticleOverlay(
      key: _particleKey,
      child: Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            key: _dialogCardKey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
            ),
            icon: Icon(
              saved ? Icons.savings_outlined : Icons.trending_up_rounded,
              color: saved ? QoffaColors.actionGreen : QoffaColors.warningCoral,
              size: 34,
            ),
            title: Text(
              widget.l10n.wasItWorthWaiting,
              style: const TextStyle(
                fontFamily: QoffaFontFamily.display,
                fontFamilyFallback: QoffaFontFamily.fallback,
                fontSize: QoffaFontSize.headlineSmall,
                fontWeight: FontWeight.w900,
                color: QoffaColors.primaryNavy,
              ),
            ),
            content: _LaterBuyScreenState._buildOutcomeContent(
              widget.result,
              widget.l10n,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              QoffaTactilePressable.filled(
                height: 46,
                label: widget.l10n.confirm,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({
    required this.activeTab,
    required this.pendingCount,
    required this.onChanged,
  });

  final String activeTab;
  final int pendingCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabs = [
      ('active', '${l10n.tabActive} ($pendingCount)'),
      ('bought', l10n.tabBought),
      ('skipped', l10n.tabSkipped),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: QoffaColors.mintSurfaceTint,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
      ),
      child: Row(
        children: tabs.map((tab) {
          final selected = activeTab == tab.$1;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(tab.$1),
              borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
              child: AnimatedContainer(
                duration: QoffaTokens.motionMedium,
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? QoffaColors.actionGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    QoffaTokens.radiusControls,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tab.$2,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: QoffaFontFamily.body,
                      fontSize: QoffaFontSize.bodySmall,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : QoffaColors.primaryNavy,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LaterBuyCard extends StatefulWidget {
  const _LaterBuyCard({
    required this.entry,
    required this.onResolveBought,
    required this.onSkip,
    required this.onReactivate,
    required this.onDelete,
    this.onEditPrice,
    required this.isPricesExpanded,
    required this.onTogglePrices,
    super.key,
  });

  final LaterBuyListEntry entry;
  final void Function(QoffaCardActionController? controller) onResolveBought;
  final void Function(QoffaCardActionController? controller) onSkip;
  final void Function(QoffaCardActionController? controller) onReactivate;
  final void Function(QoffaCardActionController? controller) onDelete;
  final VoidCallback? onEditPrice;
  final bool isPricesExpanded;
  final VoidCallback onTogglePrices;

  @override
  State<_LaterBuyCard> createState() => _LaterBuyCardState();
}

class _LaterBuyCardState extends State<_LaterBuyCard>
    with SingleTickerProviderStateMixin {
  QoffaCardActionController? _animController;
  late final AnimationController _priceAnimController;
  late final Animation<double> _priceAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _priceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      value: widget.isPricesExpanded ? 1.0 : 0.0,
    );
    _priceAnimation = CurvedAnimation(
      parent: _priceAnimController,
      curve: Curves.easeInOutCubic,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _priceAnimController,
      curve: const Interval(0.1, 1.0, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_LaterBuyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPricesExpanded != oldWidget.isPricesExpanded) {
      if (widget.isPricesExpanded) {
        _priceAnimController.forward();
      } else {
        _priceAnimController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _priceAnimController.dispose();
    super.dispose();
  }

  Widget _buildProductPreview(String productName) {
    final lower = productName.toLowerCase();
    if (lower.contains('candia') ||
        lower.contains('milk') ||
        lower.contains('lait') ||
        productName.contains('حليب')) {
      return Image.asset(
        'assets/images/candia_milk.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.local_drink_rounded,
          color: Color(0xFF008744),
          size: 26,
        ),
      );
    }
    return const Icon(
      Icons.shopping_bag_outlined,
      color: QoffaColors.actionGreen,
      size: 26,
    );
  }

  Widget _buildPriceRow(
    int observedPriceDzd,
    int? targetPriceDzd,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: _PriceMetric(
            label: l10n.observedPrice,
            value: '$observedPriceDzd DA',
          ),
        ),
        if (targetPriceDzd != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: QoffaColors.mintSurfaceTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: QoffaColors.actionGreen.withValues(alpha: 0.35),
                ),
              ),
              child: _PriceMetric(
                label: l10n.targetPrice,
                value: '$targetPriceDzd DA',
                color: QoffaColors.actionGreen,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = widget.entry;
    final item = entry.item;
    final status = item.status;
    final dateLocale = l10n.languageCode;

    final String dateText;
    if (status == 'active') {
      final addedStr =
          '${l10n.addedOn}: ${DateFormat.yMMMd(dateLocale).format(item.createdAt.toLocal())}';
      final reminderStr = item.reminderAt != null
          ? ' · ${DateFormat.yMMMd(dateLocale).format(item.reminderAt!.toLocal())}'
          : '';
      dateText = '$addedStr$reminderStr';
    } else if (status == 'bought') {
      dateText =
          '${l10n.boughtOn}: ${DateFormat.yMMMd(dateLocale).format((item.resolvedAt ?? item.updatedAt).toLocal())}';
    } else {
      dateText =
          '${l10n.skippedOn}: ${DateFormat.yMMMd(dateLocale).format(item.updatedAt.toLocal())}';
    }

    return QoffaCardActionAnimator(
      controller: (ctrl) => _animController = ctrl,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: QoffaColors.softBorder,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Product preview, title, subtitle & status/actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F8F4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Center(child: _buildProductPreview(entry.productName)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.display,
                          fontFamilyFallback: QoffaFontFamily.fallback,
                          fontSize: QoffaFontSize.titleMedium,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          color: QoffaColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${item.observedQuantity} ${l10n.unitName(item.observedUnitId)}${entry.storeName == null ? '' : ' · ${entry.storeName}'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.body,
                          fontSize: QoffaFontSize.bodySmall,
                          fontWeight: FontWeight.w500,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dateText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: QoffaFontFamily.body,
                          fontSize: QoffaFontSize.caption,
                          fontWeight: FontWeight.w500,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Status badges & Remove / Edit action
                if (status == 'bought')
                  Semantics(
                    button: true,
                    label: widget.isPricesExpanded ? l10n.cancel : l10n.tabBought,
                    child: QoffaPressable(
                      onTap: widget.onTogglePrices,
                      padding: const EdgeInsets.all(6),
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedRotation(
                        turns: widget.isPricesExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOutCubic,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24,
                          color: QoffaColors.secondarySage,
                        ),
                      ),
                    ),
                  )
                else if (status == 'skipped')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: QoffaColors.softBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.redo_rounded,
                          size: 15,
                          color: QoffaColors.secondarySage,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.tabSkipped,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.body,
                            fontSize: QoffaFontSize.caption,
                            fontWeight: FontWeight.w800,
                            color: QoffaColors.secondarySage,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (status == 'active')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.onEditPrice != null) ...[
                        Semantics(
                          button: true,
                          label: l10n.editPrice,
                          child: QoffaPressable(
                            onTap: widget.onEditPrice!,
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: QoffaColors.secondarySage,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      // Remove Active picked item button
                      Semantics(
                        button: true,
                        label: l10n.deleteItemConfirmTitle,
                        child: QoffaPressable(
                          onTap: () => widget.onDelete(_animController),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: QoffaColors.secondarySage,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // Price row: Observed price and optional target price (collapsible for bought items)
            if (status == 'bought')
              AnimatedBuilder(
                animation: _priceAnimController,
                builder: (context, _) {
                  if (_priceAnimController.isDismissed) {
                    return const SizedBox.shrink();
                  }
                  return SizeTransition(
                    sizeFactor: _priceAnimation,
                    alignment: Alignment.topCenter,
                    axis: Axis.vertical,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 14),
                            _buildPriceRow(
                              item.observedPriceDzd,
                              item.targetPriceDzd,
                              l10n,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            else ...[
              const SizedBox(height: 14),
              _buildPriceRow(
                item.observedPriceDzd,
                item.targetPriceDzd,
                l10n,
              ),
            ],

            // Actions Row
            if (status == 'active') ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFEDF4EF)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: QoffaTactilePressable.outline(
                      height: 46,
                      label: l10n.skipAction,
                      icon: Icons.close_rounded,
                      onTap: () => widget.onSkip(_animController),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: QoffaTactilePressable.filled(
                      height: 46,
                      label: l10n.boughtAction,
                      icon: Icons.check_circle_outline_rounded,
                      onTap: () => widget.onResolveBought(_animController),
                    ),
                  ),
                ],
              ),
            ] else if (status == 'skipped') ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFEDF4EF)),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: QoffaTactilePressable.outline(
                  height: 44,
                  label: l10n.reactivateAction,
                  icon: Icons.replay_rounded,
                  onTap: () => widget.onReactivate(_animController),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PriceMetric extends StatelessWidget {
  const _PriceMetric({
    required this.label,
    required this.value,
    this.color = QoffaColors.primaryNavy,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: QoffaFontFamily.body,
          fontSize: QoffaFontSize.caption,
          fontWeight: FontWeight.w600,
          color: QoffaColors.secondarySage,
        ),
      ),
      const SizedBox(height: 3),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          style: TextStyle(
            fontFamily: QoffaFontFamily.display,
            fontFamilyFallback: QoffaFontFamily.fallback,
            fontSize: QoffaFontSize.titleMedium,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ),
    ],
  );
}

class _SmartAnimatedPositionCard extends StatefulWidget {
  const _SmartAnimatedPositionCard({
    required this.index,
    required this.filterKey,
    required this.child,
    super.key,
  });

  final int index;
  final Object filterKey;
  final Widget child;

  @override
  State<_SmartAnimatedPositionCard> createState() =>
      _SmartAnimatedPositionCardState();
}

class _SmartAnimatedPositionCardState extends State<_SmartAnimatedPositionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: 1.0,
    );
    _slideAnimation = const AlwaysStoppedAnimation<Offset>(Offset.zero);
    _fadeAnimation = const AlwaysStoppedAnimation<double>(1.0);
  }

  @override
  void didUpdateWidget(_SmartAnimatedPositionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only animate position changes when filter or sorting was actually changed,
    // avoiding re-animating/refreshing remaining cards when an item is moved/removed (by skip, bought, reactivate, or delete).
    if (oldWidget.filterKey != widget.filterKey &&
        oldWidget.index != widget.index) {
      final movedDown = widget.index > oldWidget.index;
      // Animate smoothly from the vertical column direction it moved from
      _slideAnimation = Tween<Offset>(
        begin: Offset(0, movedDown ? -0.22 : 0.22),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _fadeAnimation = Tween<double>(
        begin: 0.35,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}

