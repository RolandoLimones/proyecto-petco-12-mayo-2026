A continuación se presenta el documento técnico-visual completo para la implementación de la aplicación **PetcoGestionApp**, desarrollada con **Flutter** multiplataforma (Android, iOS, Web, Windows) utilizando **Antigravity** como entorno de desarrollo principal. El documento está estructurado como una guía exhaustiva para que otra inteligencia artificial pueda construir el proyecto desde cero, sin asumir nada implícito y sin incluir código. Se describen todos los aspectos: diseño visual, arquitectura de archivos, flujos de navegación, integración con Firebase Firestore (proyecto en modo prueba), manejo de datos basado en las tablas SQL proporcionadas, experiencia de usuario, assets, dependencias conceptuales y mucho más.

---

## 1. Identidad visual y diseño general

La aplicación debe transmitir modernidad, limpieza y confianza, utilizando una paleta basada en **azul pastel** y **rojo pastel** como colores principales, complementados con efectos de **glassmorphism** (transparencias, desenfoques, bordes sutiles y sombras ligeras). El diseño debe adaptarse a móvil, web y escritorio manteniendo coherencia visual.

### 1.1 Paleta de colores exacta
- **Azul pastel principal**: `#A3C6F2` (fondo de tarjetas, botones secundarios, acentos).
- **Azul pastel oscuro** (para contraste): `#6EA8FE` (bordes, iconos activos, enlaces).
- **Rojo pastel principal**: `#F9B5AC` (botones de acción principal, alertas, elementos destacados).
- **Rojo pastel oscuro** (hover o presión): `#F48B7A` (estados de error o advertencia).
- **Fondo general**: `#F4F7FC` (gris muy claro con ligero tono azulado).
- **Fondo de elementos glassmorphism**: blanco con opacidad `0.65` y desenfoque `10px`.
- **Texto principal**: `#1E2A3A` (gris azulado oscuro).
- **Texto secundario**: `#5A6E7F` (gris azulado medio).
- **Bordes y líneas divisorias**: `#D0DFF0` (muy sutil).
- **Sombras**: `#A3C6F2` con opacidad `0.2` y desenfoque `12px`.

### 1.2 Efectos glassmorphism (aplicar en tarjetas, menús laterales, barras inferiores)
- **Fondo**: blanco o color claro con `opacidad 0.7`.
- **Desenfoque (blur)**: `10px` a `16px` dependiendo del elemento.
- **Borde**: `1px` sólido con color blanco semi-transparente (`#FFFFFF 0.3`).
- **Sombra exterior**: ligera, con desplazamiento vertical `4px` y radio `20px`.
- **Esquinas redondeadas**: `16px` para tarjetas grandes, `24px` para modales, `8px` para botones.

### 1.3 Tipografía
- **Familia principal**: `Poppins` (moderna, redondeada, legible) o `Inter` como alternativa.
- **Pesos**: `Regular (400)` para cuerpo de texto, `Medium (500)` para subtítulos, `SemiBold (600)` para títulos, `Bold (700)` para botones y encabezados principales.
- **Tamaños base**: 
  - Texto pequeño: `12px`
  - Texto normal: `14px`
  - Subtítulos: `18px`
  - Títulos de sección: `22px`
  - Títulos de pantalla: `28px`

### 1.4 Espaciado y layout
- **Grid base**: 8 píxeles (márgenes, paddings, gaps).
- **Márgenes laterales en móvil**: `16px`.
- **Márgenes laterales en web/escritorio**: `24px` (con un ancho máximo de contenido de `1200px` centrado).
- **Separación entre tarjetas**: `16px`.
- **Iconos**: tamaño `20px` o `24px`, con trazo fino (stroke 1.5) y esquinas redondeadas.

### 1.5 Ejemplo visual por pantalla (descripción sin código)

**Pantalla principal (home)**:
- Barra superior con logo a la izquierda (fondo glassmorphism), buscador centrado o a la derecha (campo con borde redondeado y efecto de desenfoque), icono de carrito y perfil.
- Carrusel de banners promocionales con imágenes de mascotas, usando indicadores circulares en azul pastel.
- Grid de categorías (3 columnas en móvil, 6 en web) con iconos y texto bajo cada una.
- Sección "Productos destacados": lista horizontal desplazable, cada tarjeta muestra imagen, nombre, precio, botón de favorito (corazón rojo pastel) y botón "Agregar" (azul pastel).
- Sección "Mascotas en adopción/venta": similar a productos pero con información de especie, edad y sexo.
- Barra inferior (para móvil) con 5 iconos: Inicio, Catálogo (mascotas+productos), Carrito, Citas, Perfil.

**Pantalla de detalle de producto**:
- Imagen grande con fondo glassmorphism y sombra.
- Título, precio, descripción, selector de cantidad (botones + y - con fondo rojo pastel suave).
- Botón principal "Añadir al carrito" (fondo rojo pastel, texto blanco, esquinas redondeadas de 30px, sombra ligera).
- Sección "Especificaciones" con etiquetas azul pastel.
- Botón de favoritos (corazón animable).

**Pantalla de citas**:
- Calendario visual (estilo semana o mes) con fechas destacadas en rojo pastel.
- Lista de citas agendadas (cada una como tarjeta glassmorphism mostrando servicio, mascota, fecha, hora y estado).
- Botón flotante (FAB) redondo con icono de más (rojo pastel) para crear nueva cita.
- Formulario de nueva cita: campos desplegables (servicio, mascota, sucursal), selector de fecha y hora (con interfaz nativa de cada plataforma), campo de notas, botón "Agendar" (azul pastel).

**Pantalla de carrito**:
- Lista de productos con imagen, nombre, precio unitario, cantidad modificable (+/-), botón eliminar (basurero).
- Resumen de compra (subtotal, impuestos, descuento, total) con texto alineado a la derecha.
- Botón "Proceder al pago" (rojo pastel) que lleva a la pantalla de selección de método de pago (simulado, sin pasarela real).
- Botón "Seguir comprando" (azul pastel con borde).

**Todos los formularios** deben tener campos con bordes redondeados de 12px, fondo blanco semi-transparente, etiquetas flotantes o dentro del campo, y mensajes de error en rojo pastel oscuro debajo del campo.

---

## 2. Arquitectura de carpetas del proyecto Flutter

Estructura completa del proyecto (explicación fuera de la lista). **Nota**: la siguiente es solo la jerarquía de carpetas y archivos, sin explicaciones dentro de ella.

