import 'package:flutter/material.dart';
import 'package:velvet_projekt/views/clientes/clientes_view.dart';
import 'package:velvet_projekt/views/sucursales/sucursales_view.dart';
import 'package:velvet_projekt/views/reservaciones/reservaciones_view.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    ClientesView(),
    SucursalesView(),
    ReservacionesView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Sucursales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Reservaciones',
          ),
        ],
      ),
    );
  }
}
