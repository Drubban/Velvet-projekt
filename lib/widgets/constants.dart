import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Sistema de Reservaciones';
  
  // Colores
  static const Color primaryColor = Color(0xFF2962FF);
  static const Color secondaryColor = Color(0xFF00BFA5);
  static const Color errorColor = Color(0xFFD32F2F);
  
  // Rutas
  static const String homeRoute = '/';
  static const String clientesRoute = '/clientes';
  static const String sucursalesRoute = '/sucursales';
  static const String reservacionesRoute = '/reservaciones';
  
  // Tamaños
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
}

class ApiEndpoints {
  static const String clientes = '/clientes';
  static const String sucursales = '/sucursales';
  static const String salones = '/salones';
  static const String mesas = '/mesas';
  static const String tiposReservacion = '/tipos-reservacion';
  static const String reservaciones = '/reservaciones';
}