```
lib/
  main.dart
  firebase_options.dart
  config/
    app_constants.dart
    firebase_config.dart
  models/
    cliente_model.dart
    mascota_model.dart
    categoria_model.dart
    proveedor_model.dart
    producto_model.dart
    sucursal_model.dart
    empleado_model.dart
    pedido_model.dart
    detalle_pedido_model.dart
    servicio_model.dart
    cita_model.dart
    inventario_model.dart
  views/
    splash_screen.dart
    welcome_screen.dart
    login_screen.dart
    register_screen.dart
    forgot_password_screen.dart
    home_screen.dart
    catalog/
      mascotas_catalog_screen.dart
      productos_catalog_screen.dart
      detalle_mascota_screen.dart
      detalle_producto_screen.dart
    cart/
      cart_screen.dart
      checkout_screen.dart
    favorites/
      favorites_screen.dart
    profile/
      profile_screen.dart
      edit_profile_screen.dart
      purchase_history_screen.dart
    appointments/
      appointments_screen.dart
      new_appointment_screen.dart
      appointment_detail_screen.dart
    admin/
      admin_dashboard_screen.dart
      manage_mascotas_screen.dart
      manage_productos_screen.dart
      manage_citas_screen.dart
    search/
      search_screen.dart
      filters_widget.dart
  widgets/
    common/
      glass_card.dart
      glass_button.dart
      glass_app_bar.dart
      glass_bottom_nav_bar.dart
      loading_indicator.dart
      error_widget.dart
      empty_state_widget.dart
      custom_text_field.dart
      rating_stars.dart
    catalog/
      product_card.dart
      mascota_card.dart
      category_grid.dart
      horizontal_product_list.dart
    cart/
      cart_item_card.dart
      cart_summary.dart
    appointments/
      calendar_widget.dart
      appointment_card.dart
    navigation/
      custom_drawer.dart
      main_navigation.dart
  controllers/
    auth_controller.dart
    user_controller.dart
    product_controller.dart
    mascota_controller.dart
    cart_controller.dart
    favorites_controller.dart
    appointments_controller.dart
    order_controller.dart
    search_controller.dart
    admin_controller.dart
  services/
    firestore_service.dart
    auth_service.dart
    storage_service.dart (para imágenes)
    notification_service.dart (local)
    location_service.dart (opcional)
  state/   (manejo de estado con Provider o Riverpod)
    providers/
      auth_provider.dart
      cart_provider.dart
      favorites_provider.dart
      theme_provider.dart
      appointments_provider.dart
  navigation/
    app_router.dart
    routes.dart
  utils/
    validators.dart
    formatters.dart
    date_helpers.dart
    constants.dart
    theme_data.dart
    glassmorphism_effects.dart
  assets/
    images/
      logo.png
      placeholder.png
      banner1.jpg
      ...
    icons/
      custom_icons.dart (si se usa iconfont)
    fonts/
      Poppins-Regular.ttf
      Poppins-Medium.ttf
      Poppins-SemiBold.ttf
      Poppins-Bold.ttf
    animations/
      loading_animation.json (Lottie)
  firebase/
    collections.dart   (nombres de colecciones como constantes)
    helpers/
      firebase_helpers.dart
```

### 2.1 Explicación detallada de cada carpeta y archivo

- **main.dart**: Punto de entrada de la aplicación. Se encarga de inicializar Firebase (usando `firebase_options.dart`), configurar el enrutador global, y definir el widget principal que envuelve la app con los proveedores de estado (Provider/Riverpod) y el tema visual.

- **firebase_options.dart**: Archivo generado automáticamente por FlutterFire CLI. Contiene la configuración específica del proyecto Firebase (claves, IDs de proyecto, etc.) para cada plataforma (Android, iOS, Web, Windows). Este archivo nunca debe editarse manualmente.

