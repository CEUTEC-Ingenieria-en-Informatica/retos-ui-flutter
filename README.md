# Retos UI Flutter

Pantallas para armar en Flutter, de la más sencilla a la más pesada. Cada reto trae su especificación con medidas, colores y estados, un boceto, y pruebas que corren solas cuando mandás tu PR. Si sale verde, tu pantalla cumple.

Esto es de la comunidad estudiantil CEUTEC Ingeniería en Informática. No es una cuenta oficial de la universidad.

Todos los diseños son originales: las tiendas, las apps y las personas de los retos son inventadas.

## Los retos

| # | Reto | Nivel | Lo que vas a practicar |
|---|---|---|---|
| 01 | [Tarjeta de perfil](retos/01-tarjeta-perfil/) | inicial | `Stack`, `Row`, `Column`, un botón con dos estados |
| 02 | [Inicio de sesión](retos/02-inicio-sesion/) | inicial | `Form`, validación, mostrar y ocultar la contraseña |
| 03 | [Catálogo de tienda](retos/03-catalogo-tienda/) | intermedio | `GridView`, filtros, contador del carrito, precios en lempiras |
| 04 | [Detalle con galería](retos/04-detalle-galeria/) | intermedio | `PageView`, miniaturas, cantidad y total |
| 05 | [Bienvenida de tres pasos](retos/05-bienvenida-tres-pasos/) | intermedio | `PageView` con botones, estados del último paso |
| 06 | [Panel con gráficas](retos/06-panel-graficas/) | avanzado | `CustomPaint` para barras y dona, cambio de periodo |
| 07 | [Chat con burbujas](retos/07-chat-burbujas/) | avanzado | burbujas alineadas, ancho máximo, enviar mensajes |
| 08 | [Clima con modo oscuro](retos/08-clima-modo-oscuro/) | avanzado | `ThemeData` claro y oscuro, tema del sistema, lista horizontal |

## Cómo participar

Necesitás Flutter stable instalado ([guía oficial](https://docs.flutter.dev/get-started/install)). Las pruebas del repo corren con Flutter 3.47.9.

1. Hacé fork de este repo y clonalo en tu compu.
2. Dentro del repo corré `flutter pub get`.
3. Elegí un reto y creá tu carpeta con tu usuario de GitHub, tal cual:
   `retos/01-tarjeta-perfil/soluciones/tu-usuario/`
4. Copiá `plantilla/solucion.dart` a tu carpeta y armá ahí tu pantalla. Podés agregar más archivos `.dart` en tu carpeta.
5. Corré las pruebas de tu solución:

   ```bash
   dart run herramientas/generar_pruebas.dart --reto 01-tarjeta-perfil --usuario tu-usuario
   flutter test test/generado
   ```

6. Para verla en el navegador:

   ```bash
   flutter run -d chrome -t retos/01-tarjeta-perfil/soluciones/tu-usuario/solucion.dart
   ```

7. Cuando pase, hacé commit, push a tu fork y abrí el PR. Un PR por reto, así es más fácil revisarlo.

## Lo que piden las pruebas

Las pruebas no revisan cómo armaste la pantalla. Revisan lo que se ve y lo que se puede hacer:

1. Tu `solucion.dart` tiene una clase pública `Reto` con constructor sin parámetros obligatorios, y esa clase arma su propio `MaterialApp`.
2. Los textos salen igual que en la especificación, con tildes y signos.
3. Los widgets que el README del reto marca con una key la llevan, por ejemplo `Key('boton-seguir')`.
4. Las medidas que el reto marca como obligatorias se cumplen, con un punto de tolerancia.
5. Nada se desborda en un teléfono de 390 x 844 ni en uno chico de 360 x 640.

Lo demás (colores exactos, sombras, íconos, animaciones) se revisa a ojo en el PR. La especificación te dice qué buscamos.

Un detalle que te va a ahorrar un rato: en las pruebas de Flutter las letras se dibujan como cuadritos y salen más anchas que en tu teléfono. Si un texto largo va en un `Row`, metelo en `Expanded` o `Flexible`, o la prueba de desborde te va a marcar error aunque en tu compu se vea bien.

## Reglas de las soluciones

1. Solo tocás tu carpeta: `retos/<reto>/soluciones/<tu-usuario>/`. El check revisa que el nombre de la carpeta sea tu usuario.
2. En tu carpeta van archivos `.dart` y, si querés, un `README.md` contando cómo lo hiciste. Nada de imágenes ni binarios.
3. Solo Flutter y Dart, sin paquetes extra. No cambies `pubspec.yaml`.
4. Nada de copiar la pantalla de una app real. Si te inspirás en algo, contalo en tu README.
5. La solución de referencia está en `soluciones/referencia/`. Mirala si te trabás, pero intentalo primero.

## Cómo corre el check

El workflow [`revisar.yml`](.github/workflows/revisar.yml) clona Flutter desde el repo oficial en la versión fijada, mira qué archivos tocó tu PR y corre solo esos retos:

1. Si tocaste tu carpeta, corre las pruebas contra tu solución y contra la de referencia.
2. Si alguien cambia las pruebas de un reto, corren todas las soluciones de ese reto.
3. Siempre corre una contraprueba: la plantilla vacía tiene que fallar. Si pasara, las pruebas no servirían de nada.

El generador está en [`herramientas/generar_pruebas.dart`](herramientas/generar_pruebas.dart). Busca cada `solucion.dart`, arma un archivo en `test/generado/` que importa tu solución y le pasa las pruebas del reto.

## Galería

Quienes ya resolvieron cada reto. La tabla la actualiza quien mantiene el repo con `dart run herramientas/galeria.dart` después de aceptar los PR, así no chocan los cambios en este archivo.

<!-- galeria:inicio -->

Soluciones de la comunidad: 0. La de referencia de cada reto no se cuenta.

| Reto | Nivel | Soluciones | Quiénes |
|---|---|---|---|
| [Tarjeta de perfil](retos/01-tarjeta-perfil/) | inicial | 0 | Todavía nadie. ¡Estrená este reto! |
| [Inicio de sesión](retos/02-inicio-sesion/) | inicial | 0 | Todavía nadie. ¡Estrená este reto! |
| [Catálogo de tienda](retos/03-catalogo-tienda/) | intermedio | 0 | Todavía nadie. ¡Estrená este reto! |
| [Detalle con galería](retos/04-detalle-galeria/) | intermedio | 0 | Todavía nadie. ¡Estrená este reto! |
| [Bienvenida de tres pasos](retos/05-bienvenida-tres-pasos/) | intermedio | 0 | Todavía nadie. ¡Estrená este reto! |
| [Panel con gráficas](retos/06-panel-graficas/) | avanzado | 0 | Todavía nadie. ¡Estrená este reto! |
| [Chat con burbujas](retos/07-chat-burbujas/) | avanzado | 0 | Todavía nadie. ¡Estrená este reto! |
| [Clima con modo oscuro](retos/08-clima-modo-oscuro/) | avanzado | 0 | Todavía nadie. ¡Estrená este reto! |

<!-- galeria:fin -->

## Sobre este material

Los retos, las pruebas y las soluciones de referencia los escribió James V con ayuda de IA, y la comunidad los revisa. Si ves algo raro, abrí un issue.

Licencia [MIT](LICENSE).
