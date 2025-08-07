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
    final clientes = await _clienteService.getAllClientes();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showClienteForm(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar cliente',
      ),
      body: _clientes.isEmpty
          ? Center(child: Text('No hay registros', style: TextStyle(color: Colors.grey)))
          : SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Correo')),
                  DataColumn(label: Text('Teléfono')),
                  DataColumn(label: Text('Dirección')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: _clientes.map((cliente) {
                  return DataRow(cells: [
                    DataCell(Text(cliente.nombre)),
                    DataCell(Text(cliente.correo ?? '')),
                    DataCell(Text(cliente.telefono ?? '')),
                    DataCell(Text(cliente.direccion ?? '')),
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
                          onPressed: () async {
                            await _showClienteForm(context, cliente: cliente);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _deleteCliente(cliente.id);
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

  Future<void> _showClienteForm(BuildContext context, {Cliente? cliente}) async {
    final nombreController = TextEditingController(text: cliente?.nombre ?? '');
    final correoController = TextEditingController(text: cliente?.correo ?? '');
    final telefonoController = TextEditingController(text: cliente?.telefono ?? '');
    final direccionController = TextEditingController(text: cliente?.direccion ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(cliente == null ? 'Nuevo Cliente' : 'Editar Cliente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: correoController,
                  decoration: InputDecoration(labelText: 'Correo'),
                ),
                TextField(
                  controller: telefonoController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                ),
                TextField(
                  controller: direccionController,
                  decoration: InputDecoration(labelText: 'Dirección'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text(cliente == null ? 'Guardar' : 'Actualizar'),
              onPressed: () async {
                final nuevoCliente = Cliente(
                  id: cliente?.id,
                  nombre: nombreController.text,
                  correo: correoController.text,
                  telefono: telefonoController.text,
                  direccion: direccionController.text,
                );
                if (cliente == null) {
                  await _clienteService.createCliente(nuevoCliente);
                } else {
                  await _clienteService.updateCliente(nuevoCliente);
                }
                Navigator.of(context).pop();
                await _loadClientes();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCliente(int? id) async {
    if (id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar este cliente?'),
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
      await _clienteService.deleteCliente(id);
      await _loadClientes();
    }
  }
}