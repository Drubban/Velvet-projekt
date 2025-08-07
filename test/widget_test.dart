// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:velvet_projekt/main.dart';
import 'package:velvet_projekt/widgets/constants.dart';

void main() {
  testWidgets('App loads and shows main navigation', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verifica que el título principal de la app esté presente
    expect(find.text(AppConstants.appName), findsOneWidget);

    // Verifica que la barra de navegación principal esté presente
    expect(find.byType(AppBar), findsOneWidget);
  });
}
