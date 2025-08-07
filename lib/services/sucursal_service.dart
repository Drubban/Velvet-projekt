import '../models/sucursal.dart';
import 'api_service.dart';

class SucursalService {
  final ApiService _api = ApiService(baseUrl: 'PENDIENTE_A_TU_API_URL');

  Future<List<Sucursal>> getSucursales() async {
    try {
      final response = await _api.get('/sucursales');
      return (response as List).map((json) => Sucursal.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener sucursales: $e');
    }
  }

  Future<Sucursal> createSucursal(Sucursal sucursal) async {
    try {
      final response = await _api.post('/sucursales', data: sucursal.toJson());
      return Sucursal.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear sucursal: $e');
    }
  }

  Future<Sucursal> updateSucursal(Sucursal sucursal) async {
    try {
      final response = await _api.put('/sucursales/${sucursal.id}', data: sucursal.toJson());
      return Sucursal.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar sucursal: $e');
    }
  }
}