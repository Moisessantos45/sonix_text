import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/infrastructure/level_model.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';

final levelNotifierProvider =
    StateNotifierProvider<LevelNotifier, List<LevelModel>>((ref) {
  final repository = ref.watch(dbRepositoryProvider);
  return LevelNotifier(repository);
});

class LevelNotifier extends StateNotifier<List<LevelModel>> {
  final DbRepository _dbRepository;
  final String _table = 'level';

  LevelNotifier(this._dbRepository) : super([]);

  Future<void> getLevels() async {
    final levels = await _dbRepository.getAll(_table);
    state = levels.map((e) => LevelModel.fromMap(e)).toList();
  }

  Future<void> addLevel(LevelModel level) async {
    await _dbRepository.add(_table, level.toMap());
    state = [...state, level];
  }

  Future<void> updateLevel(LevelModel level) async {
    await _dbRepository.update(_table, level.id, level.toMapClaimed());
    state = state.map((e) => e.id == level.id ? level : e).toList();
  }

  Future<void> deleteLevel(String id) async {
    await _dbRepository.remove(_table, id);
    state = state.where((e) => e.id != id).toList();
  }
}

final levelProvider = Provider<List<LevelModel>>((ref) {
  final levels = ref.watch(levelNotifierProvider);
  return levels.isEmpty ? [] : levels;
});

final currentLevelProvider = Provider<LevelModel?>((ref) {
  final levels = ref.watch(levelNotifierProvider);
  try {
    return levels.firstWhere((element) => !element.isClaimed);
  } catch (e) {
    return null;
  }
});

final currentLevelNumberProvider = Provider<int>((ref) {
  final level = ref.watch(currentLevelProvider);
  return level?.level ?? 1;
});

final nextLevelProvider = Provider<LevelModel?>((ref) {
  final levels = ref.watch(levelNotifierProvider);
  final currentLevel = ref.watch(currentLevelNumberProvider);
  try {
    return levels.where((element) => !element.isClaimed).firstWhere(
          (element) => element.level == currentLevel + 1,
        );
  } catch (e) {
    return null;
  }
});

final pointsLevelProvider = Provider<int>((ref) {
  final level = ref.watch(currentLevelProvider);
  return level?.point ?? 1;
});

final multiplyLevelProvider = Provider<int>((ref) {
  final level = ref.watch(currentLevelProvider);
  return level?.multiplier ?? 1;
});
