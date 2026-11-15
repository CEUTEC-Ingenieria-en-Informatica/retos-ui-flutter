// Solución de referencia del reto 06. Es una forma de hacerlo, no la única.
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Reto());

const _fondo = Color(0xFFF7F5F0);
const _tarjeta = Color(0xFFFFFFFF);
const _texto = Color(0xFF292524);
const _textoSuave = Color(0xFF78716C);
const _barra = Color(0xFFD97706);
const _barraFuerte = Color(0xFF92400E);
const _colores = [Color(0xFFD97706), Color(0xFF65A30D), Color(0xFFDB2777), Color(0xFF0284C7)];

class Periodo {
  const Periodo({
    required this.ventas,
    required this.pedidos,
    required this.ticket,
    required this.etiquetas,
    required this.valores,
    required this.porcentajes,
  });

  final String ventas;
  final String pedidos;
  final String ticket;
  final List<String> etiquetas;
  final List<double> valores;
  final List<int> porcentajes;
}

const _categorias = ['Pan dulce', 'Pan salado', 'Repostería', 'Bebidas'];

const _semana = Periodo(
  ventas: 'L 48,250.00',
  pedidos: '312',
  ticket: 'L 154.65',
  etiquetas: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
  valores: [5200, 6100, 5800, 7400, 8900, 9650, 5200],
  porcentajes: [45, 30, 15, 10],
);

const _mes = Periodo(
  ventas: 'L 196,400.00',
  pedidos: '1,284',
  ticket: 'L 152.96',
  etiquetas: ['S1', 'S2', 'S3', 'S4'],
  valores: [45200, 47800, 52100, 51300],
  porcentajes: [42, 33, 17, 8],
);

class Reto extends StatelessWidget {
  const Reto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _barra, scaffoldBackgroundColor: _fondo),
      home: const PanelVentas(),
    );
  }
}

class PanelVentas extends StatefulWidget {
  const PanelVentas({super.key});

  @override
  State<PanelVentas> createState() => _PanelVentasState();
}

class _PanelVentasState extends State<PanelVentas> {
  bool _esMes = false;

  @override
  Widget build(BuildContext context) {
    final p = _esMes ? _mes : _semana;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _fondo,
        toolbarHeight: 72,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panel de ventas', style: TextStyle(fontWeight: FontWeight.w700, color: _texto)),
            Text('Panadería La Espiga', style: TextStyle(fontSize: 13, color: _textoSuave)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Semana', key: Key('periodo-semana'))),
              ButtonSegment(value: true, label: Text('Mes', key: Key('periodo-mes'))),
            ],
            selected: {_esMes},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _esMes = s.first),
          ),
          const SizedBox(height: 16),
          _Cifra(titulo: _esMes ? 'Ventas del mes' : 'Ventas de la semana', valor: p.ventas, grande: true),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Cifra(titulo: 'Pedidos', valor: p.pedidos)),
              const SizedBox(width: 12),
              Expanded(child: _Cifra(titulo: 'Ticket promedio', valor: p.ticket)),
            ],
          ),
          const SizedBox(height: 16),
          _Tarjeta(
            titulo: 'Ventas por día',
            child: SizedBox(
              key: const Key('grafica-barras'),
              height: 200,
              child: CustomPaint(
                painter: BarrasPainter(valores: p.valores, etiquetas: p.etiquetas),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Tarjeta(
            titulo: 'Qué se vende más',
            child: Row(
              children: [
                SizedBox(
                  key: const Key('grafica-dona'),
                  width: 160,
                  height: 160,
                  child: CustomPaint(painter: DonaPainter(porcentajes: p.porcentajes)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _categorias.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _colores[i],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${_categorias[i]} ${p.porcentajes[i]}%',
                                  style: const TextStyle(fontSize: 13, color: _texto),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Cifra extends StatelessWidget {
  const _Cifra({required this.titulo, required this.valor, this.grande = false});

  final String titulo;
  final String valor;
  final bool grande;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _tarjeta, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 13, color: _textoSuave)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              valor,
              style: TextStyle(
                fontSize: grande ? 28 : 20,
                fontWeight: FontWeight.w700,
                color: _texto,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _tarjeta, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600, color: _texto)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class BarrasPainter extends CustomPainter {
  BarrasPainter({required this.valores, required this.etiquetas});

  final List<double> valores;
  final List<String> etiquetas;

  @override
  void paint(Canvas canvas, Size size) {
    const altoEtiqueta = 20.0;
    final maximo = valores.reduce(math.max);
    final ancho = size.width / valores.length;
    final altoUtil = size.height - altoEtiqueta;
    for (var i = 0; i < valores.length; i++) {
      final alto = altoUtil * valores[i] / maximo;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(i * ancho + ancho * 0.2, altoUtil - alto, ancho * 0.6, alto),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );
      canvas.drawRRect(rect, Paint()..color = valores[i] == maximo ? _barraFuerte : _barra);
      final etiqueta = TextPainter(
        text: TextSpan(text: etiquetas[i], style: const TextStyle(fontSize: 11, color: _textoSuave)),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: ancho);
      etiqueta.paint(canvas, Offset(i * ancho + (ancho - etiqueta.width) / 2, altoUtil + 4));
    }
  }

  @override
  bool shouldRepaint(BarrasPainter oldDelegate) =>
      !listEquals(oldDelegate.valores, valores) || !listEquals(oldDelegate.etiquetas, etiquetas);
}

class DonaPainter extends CustomPainter {
  DonaPainter({required this.porcentajes});

  final List<int> porcentajes;

  @override
  void paint(Canvas canvas, Size size) {
    const grosor = 24.0;
    final lado = math.min(size.width, size.height) - grosor;
    final rect = Rect.fromCenter(center: size.center(Offset.zero), width: lado, height: lado);
    var inicio = -math.pi / 2;
    for (var i = 0; i < porcentajes.length; i++) {
      final barrido = 2 * math.pi * porcentajes[i] / 100;
      canvas.drawArc(
        rect,
        inicio,
        barrido - 0.04,
        false,
        Paint()
          ..color = _colores[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = grosor,
      );
      inicio += barrido;
    }
  }

  @override
  bool shouldRepaint(DonaPainter oldDelegate) => !listEquals(oldDelegate.porcentajes, porcentajes);
}
