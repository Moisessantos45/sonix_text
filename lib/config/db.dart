import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

Future<Database> initializeDatabase() async {
  try {
    var databasesPath = await getDatabasesPath();
    String directory = p.join(databasesPath, 'demo.db');
    Database database = await openDatabase(directory, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE grade (id TEXT PRIMARY KEY, title TEXT NOT NULL, content TEXT,date TEXT,due_date TEXT,status TEXT,priority TEXT,category TEXT,color TEXT,point INTEGER)');
    });

    return database;
  } catch (e) {
    throw Exception(e);
  }
}
