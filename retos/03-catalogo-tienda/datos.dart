// Datos del reto 03. Podés usarlos desde tu solución con:
//   import '../../datos.dart';
// o copiarlos a tu carpeta. La tienda y los productos son inventados.

class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.color,
  });

  /// Va en la key del botón agregar: `Key('agregar-$id')`.
  final String id;
  final String nombre;
  final String categoria;

  /// En lempiras. Se muestra así: L 1,350.00
  final double precio;

  /// Color de fondo del recuadro de la foto (no hay fotos, es un bloque de color con un ícono).
  final int color;
}

const categorias = ['Todo', 'Ropa', 'Hogar', 'Accesorios'];

const productos = [
  Producto(id: 'camisa-manta', nombre: 'Camisa de manta', categoria: 'Ropa', precio: 450, color: 0xFFFDE68A),
  Producto(id: 'gorra-bordada', nombre: 'Gorra bordada', categoria: 'Accesorios', precio: 280, color: 0xFFBFDBFE),
  Producto(id: 'taza-barro', nombre: 'Taza de barro', categoria: 'Hogar', precio: 120, color: 0xFFFECACA),
  Producto(id: 'hamaca', nombre: 'Hamaca de colores', categoria: 'Hogar', precio: 1350, color: 0xFFBBF7D0),
  Producto(id: 'bolso-tule', nombre: 'Bolso de tule', categoria: 'Accesorios', precio: 390, color: 0xFFE9D5FF),
  Producto(id: 'vestido-bordado', nombre: 'Vestido bordado', categoria: 'Ropa', precio: 980, color: 0xFFFBCFE8),
];
