import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../data/shopping_list_repository.dart';

class ShoppingListsScreen extends ConsumerStatefulWidget {
  const ShoppingListsScreen({super.key});

  @override
  ConsumerState<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends ConsumerState<ShoppingListsScreen> {
  final _addItemController = TextEditingController();

  @override
  void dispose() {
    _addItemController.dispose();
    super.dispose();
  }

  void _showNewListDialog(BuildContext context, ShoppingListRepository repo) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor)),
        title: const Text('قائمة تسوق جديدة', style: TextStyle(fontFamily: 'Hero Sandwich Pro', fontWeight: FontWeight.w800)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'اسم القائمة...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: QoffaColors.brandGreen),
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                await repo.createList(title: title);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('إنشاء', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(shoppingListRepositoryProvider);
    final listsAsync = ref.watch(StreamProvider((ref) => repo.watchActiveLists()));

    return MintBackgroundScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: QoffaColors.primaryNavy),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.shoppingListsTitle,
                      style: const TextStyle(
                        fontFamily: 'Hero Sandwich Pro',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.playlist_add_rounded, color: QoffaColors.actionGreen, size: 28),
                    onPressed: () => _showNewListDialog(context, repo),
                  ),
                ],
              ),
            ),

            Expanded(
              child: listsAsync.when(
                data: (lists) {
                  if (lists.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.list_alt_rounded, size: 64, color: QoffaColors.secondarySage),
                          const SizedBox(height: 12),
                          const Text(
                            'لا توجد أي قوائم تسوق حالياً',
                            style: TextStyle(fontFamily: 'Alexandria', fontSize: 16, fontWeight: FontWeight.bold, color: QoffaColors.primaryNavy),
                          ),
                          const SizedBox(height: 16),
                          QoffaButton(
                            label: 'إنشاء أول قائمة',
                            onTap: () async {
                              await repo.getOrCreateDefaultList();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  final currentList = lists.first;
                  return _ShoppingListContentView(list: currentList, repo: repo);
                },
                loading: () => const Center(child: CircularProgressIndicator(color: QoffaColors.brandGreen)),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingListContentView extends ConsumerStatefulWidget {
  const _ShoppingListContentView({required this.list, required this.repo});
  final ShoppingList list;
  final ShoppingListRepository repo;

  @override
  ConsumerState<_ShoppingListContentView> createState() => _ShoppingListContentViewState();
}

class _ShoppingListContentViewState extends ConsumerState<_ShoppingListContentView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addItem() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    await widget.repo.addItem(
      listId: widget.list.id,
      customName: text,
      quantity: 1.0,
      unitId: 'piece',
    );
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(StreamProvider((ref) => widget.repo.watchListItems(widget.list.id)));

    return Column(
      children: [
        // List Title & Quick Add row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                    border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                  ),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'أضف منتجاً للقائمة (مثلاً: حليب، بيض)...',
                      hintStyle: TextStyle(fontFamily: 'Alexandria', fontSize: 13, color: QoffaColors.secondarySage),
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
                    color: QoffaColors.brandGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: itemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'قائمتك فارغة الآن. أضف ما تحتاجه للرحلة القادمة!',
                    style: TextStyle(fontFamily: 'Alexandria', fontSize: 13, color: QoffaColors.primaryNavy.withValues(alpha: 0.6)),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, idx) {
                  final item = items[idx];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                      border: Border.all(
                        color: item.isCompleted ? QoffaColors.softBorder.withValues(alpha: 0.5) : QoffaColors.softBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: item.isCompleted,
                          activeColor: QoffaColors.brandGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          onChanged: (val) {
                            if (val != null) {
                              widget.repo.toggleItemCompleted(item.id, val);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.customName,
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 15,
                              fontWeight: item.isCompleted ? FontWeight.w500 : FontWeight.w700,
                              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                              color: item.isCompleted ? QoffaColors.secondarySage : QoffaColors.primaryNavy,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: QoffaColors.secondarySage, size: 20),
                          onPressed: () => widget.repo.deleteItem(item.id),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: QoffaColors.brandGreen)),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
