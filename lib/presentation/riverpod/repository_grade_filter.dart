import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';

final relatedGradesProvider =
    StateNotifierProvider<RelatedGradesNotifier, List<EntityGrade>>(
  (ref) {
    final db = ref.watch(dbRepositoryProvider);
    return RelatedGradesNotifier(db);
  },
);

class RelatedGradesNotifier extends StateNotifier<List<EntityGrade>> {
  final DbRepository _repository;
  String noteId = '';

  RelatedGradesNotifier(this._repository) : super([]) {
    loadRelatedNotes();
  }

  void setNoteId(String id) {
    if (id.isEmpty) {
      noteId = '';
      state = [];
    } else if (noteId != id) {
      noteId = id;
      loadRelatedNotes();
    }
  }

  Future<void> loadRelatedNotes() async {
    // 1. Obtener relaciones (note_links)
    final result = await _repository.executeQuery(
      'SELECT from_id, to_id FROM note_links WHERE from_id = ? OR to_id = ?',
      [noteId, noteId],
    );

    final relatedIds = result
        .map<String>((e) {
          if (e['from_id'] == noteId) return e['to_id'] as String;
          return e['from_id'] as String;
        })
        .toSet()
        .toList(); // evitar duplicados

    if (relatedIds.isEmpty) {
      state = [];
      return;
    }

    final placeholders = List.filled(relatedIds.length, '?').join(', ');
    final relatedNotes = await _repository.executeQuery(
      'SELECT * FROM grade WHERE id IN ($placeholders)',
      relatedIds,
    );

    final grades = relatedNotes
        .map<EntityGrade>((noteMap) => EntityGrade.fromMap(noteMap))
        .toList();

    state = grades;
  }
}

final unrelatedGradesProvider =
    StateNotifierProvider<UnrelatedGradesNotifier, List<EntityGrade>>((ref) {
  final repository = ref.watch(dbRepositoryProvider);
  return UnrelatedGradesNotifier(repository);
});

class UnrelatedGradesNotifier extends StateNotifier<List<EntityGrade>> {
  final DbRepository _repository;
  String noteId = '';

  UnrelatedGradesNotifier(this._repository) : super([]) {
    loadUnrelatedNotes();
  }

  void setNoteId(String id) {
    if (id.isEmpty) {
      state = [];
    } else {
      noteId = id;
      loadUnrelatedNotes();
    }
  }

  Future<void> loadUnrelatedNotes({
    int limit = 15,
    int offset = 0,
  }) async {
    final links = await _repository.executeQuery(
      'SELECT from_id, to_id FROM note_links WHERE from_id = ? OR to_id = ?',
      [noteId, noteId],
    );

    final relatedIds = links
        .map<String>((e) => e['from_id'] == noteId
            ? e['to_id'] as String
            : e['from_id'] as String)
        .toSet()
        .toList();

    relatedIds.add(noteId);

    final allGrades = await _repository.executeQuery(
      'SELECT * FROM grade WHERE id NOT IN (${List.filled(relatedIds.length, '?').join(', ')}) LIMIT ? OFFSET ?',
      [...relatedIds, limit, offset],
    );

    if (offset == 0) {
      state = allGrades
          .map<EntityGrade>((noteMap) => EntityGrade.fromMap(noteMap))
          .toList();
    } else {
      state = [
        ...state,
        ...allGrades
            .map<EntityGrade>((noteMap) => EntityGrade.fromMap(noteMap))
            .toList(),
      ];
    }
  }
}
