-- ============================================
-- Base de Datos: bdpetco
-- Sistema: PostgreSQL
-- ============================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- TABLA: CLIENTE
-- ============================================

CREATE TABLE cliente (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    fecha_nacimiento DATE,
    fecha_registro TIMESTAMP NOT NULL DEFAULT NOW(),
    tipo_membresia VARCHAR(20) DEFAULT 'estandar',
    activo BOOLEAN DEFAULT TRUE
);

-- ============================================
-- TABLA: MASCOTA
-- ============================================

CREATE TABLE mascota (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    especie VARCHAR(40) NOT NULL,
    raza VARCHAR(60),
    sexo CHAR(1) CHECK (sexo IN ('M', 'F', 'N')),
    fecha_nacimiento DATE,
    peso_kg DECIMAL(5,2),
    foto_url VARCHAR(255),
    notas_medicas TEXT,

    CONSTRAINT fk_mascota_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES cliente(id)
        ON DELETE CASCADE
);

-- ============================================
-- TABLA: CATEGORIA
-- ============================================

CREATE TABLE categoria (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(80) NOT NULL,
    descripcion TEXT,
    categoria_padre_id UUID,
    imagen_url VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_categoria_padre
        FOREIGN KEY (categoria_padre_id)
        REFERENCES categoria(id)
        ON DELETE SET NULL
);

-- ============================================
-- TABLA: PROVEEDOR
-- ============================================

CREATE TABLE proveedor (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(120) NOT NULL,
    contacto_nombre VARCHAR(100),
    email VARCHAR(150),
    telefono VARCHAR(20),
    pais VARCHAR(60),
    rfc VARCHAR(20) UNIQUE,
    activo BOOLEAN DEFAULT TRUE
);

-- ============================================
-- TABLA: PRODUCTO
-- ============================================

CREATE TABLE producto (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    categoria_id UUID NOT NULL,
    proveedor_id UUID,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    codigo_barras VARCHAR(30) UNIQUE,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    precio_costo DECIMAL(10,2),
    especie_objetivo VARCHAR(60),
    imagen_url VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categoria(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_producto_proveedor
        FOREIGN KEY (proveedor_id)
        REFERENCES proveedor(id)
        ON DELETE SET NULL
);

-- ============================================
-- TABLA: SUCURSAL
-- ============================================

CREATE TABLE sucursal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(80) NOT NULL,
    estado VARCHAR(60) NOT NULL,
    telefono VARCHAR(20),
    horario VARCHAR(100),
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6),
    activo BOOLEAN DEFAULT TRUE
);

-- ============================================
-- TABLA: EMPLEADO
-- ============================================

CREATE TABLE empleado (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sucursal_id UUID NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(60) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_contrato DATE NOT NULL,
    salario DECIMAL(10,2),
    activo BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_empleado_sucursal
        FOREIGN KEY (sucursal_id)
        REFERENCES sucursal(id)
        ON DELETE RESTRICT
);

-- ============================================
-- TABLA: PEDIDO
-- ============================================

CREATE TABLE pedido (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL,
    empleado_id UUID,
    sucursal_id UUID,
    fecha_pedido TIMESTAMP NOT NULL DEFAULT NOW(),
    subtotal DECIMAL(10,2) NOT NULL,
    impuesto DECIMAL(10,2) DEFAULT 0,
    descuento DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    canal VARCHAR(20) NOT NULL,
    metodo_pago VARCHAR(30),

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES cliente(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_pedido_empleado
        FOREIGN KEY (empleado_id)
        REFERENCES empleado(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_pedido_sucursal
        FOREIGN KEY (sucursal_id)
        REFERENCES sucursal(id)
        ON DELETE SET NULL
);

-- ============================================
-- TABLA: DETALLE_PEDIDO
-- ============================================

CREATE TABLE detalle_pedido (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pedido_id UUID NOT NULL,
    producto_id UUID NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (pedido_id)
        REFERENCES pedido(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id)
        REFERENCES producto(id)
        ON DELETE RESTRICT
);

-- ============================================
-- TABLA: SERVICIO
-- ============================================

CREATE TABLE servicio (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    duracion_min INT NOT NULL,
    tipo VARCHAR(40) NOT NULL,
    especie_objetivo VARCHAR(60),
    activo BOOLEAN DEFAULT TRUE
);

-- ============================================
-- TABLA: CITA
-- ============================================

CREATE TABLE cita (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL,
    mascota_id UUID NOT NULL,
    servicio_id UUID NOT NULL,
    empleado_id UUID,
    sucursal_id UUID NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    estado VARCHAR(20) NOT NULL,
    precio_cobrado DECIMAL(10,2),
    notas TEXT,

    CONSTRAINT fk_cita_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES cliente(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_cita_mascota
        FOREIGN KEY (mascota_id)
        REFERENCES mascota(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_cita_servicio
        FOREIGN KEY (servicio_id)
        REFERENCES servicio(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_cita_empleado
        FOREIGN KEY (empleado_id)
        REFERENCES empleado(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_cita_sucursal
        FOREIGN KEY (sucursal_id)
        REFERENCES sucursal(id)
        ON DELETE RESTRICT
);

-- ============================================
-- TABLA: INVENTARIO
-- ============================================

CREATE TABLE inventario (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    producto_id UUID NOT NULL,
    sucursal_id UUID NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 5,
    stock_maximo INT,
    ultima_actualizacion TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (producto_id)
        REFERENCES producto(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_inventario_sucursal
        FOREIGN KEY (sucursal_id)
        REFERENCES sucursal(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_producto_sucursal
        UNIQUE (producto_id, sucursal_id)
);

-- ============================================
-- ÍNDICES RECOMENDADOS
-- ============================================

CREATE INDEX idx_mascota_cliente ON mascota(cliente_id);
CREATE INDEX idx_producto_categoria ON producto(categoria_id);
CREATE INDEX idx_producto_proveedor ON producto(proveedor_id);
CREATE INDEX idx_empleado_sucursal ON empleado(sucursal_id);
CREATE INDEX idx_pedido_cliente ON pedido(cliente_id);
CREATE INDEX idx_pedido_empleado ON pedido(empleado_id);
CREATE INDEX idx_detalle_pedido ON detalle_pedido(pedido_id);
CREATE INDEX idx_detalle_producto ON detalle_pedido(producto_id);
CREATE INDEX idx_cita_cliente ON cita(cliente_id);
CREATE INDEX idx_cita_mascota ON cita(mascota_id);
CREATE INDEX idx_inventario_producto ON inventario(producto_id);
CREATE INDEX idx_inventario_sucursal ON inventario(sucursal_id);
