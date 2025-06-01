import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

Future<Database> initializeDatabase() async {
  try {
    var databasesPath = await getDatabasesPath();
    String directory = p.join(databasesPath, 'demo.db');
    Database database = await openDatabase(
      directory,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS category (id TEXT PRIMARY KEY, name TEXT NOT NULL)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS user (id TEXT PRIMARY KEY, name TEXT NOT NULL, nickname TEXT NOT NULL, level INTEGER NOT NULL,hora INTEGER DEFAULT 0,minuto INTEGER DEFAULT 0,active_notifications TEXT DEFAULT "false",avatar TEXT DEFAULT "92574792835600d793")');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS grade (id TEXT PRIMARY KEY, title TEXT NOT NULL, content TEXT, date TEXT, due_date TEXT, status TEXT, priority TEXT, category TEXT, color TEXT, point INTEGER)');

        await db.execute(
            "CREATE TABLE IF NOT EXISTS note_links (id INTEGER PRIMARY KEY AUTOINCREMENT, from_id TEXT NOT NULL, to_id TEXT NOT NULL,created_at TEXT NOT NULL, FOREIGN KEY(from_id) REFERENCES grade(id) ON DELETE CASCADE,FOREIGN KEY(to_id) REFERENCES grade(id) ON DELETE CASCADE);");

        await db.execute(
            'CREATE TABLE IF NOT EXISTS level (id TEXT PRIMARY KEY, title TEXT NOT NULL, level INTEGER NOT NULL,point INTEGER NOT NULL, multiplier INTEGER NOT NULL, message TEXT NOT NULL, isClaimed TEXT NOT NULL)');
      },
      onOpen: (Database db) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS category (id TEXT PRIMARY KEY, name TEXT NOT NULL)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS user (id TEXT PRIMARY KEY, name TEXT NOT NULL, nickname TEXT NOT NULL, level INTEGER NOT NULL,hora INTEGER DEFAULT 0,minuto INTEGER DEFAULT 0,active_notifications TEXT DEFAULT "false",avatar TEXT DEFAULT "92574792835600d793")');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS grade (id TEXT PRIMARY KEY, title TEXT NOT NULL, content TEXT, date TEXT, due_date TEXT, status TEXT, priority TEXT, category TEXT, color TEXT, point INTEGER)');

        await db.execute(
            "CREATE TABLE IF NOT EXISTS note_links (id INTEGER PRIMARY KEY AUTOINCREMENT, from_id TEXT NOT NULL, to_id TEXT NOT NULL,created_at TEXT NOT NULL, FOREIGN KEY(from_id) REFERENCES grade(id) ON DELETE CASCADE,FOREIGN KEY(to_id) REFERENCES grade(id) ON DELETE CASCADE);");

        await db.execute(
            'CREATE TABLE IF NOT EXISTS level (id TEXT PRIMARY KEY, title TEXT NOT NULL, level INTEGER NOT NULL,point INTEGER NOT NULL, multiplier INTEGER NOT NULL, message TEXT NOT NULL, isClaimed TEXT NOT NULL)');
      },
    );

    return database;
  } catch (e) {
    throw Exception(e);
  }
}
