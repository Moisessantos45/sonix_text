import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/infrastructure/category_model.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, List<CategoryModel>>((ref) {
  final respository = ref.watch(dbRepositoryProvider);

  return CategoryNotifier(respository);
});

class CategoryNotifier extends StateNotifier<List<CategoryModel>> {
  final DbRepository _dbRepository;
  final String _table = 'category';

  CategoryNotifier(this._dbRepository) : super([]);

  Future<void> getCategories() async {
    final categories = await _dbRepository.getAll(_table);
    state = [
      ...categories.where((e) => e["id"] != null).map(CategoryModel.fromMap)
    ];
  }

  Future<void> addCategory(CategoryModel category) async {
    await _dbRepository.add(_table, category.toMap());
    state = [...state, category];
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _dbRepository.update(_table, category.id, category.toDocument());
    state = state.map((e) => e.id == category.id ? category : e).toList();
  }

  Future<void> deleteCategory(String id) async {
    await _dbRepository.remove(_table, id);
    state = state.where((e) => e.id != id).toList();
  }
}
