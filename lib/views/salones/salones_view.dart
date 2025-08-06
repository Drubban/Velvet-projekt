import 'package:flutter/material.dart';
import '../models/salon.dart';
import '../models/sucursal.dart';
import '../services/salon_service.dart';
import 'salon_form.dart';
import 'mesas_modal.dart';

class SalonesView extends StatefulWidget {
  final Sucursal sucursal;

  SalonesView({required this.sucursal});

  @override
  _SalonesViewState createState() => _SalonesViewState();
}

class _SalonesViewState extends State<SalonesView> {
  final SalonService _salonService = SalonService();
  List<Salon> _salones = [];

  @override
  void initState() {
    super.initState();
    _loadSalones();
  }

  Future<void> _loadSalones() async {
    final salones = await _salonService.getSalonesPorSucursal(widget.sucursal.id!);
    setState(() {
      _salones = salones;
    });
  }

  Future<void> _addSalon() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalonForm(sucursalId: widget.sucursal.id!),
      ),
    );
    
    if (result == true) {
      _loadSalones();
    }
  }

  Future<void> _manageMesas(Salon salon) async {
    final result = await showDialog(
      context: context,
      builder: (context) => MesasModal(salonId: salon.id!),
    );
    
    if (result != null) {
      // Mesas fueron actualizadas
      _loadSalones();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salones - ${widget.sucursal.nombre}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSalon,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _salones.length,
        itemBuilder: (context, index) {
          final salon = _salones[index];
          return ExpansionTile(
            title: Text(salon.nombre),
            subtitle: Text('Capacidad: ${salon.capacidad} personas'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    if (salon.mesas != null && salon.mesas!.isNotEmpty)
                      ...salon.mesas!.map((mesa) => ListTile(
                        title: Text('Mesa ${mesa.numero}'),
                        subtitle: Text('Capacidad: ${mesa.capacidad}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implementar edición de mesa
                          },
                        ),
                      )),
                    ElevatedButton(
                      onPressed: () => _manageMesas(salon),
                      child: Text('Gestionar Mesas'),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}