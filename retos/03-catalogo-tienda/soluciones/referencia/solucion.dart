// Solución de referencia del reto 03. Es una forma de hacerlo, no la única.
import 'package:flutter/material.dart';

import '../../datos.dart';

void main() => runApp(const Reto());

const _fondo = Color(0xFFFAF7F2);
const _primario = Color(0xFF1D4ED8);
const _texto = Color(0xFF111827);
const _textoSuave = Color(0xFF6B7280);

String lempiras(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final entero = partes[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return 'L $entero.${partes[1]}';
}

class Reto extends StatelessWidget {
  const Reto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _primario, scaffoldBackgroundColor: _fondo),
      home: const Catalogo(),
    );
  }
}

class Catalogo extends StatefulWidget {
  const Catalogo({super.key});

  @override
  State<Catalogo> createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  String _categoria = 'Todo';
  int _enCarrito = 0;

  @override
  Widget build(BuildContext context) {
    final visibles = _categoria == 'Todo'
        ? productos
        : productos.where((p) => p.categoria == _categoria).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _fondo,
        title: const Text(
          'Tiendita Barrilete',
          style: TextStyle(fontWeight: FontWeight.w700, color: _texto),
        ),
        actions: [
          IconButton(
            tooltip: 'Carrito',
            onPressed: () {},
            icon: Badge(
              key: const Key('contador-carrito'),
              isLabelVisible: _enCarrito > 0,
              label: Text('$_enCarrito'),
              backgroundColor: const Color(0xFFDC2626),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                for (final c in categorias)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: c == _categoria,
                      onSelected: (_) => setState(() => _categoria = c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 260,
              ),
              itemCount: visibles.length,
              itemBuilder: (context, i) => _TarjetaProducto(
                producto: visibles[i],
                alAgregar: () => setState(() => _enCarrito++),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaProducto extends StatelessWidget {
  const _TarjetaProducto({required this.producto, required this.alAgregar});

  final Producto producto;
  final VoidCallback alAgregar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Color(producto.color),
              alignment: Alignment.center,
              child: const Icon(Icons.local_mall_outlined, size: 40, color: Color(0x99000000)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Text(
              producto.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _texto),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    lempiras(producto.precio),
                    style: const TextStyle(fontSize: 13, color: _textoSuave),
                  ),
                ),
                IconButton(
                  key: Key('agregar-${producto.id}'),
                  tooltip: 'Agregar ${producto.nombre}',
                  onPressed: alAgregar,
                  icon: const Icon(Icons.add_circle, color: _primario),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
