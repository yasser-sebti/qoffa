import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

abstract class NotebookRepository {
  Stream<List<Note>> watchAllNotes();
  Stream<List<Note>> watchNotesForDate(String localDate);
  Future<List<Note>> getNotesForProduct(String productId);
  Future<Note> createNote({
    required String title,
    required String body,
    String noteType = 'food_diary',
    required DateTime eventAt,
    List<String> linkedProductIds = const [],
    List<String> linkedPurchaseIds = const [],
  });
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}

class DriftNotebookRepository implements NotebookRepository {
  DriftNotebookRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Stream<List<Note>> watchAllNotes() {
    return (_db.select(_db.notes)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.eventAt)]))
        .watch();
  }

  @override
  Stream<List<Note>> watchNotesForDate(String localDate) {
    return (_db.select(_db.notes)
          ..where((t) => t.localDate.equals(localDate) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.eventAt)]))
        .watch();
  }

  @override
  Future<List<Note>> getNotesForProduct(String productId) async {
    final links = await (_db.select(_db.noteProductLinks)
          ..where((t) => t.productId.equals(productId)))
        .get();
    if (links.isEmpty) return [];

    final noteIds = links.map((l) => l.noteId).toList();
    return (_db.select(_db.notes)
          ..where((t) => t.id.isIn(noteIds) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.eventAt)]))
        .get();
  }

  @override
  Future<Note> createNote({
    required String title,
    required String body,
    String noteType = 'food_diary',
    required DateTime eventAt,
    List<String> linkedProductIds = const [],
    List<String> linkedPurchaseIds = const [],
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final localDate = '${eventAt.year.toString().padLeft(4, '0')}-${eventAt.month.toString().padLeft(2, '0')}-${eventAt.day.toString().padLeft(2, '0')}';

    final companion = NotesCompanion.insert(
      id: id,
      title: title,
      body: body,
      noteType: Value(noteType),
      eventAt: eventAt,
      localDate: localDate,
      createdAt: now,
      updatedAt: now,
    );

    await _db.transaction(() async {
      await _db.into(_db.notes).insert(companion);

      for (final pId in linkedProductIds) {
        await _db.into(_db.noteProductLinks).insert(
              NoteProductLinksCompanion.insert(noteId: id, productId: pId),
            );
      }

      for (final purchId in linkedPurchaseIds) {
        await _db.into(_db.notePurchaseLinks).insert(
              NotePurchaseLinksCompanion.insert(noteId: id, purchaseId: purchId),
            );
      }
    });

    return (await (_db.select(_db.notes)..where((t) => t.id.equals(id))).getSingle());
  }

  @override
  Future<void> updateNote(Note note) async {
    await (_db.update(_db.notes)..where((t) => t.id.equals(note.id))).write(
      note.copyWith(updatedAt: DateTime.now().toUtc()),
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    await (_db.update(_db.notes)..where((t) => t.id.equals(id))).write(
      NotesCompanion(deletedAt: Value(DateTime.now().toUtc())),
    );
  }
}

final notebookRepositoryProvider = Provider<NotebookRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftNotebookRepository(db);
});
