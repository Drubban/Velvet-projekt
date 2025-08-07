import 'package:flutter/material.dart';
import 'package:velvet_projekt/models/reservacion.dart';
import 'package:velvet_projekt/services/reservacion_service.dart';
import 'package:velvet_projekt/views/reservaciones/reservacion_form.dart';
import 'package:velvet_projekt/views/reservaciones/cliente_modal.dart';
import 'package:velvet_projekt/views/reservaciones/reservacion_details.dart';

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
      body: _reservaciones.isEmpty
          ? Center(child: Text('No hay registros', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: _reservaciones.length,
              itemBuilder: (context, index) {
                final reservacion = _reservaciones[index];
                return Card(
                  child: ListTile(
                    title: Text('Reservación #${reservacion.id}'),
                    subtitle: Text('Cliente: ${reservacion.cliente.nombre} - Fecha: ${reservacion.fecha}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservacionDetails(reservacion: reservacion),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservacionForm(reservacion: reservacion),
                              ),
                            );
                            if (result == true) _loadReservaciones();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _deleteReservacion(reservacion.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _deleteReservacion(int? id) async {
    if (id == null) return;
    await _reservacionService.deleteReservacion(id);
    await _loadReservaciones();
  }
}