// Pruebas del reto 06: panel con gráficas. Revisan lo que pide el README, no cómo lo armaste.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../herramientas/ayuda_pruebas.dart';

/// El primer CustomPainter que haya dentro del widget con esa key.
CustomPainter? _pintor(WidgetTester tester, String nombreClave) {
  final pinturas = tester.widgetList<CustomPaint>(
    find.descendant(of: clave(nombreClave), matching: find.byType(CustomPaint), matchRoot: true),
  );
  for (final p in pinturas) {
    if (p.painter != null) return p.painter;
  }
  return null;
}

void probar(CrearReto crear, {required String quien}) {
  group('06 panel con gráficas ($quien)', () {
    testWidgets('muestra el negocio y las cifras de la semana', (tester) async {
      await abrir(tester, crear);
      expect(find.text('Panel de ventas'), findsOneWidget);
      expect(find.text('Panadería La Espiga'), findsOneWidget);
      expect(find.text('L 48,250.00'), findsOneWidget);
      expect(find.text('312'), findsOneWidget);
      expect(find.text('L 154.65'), findsOneWidget);
    });

    testWidgets('las dos gráficas están pintadas con CustomPaint', (tester) async {
      await abrir(tester, crear);
      for (final nombre in ['grafica-barras', 'grafica-dona']) {
        await tester.ensureVisible(clave(nombre));
        await tester.pumpAndSettle();
        expect(_pintor(tester, nombre), isNotNull,
            reason: '$nombre tiene que tener un CustomPaint con su painter');
        expect(tester.getSize(clave(nombre)).height, greaterThanOrEqualTo(160),
            reason: '$nombre tiene que medir al menos 160 de alto');
      }
    });

    testWidgets('la leyenda de la dona trae categorías y porcentajes', (tester) async {
      await abrir(tester, crear);
      await tester.ensureVisible(clave('grafica-dona'));
      await tester.pumpAndSettle();
      for (final t in ['Pan dulce', 'Pan salado', 'Repostería', 'Bebidas', '45%', '30%', '15%', '10%']) {
        expect(find.textContaining(t), findsWidgets, reason: 'Falta "$t" en la leyenda');
      }
    });

    testWidgets('Mes cambia las cifras y vuelve con Semana', (tester) async {
      await abrir(tester, crear);
      await tocar(tester, clave('periodo-mes'));
      expect(find.text('L 196,400.00'), findsOneWidget);
      expect(find.text('1,284'), findsOneWidget);
      expect(find.text('L 152.96'), findsOneWidget);
      expect(find.text('L 48,250.00'), findsNothing);
      await tocar(tester, clave('periodo-semana'));
      expect(find.text('L 48,250.00'), findsOneWidget);
    });

    testWidgets('al cambiar de periodo las gráficas se vuelven a pintar', (tester) async {
      await abrir(tester, crear);
      await tester.ensureVisible(clave('grafica-barras'));
      await tester.pumpAndSettle();
      final barrasAntes = _pintor(tester, 'grafica-barras')!;
      // Se abre de nuevo para no depender de cómo hiciste el scroll.
      await tester.pumpWidget(const SizedBox());
      await abrir(tester, crear);
      await tocar(tester, clave('periodo-mes'));
      await tester.ensureVisible(clave('grafica-barras'));
      await tester.pumpAndSettle();
      final barrasDespues = _pintor(tester, 'grafica-barras')!;
      expect(barrasDespues.shouldRepaint(barrasAntes), isTrue,
          reason: 'Las barras del mes son otras: shouldRepaint tiene que dar true');
      await tester.ensureVisible(clave('grafica-dona'));
      await tester.pumpAndSettle();
      expect(find.textContaining('42%'), findsWidgets, reason: 'En el mes, Pan dulce es 42%');
    });

    testWidgets('cabe en un teléfono chico sin desbordarse', (tester) async {
      await abrir(tester, crear, tamano: telefonoChico);
      expect(find.text('Panel de ventas'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
