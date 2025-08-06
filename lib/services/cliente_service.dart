import '../models/cliente.dart';
import 'api_service.dart';

class ClienteService {
  final ApiService _api = ApiService();

  Future<List<Cliente>> getClientes() async {
    try {
      final response = await _api.get('/clientes');
      return (response as List).map((json) => Cliente.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener clientes: $e');
    }
  }

  Future<Cliente> createCliente(Cliente cliente) async {
    try {
      final response = await _api.post('/clientes', data: cliente.toJson());
      return Cliente.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear cliente: $e');
    }
  }

  Future<Cliente> updateCliente(Cliente cliente) async {
    try {
      final response = await _api.put('/clientes/${cliente.id}', data: cliente.toJson());
      return Cliente.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar cliente: $e');
    }
  }
}