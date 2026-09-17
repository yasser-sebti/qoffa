import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../data/notebook_repository.dart';

class NotebookScreen extends ConsumerStatefulWidget {
  const NotebookScreen({super.key});

  @override
  ConsumerState<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends ConsumerState<NotebookScreen> {
  String _selectedFilter = 'all';

  void _showNewNoteDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    var noteType = 'food_diary';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
              ),
              title: const Text(
                'New Food Note',
                style: TextStyle(
                  fontFamily: 'Hero Sandwich Pro',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: noteType,
                      decoration: const InputDecoration(
                        labelText: 'Note Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'food_diary', child: Text('Food Diary')),
                        DropdownMenuItem(value: 'shopping_note', child: Text('Shopping Note')),
                        DropdownMenuItem(value: 'price_observation', child: Text('Price Observation')),
                        DropdownMenuItem(value: 'product_review', child: Text('Product Review')),
                        DropdownMenuItem(value: 'meal_idea', child: Text('Meal Idea')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => noteType = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Body / Observations',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                QoffaButton(
                  label: 'Save Note',
                  width: 140,
                  height: 48,
                  onTap: () async {
                    if (titleController.text.trim().isEmpty) return;
                    final repo = ref.read(notebookRepositoryProvider);
                    await repo.createNote(
                      title: titleController.text.trim(),
                      body: bodyController.text.trim(),
                      noteType: noteType,
                      eventAt: DateTime.now(),
                    );
                    if (context.mounted) Navigator.pop(context);
                    QoffaToast.show(
                      title: 'Note saved',
                      message: titleController.text.trim(),
                      icon: Icons.note_alt_outlined,
                      color: QoffaColors.noteYellow,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(notebookRepositoryProvider);
    final notesAsync = ref.watch(StreamProvider((ref) => repo.watchAllNotes()));

    return MintBackgroundScaffold(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.notebookTitle,
                    style: const TextStyle(
                      fontFamily: 'Hero Sandwich Pro',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: QoffaColors.actionGreen, size: 32),
                    onPressed: _showNewNoteDialog,
                  ),
                ],
              ),
            ),

            // Note Type Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  _filterChip('all', 'All Notes'),
                  const SizedBox(width: 8),
                  _filterChip('food_diary', 'Food Diary'),
                  const SizedBox(width: 8),
                  _filterChip('shopping_note', 'Shopping Notes'),
                  const SizedBox(width: 8),
                  _filterChip('price_observation', 'Price Observations'),
                  const SizedBox(width: 8),
                  _filterChip('meal_idea', 'Meal Ideas'),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Notes List
            Expanded(
              child: notesAsync.when(
                data: (notes) {
                  final filtered = _selectedFilter == 'all'
                      ? notes
                      : notes.where((n) => n.noteType == _selectedFilter).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.note_alt_outlined, size: 64, color: QoffaColors.secondarySage),
                          const SizedBox(height: 14),
                          const Text(
                            'No notes yet. Tap + to record a note.',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 15,
                              color: QoffaColors.secondarySage,
                            ),
                          ),
                          const SizedBox(height: 16),
                          QoffaButton(
                            label: l10n.newNote,
                            icon: Icons.add,
                            width: 180,
                            onTap: _showNewNoteDialog,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final n = filtered[index];
                      final dateStr = DateFormat.yMMMd().format(n.eventAt);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: QoffaColors.whiteSurface,
                          borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
                          border: Border.all(color: QoffaColors.softBorder, width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    n.title,
                                    style: const TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: QoffaColors.primaryNavy,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: QoffaColors.mintSurfaceTint,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    n.noteType.replaceAll('_', ' '),
                                    style: const TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: QoffaColors.actionGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              n.body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 14,
                                color: QoffaColors.secondarySage,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontFamily: 'Hero Sandwich Pro',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: QoffaColors.secondarySage,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? QoffaColors.actionGreen : QoffaColors.whiteSurface,
          borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
          border: Border.all(
            color: isSelected ? QoffaColors.actionGreen : QoffaColors.softBorder,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? QoffaColors.whiteSurface : QoffaColors.primaryNavy,
          ),
        ),
      ),
    );
  }
}
