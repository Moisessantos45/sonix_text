import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/infrastructure/user_model.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, List<UserModel>>((ref) {
  final repository = ref.watch(dbRepositoryProvider);
  return UserNotifier(repository);
});

class UserNotifier extends StateNotifier<List<UserModel>> {
  final DbRepository _dbRepository;
  final String _table = 'user';

  UserNotifier(this._dbRepository) : super([]);

  Future<void> getUsers() async {
    final users = await _dbRepository.getAll(_table);
    state = users.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<void> addUser(UserModel user) async {
    await _dbRepository.add(_table, user.toMap());
    state = [...state, user];
  }

  Future<void> updateUser(UserModel user) async {
    await _dbRepository.update(_table, user.id, user.toDocument());
    state = state.map((e) => e.id == user.id ? user : e).toList();
  }

  Future<void> deleteUser(String id) async {
    await _dbRepository.remove(_table, id);
    state = state.where((e) => e.id != id).toList();
  }
}

final userProvider = Provider<List<UserModel>>((ref) {
  final user = ref.watch(userNotifierProvider);
  return user.isNotEmpty ? user : [];
});

final leveUserProvider = Provider<int>((ref) {
  final user = ref.watch(userNotifierProvider);
  return user.isNotEmpty ? user.first.level : 1;
});
