import 'package:flutter/material.dart';
import 'package:velvet_projekt/models/cliente.dart';
import 'package:velvet_projekt/services/cliente_service.dart';

class ClienteModal extends StatefulWidget {
  @override
  _ClienteModalState createState() => _ClienteModalState();
}

class _ClienteModalState extends State<ClienteModal> {
  final _formKey = GlobalKey<FormState>();
  final _clienteService = ClienteService();
  final _cliente = Cliente(nombre: '', email: '', telefono: '');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Agregar Cliente', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) => _cliente.nombre = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _cliente.email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _cliente.telefono = value,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await _clienteService.createCliente(_cliente);
                        Navigator.pop(context, true);
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