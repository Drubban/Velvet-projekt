import 'package:flutter/material.dart';
import '../../models/mesa.dart';

class MesasModal extends StatefulWidget {
  final int salonId;

  MesasModal({required this.salonId});

  @override
  _MesasModalState createState() => _MesasModalState();
}

class _MesasModalState extends State<MesasModal> {
  final List<Mesa> _mesas = [];
  final _numeroController = TextEditingController();
  final _capacidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Agregar Mesas', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _numeroController,
                    decoration: InputDecoration(labelText: 'Número'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _capacidadController,
                    decoration: InputDecoration(labelText: 'Capacidad'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final mesa = Mesa(
                      numero: _numeroController.text,
                      capacidad: int.tryParse(_capacidadController.text) ?? 0,
                      salonId: widget.salonId,
                    );
                    setState(() {
                      _mesas.add(mesa);
                    });
                    _numeroController.clear();
                    _capacidadController.clear();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_mesas.isNotEmpty)
              Column(
                children: [
                  Text('Mesas a agregar:'),
                  SizedBox(height: 8),
                  ..._mesas.map((mesa) => ListTile(
                    title: Text('Mesa ${mesa.numero}'),
                    subtitle: Text('Capacidad: ${mesa.capacidad}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _mesas.remove(mesa);
                        });
                      },
                    ),
                  )),
                ],
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
                  onPressed: _mesas.isEmpty
                      ? null
                      : () {
                          // Guardar mesas en la base de datos
                          Navigator.pop(context, _mesas);
                        },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _capacidadController.dispose();
    super.dispose();
  }
}