import 'package:flutter/material.dart';
import '../../models/sucursal.dart';
import '../../models/direccion.dart';
import 'direccion_modal.dart';

class SucursalForm extends StatefulWidget {
  final Sucursal? sucursal;

  SucursalForm({this.sucursal});

  @override
  _SucursalFormState createState() => _SucursalFormState();
}

class _SucursalFormState extends State<SucursalForm> {
  final _formKey = GlobalKey<FormState>();
  late Sucursal _sucursal;

  @override
  void initState() {
    super.initState();
    _sucursal = widget.sucursal ?? Sucursal(nombre: '');
  }

  Future<void> _selectDireccion() async {
    final direccion = await showDialog<Direccion>(
      context: context,
      builder: (context) => DireccionModal(direccion: _sucursal.direccion),
    );
    
    if (direccion != null) {
      setState(() {
        _sucursal.direccion = direccion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sucursal == null ? 'Nueva Sucursal' : 'Editar Sucursal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de la Sucursal'),
                initialValue: _sucursal.nombre,
                validator: (value) => value?.isEmpty ?? true ? 'Ingrese un nombre' : null,
                onSaved: (value) => _sucursal.nombre = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono'),
                initialValue: _sucursal.telefono,
                keyboardType: TextInputType.phone,
                onSaved: (value) => _sucursal.telefono = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Horario'),
                initialValue: _sucursal.horario,
                onSaved: (value) => _sucursal.horario = value,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Dirección'),
                subtitle: Text(_sucursal.direccion?.toString() ?? 'No seleccionada'),
                trailing: IconButton(
                  icon: Icon(Icons.edit_location),
                  onPressed: _selectDireccion,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, _sucursal);
                  }
                },
                child: Text('Guardar Sucursal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}