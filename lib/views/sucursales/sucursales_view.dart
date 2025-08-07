import 'package:flutter/material.dart';
import 'package:velvet_projekt/models/sucursal.dart';
import 'package:velvet_projekt/services/sucursal_service.dart';
import 'package:velvet_projekt/views/sucursales/sucursal_form.dart';
import 'package:velvet_projekt/views/sucursales/direccion_modal.dart';

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
  Future<void> _editSucursal(Sucursal sucursal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SucursalForm(sucursal: sucursal),
      ),
    );
    if (result == true) {
      _loadSucursales();
    }
  }

  Future<void> _deleteSucursal(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar esta sucursal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _sucursalService.deleteSucursal(id);
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editSucursal(sucursal);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (sucursal.id != null) {
                      _deleteSucursal(sucursal.id!);
                    }
                  },
                ),
              ],
            ),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}