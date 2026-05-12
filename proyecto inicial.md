Actúa como un administrador de base de datos: proyecto tienda petco, que entidades se necesitan para su gestión<br>
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

<br>las entidades con sus atributos y tipo en forma de tabla para cada una de las entidades

<style>
.entity-card { background: var(--color-background-primary); border: 0.5px solid var(--color-border-tertiary); border-radius: var(--border-radius-lg); margin-bottom: 1.25rem; overflow: hidden; }
.entity-header { display: flex; align-items: center; gap: 10px; padding: 10px 16px; border-bottom: 0.5px solid var(--color-border-tertiary); }
.entity-icon { width: 28px; height: 28px; border-radius: var(--border-radius-md); display: flex; align-items: center; justify-content: center; font-size: 14px; flex-shrink: 0; }
.entity-name { font-size: 14px; font-weight: 500; color: var(--color-text-primary); font-family: var(--font-mono); }
.entity-desc { font-size: 12px; color: var(--color-text-secondary); margin-left: auto; }
table { width: 100%; border-collapse: collapse; font-size: 13px; }
th { text-align: left; padding: 6px 16px; font-size: 11px; font-weight: 500; color: var(--color-text-tertiary); background: var(--color-background-secondary); border-bottom: 0.5px solid var(--color-border-tertiary); letter-spacing: 0.04em; }
td { padding: 7px 16px; border-bottom: 0.5px solid var(--color-border-tertiary); vertical-align: middle; color: var(--color-text-primary); }
tr:last-child td { border-bottom: none; }
.col-attr { font-family: var(--font-mono); font-size: 12px; color: var(--color-text-primary); }
.badge { display: inline-block; font-size: 11px; padding: 2px 8px; border-radius: 20px; font-family: var(--font-mono); font-weight: 400; }
.b-pk  { background: #EEEDFE; color: #3C3489; }
.b-fk  { background: #E1F5EE; color: #085041; }
.b-int { background: #E6F1FB; color: #0C447C; }
.b-str { background: #FAEEDA; color: #633806; }
.b-dec { background: #EAF3DE; color: #27500A; }
.b-dat { background: #FAECE7; color: #712B13; }
.b-boo { background: #FBEAF0; color: #72243E; }
.b-tst { background: #F1EFE8; color: #444441; }
.desc-col { font-size: 12px; color: var(--color-text-secondary); }
.pk-row td { background: transparent; }
.section-sep { height: 2rem; }
</style>

<h2 class="sr-only">Tablas de entidades del proyecto Petco con sus atributos y tipos de datos</h2>

<div style="display:flex; gap:8px; flex-wrap:wrap; margin-bottom:1.25rem; padding-top:0.5rem;">
  <span style="font-size:12px; color:var(--color-text-secondary)">Leyenda:</span>
  <span class="badge b-pk">PK uuid</span>
  <span class="badge b-fk">FK uuid</span>
  <span class="badge b-str">VARCHAR</span>
  <span class="badge b-int">INT</span>
  <span class="badge b-dec">DECIMAL</span>
  <span class="badge b-dat">DATE</span>
  <span class="badge b-tst">TIMESTAMP</span>
  <span class="badge b-boo">BOOLEAN</span>
</div>

<!-- CLIENTE -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#EEEDFE"><i class="ti ti-user" style="color:#534AB7"></i></div>
    <span class="entity-name">CLIENTE</span>
    <span class="entity-desc">Personas que compran o usan servicios</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">nombre</td><td><span class="badge b-str">VARCHAR(100)</span></td><td>NOT NULL</td><td class="desc-col">Nombre completo</td></tr>
      <tr><td class="col-attr">email</td><td><span class="badge b-str">VARCHAR(150)</span></td><td>UNIQUE NOT NULL</td><td class="desc-col">Correo electrónico</td></tr>
      <tr><td class="col-attr">telefono</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>NULL</td><td class="desc-col">Número de contacto</td></tr>
      <tr><td class="col-attr">direccion</td><td><span class="badge b-str">VARCHAR(255)</span></td><td>NULL</td><td class="desc-col">Dirección de entrega</td></tr>
      <tr><td class="col-attr">fecha_nacimiento</td><td><span class="badge b-dat">DATE</span></td><td>NULL</td><td class="desc-col">Para promociones y perfil</td></tr>
      <tr><td class="col-attr">fecha_registro</td><td><span class="badge b-tst">TIMESTAMP</span></td><td>NOT NULL DEFAULT NOW()</td><td class="desc-col">Alta en el sistema</td></tr>
      <tr><td class="col-attr">tipo_membresia</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>DEFAULT 'estandar'</td><td class="desc-col">estandar / gold / vip</td></tr>
      <tr><td class="col-attr">activo</td><td><span class="badge b-boo">BOOLEAN</span></td><td>DEFAULT TRUE</td><td class="desc-col">Baja lógica del cliente</td></tr>
    </tbody>
  </table>
</div>

<!-- MASCOTA -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#E1F5EE"><i class="ti ti-paw" style="color:#0F6E56"></i></div>
    <span class="entity-name">MASCOTA</span>
    <span class="entity-desc">Animales registrados por los clientes</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">cliente_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Dueño de la mascota</td></tr>
      <tr><td class="col-attr">nombre</td><td><span class="badge b-str">VARCHAR(60)</span></td><td>NOT NULL</td><td class="desc-col">Nombre de la mascota</td></tr>
      <tr><td class="col-attr">especie</td><td><span class="badge b-str">VARCHAR(40)</span></td><td>NOT NULL</td><td class="desc-col">Perro, gato, ave, etc.</td></tr>
      <tr><td class="col-attr">raza</td><td><span class="badge b-str">VARCHAR(60)</span></td><td>NULL</td><td class="desc-col">Raza específica</td></tr>
      <tr><td class="col-attr">sexo</td><td><span class="badge b-str">CHAR(1)</span></td><td>CHECK (M/F/N)</td><td class="desc-col">Macho / Hembra / Neutro</td></tr>
      <tr><td class="col-attr">fecha_nacimiento</td><td><span class="badge b-dat">DATE</span></td><td>NULL</td><td class="desc-col">Para calcular edad</td></tr>
      <tr><td class="col-attr">peso_kg</td><td><span class="badge b-dec">DECIMAL(5,2)</span></td><td>NULL</td><td class="desc-col">Peso en kilogramos</td></tr>
      <tr><td class="col-attr">foto_url</td><td><span class="badge b-str">VARCHAR(255)</span></td><td>NULL</td><td class="desc-col">Imagen de perfil</td></tr>
      <tr><td class="col-attr">notas_medicas</td><td><span class="badge b-str">TEXT</span></td><td>NULL</td><td class="desc-col">Alergias, condiciones crónicas</td></tr>
    </tbody>
  </table>
</div>

<!-- CATEGORIA -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#FAEEDA"><i class="ti ti-tag" style="color:#854F0B"></i></div>
    <span class="entity-name">CATEGORIA</span>
    <span class="entity-desc">Árbol de categorías de productos</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">nombre</td><td><span class="badge b-str">VARCHAR(80)</span></td><td>NOT NULL</td><td class="desc-col">Nombre de la categoría</td></tr>
      <tr><td class="col-attr">descripcion</td><td><span class="badge b-str">TEXT</span></td><td>NULL</td><td class="desc-col">Descripción detallada</td></tr>
      <tr><td class="col-attr">categoria_padre_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NULL (raíz)</td><td class="desc-col">Auto-referencia para jerarquía</td></tr>
      <tr><td class="col-attr">imagen_url</td><td><span class="badge b-str">VARCHAR(255)</span></td><td>NULL</td><td class="desc-col">Ícono o imagen de categoría</td></tr>
      <tr><td class="col-attr">activo</td><td><span class="badge b-boo">BOOLEAN</span></td><td>DEFAULT TRUE</td><td class="desc-col">Visibilidad en tienda</td></tr>
    </tbody>
  </table>
</div>

<!-- PROVEEDOR -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#FAECE7"><i class="ti ti-truck" style="color:#993C1D"></i></div>
    <span class="entity-name">PROVEEDOR</span>
    <span class="entity-desc">Empresas que suministran productos</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">nombre</td><td><span class="badge b-str">VARCHAR(120)</span></td><td>NOT NULL</td><td class="desc-col">Razón social</td></tr>
      <tr><td class="col-attr">contacto_nombre</td><td><span class="badge b-str">VARCHAR(100)</span></td><td>NULL</td><td class="desc-col">Persona de contacto</td></tr>
      <tr><td class="col-attr">email</td><td><span class="badge b-str">VARCHAR(150)</span></td><td>NULL</td><td class="desc-col">Correo comercial</td></tr>
      <tr><td class="col-attr">telefono</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>NULL</td><td class="desc-col">Teléfono de contacto</td></tr>
      <tr><td class="col-attr">pais</td><td><span class="badge b-str">VARCHAR(60)</span></td><td>NULL</td><td class="desc-col">País de origen</td></tr>
      <tr><td class="col-attr">rfc</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>UNIQUE NULL</td><td class="desc-col">Registro fiscal</td></tr>
      <tr><td class="col-attr">activo</td><td><span class="badge b-boo">BOOLEAN</span></td><td>DEFAULT TRUE</td><td class="desc-col">Estado del proveedor</td></tr>
    </tbody>
  </table>
</div>

<!-- PRODUCTO -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#EAF3DE"><i class="ti ti-package" style="color:#3B6D11"></i></div>
    <span class="entity-name">PRODUCTO</span>
    <span class="entity-desc">Artículos en venta en la tienda</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">categoria_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Categoría del producto</td></tr>
      <tr><td class="col-attr">proveedor_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NULL</td><td class="desc-col">Proveedor principal</td></tr>
      <tr><td class="col-attr">nombre</td><td><span class="badge b-str">VARCHAR(150)</span></td><td>NOT NULL</td><td class="desc-col">Nombre del producto</td></tr>
      <tr><td class="col-attr">descripcion</td><td><span class="badge b-str">TEXT</span></td><td>NULL</td><td class="desc-col">Descripción completa</td></tr>
      <tr><td class="col-attr">codigo_barras</td><td><span class="badge b-str">VARCHAR(30)</span></td><td>UNIQUE NULL</td><td class="desc-col">SKU / código de barras</td></tr>
      <tr><td class="col-attr">precio</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NOT NULL CHECK >= 0</td><td class="desc-col">Precio de venta</td></tr>
      <tr><td class="col-attr">precio_costo</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NULL</td><td class="desc-col">Precio de compra al proveedor</td></tr>
      <tr><td class="col-attr">especie_objetivo</td><td><span class="badge b-str">VARCHAR(60)</span></td><td>NULL</td><td class="desc-col">Perro, gato, ave, todos...</td></tr>
      <tr><td class="col-attr">imagen_url</td><td><span class="badge b-str">VARCHAR(255)</span></td><td>NULL</td><td class="desc-col">Foto del producto</td></tr>
      <tr><td class="col-attr">activo</td><td><span class="badge b-boo">BOOLEAN</span></td><td>DEFAULT TRUE</td><td class="desc-col">Disponible para venta</td></tr>
    </tbody>
  </table>
</div>

<!-- SUCURSAL -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#E6F1FB"><i class="ti ti-building-store" style="color:#185FA5"></i></div>
    <span class="entity-name">SUCURSAL</span>
    <span class="entity-desc">Tiendas físicas de la cadena</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">nombre</td><td><span class="badge b-str">VARCHAR(100)</span></td><td>NOT NULL</td><td class="desc-col">Nombre de la sucursal</td></tr>
      <tr><td class="col-attr">direccion</td><td><span class="badge b-str">VARCHAR(255)</span></td><td>NOT NULL</td><td class="desc-col">Dirección completa</td></tr>
      <tr><td class="col-attr">ciudad</td><td><span class="badge b-str">VARCHAR(80)</span></td><td>NOT NULL</td><td class="desc-col">Ciudad de ubicación</td></tr>
      <tr><td class="col-attr">estado</td><td><span class="badge b-str">VARCHAR(60)</span></td><td>NOT NULL</td><td class="desc-col">Estado / provincia</td></tr>
      <tr><td class="col-attr">telefono</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>NULL</td><td class="desc-col">Teléfono de la tienda</td></tr>
      <tr><td class="col-attr">horario</td><td><span class="badge b-str">VARCHAR(100)</span></td><td>NULL</td><td class="desc-col">Ej: Lun-Dom 9:00-21:00</td></tr>
      <tr><td class="col-attr">latitud</td><td><span class="badge b-dec">DECIMAL(9,6)</span></td><td>NULL</td><td class="desc-col">Coordenada GPS</td></tr>
      <tr><td class="col-attr">longitud</td><td><span class="badge b-dec">DECIMAL(9,6)</span></td><td>NULL</td><td class="desc-col">Coordenada GPS</td></tr>
      <tr><td class="col-attr">activo</td><td><span class="badge b-boo">BOOLEAN</span></td><td>DEFAULT TRUE</td><td class="desc-col">Si la sucursal está operativa</td></tr>
    </tbody>
  </table>
</div>

<!-- EMPLEADO -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#FBEAF0"><i class="ti ti-id-badge" style="color:#993556"></i></div>
    <span class="entity-name">EMPLEADO</span>
    <span class="entity-desc">Personal de la tienda y servicios</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">sucursal_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Tienda donde trabaja</td></tr>
      <tr><td class="col-attr">nombre</td><td><span class="badge b-str">VARCHAR(100)</span></td><td>NOT NULL</td><td class="desc-col">Nombre completo</td></tr>
      <tr><td class="col-attr">cargo</td><td><span class="badge b-str">VARCHAR(60)</span></td><td>NOT NULL</td><td class="desc-col">Cajero, groomer, veterinario...</td></tr>
      <tr><td class="col-attr">email</td><td><span class="badge b-str">VARCHAR(150)</span></td><td>UNIQUE NOT NULL</td><td class="desc-col">Correo corporativo</td></tr>
      <tr><td class="col-attr">telefono</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>NULL</td><td class="desc-col">Contacto del empleado</td></tr>
      <tr><td class="col-attr">fecha_contrato</td><td><span class="badge b-dat">DATE</span></td><td>NOT NULL</td><td class="desc-col">Inicio de la relación laboral</td></tr>
      <tr><td class="col-attr">salario</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NULL</td><td class="desc-col">Salario mensual</td></tr>
      <tr><td class="col-attr">activo</td><td><span class="badge b-boo">BOOLEAN</span></td><td>DEFAULT TRUE</td><td class="desc-col">Baja laboral lógica</td></tr>
    </tbody>
  </table>
</div>

<!-- PEDIDO -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#EEEDFE"><i class="ti ti-receipt" style="color:#534AB7"></i></div>
    <span class="entity-name">PEDIDO</span>
    <span class="entity-desc">Transacción de venta (encabezado)</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">cliente_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Cliente que compra</td></tr>
      <tr><td class="col-attr">empleado_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NULL</td><td class="desc-col">Vendedor que atiende</td></tr>
      <tr><td class="col-attr">sucursal_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NULL</td><td class="desc-col">Sucursal de origen</td></tr>
      <tr><td class="col-attr">fecha_pedido</td><td><span class="badge b-tst">TIMESTAMP</span></td><td>NOT NULL DEFAULT NOW()</td><td class="desc-col">Fecha y hora de la venta</td></tr>
      <tr><td class="col-attr">subtotal</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NOT NULL</td><td class="desc-col">Antes de impuestos</td></tr>
      <tr><td class="col-attr">impuesto</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>DEFAULT 0</td><td class="desc-col">IVA u otros</td></tr>
      <tr><td class="col-attr">descuento</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>DEFAULT 0</td><td class="desc-col">Descuento global</td></tr>
      <tr><td class="col-attr">total</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NOT NULL</td><td class="desc-col">Total a pagar</td></tr>
      <tr><td class="col-attr">estado</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>NOT NULL</td><td class="desc-col">pendiente / pagado / cancelado</td></tr>
      <tr><td class="col-attr">canal</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>NOT NULL</td><td class="desc-col">tienda / online / app</td></tr>
      <tr><td class="col-attr">metodo_pago</td><td><span class="badge b-str">VARCHAR(30)</span></td><td>NULL</td><td class="desc-col">efectivo / tarjeta / transferencia</td></tr>
    </tbody>
  </table>
</div>

<!-- DETALLE_PEDIDO -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#EAF3DE"><i class="ti ti-list-details" style="color:#3B6D11"></i></div>
    <span class="entity-name">DETALLE_PEDIDO</span>
    <span class="entity-desc">Líneas de producto por pedido</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">pedido_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Pedido al que pertenece</td></tr>
      <tr><td class="col-attr">producto_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Producto vendido</td></tr>
      <tr><td class="col-attr">cantidad</td><td><span class="badge b-int">INT</span></td><td>NOT NULL CHECK > 0</td><td class="desc-col">Unidades compradas</td></tr>
      <tr><td class="col-attr">precio_unitario</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NOT NULL</td><td class="desc-col">Precio al momento de compra</td></tr>
      <tr><td class="col-attr">descuento</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>DEFAULT 0</td><td class="desc-col">Descuento por línea</td></tr>
      <tr><td class="col-attr">subtotal</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NOT NULL</td><td class="desc-col">cantidad × precio - descuento</td></tr>
    </tbody>
  </table>
</div>

<!-- SERVICIO -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#FAEEDA"><i class="ti ti-scissors" style="color:#854F0B"></i></div>
    <span class="entity-name">SERVICIO</span>
    <span class="entity-desc">Grooming, veterinaria, adiestramiento</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">nombre</td><td><span class="badge b-str">VARCHAR(100)</span></td><td>NOT NULL</td><td class="desc-col">Nombre del servicio</td></tr>
      <tr><td class="col-attr">descripcion</td><td><span class="badge b-str">TEXT</span></td><td>NULL</td><td class="desc-col">Detalles del servicio</td></tr>
      <tr><td class="col-attr">precio</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NOT NULL</td><td class="desc-col">Precio base del servicio</td></tr>
      <tr><td class="col-attr">duracion_min</td><td><span class="badge b-int">INT</span></td><td>NOT NULL</td><td class="desc-col">Duración estimada en minutos</td></tr>
      <tr><td class="col-attr">tipo</td><td><span class="badge b-str">VARCHAR(40)</span></td><td>NOT NULL</td><td class="desc-col">grooming / veterinaria / adiestramiento</td></tr>
      <tr><td class="col-attr">especie_objetivo</td><td><span class="badge b-str">VARCHAR(60)</span></td><td>NULL</td><td class="desc-col">Perro, gato, todas...</td></tr>
      <tr><td class="col-attr">activo</td><td><span class="badge b-boo">BOOLEAN</span></td><td>DEFAULT TRUE</td><td class="desc-col">Disponible para agendar</td></tr>
    </tbody>
  </table>
</div>

<!-- CITA -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#E1F5EE"><i class="ti ti-calendar-event" style="color:#0F6E56"></i></div>
    <span class="entity-name">CITA</span>
    <span class="entity-desc">Reservación de servicio para mascota</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">cliente_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Dueño que agenda</td></tr>
      <tr><td class="col-attr">mascota_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Mascota que recibe el servicio</td></tr>
      <tr><td class="col-attr">servicio_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Tipo de servicio</td></tr>
      <tr><td class="col-attr">empleado_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NULL</td><td class="desc-col">Empleado asignado</td></tr>
      <tr><td class="col-attr">sucursal_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Sede de la cita</td></tr>
      <tr><td class="col-attr">fecha_hora</td><td><span class="badge b-tst">TIMESTAMP</span></td><td>NOT NULL</td><td class="desc-col">Fecha y hora de la cita</td></tr>
      <tr><td class="col-attr">estado</td><td><span class="badge b-str">VARCHAR(20)</span></td><td>NOT NULL</td><td class="desc-col">agendada / completada / cancelada</td></tr>
      <tr><td class="col-attr">precio_cobrado</td><td><span class="badge b-dec">DECIMAL(10,2)</span></td><td>NULL</td><td class="desc-col">Precio final aplicado</td></tr>
      <tr><td class="col-attr">notas</td><td><span class="badge b-str">TEXT</span></td><td>NULL</td><td class="desc-col">Observaciones del servicio</td></tr>
    </tbody>
  </table>
</div>

<!-- INVENTARIO -->
<div class="entity-card">
  <div class="entity-header">
    <div class="entity-icon" style="background:#F1EFE8"><i class="ti ti-clipboard-list" style="color:#5F5E5A"></i></div>
    <span class="entity-name">INVENTARIO</span>
    <span class="entity-desc">Stock de productos por sucursal</span>
  </div>
  <table>
    <thead><tr><th>Atributo</th><th>Tipo</th><th>Restricción</th><th>Descripción</th></tr></thead>
    <tbody>
      <tr><td class="col-attr">id</td><td><span class="badge b-pk">PK uuid</span></td><td>NOT NULL</td><td class="desc-col">Identificador único</td></tr>
      <tr><td class="col-attr">producto_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Producto en inventario</td></tr>
      <tr><td class="col-attr">sucursal_id</td><td><span class="badge b-fk">FK uuid</span></td><td>NOT NULL</td><td class="desc-col">Sucursal que almacena</td></tr>
      <tr><td class="col-attr">cantidad</td><td><span class="badge b-int">INT</span></td><td>NOT NULL DEFAULT 0</td><td class="desc-col">Unidades disponibles</td></tr>
      <tr><td class="col-attr">stock_minimo</td><td><span class="badge b-int">INT</span></td><td>NOT NULL DEFAULT 5</td><td class="desc-col">Umbral de reorden</td></tr>
      <tr><td class="col-attr">stock_maximo</td><td><span class="badge b-int">INT</span></td><td>NULL</td><td class="desc-col">Capacidad máxima</td></tr>
      <tr><td class="col-attr">ultima_actualizacion</td><td><span class="badge b-tst">TIMESTAMP</span></td><td>NOT NULL DEFAULT NOW()</td><td class="desc-col">Último movimiento registrado</td></tr>
    </tbody>
  </table>
</div>
