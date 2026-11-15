// Plantilla de solución. Copiala a retos/<nn-reto>/soluciones/<tu-usuario>/solucion.dart
//
// Lo único que piden las pruebas: que este archivo tenga una clase pública
// llamada Reto, con un constructor sin parámetros obligatorios, que arme
// su propio MaterialApp. Lo demás (más archivos, más widgets) lo organizás vos.
//
// Para verla en el navegador:
//   flutter run -d chrome -t retos/<nn-reto>/soluciones/<tu-usuario>/solucion.dart

import 'package:flutter/material.dart';

void main() => runApp(const Reto());

class Reto extends StatelessWidget {
  const Reto({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('Tu pantalla va aquí')),
      ),
    );
  }
}
