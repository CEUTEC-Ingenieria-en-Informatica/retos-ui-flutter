// Ayudas que comparten las pruebas de todos los retos.
//
// Las pruebas no saben cómo armaste tu pantalla: buscan textos, keys acordadas
// y algunos widgets clave. Así hay muchas formas válidas de resolver cada reto.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Teléfono de referencia: 390 x 844 puntos lógicos.
const telefono = Size(390, 844);

/// Teléfono chico para revisar que nada se desborde: 360 x 640 puntos.
const telefonoChico = Size(360, 640);

/// Crea la función que arma la pantalla de una solución.
typedef CrearReto = Widget Function();

/// Abre la pantalla en un teléfono del tamaño indicado y espera a que se quede quieta.
Future<void> abrir(
  WidgetTester tester,
  CrearReto crear, {
  Size tamano = telefono,
  Brightness brilloDelSistema = Brightness.light,
}) async {
  tester.view.devicePixelRatio = 3;
  tester.view.physicalSize = tamano * 3;
  tester.platformDispatcher.platformBrightnessTestValue = brilloDelSistema;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  await tester.pumpWidget(crear());
  await tester.pumpAndSettle();
}

/// Busca un widget por la key acordada en la especificación, por ejemplo `Key('boton-seguir')`.
Finder clave(String nombre) => find.byKey(Key(nombre));

/// Busca un texto dentro del widget que tiene la key indicada (o el texto que lleva esa key).
Finder textoEn(String nombreClave, String texto) =>
    find.descendant(of: clave(nombreClave), matching: find.text(texto), matchRoot: true);

/// Lleva el widget a la vista (por si está más abajo en un scroll) y lo toca.
Future<void> tocar(WidgetTester tester, Finder finder) async {
  expect(finder, findsWidgets, reason: 'No encontré lo que tenía que tocar: $finder');
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

/// Escribe en el campo de texto que está dentro del widget con la key indicada.
Future<void> escribir(WidgetTester tester, String nombreClave, String texto) async {
  final campo = find.descendant(of: clave(nombreClave), matching: find.byType(EditableText));
  expect(campo, findsOneWidget, reason: 'Dentro de "$nombreClave" tiene que haber un campo de texto');
  await tester.ensureVisible(campo);
  await tester.enterText(campo, texto);
  await tester.pumpAndSettle();
}

/// El campo de texto que está dentro del widget con la key indicada.
EditableText campoEn(WidgetTester tester, String nombreClave) => tester.widget<EditableText>(
      find.descendant(of: clave(nombreClave), matching: find.byType(EditableText)),
    );

/// Color con el que se pinta un texto en pantalla, venga de donde venga el estilo.
Color? colorDelTexto(WidgetTester tester, String texto) {
  final parrafo = tester.renderObject<RenderParagraph>(find.text(texto).first);
  return parrafo.text.style?.color;
}

/// Comprueba que `finder` mida lo indicado, con un punto de tolerancia.
void midaCerca(WidgetTester tester, Finder finder, {double? ancho, double? alto}) {
  final tamano = tester.getSize(finder.first);
  if (ancho != null) {
    expect(tamano.width, closeTo(ancho, 1), reason: 'El ancho de $finder');
  }
  if (alto != null) {
    expect(tamano.height, closeTo(alto, 1), reason: 'El alto de $finder');
  }
}
