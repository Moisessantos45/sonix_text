import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/domains/entity_card.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/domains/entity_stats.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';
import 'package:sonix_text/presentation/riverpod/repository_level.dart';
import 'package:sonix_text/presentation/utils/data_card.dart';
import 'package:sonix_text/presentation/utils/parse_date.dart';
import 'package:uuid/uuid.dart';

final allGradesProvider =
    StateNotifierProvider<AllGradesNotifier, List<EntityGrade>>((ref) {
  final repository = ref.watch(dbRepositoryProvider);
  return AllGradesNotifier(repository);
});

class AllGradesNotifier extends StateNotifier<List<EntityGrade>> {
  final DbRepository _repository;
  final String _table = 'grade';

  AllGradesNotifier(this._repository) : super([]);

  Future<void> loadGrades() async {
    final rows = await _repository.getAll(_table);

    final listGrade = rows.map((json) => EntityGrade.fromMap(json)).toList();
    state = List.from(listGrade);
  }

  Future<void> addGrade(String title, String content, String dueDate,
      String status, String priority, String category, int color) async {
    final uuid = Uuid();
    final grade = EntityGrade(
      id: uuid.v4(),
      title: title,
      content: content,
      dueDate: dueDate,
      status: status,
      date: formatDateTimeToString(DateTime.now()),
      priority: priority,
      category: category,
      point: 1,
      color: color,
    );
    await _repository.add(_table, grade.toMap());
    state = [...state, grade];
  }

  Future<void> updateGrade(
      String id,
      String title,
      String content,
      String dueDate,
      String status,
      String priority,
      String category,
      int color,
      int point) async {
    final grade = EntityGrade(
      id: id,
      title: title,
      content: content,
      dueDate: dueDate,
      status: status,
      date: formatDateTimeToString(DateTime.now()),
      priority: priority,
      category: category,
      point: point,
      color: color,
    );
    await _repository.update(_table, grade.id, grade.toMap());
    state = state.map((t) => t.id == grade.id ? grade : t).toList();
  }

  Future<void> updateGradeStatus(String id, String status) async {
    final response = await _repository.executeQuery(
      'SELECT * FROM $_table WHERE id = ?',
      [id],
    );
    if (response.isEmpty) return;
    final updatedGrade =
        EntityGrade.fromMap(response.first).copyWith(status: status);
    await _repository.update(_table, updatedGrade.id, updatedGrade.toMap());
    state =
        state.map((t) => t.id == updatedGrade.id ? updatedGrade : t).toList();
  }

  Future<void> removeGrade(EntityGrade grade) async {
    await _repository.remove(_table, grade.id);
    state = state.where((t) => t.id != grade.id).toList();
  }

  Future<void> deleteTable() async {
    await _repository.executeQuery("DROP TABLE IF EXISTS $_table");
  }
}

final gradeNotifierProvider =
    StateNotifierProvider<GradeNotifier, List<EntityGrade>>((ref) {
  final allGrades = ref.watch(allGradesProvider);

  return GradeNotifier(allGrades);
});

class GradeNotifier extends StateNotifier<List<EntityGrade>> {
  final List<EntityGrade> _allGrades;
  String _currentFilter = 'All';

  GradeNotifier(this._allGrades) : super([]) {
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
}

final gradeFilterDateNotifierProvider =
    StateNotifierProvider<GradeFilterDateNotifier, List<EntityGrade>>((ref) {
  final repository = ref.watch(dbRepositoryProvider);
  return GradeFilterDateNotifier(repository);
});

class GradeFilterDateNotifier extends StateNotifier<List<EntityGrade>> {
  final DbRepository _repository;
  final String _table = 'grade';
  String _currentDate = '';

  GradeFilterDateNotifier(this._repository) : super([]) {
    _applyFilter();
  }

  void setDate(DateTime date) {
    _currentDate = "${date.day}/${date.month}/${date.year}";
    _applyFilter();
  }

  Future<void> _applyFilter() async {
    if (_currentDate.isEmpty) {
      _currentDate =
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    }
    final rows = await _repository.executeQuery(
      'SELECT * FROM $_table WHERE due_date = ?',
      [_currentDate],
    );

    final listGrade = rows.map((json) => EntityGrade.fromMap(json)).toList();
    state = [...listGrade];
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

final gradesProvider = Provider<List<EntityGrade>>((ref) {
  final grades = ref.watch(gradeNotifierProvider);
  return grades.isEmpty ? [] : grades;
});

final gradesFilterDateProvider = Provider<List<EntityGrade>>((ref) {
  final grades = ref.watch(gradeFilterDateNotifierProvider);
  return grades.isEmpty ? [] : grades;
});

final listCardsProvider = Provider<List<EntityCard>>((ref) {
  final stats = ref.watch(statsProvider);

  final updatedCards = List<EntityCard>.from(listCard)
    ..[0] = listCard[0].copyWith(title: stats.totalGrades.toString())
    ..[1] = listCard[1].copyWith(title: stats.completedGrades.toString())
    ..[2] = listCard[2].copyWith(title: stats.score.toString())
    ..[3] = listCard[3].copyWith(title: stats.remainingPoints.toString());

  return updatedCards;
});

class StatsNotifier extends StateNotifier<EntityStats> {
  final DbRepository _repository;
  final String _table = 'grade';
  int pointsLevel = 1;

  StatsNotifier(this._repository, this.pointsLevel)
      : super(EntityStats(
            totalGrades: 0, completedGrades: 0, score: 0, remainingPoints: 0));

  Future<void> getStats() async {
    final total = await _repository.getCount(_table);
    final completed =
        await _repository.getCountWhere(_table, 'status = ?', ['Completed']);
    final score = await _repository
        .getSumWhere(_table, 'point', 'status = ?', ['Completed']);

    state = EntityStats(
      totalGrades: total,
      completedGrades: completed,
      score: score,
      remainingPoints: pointsLevel - score,
    );
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, EntityStats>((ref) {
  final repository = ref.watch(dbRepositoryProvider);
  final pointsLevel = ref.watch(pointsLevelProvider);
  return StatsNotifier(repository, pointsLevel);
});
