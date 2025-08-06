import 'package:flutter/material.dart';
import '../../models/cliente.dart';

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
            if (cliente.email != null) Text('Email: ${cliente.email}'),
            if (cliente.telefono != null) Text('Teléfono: ${cliente.telefono}'),
            SizedBox(height: 20),
            Text('Historial de Reservaciones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // Aquí iría la lista de reservaciones del cliente
          ],
        ),
      ),
    );
  }
}