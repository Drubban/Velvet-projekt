import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cliente.dart';

class ClienteService {
  static final ClienteService _instance = ClienteService._internal();
  factory ClienteService() => _instance;
  ClienteService._internal();

  static Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'clientes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clientes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT,
        telefono TEXT,
        direccion TEXT
      )
    ''');
  }

  // ===== Operaciones CRUD ===== //

  Future<int> createCliente(Cliente cliente) async {
    try {
      final db = await _db;
      return await db.insert(
        'clientes',
        cliente.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al crear cliente: $e');
    }
  }

  Future<List<Cliente>> getAllClientes() async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query('clientes');
      return List.generate(maps.length, (i) => Cliente.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener clientes: $e');
    }
  }

  Future<Cliente?> getClienteById(int id) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'clientes',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return maps.isNotEmpty ? Cliente.fromJson(maps.first) : null;
    } catch (e) {
      throw Exception('Error al obtener cliente por ID: $e');
    }
  }

  Future<int> updateCliente(Cliente cliente) async {
    try {
      final db = await _db;
      return await db.update(
        'clientes',
        cliente.toJson(),
        where: 'id = ?',
        whereArgs: [cliente.id],
      );
    } catch (e) {
      throw Exception('Error al actualizar cliente: $e');
    }
  }

  Future<int> deleteCliente(int id) async {
    try {
      final db = await _db;
      return await db.delete(
        'clientes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al borrar cliente: $e');
    }
  }

  Future<List<Cliente>> searchClientes(String query) async {
    try {
      final db = await _db;
      final List<Map<String, dynamic>> maps = await db.query(
        'clientes',
        where: 'nombre LIKE ? OR correo LIKE ? OR telefono LIKE ? OR direccion LIKE ?',
        whereArgs: List.filled(4, '%$query%'),
      );
      return List.generate(maps.length, (i) => Cliente.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Error al buscar clientes: $e');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}