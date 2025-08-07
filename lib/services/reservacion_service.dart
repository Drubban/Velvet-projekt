import '../models/reservacion.dart';
import 'api_service.dart';

class ReservacionService {
  final ApiService _api = ApiService(baseUrl: 'PENDIENTE_A_TU_API_URL');

  Future<List<Reservacion>> getReservaciones() async {
    try {
      final response = await _api.get('/reservaciones');
      return (response as List).map((json) => Reservacion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener reservaciones: $e');
    }
  }

  Future<Reservacion> createReservacion(Reservacion reservacion) async {
    try {
      final response = await _api.post('/reservaciones', data: reservacion.toJson());
      return Reservacion.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear reservación: $e');
    }
  }

  Future<Reservacion> updateReservacion(Reservacion reservacion) async {
    try {
      final response = await _api.put('/reservaciones/${reservacion.id}', data: reservacion.toJson());
      return Reservacion.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar reservación: $e');
    }
  }

  Future<List<Reservacion>> getHistorialReservaciones(int clienteId) async {
    try {
      final response = await _api.get('/reservaciones/historial?cliente_id=$clienteId');
      return (response as List).map((json) => Reservacion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener historial de reservaciones: $e');
    }
  }
}