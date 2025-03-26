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
  List<EntityGrade> _allGrades = [];
  String _currentFilter = 'All';

  GradeNotifier(this._repository) : super([]);

  Future<void> loadGrades() async {
    _allGrades = await _repository.getGrade();
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
    await _repository.add(grade);
    _allGrades = [..._allGrades, grade];
    _applyFilter();
  }

  Future<void> updateGrade(EntityGrade grade) async {
    await _repository.update(grade);
    _allGrades = _allGrades.map((t) => t.id == grade.id ? grade : t).toList();
    _applyFilter();
  }

  Future<void> removeGrade(EntityGrade grade) async {
    await _repository.remove(grade);
    _allGrades = _allGrades.where((t) => t.id != grade.id).toList();
    _applyFilter();
  }
}
