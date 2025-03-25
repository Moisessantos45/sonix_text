import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError('Proveedor de base de datos no inicializado');
});

final gradeRepositoryProvider = Provider<GradeRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return GradeRepository(database);
});

class GradeRepository {
  final Database database;

  GradeRepository(this.database);

  Future<List<EntityGrade>> getGrade() async {
    final data = await database.rawQuery("SELECT * FROM grade");
    return data.map(EntityGrade.fromMap).toList();
  }

  Future<void> addGrade(EntityGrade gradeTask) async {
    await database.insert("gradeTask", gradeTask.toMap());
  }

  Future<void> updateGrade(EntityGrade gradeTask) async {
    await database.update("grade", gradeTask.toMapUpdate(),
        where: "id = ?", whereArgs: [gradeTask.id]);
  }

  Future<void> removeGrade(EntityGrade gradeTask) async {
    await database.delete("grade", where: "id = ?", whereArgs: [gradeTask.id]);
  }
}
