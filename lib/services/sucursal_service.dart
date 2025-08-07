import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/sucursal.dart';

class SucursalService {
  static final SucursalService _instance = SucursalService._internal();
  factory SucursalService() => _instance;
  SucursalService._internal();

  static Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'sucursales.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sucursales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        direccion TEXT,
        telefono TEXT
      )
    ''');
  }

  // ===== Operaciones CRUD ===== //

  Future<int> createSucursal(Sucursal sucursal) async {
    try {
      final db = await _db;
      return await db.insert(
        'sucursales',
        sucursal.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al crear sucursal: $e');
    }
  }

  Future<List<Sucursal>> getSucursales() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query('sucursales');
      return List.generate(maps.length, (i) => Sucursal.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener sucursales: $e');
    }
  }

  Future<Sucursal?> getSucursalById(int id) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'sucursales',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return maps.isNotEmpty ? Sucursal.fromJson(maps.first) : null;
    } catch (e) {
      throw Exception('Error al obtener sucursal por ID: $e');
    }
  }

  Future<int> updateSucursal(Sucursal sucursal) async {
    try {
      final db = await _db;
      return await db.update(
        'sucursales',
        sucursal.toJson(),
        where: 'id = ?',
        whereArgs: [sucursal.id],
      );
    } catch (e) {
      throw Exception('Error al actualizar sucursal: $e');
    }
  }

  Future<int> deleteSucursal(int id) async {
    try {
      final db = await _db;
      return await db.delete(
        'sucursales',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al borrar sucursal: $e');
    }
  }

  Future<List<Sucursal>> searchSucursales(String query) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'sucursales',
        where: 'nombre LIKE ? OR direccion LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return List.generate(maps.length, (i) => Sucursal.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al buscar sucursales: $e');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}