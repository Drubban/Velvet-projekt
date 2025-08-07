import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../models/reservacion.dart';
import '../../services/reservacion_service.dart';

class ClienteDetails extends StatelessWidget {
  final Cliente cliente;

  ClienteDetails({required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${cliente.nombre}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            if (cliente.correo != null) Text('Email: ${cliente.correo}'),
            if (cliente.telefono != null) Text('Teléfono: ${cliente.telefono}'),
            SizedBox(height: 20),
            Text('Historial de Reservaciones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Reservacion>>(
                future: _getHistorialReservaciones(cliente.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No hay registros', style: TextStyle(color: Colors.grey));
                  }
                  final historial = snapshot.data!;
                  return ListView.builder(
                    itemCount: historial.length,
                    itemBuilder: (context, index) {
                      final Reservacion reservacion = historial[index];
                      return Card(
                        child: ListTile(
                          title: Text('Fecha: ${reservacion.fecha.toString().substring(0, 16)}'),
                          subtitle: Text('Estado: ${reservacion.estado}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Reservacion>> _getHistorialReservaciones(int? clienteId) async {
    if (clienteId == null) return [];
    final service = ReservacionService();
    return await service.getHistorialReservaciones(clienteId);
  }
}