- **config/**: Contiene archivos con valores fijos y configuración global.
  - `app_constants.dart`: Define nombres de colecciones de Firestore (como 'clientes', 'mascotas', 'productos'), claves para almacenamiento local (SharedPreferences), URLs de términos y condiciones, etc.
  - `firebase_config.dart`: Inicializa Firebase y exporta instancias de Firestore, Auth y Storage. Incluye lógica para verificar si el modo prueba está activo y registrar advertencias en consola.

- **models/**: Clases que representan la estructura de los documentos en Firestore. Cada modelo tiene:
  - Atributos con tipos de Dart.
  - Constructor vacío y constructor desde un mapa (`fromFirestore`).
  - Método `toMap()` para enviar datos a Firestore.
  - Validaciones básicas (ej. email no vacío, precio positivo).
  - Cada modelo corresponde directamente a una de las tablas SQL proporcionadas (cliente, mascota, etc.) pero adaptado al modelo NoSQL de Firestore. Por ejemplo, en lugar de claves foráneas, se almacenan referencias (IDs) como strings.

- **views/**: Pantallas completas organizadas por módulo. Cada pantalla es un `StatefulWidget` o `ConsumerWidget` (si se usa Riverpod). Incluyen únicamente la estructura visual y llaman a métodos de los controladores para acciones de negocio. No contienen lógica de acceso a datos.

- **widgets/**: Componentes reutilizables. Subcarpetas para agrupar por función.
  - `common/`: Elementos genéricos como tarjetas glassmorphism, botones con efectos, barras de navegación personalizadas, indicadores de carga, mensajes de error, campos de texto estilizados, etc.
  - `catalog/`: Tarjetas específicas para mostrar productos o mascotas en grids o listas.
  - `cart/`: Componentes del carrito (fila de producto, resumen de compra).
  - `appointments/`: Calendario visual (puede usar un paquete externo), tarjeta de cita.
  - `navigation/`: Drawer lateral personalizado (con efecto glassmorphism) y widget de navegación principal que decide si mostrar bottom bar o drawer según la plataforma.

- **controllers/**: Capa de lógica de negocio. Cada controlador contiene métodos para:
  - Leer/escribir datos desde Firestore (usando los servicios).
  - Transformar datos de modelos a mapas.
  - Manejar estado local (por ejemplo, mantener lista de productos en memoria).
  - Validaciones complejas.
  - Comunicación entre pantallas (usando notificadores como ChangeNotifier o StateNotifierProvider).
  - Ejemplo: `cart_controller` gestiona agregar, eliminar, actualizar cantidades y calcular totales.

- **services/**: Abstracción de servicios externos.
  - `firestore_service.dart`: Contiene métodos genéricos para operaciones CRUD (crear, leer, actualizar, eliminar) sobre cualquier colección. También incluye consultas con filtros, ordenamientos y límites. Maneja errores de permisos (modo prueba) y conexión.
  - `auth_service.dart`: Wrapper sobre Firebase Auth. Provee métodos para registro con email/contraseña, inicio de sesión, cierre de sesión, restablecimiento de contraseña, verificación de email, y persistencia de sesión. También escucha cambios en el estado de autenticación.
  - `storage_service.dart`: Subir imágenes a Firebase Storage (fotos de mascotas, productos, perfil). Devuelve URLs públicas. Maneja compresión de imágenes antes de subir.
  - `notification_service.dart`: Notificaciones locales (usando un paquete como flutter_local_notifications) para recordatorios de citas, carrito abandonado, etc.
  - `location_service.dart`: (Opcional) Obtiene ubicación del usuario para sugerir sucursales cercanas.

- **state/**: Manejo de estado global. Se recomienda usar **Riverpod** por su simplicidad y compatibilidad con Firebase. Los providers se separan en archivos:
  - `auth_provider.dart`: Expone el usuario actual (null si no autenticado), estado de carga, errores.
  - `cart_provider.dart`: Lista de items en carrito, totales, persistencia local (SharedPreferences) para mantener carrito entre sesiones.
  - `favorites_provider.dart`: Conjunto de IDs de productos/mascotas favoritos.
  - `theme_provider.dart`: Alternancia entre tema claro/oscuro (aunque el diseño base es claro con glassmorphism).
  - `appointments_provider.dart`: Lista de citas, filtros, estado de carga.

- **navigation/**: Define el sistema de rutas.
  - `app_router.dart`: Configura rutas nombradas (ej. '/home', '/product/:id') y transiciones animadas (deslizamiento hacia la derecha o fade). Usa el paquete `go_router` que es declarativo y compatible con web (URLs).
  - `routes.dart`: Constantes con los nombres de las rutas para evitar errores tipográficos.

- **utils/**: Funciones auxiliares que no pertenecen a ninguna capa específica.
  - `validators.dart`: Validadores de email, teléfono, contraseña fuerte (mínimo 6 caracteres), fechas.
  - `formatters.dart`: Formateo de moneda (pesos mexicanos o dólares), fechas legibles, truncado de texto.
  - `date_helpers.dart`: Conversión entre DateTime y Timestamp de Firestore, cálculo de edad de mascotas.
  - `constants.dart`: Valores como el IVA (16%), porcentaje de descuento máximo, etc.
  - `theme_data.dart`: Configuración completa del tema de Material (colores, tipografía, formas de esquinas, sombras) aplicando la paleta pastel y efectos glassmorphism donde sea posible.
  - `glassmorphism_effects.dart`: Clases que aplican decoraciones con blur, transparencia y bordes, reutilizables en cualquier widget.

- **assets/**: Archivos estáticos.
  - `images/`: Logo, placeholders, banners, fotos de muestra para desarrollo. En producción, las imágenes reales se suben a Firebase Storage.
  - `icons/`: Si se utiliza una fuente de iconos personalizada (ej. IconFont), se define una clase Dart con los puntos de código.
  - `fonts/`: Archivos de fuentes .ttf o .otf registrados en `pubspec.yaml`.
  - `animations/`: Animaciones en formato JSON de Lottie (loading, éxito, error, etc.).

- **firebase/**: Organización adicional para Firestore.
  - `collections.dart`: Define constantes con los nombres exactos de las colecciones en Firestore (ej. `clientes`, `mascotas`, `productos`). Evita cadenas escritas manualmente en el código.
  - `helpers/firebase_helpers.dart`: Funciones para convertir Timestamp a DateTime, manejo de transacciones, lotes (batch writes) para actualizar múltiples documentos de forma atómica, y funciones de consulta optimizada (como paginación con `startAfter`).

---

## 3. Relación entre las tablas SQL adjuntas y Firestore

Las tablas proporcionadas (`cliente`, `mascota`, `categoria`, `proveedor`, `producto`, `sucursal`, `empleado`, `pedido`, `detalle_pedido`, `servicio`, `cita`, `inventario`) son la base del modelo relacional. En Firestore (NoSQL) se adaptan de la siguiente manera:

- Cada tabla se convierte en una **colección** raíz, excepto aquellas que naturalmente son subcolecciones de otra entidad.
- Las **claves foráneas** (ej. `cliente_id` en `mascota`) se representan como un campo de tipo `string` que contiene el ID del documento padre. No se usan referencias nativas de Firestore por simplicidad y compatibilidad con consultas.
- Las relaciones **uno a muchos** (un cliente tiene muchas mascotas) se mantienen como una colección `mascotas` con un campo `cliente_id`. No se anidan subcolecciones para evitar límites de tamaño y complejidad en consultas.
- Las relaciones **muchos a muchos** (productos en un pedido) se manejan con una colección `detalles_pedido` que referencia a `pedido_id` y `producto_id`.
- El campo `categoria_padre_id` (auto-relación) se implementa como un string opcional que apunta al ID de otra categoría. Las consultas recursivas se evitan trayendo todas las categorías y construyendo el árbol en el cliente.

**Estructura de colecciones en Firestore** (nombres en plural):

- `clientes` : documentos con los campos del SQL (`nombre`, `email`, `telefono`, `fecha_nacimiento`, `tipo_membresia`, `activo`, etc.) más campos adicionales como `foto_url`, `favoritos` (array de IDs de productos/mascotas), `carrito` (array de objetos temporales o colección separada).
- `mascotas` : documentos con `cliente_id`, `nombre`, `especie`, `raza`, `sexo`, `fecha_nacimiento`, `peso_kg`, `foto_url`, `notas_medicas`.
- `categorias` : documentos con `nombre`, `descripcion`, `categoria_padre_id`, `imagen_url`, `activo`.
- `proveedores` : documentos con `nombre`, `contacto_nombre`, `email`, `telefono`, `pais`, `rfc`, `activo`.
- `productos` : documentos con `categoria_id`, `proveedor_id`, `nombre`, `descripcion`, `codigo_barras`, `precio`, `precio_costo`, `especie_objetivo`, `imagen_url`, `activo`.
- `sucursales` : documentos con `nombre`, `direccion`, `ciudad`, `estado`, `telefono`, `horario`, `latitud`, `longitud`, `activo`.
- `empleados` : documentos con `sucursal_id`, `nombre`, `cargo`, `email`, `telefono`, `fecha_contrato`, `salario`, `activo`.
- `pedidos` : documentos con `cliente_id`, `empleado_id`, `sucursal_id`, `fecha_pedido`, `subtotal`, `impuesto`, `descuento`, `total`, `estado`, `canal`, `metodo_pago`.
- `detalles_pedido` : documentos con `pedido_id`, `producto_id`, `cantidad`, `precio_unitario`, `descuento`, `subtotal`.
- `servicios` : documentos con `nombre`, `descripcion`, `precio`, `duracion_min`, `tipo`, `especie_objetivo`, `activo`.
- `citas` : documentos con `cliente_id`, `mascota_id`, `servicio_id`, `empleado_id`, `sucursal_id`, `fecha_hora`, `estado`, `precio_cobrado`, `notas`.
- `inventario` : documentos con `producto_id`, `sucursal_id`, `cantidad`, `stock_minimo`, `stock_maximo`, `ultima_actualizacion`. La combinación `producto_id + sucursal_id` es única gracias a una regla de Firestore (índice compuesto).

**Flujo de información entre colecciones**:
- Cuando un cliente agrega un producto al carrito, se crea un documento temporal en una subcolección `carrito` dentro del cliente, o se usa el estado local del provider. Al finalizar la compra, se crea un documento en `pedidos` y múltiples documentos en `detalles_pedido`.
- Una cita verifica disponibilidad del servicio y empleado. Se consulta `empleados` por sucursal y horario, y se valida que no exista otra cita en la misma fecha_hora para ese empleado (usando consultas con filtros).
- El inventario se actualiza cuando se realiza un pedido (restar cantidad) o cuando se recibe una reposición (desde un panel administrativo). La actualización debe hacerse en una transacción (batch) para evitar inconsistencias.
- Las consultas de productos suelen unir información de categorías y proveedores leyendo los documentos por separado (no hay joins reales). Se recomienda desnormalizar algunos campos como el nombre de la categoría dentro del producto para evitar lecturas adicionales, pero dado el modo prueba y naturaleza académica, se pueden hacer múltiples lecturas.

---

## 4. Integración con Firebase (proyecto PetcoGestionApp en modo prueba)

### 4.1 Configuración inicial dentro de Flutter

Al iniciar la aplicación, el archivo `main.dart` debe ejecutar `WidgetsFlutterBinding.ensureInitialized()`, luego `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` usando las opciones generadas en `firebase_options.dart`. Después de inicializar, se debe verificar que Firestore esté disponible (modo prueba permitirá cualquier operación, pero sin reglas de seguridad). Para propósitos de desarrollo, se puede agregar un mensaje en consola indicando que la app está en modo prueba.

La conexión con Firestore se centraliza en `FirestoreService`. Este servicio expone métodos genéricos como `getCollection(collectionName)`, `getDocument(collectionName, docId)`, `addDocument`, `updateDocument`, `deleteDocument`, y métodos específicos como `getProductsByCategory(categoryId)`, `getMascotasByCliente(clienteId)`, etc. Internamente usa la instancia de `FirebaseFirestore.instance`.

### 4.2 Estrategias de lectura y escritura

- **Lectura única** (`get`): Para listas que no cambian frecuentemente (catálogo de productos, lista de sucursales). Los resultados se almacenan en caché local automáticamente por Firestore, lo que mejora la experiencia offline limitada.
- **Escuchas en tiempo real** (`snapshots`): Para datos que deben actualizarse en la interfaz inmediatamente, como el carrito compartido entre dispositivos (no es necesario en modo prueba académico, pero útil para notificaciones de citas). Se usan con `StreamBuilder` en las vistas correspondientes.
- **Escritura**: Todas las operaciones de creación, actualización o eliminación se realizan a través de los controladores, que llaman al `FirestoreService` y manejan errores (por ejemplo, permisos insuficientes en modo prueba rara vez ocurren, pero puede haber errores de red).
- **Transacciones y lotes**: Para operaciones que afectan múltiples documentos (ej. crear un pedido y actualizar inventario), se usa `FirebaseFirestore.instance.runTransaction` o `WriteBatch`. Esto asegura consistencia aunque el modo prueba no tenga reglas estrictas.

### 4.3 Autenticación y persistencia de sesión

Firebase Auth se utiliza con el método de **correo electrónico y contraseña**. El `AuthService` expone:
- `signUp(email, password, nombre, ...)`: crea el usuario en Auth y luego crea un documento en la colección `clientes` con el mismo UID como ID del documento. Esto permite vincular fácilmente.
- `signIn(email, password)`: inicia sesión y retorna el usuario.
- `signOut()`: cierra sesión y limpia el estado local.
- `resetPassword(email)`: envía correo de restablecimiento.
- `authStateChanges`: un stream que notifica cambios de autenticación. En el `main.dart`, se escucha este stream para redirigir a la pantalla de login si el usuario es null, o al home si está autenticado.

La persistencia de sesión se maneja automáticamente por Firebase Auth en todas las plataformas. No se necesita almacenamiento adicional. El modo prueba no limita la autenticación, pero las cuentas creadas son válidas y persisten.

### 4.4 Manejo de errores comunes en modo prueba

- **Error de permisos (Missing or insufficient permissions)**: En modo prueba, las reglas de Firestore están abiertas (`allow read, write: if true;`), por lo que este error no debería aparecer. Sin embargo, si se cambia accidentalmente a reglas restringidas, la app mostrará un diálogo amigable: "Error de conexión con el servidor. Contacta al administrador."
- **Error de red**: Se captura con try-catch en cada llamada a Firestore. Se muestra una tarjeta con mensaje "Sin conexión a internet" y un botón "Reintentar".
- **Documento no existe**: Se maneja retornando null en el servicio, y la vista muestra un `EmptyStateWidget`.
- **Límites de consultas**: En modo prueba no hay restricciones, pero para buenas prácticas se implementa paginación con `limit(20)` y `startAfter` para listas largas (productos, mascotas).

### 4.5 Estructura de colecciones y nomenclatura

- Todas las colecciones se nombran en **plural** y **minúsculas**, usando guiones bajos para separar palabras: `clientes`, `mascotas`, `detalles_pedido`.
- Los IDs de los documentos se generan automáticamente con `doc().id` excepto para `clientes`, donde se usa el UID de Firebase Auth para facilitar las consultas.
- Campos dentro de los documentos: usan `camelCase` (ej. `fechaNacimiento`) por convención de Firestore.
- Para evitar problemas con mayúsculas/minúsculas, todos los strings de búsqueda (emails, códigos de barras) se almacenan en minúsculas y se normalizan al escribir.

### 4.6 Organización visual dentro de Firebase Console

En Firebase Console, dentro del proyecto **PetcoGestionApp**, se deben crear las colecciones mencionadas. Para una fácil navegación durante el desarrollo:
- Se pueden añadir documentos de ejemplo (un cliente, algunos productos, una sucursal, etc.) usando la interfaz web.
- Es útil crear **índices compuestos** para consultas que involucren dos o más campos (por ejemplo, filtrar productos por `categoria_id` y `activo`). Firebase Console pedirá crearlos automáticamente al ejecutar la consulta desde la app.
- Las reglas de Firestore se dejarán en modo prueba (`true`) durante todo el desarrollo, sin necesidad de modificarlas. Para evitar escrituras accidentales, se puede implementar una validación adicional en los controladores (por ejemplo, no permitir eliminar un producto si tiene pedidos asociados).

---

## 5. Flujo completo de funcionamiento de la aplicación

### 5.1 Inicio de la aplicación (splash y bienvenida)

- Al abrir la app, se muestra una pantalla de **splash** con el logo centrado, fondo blanco o azul pastel muy suave, y una animación de desvanecimiento (fade in/out) o una animación Lottie de una huella de mascota. Duración aproximada: 1.5 segundos.
- Después, se evalúa el estado de autenticación. Si el usuario ya inició sesión previamente (token válido de Firebase), se navega directamente al **home**. Si no, se muestra la **pantalla de bienvenida**.
- La pantalla de bienvenida contiene una imagen o ilustración central (ej. un perro y un gato), dos botones grandes: "Iniciar sesión" (rojo pastel) y "Registrarse" (azul pastel con borde). También un enlace "Continuar como invitado" que permite explorar productos y mascotas pero sin acceder a carrito, citas o perfil.

### 5.2 Registro de nuevo usuario

Pantalla de registro:
- Campos: nombre completo, email, teléfono (opcional), contraseña (mínimo 6 caracteres), confirmar contraseña.
- Cada campo con validación en tiempo real (mientras escribe, se muestra error si no cumple).
- Botón "Registrarse" (rojo pastel). Al presionar, el controlador llama a `AuthService.signUp` y, si tiene éxito, crea el documento en Firestore en la colección `clientes` con los mismos datos y el campo `fecha_registro` automático, `tipo_membresia` = 'estandar', `activo` = true.
- Después del registro, se inicia sesión automáticamente y se navega al home. Se muestra un mensaje flotante (Snackbar) de éxito: "¡Bienvenido a PetcoGestionApp!".

### 5.3 Inicio de sesión y recuperación de contraseña

- **Login**: Email y contraseña. Botón "Entrar". Validación básica. Si las credenciales son incorrectas, se muestra un diálogo con mensaje de error. También hay un enlace "¿Olvidaste tu contraseña?" que lleva a la pantalla de recuperación.
- **Recuperación**: Campo de email. Botón "Enviar enlace de restablecimiento". Se llama a `AuthService.resetPassword`. Firebase envía un correo al usuario. Se muestra un mensaje informativo: "Revisa tu bandeja de entrada". No es necesario manejar más lógica en la app, pues el flujo es externo.

### 5.4 Página principal (home)

Una vez autenticado, el home consta de:
- **AppBar** con efecto glassmorphism: logo a la izquierda, campo de búsqueda (lupa) que al hacer clic lleva a la pantalla de búsqueda completa, icono de notificaciones (campana) y avatar del usuario (redondo). Al tocar el avatar, se abre un menú desplegable con opciones: Perfil, Mis compras, Mis citas, Favoritos, Cerrar sesión.
- **Cuerpo desplazable (scroll vertical)**:
  - Carrusel de banners (altura 180px en móvil, 220px en web). Cada banner es una imagen con texto superpuesto (ej. "20% en alimentos").
  - Cuadrícula de categorías: máximo 6 categorías principales mostradas como círculos o tarjetas pequeñas con icono y nombre. Al hacer clic, se navega al catálogo de productos filtrado por esa categoría.
  - Lista horizontal "Productos destacados": se obtienen los productos con campo `destacado = true` (campo extra que se puede agregar al modelo). Cada tarjeta muestra imagen, nombre, precio y un ícono de corazón para favoritos.
  - Lista horizontal "Mascotas en adopción/venta": se obtienen las mascotas que tienen `en_adopcion = true` (campo adicional). Muestra nombre, especie, edad estimada.
- **BottomNavigationBar** (móvil) con 5 elementos: Inicio, Catálogo (que a su vez permite alternar entre productos y mascotas), Carrito (con badge numérico de cantidad de items), Citas, Perfil. En web/escritorio, se usa un NavigationRail (barra lateral izquierda) o un Drawer, según convención.

### 5.5 Catálogos (productos y mascotas)

- **Productos**: Pantalla con un `TabBar` superior o dos pestañas: "Productos" y "Mascotas". Por defecto, "Productos". Muestra un grid de 2 columnas en móvil, 4 en web. Cada tarjeta incluye imagen, nombre, precio, botón de favorito, y un botón "+" (agregar al carrito) o un ícono de carrito. Filtros: un botón "Filtrar" (icono de embudo) que abre una hoja modal (bottom sheet) con opciones de categoría, especie objetivo (perro, gato, etc.), rango de precio, etc.
- **Mascotas**: Grid similar, pero cada tarjeta muestra nombre, especie, raza, sexo (ícono), edad y un botón "Adoptar/Comprar" que lleva al detalle.
- **Búsqueda avanzada**: Al escribir en el campo de búsqueda global (en AppBar), se muestra una pantalla con resultados en tiempo real (mientras escribe). Los resultados incluyen tanto productos como mascotas, agrupados por tipo. También hay filtros persistentes (ordenar por precio, relevancia).

### 5.6 Detalle de producto o mascota

- **Producto**: Imagen grande (carrusel si hay múltiples), título, precio, selector de cantidad (stepper), descripción completa, especificaciones (tabla), botón "Añadir al carrito" (principal) y botón "Comprar ahora" (que añade y va al carrito). Botón de favoritos (corazón animado). Sección "Productos relacionados" (basado en categoría o especie).
- **Mascota**: Muestra imagen, nombre, especie, raza, sexo, fecha de nacimiento (o edad), peso, notas médicas (si es visible para el comprador). Botón "Solicitar información" (envía un mensaje al administrador) y "Adoptar/Comprar" (inicia un proceso de compra que incluye formulario de adopción). No se añade al carrito normal; es un flujo aparte que genera una cita o un pedido especial.

### 5.7 Carrito de compras

- Icono en AppBar muestra el número de items. Al entrar al carrito:
  - Lista de productos: cada item tiene imagen, nombre, precio unitario, cantidad (con botones +/-), y un ícono de eliminar (papelera). Cambiar cantidad actualiza el subtotal en tiempo real.
  - Resumen de compra: subtotal, impuestos (16%), descuento (si aplica un cupón), total.
  - Botón "Aplicar cupón": campo de texto para ingresar código (simulado, se valida contra una lista en Firestore).
  - Botón "Proceder a pagar": lleva a la pantalla de checkout donde se selecciona método de pago (solo simulación: efectivo, tarjeta de crédito, transferencia). Al confirmar, se crea el pedido en Firestore (colección `pedidos` y `detalles_pedido`), se vacía el carrito, se actualiza inventario (restar stock) y se muestra una pantalla de éxito con resumen del pedido.
- El carrito persiste entre sesiones usando SharedPreferences o manteniendo el estado en el provider con almacenamiento local (HydratedBloc o similar). En modo prueba no se requiere sincronización entre dispositivos.

### 5.8 Sistema de favoritos

- Desde cualquier tarjeta o detalle, el usuario puede presionar un corazón. Los favoritos se guardan en el documento del cliente en Firestore (campo `favoritos`, un array de strings con IDs de productos o mascotas). También se puede mantener una copia local en el provider para respuesta inmediata.
- Pantalla de favoritos (accesible desde el perfil o el menú): muestra dos pestañas: "Productos favoritos" y "Mascotas favoritas". Misma disposición de grid que el catálogo.

### 5.9 Perfil de usuario y historial de compras

- **Perfil**: Datos personales (nombre, email, teléfono, fecha de nacimiento, tipo de membresía). Puede editarse (campos editables, botón "Guardar cambios"). Opción para cerrar sesión. También muestra la lista de mascotas registradas (con posibilidad de agregar nueva mascota, editar o eliminar). Las mascotas se asocian al cliente mediante `cliente_id`.
- **Historial de compras**: Lista de pedidos realizados, cada uno muestra fecha, total, estado (entregado, pendiente, cancelado). Al hacer clic, se ven los detalles de ese pedido (productos, cantidades, precios).

### 5.10 Agenda de citas veterinarias

- Acceso desde el bottom bar o drawer.
- Pantalla principal de citas: un calendario visual (mes o semana) donde los días con citas aparecen con un punto de color rojo pastel. Al seleccionar un día, se muestra la lista de citas de ese día (tarjetas glassmorphism). También hay un botón flotante (FAB) para crear nueva cita.
- **Nueva cita**: Formulario paso a paso:
  1. Seleccionar mascota (de las registradas por el usuario, si no hay, se invita a registrar una).
  2. Seleccionar servicio (se listan desde la colección `servicios` con precio y duración).
  3. Seleccionar sucursal (se obtienen `sucursales` activas con mapa o dirección).
  4. Seleccionar fecha y hora (solo horarios disponibles, se consulta `citas` existentes para esa sucursal y empleado).
  5. Campo de notas opcional.
  6. Botón "Agendar". Al guardar, se crea un documento en `citas` con estado "pendiente" (o "confirmada" si se requiere pago). Se envía una notificación local al usuario.
- Las citas se pueden cancelar desde el detalle (cambiar estado a "cancelada") y se notifica al usuario.

### 5.11 Panel administrativo básico

Accesible solo para usuarios con `rol = 'admin'` (campo en el documento `clientes`). El panel está oculto en la navegación normal y se accede mediante una opción secreta o un enlace en el perfil. Contiene:

- **Gestión de mascotas disponibles** (para adopción/venta): listado de todas las mascotas (no solo las de un cliente), con opción de agregar, editar (cambiar precio, disponibilidad, subir foto), eliminar (borrado lógico o físico). Campos iguales a la tabla `mascota`.
- **Gestión de productos**: CRUD completo (nombre, precio, categoría, proveedor, stock inicial en sucursales, imagen). Al crear un producto, también se debe crear el registro en `inventario` para al menos una sucursal.
- **Gestión de citas**: listado de todas las citas, filtrado por fecha, sucursal, empleado. Posibilidad de cambiar estado (confirmar, cancelar, completar) y asignar empleado.
- **Gestión de inventario**: vista de stock por producto y sucursal, permitiendo ajustar cantidades (entradas por reposición).
- **Reportes básicos** (solo en modo prueba): número de pedidos por día, productos más vendidos, citas atendidas.

### 5.12 Manejo de estados de carga y errores

- **Indicador de carga**: Mientras se espera una operación de Firestore (login, registro, carga de productos), se muestra un `LoadingIndicator` centrado (puede ser un `CircularProgressIndicator` con color azul pastel o una animación Lottie de una huella girando).
- **Estados vacíos**: Cuando una lista no tiene datos (ej. carrito vacío, sin citas), se muestra un `EmptyStateWidget` con un icono grande, mensaje amigable ("Aún no tienes productos en tu carrito") y un botón para ir al catálogo.
- **Errores generales**: Si ocurre un error inesperado (fallo de red, excepción en Firestore), se muestra un `ErrorWidget` con un mensaje claro y un botón "Reintentar". No se rompe la interfaz.
- **Mensajes de éxito**: Snackbar en la parte inferior de la pantalla con fondo verde suave y texto blanco, duración de 3 segundos.

### 5.13 Animaciones y transiciones

- **Transiciones entre pantallas**: deslizamiento horizontal hacia la derecha (slide) para rutas normales, y fade para modales. En web, se usa la navegación por URL sin animación.
- **Micro-interacciones**: 
  - Botones: reducen su escala al 0.95 al presionarse, con un efecto de ripple en rojo pastel suave.
  - Tarjetas: al pasar el mouse (web/escritorio) se elevan ligeramente (aumenta la sombra) y muestran un borde más brillante.
  - Agregar al carrito: el ícono del carrito en AppBar hace una pequeña vibración y un badge cambia de número con animación de escala.
  - Favoritos: el corazón late una vez y cambia de color de gris a rojo pastel.
- **Animaciones de entrada**: Los elementos de las listas (tarjetas) aparecen con un desvanecimiento y un pequeño desplazamiento vertical (fade-up) usando `AnimatedList` o simplemente un `FadeTransition`.

---

## 6. Módulos específicos (ampliación)

### 6.1 Pantalla de bienvenida (splash + presentación)
- Muestra el logo y el nombre de la app con un efecto de desvanecimiento. Después de 2 segundos, decide la ruta según autenticación.

### 6.2 Inicio de sesión y registro (explicados arriba)

### 6.3 Recuperación de contraseña
- Solo un campo de email y un botón. Al enviar, se muestra un diálogo informativo sin validación adicional.

### 6.4 Página principal (home) con secciones dinámicas
- Puede incluir un placeholder si no hay conexión, mostrando datos cacheados localmente (usando `persistenceEnabled` de Firestore).

### 6.5 Catálogo de mascotas con filtros por especie, tamaño, edad
- Filtros en modal con sliders y checkboxes.

### 6.6 Catálogo de productos con filtros por categoría, precio, especie objetivo
- Los filtros se aplican construyendo consultas dinámicas a Firestore (`.where()` encadenados). Es importante crear los índices necesarios.

### 6.7 Sistema de carrito de compras con persistencia local
- Se almacena en `SharedPreferences` una lista serializada de IDs y cantidades, además del provider en memoria.

### 6.8 Sistema de favoritos sincronizado con Firestore
- Al marcar/desmarcar, se actualiza el array en el documento del cliente. Se usa `FieldValue.arrayUnion` y `arrayRemove`.

### 6.9 Perfil de usuario y gestión de mascotas propias
- El usuario puede registrar una nueva mascota (solo los campos básicos) y editarla. No puede eliminar mascotas que tengan citas asociadas (validación en controlador).

### 6.10 Historial de compras con detalle de cada pedido
- Las consultas se hacen a `pedidos` donde `cliente_id == uid`, y luego se traen los `detalles_pedido` de cada pedido.

### 6.11 Agenda de citas veterinarias con calendario interactivo
- Se recomienda usar un paquete de calendario (como `table_calendar`) adaptado a los colores pastel.

### 6.12 Panel administrativo con gestión CRUD de cada entidad
- Cada pantalla de gestión muestra una tabla o lista de elementos, con botones de editar/eliminar/crear.

### 6.13 Buscador y filtros avanzados con autocompletado
- La búsqueda en Firestore se puede hacer con `isGreaterThanOrEqualTo` y `isLessThanOrEqualTo` para strings (búsqueda por prefijo). No se requiere búsqueda de texto completo.

### 6.14 Notificaciones visuales dentro de la app (sin push)
- Se usan Snackbars y diálogos modales. También notificaciones locales programadas para recordar citas (usando `flutter_local_notifications`).

### 6.15 Manejo de estados de carga y errores (explicado)

---

## 7. Dependencias conceptuales (sin código)

Para implementar todas las funcionalidades descritas, el proyecto Flutter requiere las siguientes dependencias (solo se explica su función, no se dan comandos de instalación):

- **Firebase Core**: Permite conectar la app con el proyecto Firebase `PetcoGestionApp`. Es la base para todos los demás servicios de Firebase.
- **Firebase Authentication**: Gestiona el registro, inicio de sesión y restablecimiento de contraseña utilizando correo/contraseña. También mantiene la sesión activa.
- **Cloud Firestore**: Base de datos NoSQL en tiempo real. Se usa para almacenar y sincronizar toda la información de clientes, mascotas, productos, citas, pedidos, etc. Las colecciones se organizan según la adaptación de las tablas SQL.
- **Firebase Storage**: Almacena las imágenes subidas por el administrador (fotos de mascotas, productos, logos de sucursales). Las URLs resultantes se guardan en los documentos de Firestore.
- **Provider o Riverpod**: Manejo de estado reactivo y eficiente. Se usa para compartir el estado del carrito, favoritos, autenticación, tema, etc., entre múltiples pantallas sin necesidad de pasar parámetros manualmente. Riverpod es más moderno y seguro en tiempo de compilación.
- **Go Router**: Navegación declarativa con soporte para rutas anidadas, transiciones personalizadas y deep linking. Es ideal para multiplataforma porque maneja URLs en web y navegación nativa en móvil.
- **Flutter Local Notifications**: Permite mostrar notificaciones en el dispositivo a horas programadas (ej. recordatorio de cita 1 hora antes). No requiere conexión a internet.
- **Shared Preferences**: Almacenamiento local de pares clave-valor. Se usa para guardar el estado del carrito cuando la app se cierra, o preferencias del usuario (tema oscuro, etc.).
- **Image Picker**: Permite al usuario seleccionar imágenes de la galería o tomar fotos con la cámara para subir foto de perfil o agregar fotos a mascotas (en modo administrador).
- **Lottie**: Reproduce animaciones en formato JSON de alta calidad, ideales para pantallas de carga, éxito o error.
- **Intl**: Internacionalización y formateo de fechas, números y monedas. Se usa para mostrar precios en formato local y fechas legibles.
- **Table Calendar**: Widget de calendario personalizable para la gestión de citas. Permite seleccionar fechas, resaltar días con eventos, etc.
- **Google Maps Flutter (opcional)**: Si se desea mostrar la ubicación de las sucursales en un mapa interactivo. Requiere clave de API.
- **Flutter Spinkit**: Colección de indicadores de carga animados (spinners) con varios estilos, que se pueden ajustar a los colores pastel.
- **Equatable**: Facilita la comparación de objetos en providers y reduce reconstrucciones innecesarias de widgets.
- **Firebase UI Auth (opcional)**: Para acelerar la implementación de pantallas de login/registro con diseño predefinido, pero dado que se requiere diseño personalizado con glassmorphism, no se recomienda.

---

## 8. Gestión de assets y recursos visuales

### 8.1 Organización en la carpeta `assets/`

- **images/**: 
  - `logo.png` (versión horizontal y solo icono).
  - `placeholder.png` (imagen genérica para productos sin foto).
  - `banner_home_1.jpg`, `banner_home_2.jpg` (banners promocionales).
  - `category_dog.png`, `category_cat.png`, etc. (íconos para las categorías).
  - `avatar_default.png` (para usuarios sin foto).
  - Fotos de muestra para mascotas (para pruebas).
- **icons/**: Puede contener una fuente de iconos personalizada (`.ttf`) o simplemente usar Iconos de Material Design (que ya vienen con Flutter). Para mantener coherencia, se usarán principalmente iconos de `Icons` con el peso `outlined` o `rounded`.
- **fonts/**: Archivos `Poppins-Regular.ttf`, `Poppins-Medium.ttf`, etc. Registrados en `pubspec.yaml`. La familia tipográfica se aplica globalmente en el `ThemeData`.
- **animations/**: Archivos JSON de Lottie como `loading_animation.json`, `success_check.json`, `error_animation.json`.

### 8.2 Coherencia visual

- Todas las imágenes deben tener bordes redondeados (radio 12px por defecto).
- Los iconos de la barra inferior y AppBar se usan con tamaño 24px y color `#1E2A3A` (texto principal), excepto el icono activo que toma el color rojo pastel.
- Los placeholders son imágenes vectoriales o ilustraciones de mascotas en tonos pastel.
- Los logos deben incluir versiones para modo claro y oscuro (aunque no se use modo oscuro, se prevé).

### 8.3 Optimización

- Las imágenes subidas a Firebase Storage deben ser comprimidas antes de la subida (usando paquete `image_picker` con calidad al 70%).
- En assets locales, se prefiere formato WebP para reducir tamaño.
- Las animaciones Lottie no deben superar los 200 KB para mantener rendimiento.

---

## 9. Consideraciones multiplataforma

### 9.1 Responsive design

- Se utiliza `MediaQuery` y `LayoutBuilder` en cada pantalla para adaptar columnas, tamaños de fuente y márgenes.
- En móvil (ancho < 600px): bottom navigation bar visible, grid de 2 columnas, textos ligeramente más pequeños.
- En tablet (600px - 1200px): grid de 3 o 4 columnas, se puede usar un `NavigationRail` en lugar de bottom bar.
- En web/escritorio (>1200px): grid de 5 o 6 columnas, drawer lateral que se puede colapsar, y el contenido centrado con un ancho máximo de 1200px.

### 9.2 Adaptación a Windows, Android, iOS, Web

- **Web**: Se debe evitar el uso de `dart:io` para funcionalidades que no estén soportadas. La selección de imágenes se hace con `image_picker` que funciona en web usando HTML input. La navegación con `go_router` maneja las URLs correctamente.
- **Windows**: Las notificaciones locales pueden requerir configuración adicional; en modo prueba se pueden deshabilitar o usar un stub.
- **iOS/Android**: Todas las funcionalidades (cámara, notificaciones, almacenamiento) funcionan sin problemas. Se debe solicitar permiso para notificaciones al iniciar la app (solo una vez).
- **Diferencias de entrada**: En web/escritorio, los botones tienen efectos de hover y focus; en móvil, se usan gestos táctiles con feedback háptico opcional.

### 9.3 Pruebas en modo desarrollo

- Para probar en web, ejecutar con `flutter run -d chrome` y usar las herramientas de desarrollo de Firebase Emulator Suite (opcional) para simular Firestore localmente.
- En dispositivos físicos, asegurarse de que el archivo `google-services.json` (Android) y `GoogleService-Info.plist` (iOS) estén correctamente colocados y que el proyecto Firebase tenga los SHA-1 registrados para Android.

---

#Prompt:

Antigravity
Flutter multiplataforma para Android, Web, Windows e iOS.

Necesito un documento extremadamente detallado y completamente estructurado para la implementación de una aplicación desarrollada en Dart Flutter utilizando Antigravity como apoyo principal de desarrollo. La aplicación estará enfocada en una tienda tipo Petco, donde los usuarios puedan comprar mascotas, adquirir productos para mascotas y agendar citas veterinarias desde una misma plataforma. El objetivo es que el documento funcione como una guía técnica y visual completa para otra IA, por lo que debe describir absolutamente todos los aspectos necesarios para construir el proyecto desde cero, sin asumir nada implícitamente y sin omitir detalles importantes.

La aplicación debe tener una identidad visual moderna, elegante y tecnológica, utilizando principalmente tonos azul pastel y rojo pastel combinados con efectos glassmorphism, transparencias suaves, desenfoques, sombras ligeras y elementos visuales minimalistas. El diseño debe sentirse limpio, moderno y profesional, similar a aplicaciones móviles actuales de alta calidad. Describe detalladamente cómo se verán las pantallas, qué estructura tendrá cada sección, cómo estarán organizados los botones, tarjetas, menús, formularios y navegaciones, especificando colores exactos sugeridos, tamaños aproximados, distribución de componentes y experiencia visual esperada en cada plataforma.

No quiero código bajo ninguna circunstancia. No incluyas snippets, ejemplos de programación, estructuras JSON ni configuraciones escritas como código. Todo debe ser explicado únicamente mediante texto descriptivo y listas organizadas. Las dependencias necesarias, configuraciones de Firebase y reglas de Firestore deben mencionarse únicamente como explicación funcional y conceptual, nunca como código.

El documento debe explicar de forma extremadamente amplia y específica la arquitectura completa del proyecto Flutter. Describe detalladamente la estructura de carpetas y archivos que debería tener el proyecto, incluyendo la función exacta de cada carpeta y el propósito específico de cada archivo importante. Explica cómo deberían organizarse las carpetas relacionadas con modelos, vistas, widgets reutilizables, controladores, servicios, navegación, autenticación, manejo de estado, Firebase, assets, temas visuales, animaciones, utilidades y configuración multiplataforma. No quiero descripciones genéricas; cada carpeta y archivo debe tener una explicación clara de qué contendrá, cómo se relaciona con el resto del sistema y por qué es necesaria dentro de la arquitectura.

También necesito que expliques detalladamente el flujo completo de funcionamiento de la aplicación. Describe desde el inicio de sesión y registro de usuarios hasta el proceso de compra, navegación por productos, visualización de mascotas, filtrado de categorías, administración de citas veterinarias y conexión con Firebase. Explica cómo deberían comportarse las pantallas, cómo debe reaccionar la interfaz ante acciones del usuario, cómo se manejarán las cargas de datos, validaciones, estados vacíos, errores, animaciones y transiciones entre pantallas.

Debes mencionar explícitamente las tablas que adjuntaré posteriormente y explicar cómo se relacionarán con la aplicación, cómo serán utilizadas dentro de Firebase Firestore y cómo interactuarán entre sí. Describe ampliamente el propósito de cada tabla, el flujo de información entre colecciones y la lógica funcional esperada dentro de la app. Explica cómo se conectará Flutter con Firebase Console, cómo se organizará Firestore para mantener la información estructurada y qué estrategias deben seguirse para consultas eficientes, manejo de usuarios y sincronización de datos en tiempo real.

La experiencia de usuario debe explicarse con muchísimo detalle. Describe exactamente cómo debe sentirse la navegación, qué tipo de animaciones usar, cómo deben comportarse los botones al interactuar, cómo se mostrarán los mensajes de éxito o error, cómo será el diseño responsive para web, móvil y escritorio, y cómo adaptar la interfaz para diferentes tamaños de pantalla sin perder consistencia visual. Explica también la jerarquía visual de la información, el espaciado entre elementos, el comportamiento de los menús laterales, barras inferiores, tarjetas de productos y formularios.

Describe ampliamente todos los módulos necesarios para la aplicación, incluyendo:

* Pantalla de bienvenida.
* Inicio de sesión y registro.
* Recuperación de contraseña.
* Página principal.
* Catálogo de mascotas.
* Catálogo de productos.
* Sistema de carrito de compras.
* Sistema de favoritos.
* Perfil de usuario.
* Historial de compras.
* Agenda de citas veterinarias.
* Panel administrativo básico.
* Gestión de mascotas disponibles.
* Gestión de productos.
* Gestión de citas.
* Buscador y filtros avanzados.
* Notificaciones visuales dentro de la app.
* Manejo de estados de carga y errores.

Explica qué dependencias serían necesarias para animaciones, glassmorphism, Firebase, manejo de estado, navegación, formularios, imágenes, iconos y almacenamiento local, pero únicamente describiendo su función dentro del proyecto y por qué serían útiles. No pongas ejemplos de instalación ni comandos.

También quiero que describas ampliamente cómo deberían manejarse los assets de la aplicación: logos, iconos, imágenes de mascotas, banners, tipografías, animaciones y recursos visuales. Explica cómo deberían organizarse dentro del proyecto y cómo mantener coherencia visual en toda la aplicación.

Toma en cuenta que el proyecto es personal y académico, por lo tanto no necesito configuraciones orientadas a producción empresarial, analytics avanzados ni sistemas complejos de escalabilidad. El enfoque debe centrarse en funcionalidad, buena organización, diseño profesional y facilidad de desarrollo utilizando Flutter y Firebase Console.

Muy importante:

* No generes código.
* No hagas ejemplos en lenguaje de programación.
* No hagas un resumen corto.
* No generalices explicaciones.
* No omitas detalles técnicos importantes.
* Explica todo como si fuera documentación profesional para construir el proyecto completo.
* Cada sección debe ser amplia, específica y profundamente detallada.
Además, toma en cuenta que el proyecto ya existe dentro de Firebase Console y que el nombre exacto del proyecto es **PetcoGestionApp**. La aplicación utilizará específicamente **Cloud Firestore** como base de datos principal para almacenamiento y sincronización de información en tiempo real. Describe detalladamente cómo debe integrarse este proyecto de Firebase dentro de la arquitectura Flutter y cómo debería organizarse la comunicación entre la aplicación y Firestore para mantener una estructura clara, eficiente y fácil de mantener.

Es importante considerar que el proyecto de Firebase se encuentra actualmente en **modo prueba** y no en estado de producción. Debido a esto, el documento debe contemplar configuraciones y flujos adecuados para un entorno de desarrollo académico y personal, evitando enfoques empresariales avanzados o configuraciones innecesarias de despliegue profesional. Explica cómo afecta el modo prueba al comportamiento de Firestore, autenticación y acceso a datos, así como las precauciones básicas que deben considerarse durante el desarrollo para evitar errores comunes relacionados con permisos o sincronización.

También describe ampliamente cómo debería estructurarse la conexión entre Flutter y el proyecto **PetcoGestionApp**, incluyendo:

* Organización lógica de la configuración de Firebase dentro del proyecto Flutter.
* Manejo de inicialización de Firebase al arrancar la aplicación.
* Separación de responsabilidades entre la interfaz y las operaciones de Firestore.
* Estrategias recomendadas para leer, escribir, actualizar y eliminar datos de Firestore.
* Flujo esperado de autenticación y persistencia de sesión.
* Manejo de errores relacionados con conexión, permisos o datos inexistentes.
* Uso de colecciones y documentos dentro de Firestore para mantener ordenada la información.
* Estrategias de nomenclatura para colecciones relacionadas con usuarios, mascotas, productos, citas veterinarias, compras y favoritos.
* Organización visual y lógica del backend para que sea fácil de entender y mantener dentro de Firebase Console.

Aclara también que, al ser un proyecto en modo prueba y de carácter personal/académico, no es necesario implementar:

* Infraestructura empresarial.
* Escalabilidad avanzada.
* Microservicios.
* Configuraciones complejas de seguridad empresarial.
* Analytics avanzados.
* Integraciones de monetización.
* Sistemas externos de administración.

Que la estructura de carpetas solo contenga carpetas y archivos, no explicación (la explicación la quiero fuera de la estructura de carpetas)
