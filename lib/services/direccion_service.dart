import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/direccion.dart'; // Asegúrate de que la ruta sea correcta

class DireccionService {
  static final DireccionService _instance = DireccionService._internal();
  factory DireccionService() => _instance;
  DireccionService._internal();

  static Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'direcciones.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE direcciones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        calle TEXT NOT NULL,
        numeroExterior TEXT NOT NULL,
        numeroInterior TEXT,
        colonia TEXT NOT NULL,
        municipio TEXT NOT NULL,
        estado TEXT NOT NULL,
        codigoPostal TEXT NOT NULL,
        pais TEXT DEFAULT 'México',
        referencias TEXT
      )
    ''');
  }

  // ===== Operaciones CRUD ===== //

  Future<int> createDireccion(Direccion direccion) async {
    final db = await _db;
    return await db.insert(
      'direcciones',
      direccion.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Direccion>> getAllDirecciones() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('direcciones');
    return List.generate(maps.length, (i) => Direccion.fromJson(maps[i]));
  }

  Future<Direccion?> getDireccionById(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'direcciones',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return maps.isNotEmpty ? Direccion.fromJson(maps.first) : null;
  }

  Future<int> updateDireccion(Direccion direccion) async {
    final db = await _db;
    return await db.update(
      'direcciones',
      direccion.toJson(),
      where: 'id = ?',
      whereArgs: [direccion.id],
    );
  }

  Future<int> deleteDireccion(int id) async {
    final db = await _db;
    return await db.delete(
      'direcciones',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Direccion>> searchDirecciones(String query) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'direcciones',
      where: '''
        calle LIKE ? OR 
        numeroExterior LIKE ? OR
        colonia LIKE ? OR 
        municipio LIKE ? OR 
        estado LIKE ? OR 
        codigoPostal LIKE ? OR
        pais LIKE ?
      ''',
      whereArgs: List.filled(7, '%$query%'),
    );
    return List.generate(maps.length, (i) => Direccion.fromJson(maps[i]));
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}