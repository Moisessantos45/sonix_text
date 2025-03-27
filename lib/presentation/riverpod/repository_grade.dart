import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/domains/entity_card.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';
import 'package:sonix_text/presentation/riverpod/repository_level.dart';
import 'package:sonix_text/presentation/utils/data_card.dart';

final gradeNotifierProvider =
    StateNotifierProvider<GradeNotifier, List<EntityGrade>>((ref) {
  final repository = ref.watch(dbRepositoryProvider);

  return GradeNotifier(repository);
});

class GradeNotifier extends StateNotifier<List<EntityGrade>> {
  final DbRepository _repository;
  List<EntityGrade> _allGrades = [];
  String _currentFilter = 'All';
  final String _table = 'grade';

  GradeNotifier(this._repository) : super([]);

  Future<void> loadGrades() async {
    final rows = await _repository.getAll(_table);
    final listGrade = rows.map((json) => EntityGrade.fromMap(json)).toList();
    _allGrades = [...listGrade];
    _applyFilter();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    _applyFilter();
  }

  void _applyFilter() {
    switch (_currentFilter) {
      case 'Pending':
        state = _allGrades.where((grade) => grade.status == 'Pending').toList();
        break;
      case 'In Progress':
        state =
            _allGrades.where((grade) => grade.status == 'In Progress').toList();
        break;
      case 'Completed':
        state =
            _allGrades.where((grade) => grade.status == 'Completed').toList();
        break;
      default: // 'All'
        state = List.from(_allGrades);
    }
  }

  Future<void> addGrade(EntityGrade grade) async {
    await _repository.add(_table, grade.toMap());
    _allGrades = [..._allGrades, grade];
    _applyFilter();
  }

  Future<void> updateGrade(EntityGrade grade) async {
    await _repository.update(_table, grade.id, grade.toMap());
    _allGrades = _allGrades.map((t) => t.id == grade.id ? grade : t).toList();
    _applyFilter();
  }

  Future<void> removeGrade(EntityGrade grade) async {
    await _repository.remove(_table, grade.id);
    _allGrades = _allGrades.where((t) => t.id != grade.id).toList();
    _applyFilter();
  }
}

final gradesProvider = Provider<List<EntityGrade>>((ref) {
  final grades = ref.watch(gradeNotifierProvider);
  return grades.isEmpty ? [] : grades;
});

final totalGradesProvider = Provider<int>((ref) {
  final grades = ref.watch(gradeNotifierProvider);
  return grades.length;
});

final scoreProvider = Provider<int>((ref) {
  final grades = ref.watch(gradeNotifierProvider);
  return grades
      .where((grade) => grade.status == 'Completed')
      .fold(0, (sum, grade) => sum + grade.point);
});

final completedGradesProvider = Provider<int>((ref) {
  final grades = ref.watch(gradeNotifierProvider);
  return grades.where((grade) => grade.status == 'Completed').length;
});

final listCardsProvider = Provider<List<EntityCard>>((ref) {
  final score = ref.watch(scoreProvider);
  final points = ref.watch(pointsLevelProvider);
  final completed = ref.watch(completedGradesProvider);
  final total = ref.watch(totalGradesProvider);

  final updatedCards = List<EntityCard>.from(listCard)
    ..[0] = listCard[0].copyWith(title: total.toString())
    ..[1] = listCard[1].copyWith(title: completed.toString())
    ..[2] = listCard[2].copyWith(title: score.toString())
    ..[3] = listCard[3].copyWith(title: (points - score).toString());

  return updatedCards;
});
