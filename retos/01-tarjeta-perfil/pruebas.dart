// Pruebas del reto 01: tarjeta de perfil. Revisan lo que pide el README, no cómo lo armaste.
import 'package:flutter_test/flutter_test.dart';

import '../../herramientas/ayuda_pruebas.dart';

void probar(CrearReto crear, {required String quien}) {
  group('01 tarjeta de perfil ($quien)', () {
    testWidgets('muestra nombre, rol, ciudad y biografía', (tester) async {
      await abrir(tester, crear);
      expect(find.text('Karla Funes'), findsOneWidget);
      expect(find.text('Diseñadora de producto'), findsOneWidget);
      expect(find.textContaining('San Pedro Sula, Cortés'), findsOneWidget);
      expect(find.textContaining('Diseño interfaces para apps de transporte'), findsOneWidget);
    });

    testWidgets('el avatar mide 96 x 96 y lleva las iniciales', (tester) async {
      await abrir(tester, crear);
      expect(clave('avatar'), findsOneWidget);
      midaCerca(tester, clave('avatar'), ancho: 96, alto: 96);
      expect(textoEn('avatar', 'KF'), findsOneWidget);
    });

    testWidgets('trae las tres cifras con su etiqueta', (tester) async {
      await abrir(tester, crear);
      for (final texto in ['38', 'Proyectos', '1.2 k', 'Seguidores', '4.9', 'Reseñas']) {
        expect(find.text(texto), findsOneWidget, reason: 'Falta el texto "$texto"');
      }
    });

    testWidgets('trae las tres habilidades', (tester) async {
      await abrir(tester, crear);
      for (final texto in ['Figma', 'Flutter', 'Accesibilidad']) {
        expect(find.text(texto), findsOneWidget, reason: 'Falta la habilidad "$texto"');
      }
    });

    testWidgets('el botón Seguir cambia a Siguiendo y regresa', (tester) async {
      await abrir(tester, crear);
      expect(textoEn('boton-seguir', 'Seguir'), findsOneWidget);
      await tocar(tester, clave('boton-seguir'));
      expect(textoEn('boton-seguir', 'Siguiendo'), findsOneWidget);
      await tocar(tester, clave('boton-seguir'));
      expect(textoEn('boton-seguir', 'Seguir'), findsOneWidget);
    });

    testWidgets('el botón Seguir mide al menos 48 de alto', (tester) async {
      await abrir(tester, crear);
      expect(tester.getSize(clave('boton-seguir')).height, greaterThanOrEqualTo(48));
      expect(find.text('Mensaje'), findsOneWidget);
    });

    testWidgets('cabe en un teléfono chico sin desbordarse', (tester) async {
      await abrir(tester, crear, tamano: telefonoChico);
      expect(find.text('Karla Funes'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
