import 'package:flutter/material.dart';
import '../models/reservacion.dart';
import '../services/reservacion_service.dart';
import 'reservacion_form.dart';
import 'cliente_modal.dart';
import 'reservacion_details.dart';

class ReservacionesView extends StatefulWidget {
  @override
  _ReservacionesViewState createState() => _ReservacionesViewState();
}

class _ReservacionesViewState extends State<ReservacionesView> {
  final ReservacionService _reservacionService = ReservacionService();
  List<Reservacion> _reservaciones = [];

  @override
  void initState() {
    super.initState();
    _loadReservaciones();
  }

  Future<void> _loadReservaciones() async {
    final reservaciones = await _reservacionService.getReservaciones();
    setState(() {
      _reservaciones = reservaciones;
    });
  }

  Future<void> _addReservacion() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservacionForm(),
      ),
    );
    
    if (result == true) {
      _loadReservaciones();
    }
  }

  Future<void> _showAddClienteModal() async {
    final result = await showDialog(
      context: context,
      builder: (context) => ClienteModal(),
    );
    
    if (result != null) {
      // Cliente creado, posiblemente actualizar lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservaciones'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addReservacion,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _reservaciones.length,
        itemBuilder: (context, index) {
          final reservacion = _reservaciones[index];
          return Card(
            child: ListTile(
              title: Text('Reservación #${reservacion.id}'),
              subtitle: Text('Cliente: ${reservacion.cliente?.nombre} - Fecha: ${reservacion.fecha}'),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservacionDetails(reservacion: reservacion),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}