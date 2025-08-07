import '../models/mesa.dart';
import 'api_service.dart';

class MesaService {
  final ApiService _api = ApiService(baseUrl: 'PENDIENTE_A_TU_API_URL');

  Future<List<Mesa>> getMesasPorSalon(int salonId) async {
    try {
      final response = await _api.get('/mesas?salon_id=$salonId');
      return (response as List).map((json) => Mesa.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener mesas: $e');
    }
  }

  Future<List<Mesa>> createMesas(List<Mesa> mesas) async {
    try {
      final response = await _api.post('/mesas/bulk', data: {
        'mesas': mesas.map((m) => m.toJson()).toList()
      });
      return (response as List).map((json) => Mesa.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al crear mesas: $e');
    }
  }

  Future<Mesa> updateMesa(Mesa mesa) async {
    try {
      final response = await _api.put('/mesas/${mesa.id}', data: mesa.toJson());
      return Mesa.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar mesa: $e');
    }
  }
}