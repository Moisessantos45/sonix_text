import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/riverpod.dart';

final loadDataProvider =
    StateNotifierProvider<LoadDataNotifier, List<dynamic>>((ref) {
  final level = ref.watch(levelNotifierProvider.notifier);
  final users = ref.watch(userNotifierProvider.notifier);
  final grades = ref.watch(allGradesProvider.notifier);
  final categories = ref.watch(categoryNotifierProvider.notifier);
  final stats = ref.watch(statsProvider.notifier);
  return LoadDataNotifier(level, users, grades, categories, stats);
});

class LoadDataNotifier extends StateNotifier<List<dynamic>> {
  final LevelNotifier _levelNotifier;
  final UserNotifier _userNotifier;
  final AllGradesNotifier _gradeNotifier;
  final CategoryNotifier _categoryNotifier;
  final StatsNotifier _statsNotifier;

  LoadDataNotifier(this._levelNotifier, this._userNotifier, this._gradeNotifier,
      this._categoryNotifier, this._statsNotifier)
      : super([]);

  Future<void> loadData() async {
    try {
      await Future.wait([
        _levelNotifier.getLevels(),
        _userNotifier.getUsers(),
        _gradeNotifier.loadGrades(),
        _categoryNotifier.getCategories(),
      ]);
      await _statsNotifier.getStats();
      state = [];
    } catch (e) {
      print('Error loading data: $e');
      state = [];
    }
  }
}
