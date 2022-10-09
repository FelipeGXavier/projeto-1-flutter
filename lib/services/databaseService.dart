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
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'data.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store breeds
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE measure(id INTEGER PRIMARY KEY, height INTEGER, age INTEGER, gender INTEGER, weight REAL, imc REAL, date TEXT)',
    );
  }

  // Define a function that inserts breeds into the database
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
    for (var element in maps) {
      print("Debug $element");
    }
    return List.generate(
        maps.length, (index) => MeasureData.fromMap(maps[index]));
  }
}
