import '../models/tipo_reservacion.dart';
import 'api_service.dart';

class TipoReservacionService {
  final ApiService _api = ApiService();

  Future<List<TipoReservacion>> getTiposReservacion() async {
    try {
      final response = await _api.get('/tipos-reservacion');
      return (response as List).map((json) => TipoReservacion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tipos de reservación: $e');
    }
  }

  Future<TipoReservacion> createTipoReservacion(TipoReservacion tipo) async {
    try {
      final response = await _api.post('/tipos-reservacion', data: tipo.toJson());
      return TipoReservacion.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear tipo de reservación: $e');
    }
  }

  Future<TipoReservacion> updateTipoReservacion(TipoReservacion tipo) async {
    try {
      final response = await _api.put('/tipos-reservacion/${tipo.id}', data: tipo.toJson());
      return TipoReservacion.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar tipo de reservación: $e');
    }
  }
}