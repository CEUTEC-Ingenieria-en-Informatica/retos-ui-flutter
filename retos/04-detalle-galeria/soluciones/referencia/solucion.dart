// Solución de referencia del reto 04. Es una forma de hacerlo, no la única.
import 'package:flutter/material.dart';

void main() => runApp(const Reto());

const _fondo = Color(0xFFFFFFFF);
const _primario = Color(0xFF7C2D12);
const _texto = Color(0xFF1C1917);
const _textoSuave = Color(0xFF57534E);
const _estrella = Color(0xFFF59E0B);
const _fotos = [Color(0xFFF59E0B), Color(0xFF10B981), Color(0xFF3B82F6), Color(0xFFEC4899)];
const _precio = 590.0;

String lempiras(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final entero = partes[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return 'L $entero.${partes[1]}';
}

class Reto extends StatelessWidget {
  const Reto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _primario, scaffoldBackgroundColor: _fondo),
      home: const DetalleProducto(),
    );
  }
}

class DetalleProducto extends StatefulWidget {
  const DetalleProducto({super.key});

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  final _paginas = PageController();
  int _foto = 0;
  int _cantidad = 1;
  String _talla = 'Mediana';
  bool _favorito = false;

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  void _irA(int i) {
    _paginas.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 360,
              child: Stack(
                children: [
                  PageView.builder(
                    key: const Key('galeria'),
                    controller: _paginas,
                    itemCount: _fotos.length,
                    onPageChanged: (i) => setState(() => _foto = i),
                    itemBuilder: (context, i) => Container(
                      color: _fotos[i],
                      alignment: Alignment.center,
                      child: const Icon(Icons.backpack_outlined, size: 120, color: Colors.white),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton.filledTonal(
                            tooltip: 'Regresar',
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back),
                          ),
                          IconButton.filledTonal(
                            key: const Key('favorito'),
                            tooltip: _favorito ? 'Quitar de favoritos' : 'Marcar favorito',
                            onPressed: () => setState(() => _favorito = !_favorito),
                            icon: Icon(_favorito ? Icons.favorite : Icons.favorite_border),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      key: const Key('indicador-foto'),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0x99000000),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${_foto + 1} / ${_fotos.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  for (var i = 0; i < _fotos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        key: Key('miniatura-$i'),
                        onTap: () => _irA(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _fotos[i],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: i == _foto ? _primario : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mochila tejida',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _texto),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.star_rounded, color: _estrella, size: 20),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '4.8 (126 reseñas)',
                          style: TextStyle(color: _textoSuave),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lempiras(_precio),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _primario,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tejida a mano con hilo de algodón. Tiene bolsillo para la laptop, '
                    'correas acolchadas y aguanta la lluvia de la tarde.',
                    style: TextStyle(fontSize: 14, height: 1.5, color: _textoSuave),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Talla',
                    style: TextStyle(fontWeight: FontWeight.w600, color: _texto),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in ['Pequeña', 'Mediana', 'Grande'])
                        ChoiceChip(
                          label: Text(t),
                          selected: t == _talla,
                          onSelected: (_) => setState(() => _talla = t),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Cantidad',
                          style: TextStyle(fontWeight: FontWeight.w600, color: _texto),
                        ),
                      ),
                      IconButton.outlined(
                        key: const Key('menos'),
                        tooltip: 'Quitar una',
                        onPressed: () => setState(() {
                          if (_cantidad > 1) _cantidad--;
                        }),
                        icon: const Icon(Icons.remove),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$_cantidad',
                          key: const Key('cantidad'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton.outlined(
                        key: const Key('mas'),
                        tooltip: 'Agregar una',
                        onPressed: () => setState(() {
                          if (_cantidad < 10) _cantidad++;
                        }),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 56,
            child: FilledButton(
              key: const Key('boton-agregar'),
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: _primario,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Agregar · ${lempiras(_precio * _cantidad)}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
