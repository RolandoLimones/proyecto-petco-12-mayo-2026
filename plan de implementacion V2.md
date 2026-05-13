# Plan de Implementación Extendido – App Petco (Flutter + Firebase)

## Índice
1. [Arquitectura y Filosofía de Diseño](#1-arquitectura-y-filosofía-de-diseño)
2. [Estructura de Carpetas y Archivos – Desglose Completo](#2-estructura-de-carpetas-y-archivos-–-desglose-completo)
3. [Dependencias y Paquetes – Especificación Técnica](#3-dependencias-y-paquetes-–-especificación-técnica)
4. [Configuración de Firebase – Firestore, Auth, Storage, Functions](#4-configuración-de-firebase-–-firestore-auth-storage-functions)
5. [Modelado de Datos en Firestore – Colecciones, Subcolecciones, Referencias](#5-modelado-de-datos-en-firestore-–-colecciones-subcolecciones-referencias)
6. [Reglas de Seguridad de Firestore – Explicación Lógica Completa](#6-reglas-de-seguridad-de-firestore-–-explicación-lógica-completa)
7. [Índices Compuestos en Firestore – Lista Necesaria](#7-índices-compuestos-en-firestore-–-lista-necesaria)
8. [Cloud Functions – Triggers, Propósitos y Lógica de Negocio](#8-cloud-functions-–-triggers-propósitos-y-lógica-de-negocio)
9. [Gestión de Estado con Riverpod – Providers Detallados](#9-gestión-de-estado-con-riverpod-–-providers-detallados)
10. [Navegación y Rutas – GoRouter Configuración](#10-navegación-y-rutas-–-gorouter-configuración)
11. [Diseño UX/UI – Especificaciones Completas de Glassmorphism, Colores, Tipografía, Animaciones](#11-diseño-uxui-–-especificaciones-completas-de-glassmorphism-colores-tipografía-animaciones)
12. [Pantallas y Flujos – Explicación Paso a Paso de Cada Interfaz](#12-pantallas-y-flujos-–-explicación-paso-a-paso-de-cada-interfaz)
    - 12.1 Autenticación (Login/Registro)
    - 12.2 Home (Dashboard principal)
    - 12.3 Catálogo de Productos y Búsqueda
    - 12.4 Detalle de Producto y Carrito de Compras
    - 12.5 Proceso de Checkout y Pedidos
    - 12.6 Gestión de Mascotas
    - 12.7 Agenda de Citas Veterinarias
    - 12.8 Perfil de Usuario y Configuración
    - 12.9 Historial de Pedidos y Detalles
    - 12.10 Sucursales y Mapa
13. [Manejo de Imágenes – Carga, Optimización y Almacenamiento en Firebase Storage](#13-manejo-de-imágenes-–-carga-optimización-y-almacenamiento-en-firebase-storage)
14. [Persistencia Local – SharedPreferences para Carrito y Preferencias](#14-persistencia-local-–-sharedpreferences-para-carrito-y-preferencias)
15. [Manejo de Errores y Estados de Carga – Estrategia Global](#15-manejo-de-errores-y-estados-de-carga-–-estrategia-global)
16. [Pruebas Manuales – Escenarios y Casos de Uso a Verificar](#16-pruebas-manuales-–-escenarios-y-casos-de-uso-a-verificar)
17. [Configuración Multiplataforma – Android, iOS, Web, Windows](#17-configuración-multiplataforma-–-android-ios-web-windows)
18. [Despliegue Local y Variables de Entorno](#18-despliegue-local-y-variables-de-entorno)
19. [Lista de Verificación Final (Checklist)](#19-lista-de-verificación-final-checklist)

---

## 1. Arquitectura y Filosofía de Diseño

Se adopta una **arquitectura limpia (Clean Architecture)** con tres capas:

- **Capa de datos (data):** Contiene modelos (con `fromJson`/`toJson`), repositorios concretos y fuentes de datos (Firestore, Storage, SharedPreferences). Se encarga de la comunicación con Firebase y el almacenamiento local.
- **Capa de dominio (domain):** Contiene entidades de negocio (clases simples), interfaces de repositorios (contratos) y casos de uso (cada caso de uso es una clase con un método `execute`). Esta capa no depende de Flutter ni de Firebase, es pura lógica Dart.
- **Capa de presentación (presentation):** Contiene screens, widgets, providers (Riverpod) y lógica de UI. Depende de la capa de dominio para invocar casos de uso.

Esta separación permite:
- Testabilidad unitaria de la lógica de negocio.
- Facilidad para cambiar el origen de datos (por ejemplo, reemplazar Firestore por una API REST).
- Reutilización de casos de uso en diferentes pantallas.

**Principios aplicados:**
- Inyección de dependencias mediante Riverpod (providers que proveen instancias de repositorios y casos de uso).
- Programación reactiva: los providers notifican a los widgets cuando el estado cambia.
- Manejo de estado local (dentro de una pantalla) con `StateProvider` o `StateNotifierProvider`; estado global compartido con `Provider` o `FutureProvider`.

---

## 2. Estructura de Carpetas y Archivos – Desglose Completo

A continuación se detalla **cada archivo** con su responsabilidad exacta.

```
lib/
├── main.dart
│   └── Función main() que llama a runApp() envolviendo la app con ProviderScope (Riverpod) y ejecuta la inicialización de Firebase (usando async/await y Firebase.initializeApp).
│
├── app/
│   ├── app.dart
│   │   └── Widget MyApp (stateless). Configura MaterialApp.router con:
│   │       - routerConfig (GoRouter)
│   │       - theme: lightTheme definido en theme.dart
│   │       - debugShowCheckedModeBanner: false
│   │       - scaffoldMessengerKey para mostrar SnackBars globales
│   │       - builder: envolver con un widget que maneje la conexión a internet (ConnectivityObserver)
│   ├── routes.dart
│   │   └── Definición de todas las rutas como constantes (e.g. '/login', '/home', '/productos/:id')
│   ├── theme.dart
│   │   └── LightTheme definido: 
│   │       - colorScheme (Material 3) con primary = azul pastel #A3C6FF, secondary = rojo pastel #FFB3B3
│   │       - elevatedButtonTheme, textTheme, cardTheme, etc. para aplicar glassmorphism por defecto.
│   └── constants.dart
│       └── Constantes globales: 
│           - firestoreCollectionNames (clientes, productos, etc.)
│           - storagePaths (productos/, mascotas/, etc.)
│           - límites de paginación (10 productos por página)
│           - tiempos de caché (por ejemplo, 5 minutos para productos)
│
├── core/
│   ├── utils/
│   │   ├── formatters.dart
│   │   │   └── Funciones: formatearPrecio (moneda CLP, MXN, etc.), formatearFecha (dd/MM/yyyy), formatearHora (HH:mm)
│   │   ├── validators.dart
│   │   │   └── Validadores: emailValido, telefonoValido, fechaNacimientoValida, nombreNoVacio, etc.
│   │   ├── helpers.dart
│   │   │   └── Funciones misceláneas: mostrarSnackBar (usa scaffoldMessengerKey), calcularSubtotal, calcularTotalConImpuestos, generarIdLocal (para carrito)
│   │   ├── logger.dart
│   │   │   └── Configuración de logger (usa `logger` package) con niveles: debug, info, warning, error. Solo imprime en modo debug.
│   │   └── connectivity.dart
│   │       └── Función que retorna un Stream<bool> de conectividad usando ConnectivityPlus, y un provider de estado de conexión.
│   ├── exceptions/
│   │   └── app_exceptions.dart
│   │       └── Jerarquía de excepciones: 
│   │           - AppException (base)
│   │           - AuthException (subclases: InvalidEmail, WrongPassword, UserNotFound)
│   │           - FirestoreException (subclases: NetworkError, PermissionDenied, NotFound)
│   │           - StockException (StockInsuficiente)
│   │           - CitaException (HorarioOcupado, MascotaNoEncontrada)
│   └── services/
│       ├── firebase_service.dart
│       │   └── Clase FirebaseService con métodos estáticos: initialize() (llama a Firebase.initializeApp y configura opciones), getFirestore(), getAuth(), getStorage().
│       ├── auth_service.dart
│       │   └── Clase que envuelve FirebaseAuth: 
│       │       - signInWithEmailAndPassword(email, password)
│       │       - createUserWithEmailAndPassword(email, password)
│       │       - sendPasswordResetEmail(email)
│       │       - signOut()
│       │       - currentUser (Stream<User?>)
│       │       - updateProfile(displayName, photoURL)
│       └── storage_service.dart
│           └── Clase que envuelve FirebaseStorage:
│               - uploadImage(file, path) → retorna URL de descarga
│               - deleteImage(path)
│               - compressImage (antes de subir, reduce calidad a 80% y redimensiona a 1024x1024)
│
├── data/
│   ├── models/                  // Modelos de datos (con JSON serialization)
│   │   ├── cliente_model.dart
│   │   │   └── Clase ClienteModel con campos: id (String), nombre, email, telefono, direccion, fechaNacimiento (DateTime), fechaRegistro (DateTime), tipoMembresia (String), activo (bool), fotoUrl (String?).
│   │   │       - fromFirestore(DocumentSnapshot) → ClienteModel
│   │   │       - toFirestore() → Map<String, dynamic>
│   │   ├── mascota_model.dart
│   │   │   └── Clase MascotaModel: id, clienteId (String ref), nombre, especie, raza, sexo (enum: M, F, N), fechaNacimiento, pesoKg (double), fotoUrl, notasMedicas.
│   │   ├── categoria_model.dart
│   │   │   └── id, nombre, descripcion, categoriaPadreId (String? ref), imagenUrl, activo.
│   │   ├── proveedor_model.dart
│   │   ├── producto_model.dart
│   │   │   └── id, categoriaId, proveedorId, nombre, descripcion, codigoBarras, precio, precioCosto, especieObjetivo (String), imagenUrl, activo, ventasTotales (int, opcional para ranking).
│   │   ├── sucursal_model.dart
│   │   │   └── id, nombre, direccion, ciudad, estado, telefono, horario, latitud, longitud, activo.
│   │   ├── empleado_model.dart
│   │   ├── pedido_model.dart
│   │   │   └── id, clienteId, empleadoId?, sucursalId, fechaPedido (Timestamp), subtotal, impuesto, descuento, total, estado (enum: pendiente, pagado, enviado, entregado, cancelado), canal (enum: app, web, tienda), metodoPago.
│   │   ├── detalle_pedido_model.dart
│   │   │   └── id, pedidoId, productoId, cantidad, precioUnitario, descuento, subtotal.
│   │   ├── servicio_model.dart
│   │   ├── cita_model.dart
│   │   │   └── id, clienteId, mascotaId, servicioId, empleadoId?, sucursalId, fechaHora (Timestamp), estado (pendiente, confirmada, completada, cancelada), precioCobrado, notas.
│   │   └── inventario_model.dart
│   │       └── id (autogenerado), productoId, sucursalId, cantidad, stockMinimo, stockMaximo, ultimaActualizacion.
│   │
│   ├── repositories/            // Implementación concreta de interfaces del dominio
│   │   ├── auth_repository.dart
│   │   │   └── Implementa IAuthRepository usando auth_service.dart y firestore para guardar/leer clientes.
│   │   ├── cliente_repository.dart
│   │   │   └── CRUD de clientes en Firestore, usando cliente_firestore.dart.
│   │   ├── mascota_repository.dart
│   │   ├── producto_repository.dart
│   │   │   └── Métodos: getProductos(filtros, paginación), getProductoPorId, getProductosPorCategoria, buscarProductos(query).
│   │   ├── pedido_repository.dart
│   │   │   └── crearPedido (transacción que también actualiza inventario, se llama a Cloud Function mejor), getPedidosPorCliente, getPedidoDetalle.
│   │   ├── cita_repository.dart
│   │   ├── sucursal_repository.dart
│   │   └── inventario_repository.dart
│   │       └── verificarStock(sucursalId, productoId, cantidadRequerida), actualizarStock (solo admin o vía Cloud Function).
│   │
│   └── datasources/
│       ├── firestore/
│       │   ├── cliente_firestore.dart
│       │   │   └── Métodos: getCliente(String uid), updateCliente(ClienteModel), createCliente(ClienteModel).
│       │   ├── mascota_firestore.dart
│       │   │   └── Métodos: getMascotasByCliente(String clienteId), createMascota, updateMascota, deleteMascota.
│       │   ├── producto_firestore.dart
│       │   │   └── Métodos con queries paginadas: getProductos con filtros (usando where, orderBy, limit, startAfter), getProductoById.
│       │   ├── pedido_firestore.dart
│       │   │   └── createPedido (escribe documento y subcolección detalles_pedido), getPedidosByCliente (ordenado por fecha descendente).
│       │   ├── cita_firestore.dart
│       │   │   └── createCita, getCitasByCliente, getCitasBySucursalAndFecha (para verificar disponibilidad), cancelarCita.
│       │   ├── sucursal_firestore.dart
│       │   │   └── getSucursales (con opción de activas), getSucursalById.
│       │   └── inventario_firestore.dart
│       │       └── getStock(productoId, sucursalId), updateStock (en transacción, pero mejor delegar a Cloud Function).
│       └── local/               // Para persistencia offline (opcional con Hive)
│           ├── carrito_local.dart
│           │   └── Lee/escribe carrito en SharedPreferences (JSON).
│           └── preferencias_local.dart
│               └── Guarda sucursal favorita, último email usado, etc.
│
├── domain/
│   ├── entities/                // Entidades simples (sin métodos de persistencia)
│   │   ├── cliente.dart
│   │   │   └── Clase Cliente con los mismos campos que el modelo pero sin fromJson/toJson. Incluye métodos de validación de dominio (e.g. esMayorDeEdad).
│   │   ├── mascota.dart
│   │   ├── producto.dart
│   │   ├── pedido.dart
│   │   ├── detalle_pedido.dart
│   │   ├── cita.dart
│   │   ├── sucursal.dart
│   │   ├── inventario.dart
│   │   └── ... (resto)
│   ├── repositories/            // Interfaces (contratos)
│   │   ├── i_auth_repository.dart
│   │   ├── i_cliente_repository.dart
│   │   ├── i_mascota_repository.dart
│   │   ├── i_producto_repository.dart
│   │   ├── i_pedido_repository.dart
│   │   ├── i_cita_repository.dart
│   │   ├── i_sucursal_repository.dart
│   │   └── i_inventario_repository.dart
│   └── usecases/                // Casos de uso (cada uno expone un método call)
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   │   └── Recibe email, password; invoca authRepository.login; si éxito, también carga cliente desde clienteRepository.
│       │   ├── register_usecase.dart
│       │   │   └── Recibe email, password, datos de perfil; crea usuario en Auth, luego crea documento en clientes.
│       │   └── logout_usecase.dart
│       ├── cliente/
│       │   ├── obtener_cliente_usecase.dart
│       │   ├── actualizar_cliente_usecase.dart
│       │   └── cambiar_contrasena_usecase.dart
│       ├── mascota/
│       │   ├── registrar_mascota_usecase.dart
│       │   │   └── Recibe datos de mascota + archivo de imagen (opcional). Sube imagen a Storage, luego guarda en Firestore.
│       │   ├── listar_mascotas_usecase.dart
│       │   ├── eliminar_mascota_usecase.dart
│       │   └── actualizar_mascota_usecase.dart
│       ├── producto/
│       │   ├── obtener_productos_usecase.dart (paginado, con filtros)
│       │   ├── buscar_productos_usecase.dart
│       │   └── obtener_producto_por_id_usecase.dart
│       ├── pedido/
│       │   ├── crear_pedido_usecase.dart
│       │   │   └── Recibe carrito (lista de items con productoId, cantidad, precio), sucursalId, metodoPago. Invoca pedidoRepository.crearPedido, luego limpia carrito local.
│       │   ├── obtener_pedidos_cliente_usecase.dart
│       │   └── cancelar_pedido_usecase.dart (solo si estado pendiente)
│       ├── cita/
│       │   ├── agendar_cita_usecase.dart
│       │   │   └── Valida disponibilidad (consultando citas existentes en esa sucursal y hora), luego crea.
│       │   ├── obtener_citas_cliente_usecase.dart
│       │   ├── cancelar_cita_usecase.dart
│       │   └── obtener_horarios_disponibles_usecase.dart (para una sucursal, servicio y día)
│       ├── sucursal/
│       │   ├── obtener_sucursales_usecase.dart
│       │   └── obtener_sucursal_por_id_usecase.dart
│       └── inventario/
│           └── verificar_stock_usecase.dart (retorna true/false y cantidad disponible)
│
├── presentation/
│   ├── screens/                 // Cada pantalla es un widget Stateful o ConsumerStatefulWidget
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   │   └── Contiene: formulario (email, password), botón login, enlace a registro, botón de recuperar contraseña. Muestra errores de autenticación.
│   │   │   └── registro_screen.dart
│   │   │       └── Dos pasos: 1) email, password, confirmación; 2) nombre, teléfono, dirección, fecha nacimiento.
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   │   └── Scaffold con body: SingleChildScrollView, Column con:
│   │   │   │       - Carrusel de banners (usando CarouselSlider con imágenes de promociones)
│   │   │   │       - Sección "Servicios rápidos" (3 botones: Baño, Corte, Consulta) que navegan a agendar cita con ese servicio preseleccionado.
│   │   │   │       - Sección "Productos más vendidos" (ListView horizontal con ProductCards)
│   │   │   │       - Sección "Sucursales cercanas" (solo si hay geolocalización)
│   │   │   └── components/ (widgets específicos del home, ej. home_banner.dart, home_service_button.dart)
│   │   ├── productos/
│   │   │   ├── catalogo_productos_screen.dart
│   │   │   │   └── Usa CustomScrollView con SliverAppBar (colapsable), filtros (persistent header), GridView de productos.
│   │   │   ├── detalle_producto_screen.dart
│   │   │   │   └── Muestra imagen principal, selector de cantidad, botones, disponibilidad por sucursal (selección de sucursal mediante dropdown), reseñas (opcional).
│   │   │   └── componentes/ (product_card.dart, filtros_chip.dart)
│   │   ├── mascotas/
│   │   │   ├── mis_mascotas_screen.dart
│   │   │   │   └── ListView con tarjetas de mascotas, botón flotante para agregar.
│   │   │   ├── registrar_mascota_screen.dart
│   │   │   │   └── Formulario con 2 columnas (responsive), selector de sexo (botones), picker de fecha, picker de imagen (cámara/galería), campo de notas médicas.
│   │   │   └── editar_mascota_screen.dart (similar a registrar, pero con datos precargados)
│   │   ├── carrito/
│   │   │   ├── carrito_screen.dart
│   │   │   │   └── Lista de items con cantidad modificable, botón eliminar, resumen de totales, botón "Continuar compra" y "Proceder al pago".
│   │   │   └── checkout_screen.dart
│   │   │       └── Paso 1: Seleccionar sucursal (mapa o lista), Paso 2: Método de pago (simulado: efectivo, tarjeta), Paso 3: Resumen final y botón "Confirmar pedido".
│   │   ├── citas/
│   │   │   ├── agendar_cita_screen.dart
│   │   │   │   └── Stepper con 4 pasos: 1) Seleccionar mascota, 2) Seleccionar servicio, 3) Seleccionar sucursal, 4) Seleccionar fecha/hora (calendario + slots disponibles), 5) Confirmación.
│   │   │   ├── mis_citas_screen.dart
│   │   │   │   └── TabBar: Próximas (pendientes/confirmadas) y Pasadas (completadas/canceladas). Cada cita en tarjeta con acciones (cancelar).
│   │   │   └── detalle_cita_screen.dart
│   │   ├── perfil/
│   │   │   ├── perfil_screen.dart
│   │   │   │   └── Header con foto de perfil (editable), campos de información, botón "Editar perfil", botón "Cerrar sesión".
│   │   │   └── editar_perfil_screen.dart
│   │   ├── pedidos/
│   │   │   ├── mis_pedidos_screen.dart
│   │   │   │   └── ListView de pedidos ordenados por fecha descendente, cada tarjeta muestra número, total, estado, fecha.
│   │   │   └── detalle_pedido_screen.dart
│   │   │       └── Muestra items (productos), direcciones, totales, estado y línea de tiempo (si se implementa).
│   │   └── sucursales/
│   │       ├── sucursales_screen.dart
│   │       │   └── Lista de sucursales con mapa integrado (Google Maps). Cada sucursal tiene botón "Seleccionar" (para carrito) o "Ver horarios".
│   │       └── mapa_sucursales.dart (widget reutilizable)
│   │
│   ├── widgets/                 // Widgets reutilizables (stateless)
│   │   ├── glass_card.dart
│   │   │   └── Container con decoration personalizado: color blanco con opacidad 0.7, borderRadius 24, border suave, sombra. Opcionalmente acepta child y margin/padding.
│   │   ├── glass_button.dart
│   │   │   └── ElevatedButton con estilo: fondo blanco translúcido, borde redondeado, onPressed, icono opcional.
│   │   ├── app_bar_custom.dart
│   │   │   └── AppBar con título, fondo transparente o con blur (usando BackdropFilter), iconos de carrito y notificaciones.
│   │   ├── bottom_nav_bar.dart
│   │   │   └── Barra de navegación inferior con efecto glass, 5 ítems: Home, Productos, Mascotas, Citas, Perfil. Cambia el índice mediante Riverpod.
│   │   ├── loading_indicator.dart
│   │   │   └── Centro de pantalla con CircularProgressIndicator color azul pastel.
│   │   ├── product_card.dart
│   │   │   └── Tarjeta que muestra imagen, nombre, precio, botón de agregar al carrito (con ícono +). Efecto hover en web y ripple en móvil.
│   │   ├── mascota_card.dart
│   │   ├── cita_card.dart
│   │   ├── pedido_card.dart
│   │   ├── filtros_chip.dart
│   │   │   └── Filtros desplegables (categorías, especie, rango de precios) usando chips que se pueden seleccionar.
│   │   └── campo_formulario_glass.dart
│   │       └── TextFormField con estilo glass: fondo blanco translúcido, bordes redondeados, label con color pastel.
│   │
│   ├── providers/               // Gestión de estado con Riverpod
│   │   ├── auth_provider.dart
│   │   │   └── StateNotifierProvider<AuthNotifier, AuthState> que maneja usuario autenticado, loading, error. Depende de LoginUseCase, LogoutUseCase, etc.
│   │   ├── carrito_provider.dart
│   │   │   └── StateNotifierProvider<CarritoNotifier, List<ItemCarrito>>. Métodos: agregar, quitar, actualizarCantidad, limpiar. Persiste en SharedPreferences.
│   │   ├── productos_provider.dart
│   │   │   └── FutureProvider.family para listas paginadas. También un StateProvider para filtros actuales.
│   │   ├── citas_provider.dart
│   │   │   └── FutureProvider<List<Cita>> (próximas y pasadas), con métodos para refrescar.
│   │   ├── mascotas_provider.dart
│   │   │   └── StreamProvider<List<Mascota>> (escucha en tiempo real cambios en Firestore para ese cliente).
│   │   ├── sucursales_provider.dart
│   │   │   └── FutureProvider<List<Sucursal>>.
│   │   ├── pedidos_provider.dart
│   │   │   └── FutureProvider<List<Pedido>>.
│   │   └── conectividad_provider.dart
│   │       └── StreamProvider<bool> para saber si hay internet.
│   │
│   └── utils/
│       ├── formatters.dart (ya descrito arriba)
│       └── validators.dart (ya descrito)
│
└── firebase_options.dart        // Generado automáticamente por FlutterFire
```

**Archivos adicionales en la raíz del proyecto:**

- `pubspec.yaml` – con todas las dependencias listadas en la sección 3.
- `.env` – contiene `FIREBASE_API_KEY`, `FIREBASE_PROJECT_ID`, etc. (no se sube a git).
- `firebase.json` – configuración de hosting (para web).
- `analysis_options.yaml` – reglas de lint personalizadas (incluyendo evitar `print` en producción).
- `assets/` – carpeta con fuentes (Quicksand, Poppins), imágenes de placeholder, iconos SVG.
- `web/` – contiene `index.html` modificado para incluir scripts de Firebase (si es necesario) y meta viewport.

---

## 3. Dependencias y Paquetes – Especificación Técnica

A continuación se listan **todos** los paquetes necesarios en `pubspec.yaml`, con su versión recomendada y propósito exacto.

| Paquete | Versión | Propósito |
|---------|---------|------------|
| **flutter** | sdk: flutter | SDK base |
| **firebase_core** | ^2.24.2 | Inicialización de Firebase en todas las plataformas |
| **cloud_firestore** | ^4.14.0 | Acceso a Firestore (colecciones, documentos, queries) |
| **firebase_auth** | ^4.16.0 | Autenticación de usuarios (email/password) |
| **firebase_storage** | ^11.6.0 | Subida y descarga de imágenes |
| **riverpod** | ^2.4.9 | Gestión de estado reactivo (providers) |
| **flutter_riverpod** | ^2.4.9 | Integración de Riverpod con Flutter |
| **go_router** | ^13.0.0 | Navegación declarativa con rutas anidadas y protección |
| **google_fonts** | ^6.1.0 | Fuentes Poppins y Quicksand |
| **glassmorphism** | ^3.0.0 | Efecto de vidrio esmerilado (alternativa a BackdropFilter) |
| **animate_do** | ^3.1.2 | Animaciones predefinidas (fadeIn, bounce, zoom) |
| **carousel_slider** | ^4.2.1 | Carrusel de banners en el home |
| **image_picker** | ^1.0.5 | Seleccionar imagen de cámara o galería |
| **flutter_svg** | ^2.0.9 | Mostrar iconos en formato SVG |
| **intl** | ^0.18.1 | Formateo de fechas, números y moneda |
| **equatable** | ^2.0.5 | Simplificar comparaciones de objetos (para providers) |
| **uuid** | ^4.2.1 | Generar IDs locales temporales (carrito) |
| **shared_preferences** | ^2.2.2 | Persistir carrito de compras y preferencias |
| **connectivity_plus** | ^5.0.2 | Detectar cambios en la conectividad a internet |
| **flutter_native_splash** | ^2.3.8 | Pantalla de bienvenida personalizada |
| **flutter_launcher_icons** | ^0.13.1 | Generar ícono de la app para todas las plataformas |
| **mask_text_input_formatter** | ^2.8.0 | Máscara para teléfono (formato internacional o local) |
| **flutter_dotenv** | ^5.1.0 | Cargar variables de entorno desde .env |
| **logger** | ^1.4.0 | Logs estructurados en consola (debug) |
| **google_maps_flutter** | ^2.5.3 | Mostrar mapa de sucursales (Android/iOS) – opcional, se puede usar webview |
| **geolocator** | ^10.1.0 | Obtener ubicación del usuario para sucursales cercanas (opcional) |
| **flutter_cache_manager** | ^3.3.1 | Cachear imágenes de productos para mejorar rendimiento |
| **dio** | ^5.4.0 | (Opcional) Para llamadas a Cloud Functions HTTP, aunque se prefieren triggers) |

**Dev dependencies:**
- `flutter_test` – pruebas unitarias.
- `mocktail` – simular dependencias en pruebas.
- `build_runner` – para generar código de serialización JSON (si se usa json_serializable).

**Assets a incluir en `pubspec.yaml`:**
```
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
    - .env
```

**Fuentes:**
- `Poppins-Regular.ttf`, `Poppins-SemiBold.ttf`, `Quicksand-Bold.ttf` descargadas de Google Fonts e incluidas en `assets/fonts/`.

---

## 4. Configuración de Firebase – Firestore, Auth, Storage, Functions

### 4.1 Proyecto Firebase
- Crear proyecto en consola de Firebase con nombre `petco-app`.
- No habilitar Google Analytics (proyecto personal).

### 4.2 Aplicaciones registradas
- **Android:** `com.petco.app` (crear archivo `android/app/google-services.json`).
- **iOS:** `com.petco.app` (crear `ios/Runner/GoogleService-Info.plist`).
- **Web:** `petco-app.web.app` (copiar configuración de SDK en `web/index.html` o usar `firebase_options.dart`).
- **Windows:** usar la misma configuración que Android (Firebase admite Windows mediante C++ SDK, pero Flutter Windows usa la misma configuración que Android a través de `firebase_core`).

### 4.3 Autenticación
- Habilitar **proveedor de correo electrónico/contraseña**.
- Deshabilitar "verificación de correo electrónico" para simplificar (proyecto personal, pero se puede activar luego).

### 4.4 Firestore
- Crear base de datos en modo **nativo** (no Datastore).
- Ubicación: `us-central1` (por defecto).
- Las colecciones se crearán automáticamente al primer documento insertado. Para facilitar, se crean manualmente desde la consola: `clientes`, `mascotas`, `categorias`, `proveedores`, `productos`, `sucursales`, `empleados`, `pedidos`, `servicios`, `citas`, `inventario`.

### 4.5 Firebase Storage
- Bucket por defecto: `petco-app.appspot.com`.
- Crear carpetas: `productos/`, `mascotas/`, `clientes/`, `promociones/`.

### 4.6 Cloud Functions
- Inicializar funciones con `firebase init functions` (seleccionar TypeScript o JavaScript). Se usarán Node.js 18.
- Estructura de funciones:
  - `onPedidoCreated`: trigger cuando se crea un documento en `pedidos`.
  - `onCitaCreated`: trigger cuando se crea una cita (valida disponibilidad y asigna empleado).
  - `actualizarInventario`: llamada HTTP (o trigger) para recalcular stock.
- Desplegar con `firebase deploy --only functions`.

---

## 5. Modelado de Datos en Firestore – Colecciones, Subcolecciones, Referencias

Cada colección se documenta con su estructura exacta (campos, tipos, índices requeridos).

### Colección `clientes`
- Document ID: `uid` de Firebase Authentication.
- Campos:
  - `nombre`: string, obligatorio.
  - `email`: string, obligatorio, único (se valida en reglas).
  - `telefono`: string, opcional.
  - `direccion`: string, opcional.
  - `fecha_nacimiento`: timestamp, opcional.
  - `fecha_registro`: timestamp, automático (serverTimestamp).
  - `tipo_membresia`: string, valores posibles: `estandar`, `premium`. Default `estandar`.
  - `activo`: booleano, default true.
  - `foto_url`: string, opcional (URL de Storage).

### Colección `mascotas`
- Document ID: autogenerado.
- Campos:
  - `cliente_id`: referencia (string) al documento en `clientes`.
  - `nombre`: string.
  - `especie`: string (perro, gato, ave, etc.).
  - `raza`: string, opcional.
  - `sexo`: string, valores 'M', 'F', 'N'.
  - `fecha_nacimiento`: timestamp.
  - `peso_kg`: número (double).
  - `foto_url`: string, opcional.
  - `notas_medicas`: string, opcional.

### Colección `categorias`
- Document ID: autogenerado.
- Campos:
  - `nombre`: string.
  - `descripcion`: string.
  - `categoria_padre_id`: referencia (string) a otra categoría (opcional). Para construir árbol.
  - `imagen_url`: string.
  - `activo`: booleano.

### Colección `productos`
- Document ID: autogenerado.
- Campos:
  - `categoria_id`: referencia.
  - `proveedor_id`: referencia, opcional.
  - `nombre`: string.
  - `descripcion`: string.
  - `codigo_barras`: string, único.
  - `precio`: número.
  - `precio_costo`: número.
  - `especie_objetivo`: string (perro, gato, etc. o 'todas').
  - `imagen_url`: string.
  - `activo`: booleano.
  - `ventas_totales`: número (actualizado por Cloud Function).

### Colección `sucursales`
- Document ID: autogenerado.
- Campos: `nombre`, `direccion`, `ciudad`, `estado`, `telefono`, `horario` (texto libre, ej. "Lun-Vie 9-20"), `latitud`, `longitud`, `activo`.

### Colección `pedidos`
- Document ID: autogenerado.
- Campos:
  - `cliente_id`: referencia.
  - `empleado_id`: referencia opcional.
  - `sucursal_id`: referencia.
  - `fecha_pedido`: timestamp.
  - `subtotal`, `impuesto`, `descuento`, `total`: números.
  - `estado`: string (pendiente, pagado, enviado, entregado, cancelado).
  - `canal`: string (app, web, tienda).
  - `metodo_pago`: string (efectivo, tarjeta).
- Subcolección `detalles_pedido` (dentro de cada pedido):
  - Documentos autogenerados.
  - Campos: `producto_id`, `cantidad`, `precio_unitario`, `descuento`, `subtotal`.

### Colección `servicios`
- Campos: `nombre`, `descripcion`, `precio`, `duracion_min` (entero), `tipo` (baño, corte, consulta, vacunación, etc.), `especie_objetivo`, `activo`.

### Colección `citas`
- Campos:
  - `cliente_id`, `mascota_id`, `servicio_id`, `empleado_id` (opcional), `sucursal_id`.
  - `fecha_hora`: timestamp.
  - `estado`: string (pendiente, confirmada, completada, cancelada).
  - `precio_cobrado`: número (puede ser el precio del servicio en ese momento).
  - `notas`: string.

### Colección `inventario`
- Document ID: compuesto por `producto_id_sucursal_id` (ej. "abc123_xyz789") para evitar duplicados.
- Campos: `producto_id`, `sucursal_id`, `cantidad` (entero), `stock_minimo`, `stock_maximo`, `ultima_actualizacion`.

---

## 6. Reglas de Seguridad de Firestore – Explicación Lógica Completa

Las reglas se escriben en el lenguaje de reglas de Firebase. Aunque no se da código, se describe la lógica para cada colección.

### Reglas generales:
- `allow read, write: if false;` para todo por defecto.
- Solo usuarios autenticados: `allow read: if request.auth != null;` para colecciones de solo lectura (productos, servicios, sucursales, categorías).
- Escritura restringida según propiedad del documento.

### Colección `clientes`
- **Lectura:** Un usuario puede leer su propio documento: `request.auth.uid == resource.id`.
- **Escritura (crear):** Solo puede crear un documento si `request.auth.uid == request.resource.id` (el ID debe coincidir con el UID). Además, el campo `email` debe coincidir con `request.auth.token.email` (si se usa verificación de email).
- **Actualización:** Misma regla de ID, y no puede cambiar `email` o `fecha_registro`.
- **Eliminación:** No permitida (solo desactivar `activo`).

### Colección `mascotas`
- **Lectura:** Solo si `request.auth.uid == resource.data.cliente_id` (el dueño de la mascota es el autenticado). Alternativa: usar `get` para verificar que el cliente_id existe y pertenece.
- **Escritura (crear):** El `cliente_id` debe ser igual a `request.auth.uid`.
- **Actualización:** Solo si el `cliente_id` del documento es el uid.
- **Eliminación:** Misma regla.

### Colección `productos`, `categorias`, `servicios`, `sucursales`
- **Lectura:** `allow read: if request.auth != null;` (cualquier autenticado).
- **Escritura:** Solo si `request.auth.token.admin == true` (se debe asignar un claim personalizado en Firebase Auth para un usuario admin). Como es proyecto personal, se puede hacer una excepción: `allow write: if request.auth.uid == "uid_del_administrador"` (valor fijo).

### Colección `pedidos`
- **Lectura:** Un usuario solo puede leer sus propios pedidos: `request.auth.uid == resource.data.cliente_id`.
- **Escritura (crear):** Debe cumplir que `request.resource.data.cliente_id == request.auth.uid`. Además, el `subtotal` debe coincidir con la suma de los `detalles_pedido` (se puede delegar a Cloud Function).
- **Actualización:** Solo el mismo usuario puede actualizar, pero no cambiar `total` ni `estado` (esto lo hará la Cloud Function).
- **Eliminación:** No permitida.

### Subcolección `detalles_pedido`
- Las reglas se heredan del pedido padre. Se valida que el pedido pertenezca al usuario.

### Colección `citas`
- **Lectura:** `request.auth.uid == resource.data.cliente_id`.
- **Creación:** `request.resource.data.cliente_id == request.auth.uid`. Además, debe validarse que `mascota_id` existe y su `cliente_id` coincide (usando `get`).
- **Actualización/cancelación:** Solo el cliente o un empleado (si se implementa rol empleado).

### Colección `inventario`
- **Lectura:** Autenticados (para consultar stock antes de comprar).
- **Escritura:** Solo administradores o la Cloud Function. El cliente no puede modificar stock directamente.

### Validaciones adicionales:
- Al crear un pedido, se debe verificar que el stock en `inventario` para cada producto y sucursal sea suficiente (esto se hace en la Cloud Function, no en reglas).
- Al crear una cita, verificar que no exista otra cita en la misma sucursal a la misma hora (consulta en reglas es costosa, se hace en Cloud Function).

---

## 7. Índices Compuestos en Firestore – Lista Necesaria

Firestore requiere índices para consultas con múltiples `where` y `orderBy`. Se definen los siguientes:

| Colección | Campos indexados | Tipo de consulta |
|-----------|----------------|------------------|
| `productos` | `activo` (asc), `nombre` (asc) | Listar productos activos ordenados por nombre |
| `productos` | `activo` (asc), `precio` (asc) | Filtrar activos por precio |
| `productos` | `categoria_id` (asc), `activo` (asc) | Filtrar por categoría |
| `productos` | `especie_objetivo` (asc), `activo` (asc) | Filtrar por especie |
| `pedidos` | `cliente_id` (asc), `fecha_pedido` (desc) | Obtener pedidos de un cliente ordenados por fecha |
| `citas` | `cliente_id` (asc), `fecha_hora` (desc) | Historial de citas por cliente |
| `citas` | `sucursal_id` (asc), `fecha_hora` (asc) | Verificar disponibilidad de horario en sucursal |
| `inventario` | `producto_id` (asc), `sucursal_id` (asc) | Consultar stock por producto y sucursal |
| `mascotas` | `cliente_id` (asc), `nombre` (asc) | Listar mascotas de un cliente |

Estos índices se crean automáticamente cuando la app ejecuta la consulta (Firestore muestra un enlace en el error). También se pueden predefinir en un archivo `firestore.indexes.json`.

---

## 8. Cloud Functions – Triggers, Propósitos y Lógica de Negocio

Se implementan **tres funciones principales** usando Node.js (runtime 18). Se describen paso a paso.

### Función 1: `onPedidoCreated`
- **Trigger:** `functions.firestore.document('pedidos/{pedidoId}').onCreate`
- **Propósito:** Validar stock, actualizar inventario, recalcular totales y cambiar estado del pedido.
- **Lógica (en palabras):**
  1. Obtener el nuevo pedido (datos del documento).
  2. Obtener los detalles del pedido desde la subcolección `detalles_pedido` (se leen todos los documentos).
  3. Para cada detalle:
     - Buscar el inventario correspondiente (`producto_id` + `sucursal_id` del pedido).
     - Verificar si `cantidad` en inventario es mayor o igual a la cantidad solicitada.
     - Si no, abortar la transacción y marcar el pedido como `fallido_por_stock` (o cancelado).
  4. Si todo el stock es suficiente, iniciar una transacción de Firestore:
     - Restar las cantidades de cada inventario.
     - Actualizar el campo `estado` del pedido a `pagado` (o `confirmado`).
     - Actualizar el campo `ventas_totales` de cada producto (incrementar por cantidad).
  5. Enviar una notificación push (opcional, usando FCM) al cliente.
- **Salida:** Documento de pedido actualizado.

### Función 2: `onCitaCreated`
- **Trigger:** `functions.firestore.document('citas/{citaId}').onCreate`
- **Propósito:** Verificar que no haya doble reserva y asignar un empleado disponible.
- **Lógica:**
  1. Leer los datos de la nueva cita (sucursal_id, fecha_hora).
  2. Consultar `citas` existentes en esa sucursal con la misma `fecha_hora` y estado no cancelado.
  3. Si existe alguna, cambiar el estado de la nueva cita a `conflicto` y enviar notificación al cliente (o rechazar la creación).
  4. Si no hay conflicto, buscar un empleado de la sucursal cuyo cargo sea adecuado para el servicio (campo `tipo` del servicio). Por simplicidad, asignar el primer empleado activo.
  5. Actualizar el campo `empleado_id` y poner estado `confirmada`.
- **Nota:** Para evitar condiciones de carrera, se debe usar una transacción o Firestore triggers con `runTransaction`.

### Función 3: `actualizarVentasProducto` (llamada desde onPedidoCreated)
- Puede ser una función separada o lógica dentro de la misma. Se encarga de actualizar el contador `ventas_totales` en cada producto.

**Despliegue de funciones:**
- Se necesita instalar `firebase-tools` globalmente.
- Ejecutar `firebase init functions` y elegir TypeScript.
- Escribir las funciones en `functions/src/index.ts`.
- Desplegar con `firebase deploy --only functions`.

---

## 9. Gestión de Estado con Riverpod – Providers Detallados

Riverpod se usa para inyectar dependencias y gestionar el estado reactivo. Se crean los siguientes providers:

### Provider de repositorios (singleton)
- `authRepositoryProvider` → retorna `AuthRepository` (concreto).
- `clienteRepositoryProvider` → `ClienteRepository`.
- `mascotaRepositoryProvider`
- `productoRepositoryProvider`
- `pedidoRepositoryProvider`
- `citaRepositoryProvider`
- `sucursalRepositoryProvider`
- `inventarioRepositoryProvider`

### Provider de casos de uso
- `loginUseCaseProvider` → depende de `authRepositoryProvider`.
- `registroUseCaseProvider`
- `obtenerProductosUseCaseProvider`
- `crearPedidoUseCaseProvider`
- `agendarCitaUseCaseProvider`, etc.

### StateNotifierProvider para estado global
- `authNotifierProvider` → maneja `AuthState` (usuario autenticado, cargando, error). Escucha cambios en `auth_service` y refresca cliente.
- `carritoNotifierProvider` → maneja lista de `ItemCarrito`. Métodos públicos: `agregarItem`, `removerItem`, `actualizarCantidad`, `vaciarCarrito`. Persiste en `shared_preferences` cada vez que cambia.
- `filtrosProductosProvider` → simple `StateProvider` que guarda objeto con categoría seleccionada, especie, rango de precios, ordenamiento.

### FutureProvider/StreamProvider para datos asíncronos
- `productosProvider` → `FutureProvider<List<Producto>>` que depende de `filtrosProductosProvider` y llama a `obtenerProductosUseCase` con paginación. Se puede combinar con `family` para páginas.
- `misMascotasProvider` → `StreamProvider<List<Mascota>>` que escucha cambios en tiempo real (útil para actualizar interfaz automáticamente).
- `misCitasProvider` → `FutureProvider` con opción de refrescar manualmente.
- `sucursalesProvider` → `FutureProvider`.

### Provider de conectividad
- `connectivityStreamProvider` → `StreamProvider<bool>` que usa `connectivity_plus`.

**Ejemplo de uso en pantalla:**
```dart
// Concepto, no código
final productos = ref.watch(productosProvider);
productos.when(
  data: (lista) => mostrar lista,
  loading: () => mostrarLoading,
  error: (err) => mostrarError,
);
```

---

## 10. Navegación y Rutas – GoRouter Configuración

Se define `GoRouter` con rutas declarativas y protección de rutas.

### Lista de rutas (nombres y paths):
| Nombre | Path | Pantalla | Protección |
|--------|------|----------|-------------|
| `login` | `/login` | LoginScreen | Solo si no autenticado |
| `register` | `/register` | RegistroScreen | Solo si no autenticado |
| `home` | `/` | HomeScreen | Requiere autenticación |
| `productos` | `/productos` | CatalogoProductosScreen | Requiere autenticación |
| `productoDetalle` | `/productos/:id` | DetalleProductoScreen | Requiere autenticación |
| `carrito` | `/carrito` | CarritoScreen | Requiere autenticación |
| `checkout` | `/checkout` | CheckoutScreen | Requiere autenticación |
| `mascotas` | `/mascotas` | MisMascotasScreen | Requiere autenticación |
| `registrarMascota` | `/mascotas/registrar` | RegistrarMascotaScreen | Requiere autenticación |
| `editarMascota` | `/mascotas/editar/:id` | EditarMascotaScreen | Requiere autenticación |
| `citas` | `/citas` | MisCitasScreen | Requiere autenticación |
| `agendarCita` | `/citas/agendar` | AgendarCitaScreen | Requiere autenticación |
| `perfil` | `/perfil` | PerfilScreen | Requiere autenticación |
| `editarPerfil` | `/perfil/editar` | EditarPerfilScreen | Requiere autenticación |
| `pedidos` | `/pedidos` | MisPedidosScreen | Requiere autenticación |
| `detallePedido` | `/pedidos/:id` | DetallePedidoScreen | Requiere autenticación |
| `sucursales` | `/sucursales` | SucursalesScreen | Requiere autenticación |

**Redirección global:**
- Si el usuario no está autenticado y trata de acceder a cualquier ruta protegida, redirigir a `/login`.
- Si el usuario ya autenticado e intenta ir a `/login` o `/register`, redirigir a `/home`.

**Navegación anidada:** Se usa `ShellRoute` para mantener el `BottomNavigationBar` persistente en todas las pantallas principales (home, productos, mascotas, citas, perfil). Las rutas de detalle (producto, carrito, checkout) se muestran sin la barra inferior.

---

## 11. Diseño UX/UI – Especificaciones Completas de Glassmorphism, Colores, Tipografía, Animaciones

### 11.1 Paleta de colores (exacta)
- **Azul pastel primario:** `#A3C6FF` (RGB: 163, 198, 255) → usado en botones principales, íconos activos, enlaces, bordes de inputs en focus.
- **Azul pastel secundario:** `#B3D4FF` (RGB: 179, 212, 255) → usado en fondos de elementos seleccionados, hover de botones.
- **Rojo pastel primario:** `#FFB3B3` (RGB: 255, 179, 179) → botones de peligro (cancelar, eliminar), indicadores de error, badges de descuento.
- **Rojo pastel secundario:** `#FFC5C5` (RGB: 255, 197, 197) → fondos de advertencia suaves.
- **Fondo general de la app:** `#F8FAFE` (gris azulado muy claro).
- **Fondo glass:** blanco con opacidad 0.7 (`#FFFFFF` + 70% alpha) sobre imágenes de fondo o gradientes.
- **Texto principal:** `#1C2E3A` (azul marino oscuro).
- **Texto secundario:** `#5A6E7C` (gris azulado medio).
- **Bordes y divisores:** `#D9E2EC` con opacidad 0.5.

### 11.2 Efecto Glassmorphism (especificación visual)
- **Tarjetas (`GlassCard`):**
  - `backgroundColor: Colors.white.withOpacity(0.7)`
  - `borderRadius: BorderRadius.circular(24)`
  - `border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5)`
  - `boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 12, offset: Offset(0, 4))]`
  - En elementos que se superponen a imágenes de fondo: usar `BackdropFilter` con `ImageFilter.blur(sigmaX: 8, sigmaY: 8)`.

- **Botones (`GlassButton`):**
  - Fondo blanco semitransparente (opacity 0.8).
  - Borde redondeado de 32px.
  - Sombra suave al hover/press.
  - Texto en azul pastel primario.

- **AppBar:**
  - Fondo transparente o con blur solo en scroll (usando `SliverAppBar` con `forceElevated`).
  - Título con `Quicksand` bold, color texto principal.

- **Inputs (`CampoFormularioGlass`):**
  - Decoración: borde redondeado de 16px, relleno blanco opaco 0.6, label con `Poppins` regular, color azul pastel cuando está enfocado.

### 11.3 Tipografía
- **Títulos H1-H3:** `Quicksand` Bold, tamaños: 28, 24, 20. Espaciado entre letras: -0.5.
- **Cuerpo de texto:** `Poppins` Regular, 14px (móvil) o 16px (web). Interlineado 1.5.
- **Botones:** `Poppins` SemiBold, 16px, mayúsculas opcionales (texto en mayúscula solo para botones primarios).
- **Textos pequeños (precios, fechas):** `Poppins` Light, 12px, color texto secundario.

### 11.4 Animaciones y Microinteracciones (detalladas)

| Elemento | Animación | Duración | Curva |
|----------|-----------|----------|-------|
| Transición entre pantallas | `SlideTransition` horizontal (derecha a izquierda) | 300ms | `Curves.easeInOut` |
| Aparición de tarjetas en lista | Fade + escala (0.9 a 1) con stagger (cada 50ms) | 200ms por tarjeta | `Curves.easeOut` |
| Botón "Agregar al carrito" | Efecto de onda (ripple) + ícono de check temporal | 150ms | `Curves.elasticOut` |
| Producto añadido al carrito | Animación de vuelo: pequeña réplica del producto que se mueve hacia el icono del carrito en la AppBar | 400ms | `Curves.easeInOutCubic` |
| Carga de datos (skeleton screens) | Pulsos de opacidad (shimmer) sobre placeholders | cíclico 1.5s | lineal |
| Botón de carga (login) | Indicador circular reemplaza al texto | - | - |
| Deslizar para eliminar (en carrito o mascotas) | Deslizamiento horizontal con fondo rojo pastel | 200ms | `Curves.easeOut` |
| Refrescar lista (pull-to-refresh) | Animación nativa de `RefreshIndicator` | - | - |

### 11.5 Disposición Responsiva
- **Móvil (ancho < 600px):** Listas en columna, GridView con 2 columnas para productos, BottomNavigationBar.
- **Tablet (600-1200px):** Grid de productos con 3 o 4 columnas, menú lateral opcional.
- **Web/Desktop (>1200px):** Máximo ancho de contenido 1200px centrado, uso de `Center` y `ConstrainedBox`. Sidebar izquierdo para navegación principal.

---

## 12. Pantallas y Flujos – Explicación Paso a Paso de Cada Interfaz

### 12.1 Autenticación

**LoginScreen:**
- Campo email (con ícono de sobre) validación en tiempo real (formato email).
- Campo contraseña (ícono de candado, toggle mostrar/ocultar).
- Botón "Iniciar sesión" (glass). Al presionar:
  - Mostrar indicador de carga.
  - Invocar `loginUseCase`.
  - Si error, mostrar SnackBar con mensaje (ej. "Credenciales incorrectas").
  - Si éxito, redirigir a `/home`.
- Enlace "¿Olvidaste tu contraseña?" (envía correo de restablecimiento usando `sendPasswordResetEmail`).
- Enlace "Registrarse" → navegar a `/register`.

**RegistroScreen (2 pasos):**
- Paso 1: email, contraseña (con confirmación). Validar que coincidan.
- Paso 2: nombre completo, teléfono (con máscara), dirección, fecha de nacimiento (date picker). Opcional: foto de perfil.
- Botón final "Crear cuenta". Llamar a `registerUseCase`. Si éxito, autenticar automáticamente y redirigir a home.

### 12.2 Home (Dashboard)

**Estructura visual (de arriba a abajo):**
- AppBar con saludo "¡Hola, [nombre]!" y avatar (si tiene foto). Botón de carrito con badge de cantidad de items.
- Carrusel de promociones: imágenes de 16:9, redondeadas, con indicador de página (smooth_page_indicator). Las imágenes se obtienen de Storage (carpeta `promociones/`).
- Sección "Servicios rápidos": 3 botones grandes con íconos (Baño, Corte, Consulta). Cada uno al presionar abre `AgendarCitaScreen` con el servicio preseleccionado.
- Sección "Productos más vendidos": título, lista horizontal de `ProductCard` (imagen, nombre, precio). Se obtienen de `productos` ordenado por `ventas_totales` descendente (límite 10).
- Sección "Sucursal más cercana": si el usuario dio permiso de ubicación, mostrar la sucursal más cercana (distancia calculada con `geolocator`) y un botón "Ver sucursales".
- Botón flotante de ayuda (chat simulado, opcional).

### 12.3 Catálogo de Productos y Búsqueda

**CatalogoProductosScreen:**
- SliverAppBar colapsable con campo de búsqueda (debounce de 500ms).
- Filtros: barra de chips horizontales (Categorías, Especie, Precio). Al tocar, se abre un modal inferior (`showModalBottomSheet`) con opciones.
- GridView de productos (2 columnas en móvil, 4 en web).
- Paginación infinita (scroll): cuando se llega al final, carga siguiente página usando `startAfter` del último documento.
- Cada tarjeta: imagen, nombre, precio, botón "+" que agrega al carrito (con animación de vuelo).
- Botón flotante "Filtros" (en móvil) que abre el mismo modal.

**Búsqueda:** Mientras se escribe, se ejecuta una consulta a Firestore con `where` sobre campo `nombre` usando `array-contains`? No se puede, Firestore no permite búsqueda parcial. Alternativa: usar `isGreaterThanOrEqualTo` y `isLessThan` para prefijos, o integrar Algolia (más complejo). Para proyecto personal, se puede buscar solo por coincidencia exacta de prefijo (ej. "ali" encuentra "Alimento"). Esto se hace con `startAt(query)` y `endAt(query + '\uf8ff')`.

### 12.4 Detalle de Producto y Carrito

**DetalleProductoScreen:**
- Imagen principal (Hero animada) + galería de imágenes (si hay múltiples).
- Título, precio, descripción.
- Selector de cantidad (botones + y -) con límite de stock (consulta a inventario para sucursal seleccionada).
- Dropdown para seleccionar sucursal (solo las que tienen stock > 0). Por defecto, la sucursal guardada en preferencias.
- Botones: "Agregar al carrito" (actualiza carritoProvider) y "Comprar ahora" (lleva a checkout con ese producto).
- Sección de "Productos relacionados" (misma categoría).

**CarritoScreen:**
- Lista de `ItemCarrito` con imagen, nombre, cantidad (stepper), precio unitario, subtotal por item.
- Botón eliminar (ícono basura) con diálogo de confirmación.
- Resumen: subtotal, impuesto (16% o fijo), descuento (si hay cupón), total.
- Botón "Continuar comprando" (vuelve a catálogo) y "Proceder al pago" (navega a `/checkout`).

### 12.5 Proceso de Checkout y Pedidos

**CheckoutScreen (pasos):**
1. **Confirmar sucursal:** Mapa o lista, se muestra la sucursal seleccionada en el carrito. Puede cambiarse.
2. **Método de pago:** Dos opciones: "Efectivo en tienda" o "Tarjeta de crédito (simulado)". Para tarjeta, se muestran campos ficticios (solo para demo, no se procesa realmente).
3. **Resumen final:** Lista de productos, total, dirección de la sucursal.
4. **Botón "Confirmar pedido":** 
   - Valida stock nuevamente (llamando a `verificarStockUseCase`).
   - Crea el pedido en Firestore (documento `pedidos` y subcolección `detalles_pedido`).
   - La Cloud Function `onPedidoCreated` se encarga del resto.
   - Limpia el carrito local.
   - Muestra pantalla de éxito con número de pedido y botón "Ver mis pedidos".

### 12.6 Gestión de Mascotas

**MisMascotasScreen:**
- Lista de tarjetas. Cada tarjeta muestra foto (placeholder si no tiene), nombre, especie, raza. Botones: editar (lápiz) y eliminar (basura).
- Botón flotante + que abre `RegistrarMascotaScreen`.
- Al eliminar, diálogo de confirmación; si acepta, elimina de Firestore y opcionalmente la imagen de Storage.

**RegistrarMascotaScreen:**
- Formulario con:
  - Nombre (requerido)
  - Especie (dropdown: perro, gato, conejo, ave, etc.)
  - Raza (TextField)
  - Sexo (3 botones: Macho, Hembra, Neutro)
  - Fecha de nacimiento (DatePicker, máximo hoy, mínimo hace 30 años)
  - Peso (double, con dos decimales)
  - Notas médicas (textarea)
  - Imagen: botón para seleccionar de galería/cámara, vista previa.
- Botón "Guardar": llama a `registrarMascotaUseCase` que sube imagen a Storage (si la hay) y guarda en Firestore.

### 12.7 Agenda de Citas Veterinarias

**AgendarCitaScreen (stepper de 4 pasos):**
1. **Seleccionar mascota:** Lista de las mascotas del cliente (usando `misMascotasProvider`). Si no tiene, redirigir a registrar mascota.
2. **Seleccionar servicio:** Lista de servicios activos de Firestore, muestra nombre, precio, duración.
3. **Seleccionar sucursal:** Mapa o lista de sucursales.
4. **Seleccionar fecha y hora:** 
   - Calendario (solo días con disponibilidad, usando función auxiliar).
   - Horarios disponibles: se consulta a Firestore las citas ya existentes en esa sucursal y fecha, y se calculan los slots libres basados en duración del servicio (ej. cada 30 minutos).
5. **Confirmación:** Resumen, botón "Agendar". Llama a `agendarCitaUseCase`. La Cloud Function verificará conflictos y asignará empleado.

**MisCitasScreen:**
- TabBar: Próximas (estados: pendiente, confirmada) y Pasadas (completada, cancelada).
- Cada cita en tarjeta: servicio, mascota, sucursal, fecha/hora, estado (con color: azul para pendiente, verde para confirmada, rojo para cancelada).
- Botón "Cancelar" en citas próximas (solo si fecha_hora > ahora + 24h). Muestra diálogo de confirmación.

### 12.8 Perfil y Configuración

**PerfilScreen:**
- Header circular con foto (Avatar), botón para cambiar foto (abre image_picker).
- Campos de solo lectura o editables (nombre, email, teléfono, dirección, fecha nacimiento). Botón "Editar" que lleva a `EditarPerfilScreen`.
- Sección "Membresía": muestra tipo (estándar/premium) y quizás beneficios (no funcional por ahora).
- Botón "Cerrar sesión": llama a `logoutUseCase` y redirige a login.
- Botón "Eliminar cuenta": solo para desarrollo, elimina el usuario de Auth y su documento en Firestore.

**EditarPerfilScreen:**
- Formulario con campos editables (excepto email). Valida teléfono, dirección, etc.
- Botón "Guardar cambios" actualiza Firestore.

### 12.9 Historial de Pedidos

**MisPedidosScreen:**
- Lista de pedidos (FutureProvider) ordenados por fecha descendente.
- Cada tarjeta: número (primeros 8 caracteres del ID), total, fecha, estado (badge con color según estado).
- Al tocar, navega a `DetallePedidoScreen` con el ID.

**DetallePedidoScreen:**
- Muestra: fecha, sucursal, método de pago.
- Tabla de productos: nombre, cantidad, precio unitario, subtotal.
- Totales (subtotal, impuesto, descuento, total).
- Estado y línea de tiempo (pendiente -> pagado -> enviado -> entregado) con indicadores visuales.

### 12.10 Sucursales y Mapa

**SucursalesScreen:**
- Split view (web/tablet): mapa a la izquierda, lista a la derecha. En móvil: pestañas o modal.
- Mapa con marcadores en cada sucursal (usando `google_maps_flutter`). Al tocar marcador, se resalta la tarjeta en lista.
- Lista de sucursales: cada tarjeta muestra nombre, dirección, horario, teléfono, botón "Seleccionar" (para usarla en carrito o cita) y botón "Ver horarios" (modal).
- Botón "Usar mi ubicación" centra el mapa en la posición actual.

---

## 13. Manejo de Imágenes – Carga, Optimización y Almacenamiento en Firebase Storage

- **Compresión previa:** Usar el paquete `image_picker` para obtener archivo, luego `flutter_image_compress` para reducir tamaño (máximo 1024x1024 píxeles, calidad 80%). Esto ahorra ancho de banda y costos.
- **Subida a Storage:** 
  - Ruta: `mascotas/{cliente_id}/{nombre_archivo}.jpg` 
  - Se genera nombre único con `uuid` para evitar colisiones.
  - `FirebaseStorage` método `putFile` con `SettableMetadata` (contentType: image/jpeg).
  - Obtener URL de descarga con `getDownloadURL()`.
- **Caché:** Usar `CachedNetworkImage` (paquete `cached_network_image`) para mostrar imágenes con caché local y placeholder mientras carga.
- **Eliminación:** Al eliminar mascota o producto (si es admin), también eliminar la imagen de Storage.

---

## 14. Persistencia Local – SharedPreferences para Carrito y Preferencias

- **Carrito:** Guardar lista de `ItemCarrito` como JSON string en clave `cart_items`. Cada item: `{productoId, nombre, imagenUrl, precio, cantidad}`. Al iniciar app, se carga.
- **Preferencias:** 
  - `selected_sucursal_id`: última sucursal usada para checkout.
  - `last_email`: recordar email en login (opcional).
  - `onboarding_done`: bool para mostrar primera vez un onboarding.
- Implementación: una clase `LocalStorageService` con métodos `saveCart`, `loadCart`, `savePreference`, etc.

---

## 15. Manejo de Errores y Estados de Carga – Estrategia Global

- **Cada provider** maneja `AsyncValue` (data, loading, error). En UI se usa `when`.
- **SnackBar global:** Se usa `ScaffoldMessenger` con una key global definida en `MyApp`.
- **Errores comunes y mensajes amigables:**
  - `NetworkError`: "No hay conexión a internet. Revisa tu red."
  - `PermissionDenied`: "No tienes permiso para realizar esta acción."
  - `StockInsuficiente`: "Lo sentimos, no hay suficiente stock de [producto] en la sucursal seleccionada."
  - `HorarioOcupado`: "La cita en ese horario ya está ocupada. Por favor elige otra hora."
- **Logger:** En desarrollo, imprimir errores detallados con `logger.e(exception, stackTrace)`.

---

## 16. Pruebas Manuales – Escenarios y Casos de Uso a Verificar

| ID | Escenario | Pasos | Resultado esperado |
|----|-----------|-------|---------------------|
| T1 | Registro exitoso | Completar formulario válido | Usuario creado, redirige a home, aparece documento en Firestore `clientes` |
| T2 | Login incorrecto | Email válido, contraseña errónea | SnackBar "Credenciales incorrectas" |
| T3 | Agregar producto al carrito | Desde catálogo, tocar "+" | Carrito badge incrementa, item aparece en carrito | 
| T4 | Stock insuficiente | Intentar comprar más cantidad de la disponible | Mensaje de error, no permite checkout |
| T5 | Crear pedido | Carrito con items, seleccionar sucursal y pago | Pedido creado, stock reduce, aparece en historial |
| T6 | Agendar cita conflicto | Dos citas misma sucursal misma hora | La segunda cita se rechaza o marca conflicto |
| T7 | Cancelar cita | Desde mis citas, botón cancelar | Estado cambia a cancelada, no se puede agendar en ese horario |
| T8 | Subir foto de mascota | Seleccionar imagen, guardar | Imagen subida a Storage, URL guardada en Firestore |
| T9 | Sin conexión | Desactivar WiFi, abrir app | Indicador offline, datos cacheados (si se implementó), no se pueden nuevas compras |
| T10 | Cambiar sucursal | En checkout, cambiar sucursal | Se actualiza disponibilidad de stock y horarios de cita |

---

## 17. Configuración Multiplataforma – Android, iOS, Web, Windows

### Android
- `minSdkVersion: 21`
- `compileSdkVersion: 34`
- Permisos: internet, acceso a galería/cámara, ubicación (opcional).
- Generar `google-services.json` y colocarlo en `android/app/`.

### iOS
- `minimum deployment target: 11.0`
- Agregar permisos en `ios/Runner/Info.plist`: `NSPhotoLibraryUsageDescription`, `NSCameraUsageDescription`, `NSLocationWhenInUseUsageDescription`.
- `GoogleService-Info.plist` en `ios/Runner/`.

### Web
- Configurar en Firebase Hosting (opcional). Para desarrollo, usar `web/index.html` con los scripts de Firebase SDK (o usar `firebase_options.dart`).
- Habilitar CORS en Storage (reglas).
- El efecto glassmorphism con `BackdropFilter` puede fallar en algunos navegadores; tener fallback de color sólido.

### Windows
- Depende de `firebase_core` con soporte experimental. Se necesita la DLL de Firebase C++. En la práctica, para proyecto personal se puede omitir Windows o usar la misma configuración web dentro de un contenedor.

**Comandos de ejecución:**
- `flutter run -d chrome` (web)
- `flutter run -d windows` (Windows)
- `flutter run -d android` (dispositivo físico o emulador)

---

## 18. Despliegue Local y Variables de Entorno

- Crear archivo `.env` en la raíz (ignorado por git) con:
```
FIREBASE_API_KEY=XXXX
FIREBASE_APP_ID=XXXX
FIREBASE_PROJECT_ID=XXXX
FIREBASE_MESSAGING_SENDER_ID=XXXX
FIREBASE_STORAGE_BUCKET=XXXX
FIREBASE_AUTH_DOMAIN=XXXX
```
- Cargar con `flutter_dotenv` en `main.dart` antes de `runApp`.
- Usar `DotEnv().env['FIREBASE_API_KEY']` para configurar `FirebaseOptions` si no se usa `firebase_options.dart`. Pero es más sencillo usar el archivo generado.

---

## 19. Lista de Verificación Final (Checklist)

- [ ] Configuración de proyecto Firebase y apps registradas.
- [ ] Archivos de configuración descargados e integrados.
- [ ] Ejecución de `flutterfire configure`.
- [ ] Estructura de carpetas creada completamente.
- [ ] Dependencias añadidas en `pubspec.yaml` y ejecutado `flutter pub get`.
- [ ] Modelos y repositorios implementados (sin código, pero planificados).
- [ ] Casos de uso definidos para cada entidad.
- [ ] Providers de Riverpod configurados.
- [ ] Reglas de Firestore escritas y desplegadas (modo prueba inicial, luego reforzadas).
- [ ] Índices compuestos creados (automática o manualmente).
- [ ] Cloud Functions escritas y desplegadas.
- [ ] Pantallas diseñadas con glassmorphism (widgets reutilizables).
- [ ] Rutas GoRouter definidas con protección.
- [ ] Persistencia local para carrito.
- [ ] Pruebas manuales de todos los flujos críticos.
- [ ] Verificación del correcto funcionamiento en las cuatro plataformas (al menos Android y Web).

---

Este plan extremadamente detallado cubre todos los aspectos necesarios para la implementación de la app Petco, sin dejar nada implícito. Cada componente, archivo, regla y flujo ha sido descrito con precisión para que puedas llevarlo a la práctica sin ambigüedades.

#PROMPT:
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
