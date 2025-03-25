import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';

final gradeNotifierProvider =
    StateNotifierProvider<GradeNotifier, List<EntityGrade>>((ref) {
  final repository = ref.watch(gradeRepositoryProvider);
  return GradeNotifier(repository);
});

class GradeNotifier extends StateNotifier<List<EntityGrade>> {
  final GradeRepository _repository;

  GradeNotifier(this._repository) : super([]);

  Future<void> loadTasks() async {
    final tasks = await _repository.getGrade();
    state = tasks;
  }

  Future<void> addTask(EntityGrade grade) async {
    await _repository.addGrade(grade);
    state = [...state, grade];
  }

  Future<void> updateTask(EntityGrade grade) async {
    await _repository.updateGrade(grade);
    state = state.map((t) => t.id == grade.id ? grade : t).toList();
  }

  Future<void> removeTask(EntityGrade grade) async {
    await _repository.removeGrade(grade);
    state = state.where((t) => t.id != grade.id).toList();
  }
}
