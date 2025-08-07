import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velvet_projekt/widgets/app_theme.dart';
import 'package:velvet_projekt/widgets/constants.dart';
import 'package:velvet_projekt/services/api_service.dart';
import 'package:velvet_projekt/views/main_navigation.dart';
import 'package:velvet_projekt/views/clientes/clientes_view.dart';
import 'package:velvet_projekt/views/sucursales/sucursales_view.dart';
import 'package:velvet_projekt/views/reservaciones/reservaciones_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(baseUrl: 'https://tu-api.com/v1', apiKey: 'tu-api-key'),
        ),
        // Agrega más providers según sea necesario
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: appTheme,
      home: MainNavigation(),
      routes: {
        if (AppConstants.clientesRoute != null)
          AppConstants.clientesRoute: (context) => ClientesView(),
        if (AppConstants.sucursalesRoute != null)
          AppConstants.sucursalesRoute: (context) => SucursalesView(),
        if (AppConstants.reservacionesRoute != null)
          AppConstants.reservacionesRoute: (context) => ReservacionesView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}