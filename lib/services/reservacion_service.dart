import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reservacion.dart';

class ReservacionService {
  static final ReservacionService _instance = ReservacionService._internal();
  factory ReservacionService() => _instance;
  ReservacionService._internal();

  static Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'reservaciones.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reservaciones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteId INTEGER NOT NULL,
        mesaId INTEGER,
        fecha TEXT NOT NULL,
        hora TEXT NOT NULL,
        estado TEXT,
        observaciones TEXT
      )
    ''');
  }

  // ===== Operaciones CRUD ===== //

  Future<int> createReservacion(Reservacion reservacion) async {
    try {
      final db = await _db;
      return await db.insert(
        'reservaciones',
        reservacion.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al crear reservación: $e');
    }
  }

  Future<List<Reservacion>> getReservaciones() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query('reservaciones');
      return List.generate(maps.length, (i) => Reservacion.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener reservaciones: $e');
    }
  }

  Future<Reservacion?> getReservacionById(int id) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'reservaciones',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return maps.isNotEmpty ? Reservacion.fromJson(maps.first) : null;
    } catch (e) {
      throw Exception('Error al obtener reservación por ID: $e');
    }
  }

  Future<int> updateReservacion(Reservacion reservacion) async {
    try {
      final db = await _db;
      return await db.update(
        'reservaciones',
        reservacion.toJson(),
        where: 'id = ?',
        whereArgs: [reservacion.id],
      );
    } catch (e) {
      throw Exception('Error al actualizar reservación: $e');
    }
  }

  Future<int> deleteReservacion(int id) async {
    try {
      final db = await _db;
      return await db.delete(
        'reservaciones',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al borrar reservación: $e');
    }
  }

  Future<List<Reservacion>> getHistorialReservaciones(int clienteId) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'reservaciones',
        where: 'clienteId = ?',
        whereArgs: [clienteId],
      );
      return List.generate(maps.length, (i) => Reservacion.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener historial de reservaciones: $e');
    }
  }

  Future<List<Reservacion>> searchReservaciones(String query) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'reservaciones',
        where: 'estado LIKE ? OR observaciones LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return List.generate(maps.length, (i) => Reservacion.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al buscar reservaciones: $e');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}