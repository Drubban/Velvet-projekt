import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/salon.dart';

class SalonService {
  static final SalonService _instance = SalonService._internal();
  factory SalonService() => _instance;
  SalonService._internal();

  static Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'salones.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE salones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sucursalId INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        capacidad INTEGER
      )
    ''');
  }

  // ===== Operaciones CRUD ===== //

  Future<int> createSalon(Salon salon) async {
    try {
      final db = await _db;
      return await db.insert(
        'salones',
        salon.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al crear salón: $e');
    }
  }

  Future<List<Salon>> getSalonesPorSucursal(int sucursalId) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'salones',
        where: 'sucursalId = ?',
        whereArgs: [sucursalId],
      );
      return List.generate(maps.length, (i) => Salon.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener salones por sucursal: $e');
    }
  }

  Future<Salon?> getSalonById(int id) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'salones',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return maps.isNotEmpty ? Salon.fromJson(maps.first) : null;
    } catch (e) {
      throw Exception('Error al obtener salón por ID: $e');
    }
  }

  Future<int> updateSalon(Salon salon) async {
    try {
      final db = await _db;
      return await db.update(
        'salones',
        salon.toJson(),
        where: 'id = ?',
        whereArgs: [salon.id],
      );
    } catch (e) {
      throw Exception('Error al actualizar salón: $e');
    }
  }

  Future<int> deleteSalon(int id) async {
    try {
      final db = await _db;
      return await db.delete(
        'salones',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al borrar salón: $e');
    }
  }

  Future<List<Salon>> searchSalones(String query) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'salones',
        where: 'nombre LIKE ?',
        whereArgs: ['%$query%'],
      );
      return List.generate(maps.length, (i) => Salon.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al buscar salones: $e');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}