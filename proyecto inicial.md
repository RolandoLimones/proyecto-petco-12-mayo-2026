Actúa como un administrador de base de datos: proyecto tienda petco, que entidades se necesitan para su gestión
Para una **tienda Petco**, aquí están las entidades esenciales para su sistema de gestión:Estas son las **12 entidades** del modelo, agrupadas por dominio:
<img width="658" height="613" alt="image" src="https://github.com/user-attachments/assets/8932e1a3-71b4-400a-8056-d22bbef3e8c9" /><br>

**Clientes y mascotas**
`CLIENTE` y `MASCOTA` con relación uno a muchos: un cliente puede tener varias mascotas registradas.

**Catálogo y proveedores**
`PRODUCTO`, `CATEGORIA` (con soporte de jerarquía padre-hijo, ej. "Alimentos > Perros > Cachorros") y `PROVEEDOR`.

**Ventas**
`PEDIDO` y `DETALLE_PEDIDO` modelan el encabezado y las líneas de venta. El campo `canal` en pedido permite distinguir venta en tienda, en línea o app.

**Servicios veterinarios y grooming**
`SERVICIO` y `CITA` cubren peluquería, veterinaria, adiestramiento, etc. La cita vincula cliente, mascota, servicio, empleado y sucursal en un solo evento.

**Operaciones internas**
`EMPLEADO`, `SUCURSAL` e `INVENTARIO`. El inventario es por sucursal, lo que permite gestionar stock de forma distribuida entre tiendas.

---

Algunas entidades adicionales que podrías considerar en una fase posterior son historial médico de mascota, programa de lealtad/puntos, campañas de descuento y movimientos de inventario (entradas/salidas). ¿Quieres que profundice en alguna entidad o que genere el DDL en SQL?
