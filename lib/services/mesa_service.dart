import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mesa.dart';

class MesaService {
  static final MesaService _instance = MesaService._internal();
  factory MesaService() => _instance;
  MesaService._internal();

  static Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'mesas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mesas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        salonId INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        capacidad INTEGER
      )
    ''');
  }

  // ===== Operaciones CRUD ===== //

  Future<int> createMesa(Mesa mesa) async {
    try {
      final db = await _db;
      return await db.insert(
        'mesas',
        mesa.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al crear mesa: $e');
    }
  }

  Future<List<Mesa>> createMesas(List<Mesa> mesas) async {
    try {
      final db = await _db;
      List<Mesa> result = [];
      for (var mesa in mesas) {
        await db.insert(
          'mesas',
          mesa.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        result.add(mesa);
      }
      return result;
    } catch (e) {
      throw Exception('Error al crear mesas: $e');
    }
  }

  Future<List<Mesa>> getMesasPorSalon(int salonId) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'mesas',
        where: 'salonId = ?',
        whereArgs: [salonId],
      );
      return List.generate(maps.length, (i) => Mesa.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener mesas por salón: $e');
    }
  }

  Future<Mesa?> getMesaById(int id) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'mesas',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return maps.isNotEmpty ? Mesa.fromJson(maps.first) : null;
    } catch (e) {
      throw Exception('Error al obtener mesa por ID: $e');
    }
  }

  Future<int> updateMesa(Mesa mesa) async {
    try {
      final db = await _db;
      return await db.update(
        'mesas',
        mesa.toJson(),
        where: 'id = ?',
        whereArgs: [mesa.id],
      );
    } catch (e) {
      throw Exception('Error al actualizar mesa: $e');
    }
  }

  Future<int> deleteMesa(int id) async {
    try {
      final db = await _db;
      return await db.delete(
        'mesas',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al borrar mesa: $e');
    }
  }

  Future<List<Mesa>> searchMesas(String query) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'mesas',
        where: 'nombre LIKE ?',
        whereArgs: ['%$query%'],
      );
      return List.generate(maps.length, (i) => Mesa.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al buscar mesas: $e');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}