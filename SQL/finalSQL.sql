-- ============================================
-- BASE DE DATOS: SISTEMA DE PINTURAS
-- Versión Consolidada y Optimizada
-- ============================================

CREATE DATABASE IF NOT EXISTS pinturas;
USE pinturas;

-- ============================================
-- MÓDULO: CONFIGURACIÓN Y USUARIOS
-- ============================================

-- Tabla Roles
CREATE TABLE `roles` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(30) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Roles de usuario del sistema';

-- Tabla Sucursales
CREATE TABLE `sucursales` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(120) UNIQUE NOT NULL,
  `direccion` VARCHAR(255),
  `gps_lat` DECIMAL(10,6),
  `gps_lng` DECIMAL(10,6),
  `telefono` VARCHAR(30),
  `activa` BOOLEAN DEFAULT TRUE,
  
  -- Índices
  INDEX `idx_sucursales_gps` (`gps_lat`, `gps_lng`),
  INDEX `idx_sucursales_activa` (`activa`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Sucursales de la empresa';

-- Tabla Usuarios
CREATE TABLE `usuarios` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(120) NOT NULL,
  `dpi` VARCHAR(20) UNIQUE NOT NULL,
  `email` VARCHAR(150) UNIQUE NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `rol_id` INT NOT NULL,
  `sucursal_id` INT,
  `activo` BOOLEAN DEFAULT TRUE,
  `creado_en` DATETIME DEFAULT CURRENT_TIMESTAMP,

  -- Foreign Keys
  CONSTRAINT `fk_usuarios_rol`
    FOREIGN KEY (`rol_id`)
    REFERENCES `roles`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_usuarios_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  -- Índices
  INDEX `idx_usuarios_rol` (`rol_id`),
  INDEX `idx_usuarios_sucursal` (`sucursal_id`),
  INDEX `idx_usuarios_email` (`email`),
  INDEX `idx_usuarios_dpi` (`dpi`),
  INDEX `idx_usuarios_activo` (`activo`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Usuarios del sistema';

-- ============================================
-- MÓDULO: CLIENTES
-- ============================================

CREATE TABLE `clientes` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(150) NOT NULL,
  `nit` VARCHAR(25) UNIQUE,
  `email` VARCHAR(150) UNIQUE,
  `password_hash` VARCHAR(255),
  `opt_in_promos` BOOLEAN DEFAULT FALSE,
  `verificado` BOOLEAN DEFAULT FALSE,
  `telefono` VARCHAR(30),
  `direccion` VARCHAR(255),
  `gps_lat` DECIMAL(10,6),
  `gps_lng` DECIMAL(10,6),
  `creado_en` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  -- Índices
  INDEX `idx_clientes_email` (`email`),
  INDEX `idx_clientes_nit` (`nit`),
  INDEX `idx_clientes_gps` (`gps_lat`, `gps_lng`),
  INDEX `idx_clientes_verificado` (`verificado`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Clientes del sistema';

-- ============================================
-- MÓDULO: CATÁLOGO DE PRODUCTOS
-- ============================================

-- Tabla Categorias
CREATE TABLE `categorias` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(60) UNIQUE NOT NULL,
  `descripcion` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Categorías de productos';

-- Tabla Marcas
CREATE TABLE `marcas` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(80) UNIQUE NOT NULL,
  `activa` BOOLEAN DEFAULT TRUE,
  
  INDEX `idx_marcas_activa` (`activa`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Marcas de productos';

-- Tabla Productos
CREATE TABLE `productos` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `categoria_id` INT,
  `marca_id` INT,
  `codigo_sku` VARCHAR(50) UNIQUE NOT NULL,
  `descripcion` VARCHAR(255) NOT NULL,
  `tamano` VARCHAR(40),
  `duracion_anios` INT,
  `extension_m2` DECIMAL(10,2),
  `color` VARCHAR(60),
  `activo` BOOLEAN DEFAULT TRUE,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Foreign Keys
  CONSTRAINT `fk_productos_categoria`
    FOREIGN KEY (`categoria_id`)
    REFERENCES `categorias`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  CONSTRAINT `fk_productos_marca`
    FOREIGN KEY (`marca_id`)
    REFERENCES `marcas`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  -- Índices
  INDEX `idx_productos_categoria` (`categoria_id`),
  INDEX `idx_productos_marca` (`marca_id`),
  INDEX `idx_productos_activo` (`activo`),
  INDEX `idx_productos_sku` (`codigo_sku`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Productos del catálogo';

-- Tabla Presentaciones
CREATE TABLE `presentaciones` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(40) UNIQUE NOT NULL,
  `unidad_base` VARCHAR(20),
  `factor_galon` DECIMAL(10,5),
  `activo` BOOLEAN DEFAULT TRUE,
  
  INDEX `idx_presentaciones_activo` (`activo`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Presentaciones disponibles (galón, litro, cuarto, etc.)';

-- Tabla ProductoPresentacion (intermedia)
CREATE TABLE `productopresentacion` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `producto_id` INT NOT NULL,
  `presentacion_id` INT NOT NULL,
  `activo` BOOLEAN DEFAULT TRUE,

  -- Foreign Keys
  CONSTRAINT `fk_pp_producto`
    FOREIGN KEY (`producto_id`)
    REFERENCES `productos`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_pp_presentacion`
    FOREIGN KEY (`presentacion_id`)
    REFERENCES `presentaciones`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índice único para evitar duplicados
  UNIQUE KEY `unique_producto_presentacion` (`producto_id`, `presentacion_id`),

  -- Índices
  INDEX `idx_pp_producto` (`producto_id`),
  INDEX `idx_pp_presentacion` (`presentacion_id`),
  INDEX `idx_pp_activo` (`activo`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Relaciona productos con sus presentaciones disponibles para venta';

-- ============================================
-- MÓDULO: PRECIOS E INVENTARIO
-- ============================================

-- Tabla Precios
CREATE TABLE `precios` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `producto_presentacion_id` INT NOT NULL,
  `sucursal_id` INT,
  `precio_venta` DECIMAL(12,2) NOT NULL,
  `descuento_pct` DECIMAL(5,2) DEFAULT 0,
  `vigente_desde` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `vigente_hasta` DATETIME,
  `activo` BOOLEAN DEFAULT TRUE,

  -- Foreign Keys
  CONSTRAINT `fk_precios_producto_presentacion`
    FOREIGN KEY (`producto_presentacion_id`)
    REFERENCES `productopresentacion`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_precios_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_precios_producto_presentacion` (`producto_presentacion_id`),
  INDEX `idx_precios_sucursal` (`sucursal_id`),
  INDEX `idx_precios_vigencia` (`vigente_desde`, `vigente_hasta`),
  INDEX `idx_precios_activo` (`activo`),
  INDEX `idx_precios_consulta` (`producto_presentacion_id`, `sucursal_id`, `vigente_desde`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Precios de productos por sucursal con vigencia temporal';

-- Tabla InventarioSucursal
CREATE TABLE `inventariosucursal` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `sucursal_id` INT NOT NULL,
  `producto_presentacion_id` INT NOT NULL,
  `existencia` INT NOT NULL DEFAULT 0,
  `minimo` INT DEFAULT 0,

  -- Foreign Keys
  CONSTRAINT `fk_inventario_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_inventario_producto_presentacion`
    FOREIGN KEY (`producto_presentacion_id`)
    REFERENCES `productopresentacion`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Constraint único
  UNIQUE KEY `unique_sucursal_producto` (`sucursal_id`, `producto_presentacion_id`),

  -- Índices
  INDEX `idx_inventario_sucursal` (`sucursal_id`),
  INDEX `idx_inventario_producto` (`producto_presentacion_id`),
  INDEX `idx_inventario_existencia` (`existencia`),
  INDEX `idx_inventario_alerta` (`existencia`, `minimo`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stock actual de productos por sucursal';

-- Tabla MovimientosInventario
CREATE TABLE `movimientosinventario` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `sucursal_id` INT NOT NULL,
  `producto_presentacion_id` INT NOT NULL,
  `tipo` VARCHAR(20) NOT NULL,
  `cantidad` INT NOT NULL,
  `referencia` VARCHAR(60),
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,

  -- Foreign Keys
  CONSTRAINT `fk_movimientos_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_movimientos_producto_presentacion`
    FOREIGN KEY (`producto_presentacion_id`)
    REFERENCES `productopresentacion`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_movimientos_sucursal` (`sucursal_id`),
  INDEX `idx_movimientos_producto` (`producto_presentacion_id`),
  INDEX `idx_movimientos_tipo` (`tipo`),
  INDEX `idx_movimientos_fecha` (`created_at`),
  INDEX `idx_movimientos_consulta` (`sucursal_id`, `tipo`, `created_at`),
  INDEX `idx_movimientos_producto_fecha` (`producto_presentacion_id`, `created_at`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Historial de movimientos de inventario';

-- ============================================
-- MÓDULO: FACTURACIÓN Y VENTAS
-- ============================================

-- Tabla Secuencias para Numeración
CREATE TABLE `secuencias_facturas` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `serie` VARCHAR(10) UNIQUE NOT NULL,
  `ultimo_numero` INT NOT NULL DEFAULT 0,
  `descripcion` VARCHAR(100),
  `activa` BOOLEAN DEFAULT TRUE,
  
  INDEX `idx_secuencias_serie` (`serie`),
  INDEX `idx_secuencias_activa` (`activa`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Control de numeración de documentos';

-- Tabla Facturas
CREATE TABLE `facturas` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `numero` INT NOT NULL,
  `serie` VARCHAR(10) NOT NULL,
  `fecha_emision` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cliente_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `sucursal_id` INT NOT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `descuento_total` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `total` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `estado` ENUM('EMITIDA', 'ANULADA') NOT NULL DEFAULT 'EMITIDA',
  `anulada_por` INT,
  `anulada_fecha` DATETIME,
  `motivo_anulacion` VARCHAR(255),

  -- Foreign Keys
  CONSTRAINT `fk_facturas_cliente`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `clientes`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_facturas_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `usuarios`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_facturas_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_facturas_anulada_por`
    FOREIGN KEY (`anulada_por`)
    REFERENCES `usuarios`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  UNIQUE KEY `unique_factura` (`numero`, `serie`),
  INDEX `idx_facturas_fecha` (`fecha_emision`),
  INDEX `idx_facturas_cliente` (`cliente_id`, `fecha_emision`),
  INDEX `idx_facturas_estado` (`estado`),
  INDEX `idx_facturas_sucursal` (`sucursal_id`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Facturas de venta';

-- Tabla DetalleFactura
CREATE TABLE `detallefactura` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `factura_id` INT NOT NULL,
  `producto_presentacion_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(12,2) NOT NULL,
  `descuento_pct_aplicado` DECIMAL(5,2) DEFAULT 0,
  `subtotal` DECIMAL(12,2) NOT NULL,

  -- Foreign Keys
  CONSTRAINT `fk_detallefactura_factura`
    FOREIGN KEY (`factura_id`)
    REFERENCES `facturas`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_detallefactura_producto_presentacion`
    FOREIGN KEY (`producto_presentacion_id`)
    REFERENCES `productopresentacion`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_detallefactura_factura` (`factura_id`),
  UNIQUE KEY `unique_factura_producto` (`factura_id`, `producto_presentacion_id`),
  
  -- Validaciones
  CHECK (`cantidad` > 0),
  CHECK (`precio_unitario` >= 0)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Detalle de productos en facturas';

-- Tabla MediosPago
CREATE TABLE `mediospago` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(50) UNIQUE NOT NULL,
  `activo` BOOLEAN DEFAULT TRUE,
  
  INDEX `idx_mediospago_activo` (`activo`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Medios de pago disponibles (efectivo, tarjeta, transferencia, etc.)';

-- Tabla Pagos
CREATE TABLE `pagos` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `factura_id` INT NOT NULL,
  `medio_pago_id` INT NOT NULL,
  `monto` DECIMAL(12,2) NOT NULL,
  `referencia` VARCHAR(80),
  `entidad` VARCHAR(80),
  `transaccion_gateway_id` VARCHAR(80),
  `autorizado_por` VARCHAR(120),
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,

  -- Foreign Keys
  CONSTRAINT `fk_pagos_factura`
    FOREIGN KEY (`factura_id`)
    REFERENCES `facturas`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_pagos_medio_pago`
    FOREIGN KEY (`medio_pago_id`)
    REFERENCES `mediospago`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_pagos_factura` (`factura_id`),
  INDEX `idx_pagos_medio` (`medio_pago_id`),
  INDEX `idx_pagos_fecha` (`created_at`),
  
  -- Validación
  CHECK (`monto` > 0)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Pagos recibidos por factura (permite múltiples pagos por factura)';

-- ============================================
-- MÓDULO: COTIZACIONES
-- ============================================

CREATE TABLE `cotizaciones` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `numero` INT NOT NULL,
  `serie` VARCHAR(10) NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cliente_id` INT,
  `usuario_id` INT NOT NULL,
  `sucursal_id` INT NOT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `descuento_total` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `total` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `vigente_hasta` DATETIME,
  `estado` VARCHAR(20) DEFAULT 'ABIERTA',

  -- Foreign Keys
  CONSTRAINT `fk_cotizaciones_cliente`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `clientes`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_cotizaciones_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `usuarios`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_cotizaciones_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  UNIQUE KEY `unique_cotizacion` (`numero`, `serie`),
  INDEX `idx_cotizaciones_cliente` (`cliente_id`, `fecha`),
  INDEX `idx_cotizaciones_estado` (`estado`),
  INDEX `idx_cotizaciones_fecha` (`fecha`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Cotizaciones para clientes';

CREATE TABLE `detallecotizacion` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `cotizacion_id` INT NOT NULL,
  `producto_presentacion_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(12,2) NOT NULL,
  `descuento_pct_aplicado` DECIMAL(5,2) DEFAULT 0,
  `subtotal` DECIMAL(12,2) NOT NULL,

  -- Foreign Keys
  CONSTRAINT `fk_detallecotizacion_cotizacion`
    FOREIGN KEY (`cotizacion_id`)
    REFERENCES `cotizaciones`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_detallecotizacion_producto_presentacion`
    FOREIGN KEY (`producto_presentacion_id`)
    REFERENCES `productopresentacion`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_detallecotizacion_cotizacion` (`cotizacion_id`),
  UNIQUE KEY `unique_cotizacion_producto` (`cotizacion_id`, `producto_presentacion_id`),
  
  -- Validaciones
  CHECK (`cantidad` > 0),
  CHECK (`precio_unitario` >= 0)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Detalle de productos en cotizaciones';

-- ============================================
-- MÓDULO: COMPRAS Y PROVEEDORES
-- ============================================

CREATE TABLE `proveedores` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(150) NOT NULL,
  `razon_social` VARCHAR(200),
  `nit` VARCHAR(20),
  `telefono` VARCHAR(20),
  `email` VARCHAR(100),
  `direccion` VARCHAR(255),
  `contacto_principal` VARCHAR(100),
  `activo` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Índices
  INDEX `idx_proveedores_nombre` (`nombre`),
  INDEX `idx_proveedores_nit` (`nit`),
  INDEX `idx_proveedores_activo` (`activo`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Proveedores de productos';

CREATE TABLE `ordenes_compra` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `numero` INT NOT NULL,
  `serie` VARCHAR(10) NOT NULL DEFAULT 'OC',
  `proveedor_id` INT NOT NULL,
  `sucursal_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `fecha_orden` DATE NOT NULL,
  `fecha_entrega_estimada` DATE,
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `descuento_total` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `total` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `estado` ENUM('PENDIENTE', 'PARCIAL', 'RECIBIDA', 'CANCELADA') NOT NULL DEFAULT 'PENDIENTE',
  `observaciones` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Foreign Keys
  CONSTRAINT `fk_ordenes_proveedor`
    FOREIGN KEY (`proveedor_id`)
    REFERENCES `proveedores`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_ordenes_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_ordenes_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `usuarios`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  UNIQUE KEY `unique_orden` (`numero`, `serie`),
  INDEX `idx_ordenes_proveedor` (`proveedor_id`),
  INDEX `idx_ordenes_sucursal` (`sucursal_id`),
  INDEX `idx_ordenes_usuario` (`usuario_id`),
  INDEX `idx_ordenes_fecha` (`fecha_orden`),
  INDEX `idx_ordenes_estado` (`estado`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Órdenes de compra a proveedores';

CREATE TABLE `detalle_orden_compra` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `orden_compra_id` INT NOT NULL,
  `producto_presentacion_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(12,2) NOT NULL,
  `descuento_pct` DECIMAL(5,2) DEFAULT 0,
  `subtotal` DECIMAL(12,2) NOT NULL,
  `cantidad_recibida` INT DEFAULT 0,

  -- Foreign Keys
  CONSTRAINT `fk_detalle_orden`
    FOREIGN KEY (`orden_compra_id`)
    REFERENCES `ordenes_compra`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_detalle_producto_pres`
    FOREIGN KEY (`producto_presentacion_id`)
    REFERENCES `productopresentacion`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_detalle_orden` (`orden_compra_id`),
  INDEX `idx_detalle_producto_pres` (`producto_presentacion_id`),

  -- Validaciones
  CHECK (`cantidad` > 0),
  CHECK (`precio_unitario` >= 0),
  CHECK (`descuento_pct` >= 0 AND `descuento_pct` <= 100),
  CHECK (`cantidad_recibida` >= 0),
  CHECK (`cantidad_recibida` <= `cantidad`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Detalle de productos en órdenes de compra';

CREATE TABLE `recepciones` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `orden_compra_id` INT NOT NULL,
  `sucursal_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `fecha_recepcion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `observaciones` TEXT,

  -- Foreign Keys
  CONSTRAINT `fk_recepcion_orden`
    FOREIGN KEY (`orden_compra_id`)
    REFERENCES `ordenes_compra`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_recepcion_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_recepcion_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `usuarios`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_recepcion_orden` (`orden_compra_id`),
  INDEX `idx_recepcion_sucursal` (`sucursal_id`),
  INDEX `idx_recepcion_usuario` (`usuario_id`),
  INDEX `idx_recepcion_fecha` (`fecha_recepcion`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Recepciones de productos de órdenes de compra';

CREATE TABLE `detalle_recepciones` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `recepcion_id` INT NOT NULL,
  `detalle_orden_id` INT NOT NULL,
  `cantidad_recibida` INT NOT NULL,
  `observaciones` VARCHAR(255),

  -- Foreign Keys
  CONSTRAINT `fk_detalle_recep_recepcion`
    FOREIGN KEY (`recepcion_id`)
    REFERENCES `recepciones`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_detalle_recep_orden`
    FOREIGN KEY (`detalle_orden_id`)
    REFERENCES `detalle_orden_compra`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_detalle_recep_recepcion` (`recepcion_id`),
  INDEX `idx_detalle_recep_orden` (`detalle_orden_id`),

  -- Validación
  CHECK (`cantidad_recibida` > 0)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Detalle de productos recibidos en cada recepción';

-- ============================================
-- MÓDULO: CARRITO DE COMPRAS (E-COMMERCE)
-- ============================================

CREATE TABLE `carritos` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `cliente_id` INT NOT NULL,
  `sucursal_id` INT,
  `estado` VARCHAR(20) DEFAULT 'ABIERTO',
  `creado_en` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `actualizado_en` DATETIME,

  -- Foreign Keys
  CONSTRAINT `fk_carritos_cliente`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `clientes`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_carritos_sucursal`
    FOREIGN KEY (`sucursal_id`)
    REFERENCES `sucursales`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  -- Índices
  INDEX `idx_carritos_cliente` (`cliente_id`, `estado`),
  INDEX `idx_carritos_estado` (`estado`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Carritos de compra de clientes';

CREATE TABLE `carrito_items` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `carrito_id` INT NOT NULL,
  `producto_presentacion_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(12,2),
  `descuento_pct` DECIMAL(5,2) DEFAULT 0,
  `subtotal` DECIMAL(12,2),

  -- Foreign Keys
  CONSTRAINT `fk_carrito_items_carrito`
    FOREIGN KEY (`carrito_id`)
    REFERENCES `carritos`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT `fk_carrito_items_producto_presentacion`
    FOREIGN KEY (`producto_presentacion_id`)
    REFERENCES `productopresentacion`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_carrito_items_carrito` (`carrito_id`),
  UNIQUE KEY `unique_carrito_producto` (`carrito_id`, `producto_presentacion_id`),
  
  -- Validación
  CHECK (`cantidad` > 0)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Items en los carritos de compra';

-- ============================================
-- MÓDULO: CAMPAÑAS Y MARKETING
-- ============================================

CREATE TABLE `campanias` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `titulo` VARCHAR(120) NOT NULL,
  `cuerpo` TEXT,
  `creado_por` INT,
  `creado_en` DATETIME DEFAULT CURRENT_TIMESTAMP,

  -- Foreign Keys
  CONSTRAINT `fk_campanias_usuario`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuarios`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  -- Índices
  INDEX `idx_campanias_creado_por` (`creado_por`),
  INDEX `idx_campanias_fecha` (`creado_en`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Campañas de marketing';

CREATE TABLE `campania_adjuntos` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `campania_id` INT NOT NULL,
  `tipo` VARCHAR(20) NOT NULL,
  `url` VARCHAR(255) NOT NULL,
  `descripcion` VARCHAR(255),

  -- Foreign Keys
  CONSTRAINT `fk_campania_adjuntos_campania`
    FOREIGN KEY (`campania_id`)
    REFERENCES `campanias`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  -- Índices
  INDEX `idx_campania_adjuntos_campania` (`campania_id`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Archivos adjuntos a campañas';

CREATE TABLE `campania_destinatarios` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `campania_id` INT NOT NULL,
  `cliente_id` INT NOT NULL,
  `estado` VARCHAR(20) DEFAULT 'PENDIENTE',
  `detalle` VARCHAR(255),
  `enviado_en` DATETIME,

  -- Foreign Keys
  CONSTRAINT `fk_campania_dest_campania`
    FOREIGN KEY (`campania_id`)
    REFERENCES `campanias`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT `fk_campania_dest_cliente`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `clientes`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  -- Índices
  INDEX `idx_campania_dest_campania` (`campania_id`),
  UNIQUE KEY `unique_campania_cliente` (`campania_id`, `cliente_id`),
  INDEX `idx_campania_dest_estado` (`estado`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Destinatarios de campañas';

-- ============================================
-- MÓDULO: AUDITORÍA Y LOGS
-- ============================================

CREATE TABLE `logs_sistema` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `fecha_hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` INT,
  `tabla_afectada` VARCHAR(100),
  `accion` VARCHAR(50),
  `registro_afectado_id` VARCHAR(100),
  `descripcion` TEXT,
  `valores_antes` TEXT,
  `valores_despues` TEXT,
  `ip_origen` VARCHAR(64),
  `dispositivo` VARCHAR(100),
  `estado` VARCHAR(20),

  -- Foreign Keys
  CONSTRAINT `fk_logs_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `usuarios`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  -- Índices
  INDEX `idx_logs_fecha` (`fecha_hora`),
  INDEX `idx_logs_usuario` (`usuario_id`, `fecha_hora`),
  INDEX `idx_logs_tabla` (`tabla_afectada`, `accion`),
  INDEX `idx_logs_accion` (`accion`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Registro de auditoría del sistema';

-- ============================================
-- DATOS INICIALES
-- ============================================

-- Insertar series en secuencias
INSERT INTO `secuencias_facturas` (`serie`, `ultimo_numero`, `descripcion`, `activa`) VALUES
('FAC', 0, 'Facturas de Venta', TRUE),
('COT', 0, 'Cotizaciones', TRUE),
('OC', 0, 'Órdenes de Compra', TRUE);

-- Insertar medios de pago básicos
INSERT INTO `mediospago` (`nombre`, `activo`) VALUES
('Efectivo', TRUE),
('Tarjeta de Crédito', TRUE),
('Tarjeta de Débito', TRUE),
('Transferencia Bancaria', TRUE),
('Cheque', TRUE);

-- Insertar categorías de ejemplo
INSERT INTO `categorias` (`nombre`, `descripcion`) VALUES
('Pinturas de Interior', 'Pinturas para uso en interiores'),
('Pinturas de Exterior', 'Pinturas resistentes al clima'),
('Esmaltes', 'Esmaltes y barnices'),
('Impermeabilizantes', 'Productos para impermeabilización');

-- Insertar marcas de ejemplo
INSERT INTO `marcas` (`nombre`, `activa`) VALUES
('Sherwin Williams', TRUE),
('Comex', TRUE),
('Berel', TRUE),
('Pintuco', TRUE);

-- Insertar presentaciones comunes
INSERT INTO `presentaciones` (`nombre`, `unidad_base`, `factor_galon`, `activo`) VALUES
('Galón', 'galón', 1.00000, TRUE),
('Cuarto', 'litro', 0.25000, TRUE),
('Litro', 'litro', 0.26417, TRUE),
('5 Galones', 'galón', 5.00000, TRUE);

-- ============================================
-- FIN DEL SCRIPT
-- ============================================