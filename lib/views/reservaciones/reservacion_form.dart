import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velvet_projekt/models/cliente.dart';
import 'package:velvet_projekt/models/reservacion.dart';
import 'package:velvet_projekt/models/sucursal.dart';
import 'package:velvet_projekt/models/salon.dart';
import 'package:velvet_projekt/models/mesa.dart';
import 'package:velvet_projekt/models/tipo_reservacion.dart';
import 'package:velvet_projekt/services/cliente_service.dart';
import 'package:velvet_projekt/services/mesa_service.dart';
import 'package:velvet_projekt/services/salon_service.dart';
import 'package:velvet_projekt/services/sucursal_service.dart';
import 'package:velvet_projekt/services/tipo_reservacion_service.dart';
import 'package:velvet_projekt/services/reservacion_service.dart';
import 'package:velvet_projekt/views/reservaciones/cliente_modal.dart';

class ReservacionForm extends StatefulWidget {
  final Reservacion? reservacion;

  ReservacionForm({this.reservacion});

  @override
  _ReservacionFormState createState() => _ReservacionFormState();
}

class _ReservacionFormState extends State<ReservacionForm> {
  final _formKey = GlobalKey<FormState>();
  final _reservacionService = ReservacionService();
  final _clienteService = ClienteService();
  final _sucursalService = SucursalService();
  final _tipoService = TipoReservacionService();

  late Reservacion _reservacion;
  List<Cliente> _clientes = [];
  List<Sucursal> _sucursales = [];
  List<Salon> _salones = [];
  List<Mesa> _mesasDisponibles = [];
  List<TipoReservacion> _tipos = [];

