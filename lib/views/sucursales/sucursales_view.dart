import 'package:flutter/material.dart';
import '../models/sucursal.dart';
import '../services/sucursal_service.dart';
import 'sucursal_form.dart';
import 'direccion_modal.dart';

class SucursalesView extends StatefulWidget {
  @override
  _SucursalesViewState createState() => _SucursalesViewState();
}

class _SucursalesViewState extends State<SucursalesView> {
  final SucursalService _sucursalService = SucursalService();
  List<Sucursal> _sucursales = [];

  @override
  void initState() {
    super.initState();
    _loadSucursales();
  }

  Future<void> _loadSucursales() async {
    final sucursales = await _sucursalService.getSucursales();
    setState(() {
      _sucursales = sucursales;
    });
  }

  Future<void> _addSucursal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SucursalForm(),
      ),
    );
    
    if (result == true) {
      _loadSucursales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sucursales'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSucursal,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _sucursales.length,
        itemBuilder: (context, index) {
          final sucursal = _sucursales[index];
          return ListTile(
            title: Text(sucursal.nombre),
            subtitle: Text(sucursal.direccion?.toString() ?? 'Sin dirección'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Implementar edición
              },
            ),
            onTap: () {
              // Mostrar detalles
            },
          );
        },
      ),
    );
  }
}