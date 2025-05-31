import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/riverpod.dart';

final loadDataProvider =
    StateNotifierProvider<LoadDataNotifier, List<dynamic>>((ref) {
  final level = ref.watch(levelNotifierProvider.notifier);
  final users = ref.watch(userNotifierProvider.notifier);
  final grades = ref.watch(allGradesProvider.notifier);
  final categories = ref.watch(categoryNotifierProvider.notifier);

  return LoadDataNotifier(level, users, grades, categories);
});

class LoadDataNotifier extends StateNotifier<List<dynamic>> {
  final LevelNotifier _levelNotifier;
  final UserNotifier _userNotifier;
  final AllGradesNotifier _gradeNotifier;
  final CategoryNotifier _categoryNotifier;

  LoadDataNotifier(this._levelNotifier, this._userNotifier, this._gradeNotifier,
      this._categoryNotifier)
      : super([]);

  Future<void> loadData() async {
    try {
      await Future.wait([
        _levelNotifier.getLevels(),
        _userNotifier.getUsers(),
        _gradeNotifier.loadGrades(),
        _categoryNotifier.getCategories(),
      ]);
      state = [];
    } catch (e) {
      state = [];
    }
  }
}
