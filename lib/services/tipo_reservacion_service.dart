import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tipo_reservacion.dart';

class TipoReservacionService {
  static final TipoReservacionService _instance = TipoReservacionService._internal();
  factory TipoReservacionService() => _instance;
  TipoReservacionService._internal();

  static Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tipos_reservacion.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tipos_reservacion(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT
      )
    ''');
  }

  // ===== Operaciones CRUD ===== //

  Future<int> createTipoReservacion(TipoReservacion tipo) async {
    try {
      final db = await _db;
      return await db.insert(
        'tipos_reservacion',
        tipo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al crear tipo de reservación: $e');
    }
  }

  Future<List<TipoReservacion>> getTiposReservacion() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query('tipos_reservacion');
      return List.generate(maps.length, (i) => TipoReservacion.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener tipos de reservación: $e');
    }
  }

  Future<TipoReservacion?> getTipoReservacionById(int id) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'tipos_reservacion',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return maps.isNotEmpty ? TipoReservacion.fromJson(maps.first) : null;
    } catch (e) {
      throw Exception('Error al obtener tipo de reservación por ID: $e');
    }
  }

  Future<int> updateTipoReservacion(TipoReservacion tipo) async {
    try {
      final db = await _db;
      return await db.update(
        'tipos_reservacion',
        tipo.toJson(),
        where: 'id = ?',
        whereArgs: [tipo.id],
      );
    } catch (e) {
      throw Exception('Error al actualizar tipo de reservación: $e');
    }
  }

  Future<int> deleteTipoReservacion(int id) async {
    try {
      final db = await _db;
      return await db.delete(
        'tipos_reservacion',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al borrar tipo de reservación: $e');
    }
  }

  Future<List<TipoReservacion>> searchTiposReservacion(String query) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'tipos_reservacion',
        where: 'nombre LIKE ? OR descripcion LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return List.generate(maps.length, (i) => TipoReservacion.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al buscar tipos de reservación: $e');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}