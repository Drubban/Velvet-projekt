import 'package:flutter/material.dart';
import '../../models/salon.dart';

class SalonForm extends StatefulWidget {
  final int sucursalId;
  final Salon? salon;

  SalonForm({required this.sucursalId, this.salon});

  @override
  _SalonFormState createState() => _SalonFormState();
}

class _SalonFormState extends State<SalonForm> {
  final _formKey = GlobalKey<FormState>();
  late Salon _salon;

  @override
  void initState() {
    super.initState();
    _salon = widget.salon ?? Salon(
      nombre: '',
      descripcion: '',
      capacidad: 0,
      sucursalId: widget.sucursalId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.salon == null ? 'Nuevo Salón' : 'Editar Salón'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Salón'),
                initialValue: _salon.nombre,
                validator: (value) => value?.isEmpty ?? true ? 'Ingrese un nombre' : null,
                onSaved: (value) => _salon.nombre = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                initialValue: _salon.descripcion,
                maxLines: 3,
                onSaved: (value) => _salon.descripcion = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Capacidad'),
                initialValue: _salon.capacidad.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Ingrese la capacidad';
                  if (int.tryParse(value!) == null) return 'Ingrese un número válido';
                  return null;
                },
                onSaved: (value) => _salon.capacidad = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, _salon);
                  }
                },
                child: Text('Guardar Salón'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}