import 'package:flutter/material.dart';
import '../../models/direccion.dart';

class DireccionModal extends StatefulWidget {
  final Direccion? direccion;

  DireccionModal({this.direccion});

  @override
  _DireccionModalState createState() => _DireccionModalState();
}

class _DireccionModalState extends State<DireccionModal> {
  final _formKey = GlobalKey<FormState>();
  late Direccion _direccion;

  @override
  void initState() {
    super.initState();
    _direccion = widget.direccion ?? Direccion(
      calle: '',
      numeroExterior: '',
      colonia: '',
      municipio: '',
      estado: '',
      codigoPostal: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Agregar Dirección', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Calle'),
                initialValue: _direccion.calle,
                validator: (value) => value?.isEmpty ?? true ? 'Ingrese la calle' : null,
                onSaved: (value) => _direccion.calle = value!,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Número Exterior'),
                      initialValue: _direccion.numeroExterior,
                      validator: (value) => value?.isEmpty ?? true ? 'Ingrese número exterior' : null,
                      onSaved: (value) => _direccion.numeroExterior = value!,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Número Interior (opcional)'),
                      initialValue: _direccion.numeroInterior,
                      onSaved: (value) => _direccion.numeroInterior = value,
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Colonia'),
                initialValue: _direccion.colonia,
                validator: (value) => value?.isEmpty ?? true ? 'Ingrese la colonia' : null,
                onSaved: (value) => _direccion.colonia = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Municipio/Alcaldía'),
                initialValue: _direccion.municipio,
                validator: (value) => value?.isEmpty ?? true ? 'Ingrese el municipio' : null,
                onSaved: (value) => _direccion.municipio = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Estado'),
                initialValue: _direccion.estado,
                validator: (value) => value?.isEmpty ?? true ? 'Ingrese el estado' : null,
                onSaved: (value) => _direccion.estado = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Código Postal'),
                initialValue: _direccion.codigoPostal,
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Ingrese el código postal' : null,
                onSaved: (value) => _direccion.codigoPostal = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Referencias (opcional)'),
                initialValue: _direccion.referencias,
                maxLines: 2,
                onSaved: (value) => _direccion.referencias = value,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pop(context, _direccion);
                      }
                    },
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}