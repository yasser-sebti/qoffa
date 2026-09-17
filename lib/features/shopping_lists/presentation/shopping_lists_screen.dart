import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_layout.dart';
import '../../../core/widgets/qoffa_motion.dart';
import '../../../core/widgets/qoffa_dropdown.dart';
import '../data/shopping_list_repository.dart';

class ShoppingListsScreen extends ConsumerStatefulWidget {
  const ShoppingListsScreen({super.key});

  @override
  ConsumerState<ShoppingListsScreen> createState() =>
      _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends ConsumerState<ShoppingListsScreen> {
  final _addItemController = TextEditingController();
  String? _selectedListId;

  @override
  void dispose() {
    _addItemController.dispose();
    super.dispose();
  }

  void _showNewListDialog(BuildContext context, ShoppingListRepository repo) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        ),
        title: Text(
          l10n.newList,
          style: const TextStyle(
            fontFamily: 'Hero Sandwich Pro',
            fontWeight: FontWeight.w800,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.listName),
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
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                await repo.createList(title: title);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: Text(
              l10n.create,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(shoppingListRepositoryProvider);
    final listsAsync = ref.watch(activeShoppingListsProvider);

    return MintBackgroundScaffold(
      child: SafeArea(
        child: QoffaContentWidth(
          child: Column(
            children: [
              // Top Bar
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
                      icon: const Icon(
                        Icons.playlist_add_rounded,
                        color: QoffaColors.actionGreen,
                        size: 28,
                      ),
                      onPressed: () => _showNewListDialog(context, repo),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: listsAsync.when(
                  data: (lists) {
                    if (lists.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                        children: [
                          QoffaReveal(
                            child: QoffaEmptyState(
                              icon: Icons.list_alt_rounded,
                              title: l10n.noShoppingLists,
                              message: l10n.noShoppingListsMessage,
                              actionLabel: l10n.createFirstList,
                              onAction: () => repo.getOrCreateDefaultList(
                                title: l10n.defaultShoppingList,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    final currentList = lists.firstWhere(
                      (list) => list.id == _selectedListId,
                      orElse: () => lists.first,
                    );
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 6, 20, 4),
                          child: QoffaDropdown<String>(
                            value: currentList.id,
                            prefixIcon: Icons.list_alt_rounded,
                            items: lists
                                .map(
                                  (list) => DropdownMenuItem(
                                    value: list.id,
                                    child: Text(
                                      list.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (listId) {
                              if (listId != null) {
                                setState(() => _selectedListId = listId);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: _ShoppingListContentView(
                            key: ValueKey(currentList.id),
                            list: currentList,
                            repo: repo,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: QoffaColors.brandGreen,
                    ),
                  ),
                  error: (e, _) => Center(child: Text(l10n.errorMessage(e))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShoppingListContentView extends ConsumerStatefulWidget {
  const _ShoppingListContentView({
    required this.list,
    required this.repo,
    super.key,
  });
  final ShoppingList list;
  final ShoppingListRepository repo;

  @override
  ConsumerState<_ShoppingListContentView> createState() =>
      _ShoppingListContentViewState();
}

class _ShoppingListContentViewState
    extends ConsumerState<_ShoppingListContentView> {
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
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(shoppingListItemsProvider(widget.list.id));

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
                    borderRadius: BorderRadius.circular(
                      QoffaTokens.radiusControls,
                    ),
                    border: Border.all(
                      color: QoffaColors.softBorder,
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: l10n.addListItemHint,
                      hintStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
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
                    color: QoffaColors.brandGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
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
                    l10n.emptyShoppingList,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: QoffaColors.primaryNavy.withValues(alpha: 0.6),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, idx) {
                  final item = items[idx];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        QoffaTokens.radiusControls,
                      ),
                      border: Border.all(
                        color: item.isCompleted
                            ? QoffaColors.softBorder.withValues(alpha: 0.5)
                            : QoffaColors.softBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: item.isCompleted,
                          activeColor: QoffaColors.brandGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
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
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: item.isCompleted
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isCompleted
                                  ? QoffaColors.secondarySage
                                  : QoffaColors.primaryNavy,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: QoffaColors.secondarySage,
                            size: 20,
                          ),
                          onPressed: () => widget.repo.deleteItem(item.id),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: QoffaColors.brandGreen),
            ),
            error: (e, _) => Center(child: Text(l10n.errorMessage(e))),
          ),
        ),
      ],
    );
  }
}