  DateTime _fechaSeleccionada = DateTime.now();
  TimeOfDay _horaSeleccionada = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _reservacion = widget.reservacion ?? Reservacion(
      cliente: Cliente(nombre: '', email: '', telefono: ''),
      sucursal: Sucursal(nombre: '', direccion: null, telefono: ''),
      salon: Salon(nombre: '', descripcion: '', capacidad: 0, sucursalId: 0),
      mesa: Mesa(numero: '0', capacidad: 0, salonId: 0),
      tipo: TipoReservacion(nombre: ''),
      fecha: DateTime.now(),
      observaciones: '',
    );
    _loadDependencias();
  }

  Future<void> _loadDependencias() async {
    final clientes = await _clienteService.getAllClientes();
    final sucursales = await _sucursalService.getSucursales();
    final tipos = await _tipoService.getTiposReservacion();
    
    setState(() {
      _clientes = clientes;
      _sucursales = sucursales;
      _tipos = tipos;
    });
  }

  Future<void> _selectFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
        _reservacion.fecha = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _horaSeleccionada.hour,
          _horaSeleccionada.minute,
        );
      });
    }
  }

  Future<void> _selectHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada,
    );
    if (picked != null && picked != _horaSeleccionada) {
      setState(() {
        _horaSeleccionada = picked;
        _reservacion.fecha = DateTime(
          _fechaSeleccionada.year,
          _fechaSeleccionada.month,
          _fechaSeleccionada.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _saveReservacion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      try {
        if (widget.reservacion == null) {
          await _reservacionService.createReservacion(_reservacion);
        } else {
          await _reservacionService.updateReservacion(_reservacion);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar reservación: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reservacion == null ? 'Nueva Reservación' : 'Editar Reservación'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveReservacion,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selección de Cliente
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Cliente>(
                      value: _reservacion.cliente.id != null 
                          ? _clientes.firstWhere((c) => c.id == _reservacion.cliente.id, orElse: () => _reservacion.cliente)
                          : null,
                      decoration: InputDecoration(labelText: 'Cliente'),
                      items: _clientes.map((cliente) {
                        return DropdownMenuItem<Cliente>(
                          value: cliente,
                          child: Text(cliente.nombre),
                        );
                      }).toList(),
                      onChanged: (cliente) {
                        setState(() {
                          _reservacion.cliente = cliente!;
                        });
                      },
                      validator: (value) => value == null ? 'Seleccione un cliente' : null,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => ClienteModal(),
                      );
                      if (result == true) {
                        _loadDependencias();
                      }
                    },
                  ),
                ],
              ),
              
              // Selección de Sucursal
              DropdownButtonFormField<Sucursal>(
                value: _reservacion.sucursal.id != null
                    ? _sucursales.firstWhere((s) => s.id == _reservacion.sucursal.id, orElse: () => _reservacion.sucursal)
                    : null,
                decoration: InputDecoration(labelText: 'Sucursal'),
                items: _sucursales.map((sucursal) {
                  return DropdownMenuItem<Sucursal>(
                    value: sucursal,
                    child: Text(sucursal.nombre),
                  );
                }).toList(),
                onChanged: (sucursal) {
                  setState(() {
                    _reservacion.sucursal = sucursal!;
                    _reservacion.salon = Salon(nombre: '', descripcion: '', capacidad: 0, sucursalId: 0);
                    _reservacion.mesa = Mesa(numero: '0', capacidad: 0, salonId: 0);
                    _salones = [];
                    _mesasDisponibles = [];
                  });
                  if (sucursal != null) {
                    _loadSalones(sucursal.id!);
                  }
                },
                validator: (value) => value == null ? 'Seleccione una sucursal' : null,
              ),
              
              // Selección de Salón (solo si hay sucursal seleccionada)
              if (_reservacion.sucursal.id != null)
                DropdownButtonFormField<Salon>(
                  value: _reservacion.salon.id != null
                      ? _salones.firstWhere((s) => s.id == _reservacion.salon.id, orElse: () => _reservacion.salon)
                      : null,
                  decoration: InputDecoration(labelText: 'Salón'),
                  items: _salones.map((salon) {
                    return DropdownMenuItem<Salon>(
                      value: salon,
                      child: Text(salon.nombre),
                    );
                  }).toList(),
                  onChanged: (salon) {
                    setState(() {
                      _reservacion.salon = salon!;
                      _reservacion.mesa = Mesa(numero: '0', capacidad: 0, salonId: 0);
                    });
                    _loadMesasDisponibles(salon!.id!);
                  },
                  validator: (value) => value == null ? 'Seleccione un salón' : null,
                ),
              
              // Selección de Mesa (solo si hay salón seleccionado)
              if (_reservacion.salon.id != null)
                DropdownButtonFormField<Mesa>(
                  value: _reservacion.mesa.id != null
                      ? _mesasDisponibles.firstWhere((m) => m.id == _reservacion.mesa.id, orElse: () => _reservacion.mesa)
                      : null,
                  decoration: InputDecoration(labelText: 'Mesa'),
                  items: _mesasDisponibles.map((mesa) {
                    return DropdownMenuItem<Mesa>(
                      value: mesa,
                      child: Text('Mesa ${mesa.numero} (Capacidad: ${mesa.capacidad})'),
                    );
                  }).toList(),
                  onChanged: (mesa) {
                    setState(() {
                      _reservacion.mesa = mesa!;
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione una mesa' : null,
                ),
              
              // Selección de Tipo de Reservación
              DropdownButtonFormField<TipoReservacion>(
                value: _reservacion.tipo.id != null
                    ? _tipos.firstWhere((t) => t.id == _reservacion.tipo.id, orElse: () => _reservacion.tipo)
                    : null,
                decoration: InputDecoration(labelText: 'Tipo de Reservación'),
                items: _tipos.map((tipo) {
                  return DropdownMenuItem<TipoReservacion>(
                    value: tipo,
                    child: Text(tipo.nombre),
                  );
                }).toList(),
                onChanged: (tipo) {
                  setState(() {
                    _reservacion.tipo = tipo!;
                  });
                },
                validator: (value) => value == null ? 'Seleccione un tipo' : null,
              ),
              
              // Selección de Fecha y Hora
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Fecha'),
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_fechaSeleccionada),
                      ),
                      readOnly: true,
                      onTap: () => _selectFecha(context),
                      validator: (value) => value == null ? 'Seleccione una fecha' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Hora'),
                      controller: TextEditingController(
                        text: _horaSeleccionada.format(context),
                      ),
                      readOnly: true,
                      onTap: () => _selectHora(context),
                      validator: (value) => value == null ? 'Seleccione una hora' : null,
                    ),
                  ),
                ],
              ),
              
              // Observaciones
              TextFormField(
                decoration: InputDecoration(labelText: 'Observaciones'),
                maxLines: 3,
                initialValue: _reservacion.observaciones,
                onSaved: (value) => _reservacion.observaciones = value,
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveReservacion,
                child: Text('Guardar Reservación'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadSalones(int sucursalId) async {
    final salonService = SalonService();
    final salones = await salonService.getSalonesPorSucursal(sucursalId);
    setState(() {
      _salones = salones;
    });
  }

  Future<void> _loadMesasDisponibles(int salonId) async {
    // Aquí deberías implementar la lógica para obtener mesas disponibles
    // para la fecha y hora seleccionadas
    final mesaService = MesaService();
    final mesas = await mesaService.getMesasPorSalon(salonId);
    setState(() {
      _mesasDisponibles = mesas;
    });
  }
}