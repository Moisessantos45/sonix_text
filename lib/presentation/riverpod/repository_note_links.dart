import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/infrastructure/note_links_model.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';

final noteLinksNotifierProvider =
    StateNotifierProvider<NoteLinksNotifier, List<NoteLinksModel>>(
  (ref) {
    final repository = ref.watch(dbRepositoryProvider);
    return NoteLinksNotifier(repository);
  },
);

class NoteLinksNotifier extends StateNotifier<List<NoteLinksModel>> {
  final DbRepository _dbRepository;
  final String _table = 'note_links';

  NoteLinksNotifier(this._dbRepository) : super([]);

  Future<void> getNoteLinks() async {
    final noteLinks = await _dbRepository.getAll(_table);
    state = [
      ...noteLinks.where((e) => e["id"] != null).map(NoteLinksModel.fromJson)
    ];
  }

  Future<void> addNoteLink(NoteLinksModel noteLink) async {
    await _dbRepository.add(_table, noteLink.toMap());
    state = [...state, noteLink];
  }

  Future<void> updateNoteLink(NoteLinksModel noteLink) async {
    await _dbRepository.update(_table, noteLink.id, noteLink.toMapUpdate());
    state = state.map((e) => e.id == noteLink.id ? noteLink : e).toList();
  }

  Future<void> deleteNoteLink(int id) async {
    await _dbRepository.remove(_table, id);
    state = state.where((e) => e.id != id).toList();
  }
}
