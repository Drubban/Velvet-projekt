import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'services/api_service.dart';
import 'views/main_navigation.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppConstants.primaryColor,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: MainNavigation(),
      routes: {
        AppConstants.clientesRoute: (context) => ClientesView(),
        AppConstants.sucursalesRoute: (context) => SucursalesView(),
        AppConstants.reservacionesRoute: (context) => ReservacionesView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}