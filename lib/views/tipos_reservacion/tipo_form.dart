import 'package:flutter/material.dart';
import '../../models/tipo_reservacion.dart';

class TipoForm extends StatefulWidget {
  final TipoReservacion? tipo;

  TipoForm({this.tipo});

  @override
  _TipoFormState createState() => _TipoFormState();
}

class _TipoFormState extends State<TipoForm> {
  final _formKey = GlobalKey<FormState>();
  late TipoReservacion _tipo;

  @override
  void initState() {
    super.initState();
    _tipo = widget.tipo ?? TipoReservacion(nombre: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipo == null ? 'Nuevo Tipo' : 'Editar Tipo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Tipo'),
                initialValue: _tipo.nombre,
                validator: (value) => value?.isEmpty ?? true ? 'Ingrese un nombre' : null,
                onSaved: (value) => _tipo.nombre = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                initialValue: _tipo.descripcion,
                maxLines: 3,
                onSaved: (value) => _tipo.descripcion = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio Base'),
                initialValue: _tipo.precioBase?.toString() ?? '',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => _tipo.precioBase = double.tryParse(value ?? '0'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duración Estimada (minutos)'),
                initialValue: _tipo.duracionEstimada?.toString() ?? '',
                keyboardType: TextInputType.number,
                onSaved: (value) => _tipo.duracionEstimada = int.tryParse(value ?? '0'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, _tipo);
                  }
                },
                child: Text('Guardar Tipo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}