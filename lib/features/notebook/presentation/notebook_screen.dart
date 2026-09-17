import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_confirm_dialog.dart';
import '../../../core/widgets/qoffa_dropdown.dart';
import '../../../core/widgets/qoffa_layout.dart';
import '../../../core/widgets/qoffa_motion.dart';
import '../../../core/widgets/qoffa_tactile_pressable.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../data/notebook_repository.dart';

class NotebookScreen extends ConsumerStatefulWidget {
  const NotebookScreen({super.key});

  @override
  ConsumerState<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends ConsumerState<NotebookScreen> {
  String _selectedFilter = 'all';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showNewNoteSheet() async {
    final l10n = AppLocalizations.of(context);
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    var noteType = 'food_diary';

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
              maxHeight: MediaQuery.sizeOf(context).height * 0.9,
            ),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
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
                      l10n.newNote,
                      style: const TextStyle(
                        fontFamily: 'Hero Sandwich Pro',
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: QoffaColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: l10n.noteTitlePlaceholder,
                        prefixIcon: const Icon(Icons.title_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    QoffaDropdown<String>(
                      value: noteType,
                      label: l10n.noteType,
                      prefixIcon: Icons.category_outlined,
                      items:
                          const [
                                'food_diary',
                                'shopping_note',
                                'price_observation',
                                'product_review',
                                'meal_idea',
                              ]
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(l10n.noteTypeLabel(type)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setSheetState(() => noteType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      minLines: 5,
                      maxLines: 9,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: l10n.noteBodyPlaceholder,
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: QoffaTactilePressable.outline(
                            label: l10n.cancel,
                            height: 52,
                            onTap: () => Navigator.pop(sheetContext),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: QoffaTactilePressable.filled(
                            label: l10n.saveNote,
                            icon: Icons.check_rounded,
                            height: 52,
                            onTap: () async {
                              final title = titleController.text.trim();
                              if (title.isEmpty) {
                                return;
                              }
                              await ref
                                  .read(notebookRepositoryProvider)
                                  .createNote(
                                    title: title,
                                    body: bodyController.text.trim(),
                                    noteType: noteType,
                                    eventAt: DateTime.now(),
                                  );
                              if (sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              }
                              QoffaToast.show(
                                title: l10n.noteSaved,
                                message: title,
                                icon: Icons.note_alt_outlined,
                                color: QoffaColors.noteYellowDeep,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    titleController.dispose();
    bodyController.dispose();
  }

  Future<void> _showEditNoteSheet(Note note) async {
    final l10n = AppLocalizations.of(context);
    final titleController = TextEditingController(text: note.title);
    final bodyController = TextEditingController(text: note.body);
    var noteType = note.noteType;

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
              maxHeight: MediaQuery.sizeOf(context).height * 0.9,
            ),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.editNote,
                                style: const TextStyle(
                                  fontFamily: 'Hero Sandwich Pro',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${l10n.lastEdited}: ${DateFormat.yMMMd(l10n.languageCode).add_jm().format(note.updatedAt.toLocal())}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: QoffaColors.secondarySage,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: QoffaColors.warningCoral,
                          ),
                          tooltip: l10n.deleteNote,
                          onPressed: () async {
                            final deleted = await _confirmDeleteNote(note);
                            if (deleted && sheetContext.mounted) {
                              Navigator.pop(sheetContext);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: titleController,
                      autofocus: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: l10n.noteTitlePlaceholder,
                        prefixIcon: const Icon(Icons.title_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    QoffaDropdown<String>(
                      value: noteType,
                      label: l10n.noteType,
                      prefixIcon: Icons.category_outlined,
                      items:
                          const [
                                'food_diary',
                                'shopping_note',
                                'price_observation',
                                'product_review',
                                'meal_idea',
                              ]
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(l10n.noteTypeLabel(type)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setSheetState(() => noteType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      minLines: 5,
                      maxLines: 9,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: l10n.noteBodyPlaceholder,
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: QoffaTactilePressable.outline(
                            label: l10n.cancel,
                            height: 52,
                            onTap: () => Navigator.pop(sheetContext),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: QoffaTactilePressable.filled(
                            label: l10n.save,
                            icon: Icons.check_rounded,
                            height: 52,
                            onTap: () async {
                              final title = titleController.text.trim();
                              if (title.isEmpty) return;
                              await ref
                                  .read(notebookRepositoryProvider)
                                  .updateNote(
                                    note.copyWith(
                                      title: title,
                                      body: bodyController.text.trim(),
                                      noteType: noteType,
                                    ),
                                  );
                              if (sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              }
                              QoffaToast.show(
                                title: l10n.noteUpdated,
                                message: title,
                                icon: Icons.check_circle_outline_rounded,
                                color: QoffaColors.actionGreen,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    titleController.dispose();
    bodyController.dispose();
  }

  Future<bool> _confirmDeleteNote(Note note) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await QoffaConfirmDialog.show(
      context: context,
      title: l10n.deleteNoteConfirmTitle,
      message: l10n.deleteNoteConfirmMessage,
      confirmLabel: l10n.deleteNote,
      cancelLabel: l10n.cancel,
      icon: Icons.delete_outline_rounded,
    );

    if (confirmed == true) {
      await ref.read(notebookRepositoryProvider).deleteNote(note.id);
      QoffaToast.show(
        title: l10n.noteDeleted,
        message: note.title,
        icon: Icons.delete_outline_rounded,
        color: QoffaColors.warningCoral,
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notesAsync = ref.watch(allNotesProvider);

    return MintBackgroundScaffold(
      child: SafeArea(
        bottom: false,
        child: QoffaContentWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: QoffaReveal(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.notebookTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Hero Sandwich Pro',
                            fontSize: 31,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Semantics(
                        button: true,
                        label: l10n.newNote,
                        child: QoffaTactilePressable.filled(
                          width: 48,
                          height: 48,
                          borderRadius: BorderRadius.circular(16),
                          onTap: _showNewNoteSheet,
                          child: const Icon(
                            Icons.add_rounded,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.noteBodyPlaceholder,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () => setState(_searchController.clear),
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    _filterChip('all', l10n.allNotes),
                    const SizedBox(width: 8),
                    _filterChip('food_diary', l10n.noteTypeLabel('food_diary')),
                    const SizedBox(width: 8),
                    _filterChip(
                      'shopping_note',
                      l10n.noteTypeLabel('shopping_note'),
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      'price_observation',
                      l10n.noteTypeLabel('price_observation'),
                    ),
                    const SizedBox(width: 8),
                    _filterChip('meal_idea', l10n.noteTypeLabel('meal_idea')),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: notesAsync.when(
                  data: (notes) {
                    final query = _searchController.text.trim().toLowerCase();
                    final filtered = notes.where((note) {
                      final typeMatches =
                          _selectedFilter == 'all' ||
                          note.noteType == _selectedFilter;
                      final searchMatches =
                          query.isEmpty ||
                          note.title.toLowerCase().contains(query) ||
                          note.body.toLowerCase().contains(query);
                      return typeMatches && searchMatches;
                    }).toList();

                    if (filtered.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
                        children: [
                          QoffaEmptyState(
                            icon: Icons.menu_book_rounded,
                            title: l10n.noNotesTitle,
                            message: l10n.noNotesMessage,
                            actionLabel: l10n.newNote,
                            onAction: _showNewNoteSheet,
                          ),
                        ],
                      );
                    }
                    return ListView.builder(
                      key: const PageStorageKey('notebook-list'),
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => QoffaReveal(
                        delay: QoffaTokens.stagger * index.clamp(0, 5),
                        child: _NoteCard(
                          note: filtered[index],
                          onTap: () => _showEditNoteSheet(filtered[index]),
                          onDelete: () => _confirmDeleteNote(filtered[index]),
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: QoffaEmptyState(
                      icon: Icons.sync_problem_rounded,
                      title: l10n.errorTitle,
                      message: l10n.errorMessage(error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String filterKey, String label) {
    final selected = _selectedFilter == filterKey;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = filterKey),
        borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
        child: AnimatedContainer(
          duration: QoffaTokens.motionMedium,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? QoffaColors.actionGreen
                : QoffaColors.whiteSurface,
            borderRadius: BorderRadius.circular(QoffaTokens.radiusPill),
            border: Border.all(
              color: selected
                  ? QoffaColors.actionGreen
                  : QoffaColors.softBorder,
              width: 1.4,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : QoffaColors.primaryNavy,
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdited = note.updatedAt.difference(note.createdAt).inSeconds > 2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
          child: QoffaCard(
            radius: QoffaTokens.radiusCompact,
            padding: const EdgeInsets.all(17),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: QoffaColors.noteYellow.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.sticky_note_2_outlined,
                    color: QoffaColors.noteYellowDeep,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                height: 1.25,
                                fontWeight: FontWeight.w800,
                                color: QoffaColors.primaryNavy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: onDelete,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 20,
                                color: QoffaColors.secondarySage
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (note.body.toString().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          note.body,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            height: 1.4,
                            color: QoffaColors.secondarySage,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _NoteMeta(
                            text: l10n.noteTypeLabel(note.noteType),
                            color: QoffaColors.actionGreen,
                          ),
                          _NoteMeta(
                            text: DateFormat.yMMMd(
                              l10n.languageCode,
                            ).format(note.eventAt),
                            color: QoffaColors.secondarySage,
                          ),
                          if (isEdited)
                            _NoteMeta(
                              text:
                                  '${l10n.lastEdited}: ${DateFormat.yMMMd(l10n.languageCode).add_jm().format(note.updatedAt.toLocal())}',
                              color: QoffaColors.skyBlue,
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
      ),
    );
  }
}

class _NoteMeta extends StatelessWidget {
  const _NoteMeta({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    ),
  );
}
