import 'package:path/path.dart';
import 'package:projeto_1/widgets/historicMeasure.dart';
import 'package:projeto_1/widgets/tasks.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'app.db');

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE measure(id INTEGER PRIMARY KEY, height INTEGER, age INTEGER, gender INTEGER, weight REAL, imc REAL, date TEXT);',
    );
    await db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT);',
    );
  }

  Future<void> insertMeasure(MeasureData data) async {
    final db = await _databaseService.database;
    await db.insert(
      'measure',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTask(Task data) async {
    final db = await _databaseService.database;
    await db.insert(
      'tasks',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await _databaseService.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<MeasureData>> measures() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('measure');
    return List.generate(
        maps.length, (index) => MeasureData.fromMap(maps[index]));
  }

  Future<List<Task>> tasks() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }
}
