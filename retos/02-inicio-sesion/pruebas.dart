// Pruebas del reto 02: inicio de sesión. Revisan lo que pide el README, no cómo lo armaste.
import 'package:flutter_test/flutter_test.dart';

import '../../herramientas/ayuda_pruebas.dart';

void probar(CrearReto crear, {required String quien}) {
  group('02 inicio de sesión ($quien)', () {
    testWidgets('muestra título, campos y enlaces', (tester) async {
      await abrir(tester, crear);
      expect(find.text('Hola de nuevo'), findsOneWidget);
      expect(find.text('Entrá a Libreta para seguir con tus apuntes.'), findsOneWidget);
      expect(clave('campo-correo'), findsOneWidget);
      expect(clave('campo-clave'), findsOneWidget);
      expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
      expect(textoEn('boton-ingresar', 'Ingresar'), findsOneWidget);
      expect(find.textContaining('Creá una'), findsOneWidget);
    });

    testWidgets('la contraseña se oculta y el ojito la muestra', (tester) async {
      await abrir(tester, crear);
      expect(campoEn(tester, 'campo-clave').obscureText, isTrue,
          reason: 'La contraseña tiene que empezar oculta');
      await tocar(tester, clave('ver-clave'));
      expect(campoEn(tester, 'campo-clave').obscureText, isFalse,
          reason: 'Al tocar ver-clave la contraseña se tiene que ver');
      await tocar(tester, clave('ver-clave'));
      expect(campoEn(tester, 'campo-clave').obscureText, isTrue);
    });

    testWidgets('con los campos vacíos muestra los dos errores', (tester) async {
      await abrir(tester, crear);
      await tocar(tester, clave('boton-ingresar'));
      expect(find.text('Escribí un correo válido'), findsOneWidget);
      expect(find.text('Usá al menos 8 caracteres'), findsOneWidget);
      expect(find.text('Listo, ya entraste'), findsNothing);
    });

    testWidgets('un correo sin arroba no pasa', (tester) async {
      await abrir(tester, crear);
      await escribir(tester, 'campo-correo', 'karla.correo.hn');
      await escribir(tester, 'campo-clave', 'cafecito2026');
      await tocar(tester, clave('boton-ingresar'));
      expect(find.text('Escribí un correo válido'), findsOneWidget);
      expect(find.text('Usá al menos 8 caracteres'), findsNothing);
    });

    testWidgets('una contraseña de 7 letras no pasa', (tester) async {
      await abrir(tester, crear);
      await escribir(tester, 'campo-correo', 'karla@libreta.hn');
      await escribir(tester, 'campo-clave', 'cafecit');
      await tocar(tester, clave('boton-ingresar'));
      expect(find.text('Escribí un correo válido'), findsNothing);
      expect(find.text('Usá al menos 8 caracteres'), findsOneWidget);
    });

    testWidgets('con datos válidos avisa que entraste', (tester) async {
      await abrir(tester, crear);
      await escribir(tester, 'campo-correo', 'karla@libreta.hn');
      await escribir(tester, 'campo-clave', 'cafecito2026');
      await tocar(tester, clave('boton-ingresar'));
      expect(find.text('Listo, ya entraste'), findsOneWidget);
      expect(find.text('Escribí un correo válido'), findsNothing);
    });

    testWidgets('los campos y el botón miden al menos 48 de alto', (tester) async {
      await abrir(tester, crear);
      for (final nombre in ['campo-correo', 'campo-clave', 'boton-ingresar']) {
        expect(tester.getSize(clave(nombre)).height, greaterThanOrEqualTo(48),
            reason: '$nombre es muy bajito para tocarlo con el dedo');
      }
    });

    testWidgets('cabe en un teléfono chico sin desbordarse', (tester) async {
      await abrir(tester, crear, tamano: telefonoChico);
      expect(find.text('Hola de nuevo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
