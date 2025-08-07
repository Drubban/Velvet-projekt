import 'package:flutter/material.dart';
import 'package:velvet_projekt/models/tipo_reservacion.dart';
import 'package:velvet_projekt/services/tipo_reservacion_service.dart';
import 'package:velvet_projekt/views/tipos_reservacion/tipo_form.dart';

class TiposReservacionView extends StatefulWidget {
  @override
  _TiposReservacionViewState createState() => _TiposReservacionViewState();
}

class _TiposReservacionViewState extends State<TiposReservacionView> {
  final TipoReservacionService _tipoService = TipoReservacionService();
  List<TipoReservacion> _tipos = [];

  @override
  void initState() {
    super.initState();
    _loadTipos();
  }

  Future<void> _loadTipos() async {
    final tipos = await _tipoService.getTiposReservacion();
    setState(() {
      _tipos = tipos;
    });
  }

  Future<void> _addTipo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TipoForm(),
      ),
    );
    
    if (result == true) {
      _loadTipos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de Reservación'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTipo,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _tipos.length,
        itemBuilder: (context, index) {
          final tipo = _tipos[index];
          return ListTile(
            title: Text(tipo.nombre),
            subtitle: Text(tipo.descripcion ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tipo.precioBase != null)
                  Chip(label: Text('\$${tipo.precioBase!.toStringAsFixed(2)}')),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TipoForm(tipo: tipo),
                      ),
                    ).then((result) {
                      if (result == true) _loadTipos();
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}