import 'package:path/path.dart';
import 'package:projeto_1/widgets/historicMeasure.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
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

    final path = join(databasePath, 'teste.db');

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE measure(id INTEGER PRIMARY KEY, height INTEGER, age INTEGER, gender INTEGER, weight REAL, imc REAL, date TEXT)',
    );
  }

  // Define a funtion that inserts breeds into the database
  Future<void> inserMeasure(MeasureData data) async {
    final db = await _databaseService.database;
    await db.insert(
      'measure',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MeasureData>> measures() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('measure');
    return List.generate(
        maps.length, (index) => MeasureData.fromMap(maps[index]));
  }
}
