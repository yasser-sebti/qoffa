import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/qoffa_colors.dart';
import '../../../../app/theme/qoffa_tokens.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/particles_and_effects/particle_effect_presets.dart';
import '../../../../core/particles_and_effects/qoffa_particle_overlay.dart';
import '../../../../core/widgets/qoffa_layout.dart';
import '../../../../core/widgets/qoffa_pressable.dart';
import '../../data/shopping_list_repository.dart';

class DepartmentShoppingListView extends ConsumerStatefulWidget {
  const DepartmentShoppingListView({
    required this.list,
    required this.repo,
    super.key,
  });

  final ShoppingList list;
  final ShoppingListRepository repo;

  @override
  ConsumerState<DepartmentShoppingListView> createState() =>
      _DepartmentShoppingListViewState();
}

class _DepartmentShoppingListViewState
    extends ConsumerState<DepartmentShoppingListView> {
  final _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _addItem() async {
    final text = _addController.text.trim();
    if (text.isEmpty) return;
    await widget.repo.addItem(
      listId: widget.list.id,
      customName: text,
      quantity: 1.0,
      unitId: 'piece',
    );
    _addController.clear();
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return QoffaColors.actionGreen;
    }
  }

  IconData _resolveIcon(String iconKey) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(departmentShoppingItemsProvider(widget.list.id));

    return itemsAsync.when(
      data: (items) {
        // Calculate estimated total basket cost & completion counts
        int totalBasketDzd = 0;
        int completedCount = 0;
        for (final i in items) {
          totalBasketDzd += i.estimatedTotalDzd;
          if (i.item.isCompleted) completedCount++;
        }

        // Group items by category / department
        final grouped = <String, List<DepartmentShoppingItem>>{};
        for (final i in items) {
          grouped.putIfAbsent(i.categoryName, () => []).add(i);
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // Estimated Basket Total Hero Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0AA343),
                        Color(0xFF087D34),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: QoffaColors.brandGreen.withValues(alpha: 0.25),
                        offset: const Offset(0, 6),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_checkout_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.estimatedBasketTotal,
                                  style: TextStyle(
                                    fontFamily: QoffaFontFamily.body,
                                    fontSize: QoffaFontSize.caption,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$totalBasketDzd دج',
                                  style: const TextStyle(
                                    fontFamily: QoffaFontFamily.display,
                                    fontFamilyFallback: QoffaFontFamily.fallback,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (items.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                l10n.itemsPurchasedCount(
                                  completedCount,
                                  items.length,
                                ),
                                style: const TextStyle(
                                  fontFamily: QoffaFontFamily.body,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Add Input Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: QoffaColors.softBorder,
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: _addController,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.body,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: QoffaColors.primaryNavy,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.addListItemHint,
                            hintStyle: const TextStyle(
                              fontFamily: QoffaFontFamily.body,
                              fontSize: 13.5,
                              color: QoffaColors.secondarySage,
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _addItem(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: _addItem,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: QoffaColors.actionGreen,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: QoffaColors.actionGreen.withValues(alpha: 0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Empty state if no items
            if (items.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: QoffaEmptyState(
                    icon: Icons.checklist_rounded,
                    title: l10n.emptyShoppingList,
                    message: l10n.noShoppingListsMessage,
                  ),
                ),
              )
            else
              // Grouped by Universal Department
              for (final entry in grouped.entries) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _parseColor(
                              entry.value.first.categoryColorHex,
                            ).withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _resolveIcon(entry.value.first.categoryIconKey),
                            size: 15,
                            color: _parseColor(
                              entry.value.first.categoryColorHex,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontFamily: QoffaFontFamily.display,
                            fontFamilyFallback: QoffaFontFamily.fallback,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${entry.value.length}',
                            style: const TextStyle(
                              fontFamily: QoffaFontFamily.body,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: QoffaColors.primaryNavy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: QoffaColors.softBorder,
                          width: 1.2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          for (int i = 0; i < entry.value.length; i++) ...[
                            if (i > 0)
                              const Divider(
                                height: 1,
                                color: Color(0xFFEDF4EF),
                                indent: 14,
                                endIndent: 14,
                              ),
                            _ShoppingItemRow(
                              deptItem: entry.value[i],
                              onToggle: (val) => widget.repo.toggleItemCompleted(
                                entry.value[i].item.id,
                                val,
                              ),
                              onUpdateQty: (qty) => widget.repo.updateItemQuantity(
                                entry.value[i].item.id,
                                qty,
                              ),
                              onDelete: () {
                                final screenSize = MediaQuery.sizeOf(context);
                                QoffaParticleOverlay.spawn(
                                  context,
                                  globalOrigin: Offset(screenSize.width * 0.5, screenSize.height * 0.45),
                                  config: ParticleEffectPresets.deletion,
                                  spawnWidth: screenSize.width * 0.65,
                                );
                                widget.repo.deleteItem(
                                  entry.value[i].item.id,
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            const SliverToBoxAdapter(child: SizedBox(height: 60)),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: QoffaColors.actionGreen),
      ),
      error: (e, _) => Center(child: Text(l10n.errorMessage(e))),
    );
  }
}

class _ShoppingItemRow extends StatelessWidget {
  const _ShoppingItemRow({
    required this.deptItem,
    required this.onToggle,
    required this.onUpdateQty,
    required this.onDelete,
  });

  final DepartmentShoppingItem deptItem;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onUpdateQty;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final item = deptItem.item;
    final isDone = item.isCompleted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Checkbox
          InkWell(
            onTap: () => onToggle(!isDone),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDone ? QoffaColors.actionGreen : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDone ? QoffaColors.actionGreen : QoffaColors.softBorder,
                  width: 1.5,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Name & Unit Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.customName,
                  style: TextStyle(
                    fontFamily: QoffaFontFamily.body,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone
                        ? QoffaColors.secondarySage.withValues(alpha: 0.6)
                        : QoffaColors.primaryNavy,
                  ),
                ),
                if (deptItem.unitPriceDzd > 0)
                  Text(
                    '${deptItem.unitPriceDzd} دج للواحدة',
                    style: const TextStyle(
                      fontFamily: QoffaFontFamily.body,
                      fontSize: 11.5,
                      color: QoffaColors.secondarySage,
                    ),
                  ),
              ],
            ),
          ),

          // Stepper & Cost
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quantity stepper
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        if (item.quantity > 1) {
                          onUpdateQty(item.quantity - 1);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.remove_rounded, size: 16),
                      ),
                    ),
                    Text(
                      '${item.quantity.toInt()}',
                      style: const TextStyle(
                        fontFamily: QoffaFontFamily.body,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    InkWell(
                      onTap: () => onUpdateQty(item.quantity + 1),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.add_rounded, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Estimated item total
              if (deptItem.estimatedTotalDzd > 0)
                Text(
                  '${deptItem.estimatedTotalDzd} دج',
                  style: TextStyle(
                    fontFamily: QoffaFontFamily.display,
                    fontFamilyFallback: QoffaFontFamily.fallback,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDone
                        ? QoffaColors.secondarySage.withValues(alpha: 0.6)
                        : QoffaColors.actionGreen,
                  ),
                ),

              const SizedBox(width: 6),
              QoffaPressable(
                onTap: onDelete,
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: QoffaColors.secondarySage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
