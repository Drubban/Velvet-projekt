import 'package:flutter/material.dart';
import 'package:velvet_projekt/models/cliente.dart';
import 'package:velvet_projekt/services/cliente_service.dart';
import 'package:velvet_projekt/views/clientes/cliente_details.dart';

class ClientesView extends StatefulWidget {
  @override
  _ClientesViewState createState() => _ClientesViewState();
}

class _ClientesViewState extends State<ClientesView> {
  final ClienteService _clienteService = ClienteService();
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    final clientes = await _clienteService.getClientes();
    setState(() {
      _clientes = clientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Teléfono')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: _clientes.map((cliente) {
            return DataRow(cells: [
              DataCell(Text(cliente.nombre)),
              DataCell(Text(cliente.email ?? '')),
              DataCell(Text(cliente.telefono ?? '')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClienteDetails(cliente: cliente),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Implementar edición
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}