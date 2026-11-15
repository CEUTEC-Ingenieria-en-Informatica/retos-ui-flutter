// Solución de referencia del reto 08. Es una forma de hacerlo, no la única.
import 'package:flutter/material.dart';

void main() => runApp(const Reto());

const _acento = Color(0xFFF4A261);

final _claro = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFEAF4FB),
  colorScheme: ColorScheme.fromSeed(
    seedColor: _acento,
    brightness: Brightness.light,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF0B2545),
  ),
);

final _oscuro = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0B1320),
  colorScheme: ColorScheme.fromSeed(
    seedColor: _acento,
    brightness: Brightness.dark,
    surface: const Color(0xFF16213A),
    onSurface: const Color(0xFFE6EEF8),
  ),
);

class Reto extends StatefulWidget {
  const Reto({super.key});

  @override
  State<Reto> createState() => _RetoState();
}

class _RetoState extends State<Reto> {
  ThemeMode _modo = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _claro,
      darkTheme: _oscuro,
      themeMode: _modo,
      home: PantallaClima(
        alCambiarTema: (oscuroAhora) => setState(() {
          _modo = oscuroAhora ? ThemeMode.light : ThemeMode.dark;
        }),
      ),
    );
  }
}

class PantallaClima extends StatelessWidget {
  const PantallaClima({super.key, required this.alCambiarTema});

  final void Function(bool oscuroAhora) alCambiarTema;

  static const _horas = [
    ('9 a. m.', '16°', Icons.cloud_outlined),
    ('12 p. m.', '19°', Icons.wb_cloudy_outlined),
    ('3 p. m.', '20°', Icons.wb_sunny_outlined),
    ('6 p. m.', '18°', Icons.grain),
    ('9 p. m.', '14°', Icons.nightlight_outlined),
  ];

  static const _dias = [
    ('Lunes', 'Soleado', '23° / 13°'),
    ('Martes', 'Nublado', '20° / 12°'),
    ('Miércoles', 'Tormenta', '18° / 11°'),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final oscuro = tema.brightness == Brightness.dark;
    final texto = tema.colorScheme.onSurface;
    final suave = texto.withValues(alpha: 0.7);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: tema.scaffoldBackgroundColor,
        foregroundColor: texto,
        title: const Text('Cielito'),
        actions: [
          IconButton(
            key: const Key('cambiar-tema'),
            tooltip: oscuro ? 'Pasar a modo claro' : 'Pasar a modo oscuro',
            onPressed: () => alCambiarTema(oscuro),
            icon: Icon(oscuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('La Esperanza, Intibucá', style: TextStyle(fontSize: 16, color: suave)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '17°',
                style: TextStyle(fontSize: 72, fontWeight: FontWeight.w300, color: texto),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.grain, color: _acento, size: 32),
                    Text('Llovizna', style: TextStyle(fontSize: 18, color: texto)),
                    Text('Máx 21° · Mín 12°', style: TextStyle(fontSize: 13, color: suave)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Tarjeta(
            child: Row(
              children: [
                _Detalle(icono: Icons.water_drop_outlined, nombre: 'Humedad', valor: '84%'),
                _Detalle(icono: Icons.air, nombre: 'Viento', valor: '9 km/h'),
                _Detalle(icono: Icons.umbrella_outlined, nombre: 'Lluvia', valor: '60%'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Hoy por hora', style: TextStyle(fontWeight: FontWeight.w600, color: texto)),
          const SizedBox(height: 8),
          SizedBox(
            key: const Key('pronostico-horas'),
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _horas.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final (hora, grados, icono) = _horas[i];
                return _Tarjeta(
                  ancho: 84,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(child: Text(hora, style: TextStyle(fontSize: 12, color: suave))),
                      Icon(icono, color: _acento),
                      Text(grados, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: texto)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text('Próximos días', style: TextStyle(fontWeight: FontWeight.w600, color: texto)),
          const SizedBox(height: 8),
          _Tarjeta(
            child: Column(
              children: [
                for (final (dia, estado, rango) in _dias)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(child: Text(dia, style: TextStyle(color: texto))),
                        Expanded(child: Text(estado, style: TextStyle(color: suave))),
                        Text(rango, style: TextStyle(color: texto)),
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

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.child, this.ancho});

  final Widget child;
  final double? ancho;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class _Detalle extends StatelessWidget {
  const _Detalle({required this.icono, required this.nombre, required this.valor});

  final IconData icono;
  final String nombre;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).colorScheme.onSurface;
    return Expanded(
      child: Column(
        children: [
          Icon(icono, color: _acento),
          const SizedBox(height: 4),
          FittedBox(child: Text(valor, style: TextStyle(fontWeight: FontWeight.w600, color: texto))),
          FittedBox(child: Text(nombre, style: TextStyle(fontSize: 12, color: texto.withValues(alpha: 0.7)))),
        ],
      ),
    );
  }
}
