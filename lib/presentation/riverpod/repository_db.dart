import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError('Proveedor de base de datos no inicializado');
});

final dbRepositoryProvider = Provider<DbRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return DbRepository(database);
});

class DbRepository {
  final Database database;

  DbRepository(this.database);

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final data = await database.rawQuery("SELECT * FROM $table");
    return data;
  }

  Future<void> add(String table, Map<String, dynamic> data) async {
    await database.insert(table, data);
  }

  Future<void> update(
      String table, String id, Map<String, dynamic> data) async {
    await database.update(table, data, where: "id = ?", whereArgs: [id]);
  }

  Future<void> remove(String table, String id) async {
    await database.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
