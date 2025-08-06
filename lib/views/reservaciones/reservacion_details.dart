import 'package:flutter/material.dart';
import '../../models/reservacion.dart';
import 'package:intl/intl.dart';

class ReservacionDetails extends StatelessWidget {
  final Reservacion reservacion;

  ReservacionDetails({required this.reservacion});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Reservación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reservación #${reservacion.id}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(),
            Text('Cliente: ${reservacion.cliente.nombre}'),
            Text('Sucursal: ${reservacion.sucursal.nombre}'),
            Text('Salón: ${reservacion.salon.nombre}'),
            Text('Mesa: ${reservacion.mesa.numero} (Capacidad: ${reservacion.mesa.capacidad})'),
            Text('Tipo: ${reservacion.tipo.nombre}'),
            Text('Fecha: ${dateFormat.format(reservacion.fecha)}'),
            Text('Estado: ${reservacion.estado}'),
            SizedBox(height: 16),
            if (reservacion.observaciones != null) 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Observaciones:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(reservacion.observaciones!),
                ],
              ),
          ],
        ),
      ),
    );
  }
}