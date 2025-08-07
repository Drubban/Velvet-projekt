import '../models/salon.dart';
import 'api_service.dart';

class SalonService {
  final ApiService _api = ApiService(baseUrl: 'PENDIENTE_A_TU_API_URL');

  Future<List<Salon>> getSalonesPorSucursal(int sucursalId) async {
    try {
      final response = await _api.get('/salones?sucursal_id=$sucursalId');
      return (response as List).map((json) => Salon.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener salones: $e');
    }
  }

  Future<Salon> createSalon(Salon salon) async {
    try {
      final response = await _api.post('/salones', data: salon.toJson());
      return Salon.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear salón: $e');
    }
  }

  Future<Salon> updateSalon(Salon salon) async {
    try {
      final response = await _api.put('/salones/${salon.id}', data: salon.toJson());
      return Salon.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar salón: $e');
    }
  }
}