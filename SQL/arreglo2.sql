USE pinturas;
-- Eliminar tablas si existen (en orden correcto)
DROP TABLE IF EXISTS `productos`;
DROP TABLE IF EXISTS `categorias`;
DROP TABLE IF EXISTS `marcas`;

-- Tabla Categorias
CREATE TABLE `categorias` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(60) UNIQUE NOT NULL,
  `descripcion` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Marcas
CREATE TABLE `marcas` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(80) UNIQUE NOT NULL,
  `activa` BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

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

  -- Índices para mejorar performance
  INDEX `idx_categoria_id` (`categoria_id`),
  INDEX `idx_marca_id` (`marca_id`),
  INDEX `idx_activo` (`activo`),
  INDEX `idx_codigo_sku` (`codigo_sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar datos de prueba (opcional)
INSERT INTO `categorias` (`nombre`, `descripcion`) VALUES
('Pinturas de Interior', 'Pinturas para uso en interiores'),
('Pinturas de Exterior', 'Pinturas resistentes al clima'),
('Esmaltes', 'Esmaltes y barnices'),
('Impermeabilizantes', 'Productos para impermeabilización');

INSERT INTO `marcas` (`nombre`, `activa`) VALUES
('Sherwin Williams', TRUE),
('Comex', TRUE),
('Berel', TRUE),
('Pintuco', TRUE);


SELECT * FROM Sucursales;


DESCRIBE productopresentacion;

-- Crear tabla ProductoPresentacion
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

  -- Índices para mejorar performance
  INDEX `idx_producto_id` (`producto_id`),
  INDEX `idx_presentacion_id` (`presentacion_id`),
  INDEX `idx_activo` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Comentario explicativo
ALTER TABLE `productopresentacion`
COMMENT = 'Tabla intermedia: relaciona productos con sus presentaciones disponibles para venta';



-- 1. Eliminar tabla usuarios (si existe)
DROP TABLE IF EXISTS `usuarios`;

-- 2. Recrear correctamente
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

  -- Foreign Keys con nombres explícitos
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `Precios`;
-- Crear tabla Precios
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

  -- Índices para búsquedas rápidas
  INDEX `idx_precios_producto_presentacion` (`producto_presentacion_id`),
  INDEX `idx_precios_sucursal` (`sucursal_id`),
  INDEX `idx_precios_vigencia` (`vigente_desde`, `vigente_hasta`),
  INDEX `idx_precios_activo` (`activo`),

  -- Índice compuesto para consultas comunes
  INDEX `idx_precios_consulta` (`producto_presentacion_id`, `sucursal_id`, `vigente_desde`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Comentario
ALTER TABLE `precios`
COMMENT = 'Precios de productos por sucursal con vigencia temporal';


-- Crear tabla InventarioSucursal
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

  -- Constraint único: una sola entrada por sucursal + producto
  UNIQUE KEY `unique_sucursal_producto` (`sucursal_id`, `producto_presentacion_id`),

  -- Índices
  INDEX `idx_inventario_sucursal` (`sucursal_id`),
  INDEX `idx_inventario_producto` (`producto_presentacion_id`),
  INDEX `idx_inventario_existencia` (`existencia`),
  INDEX `idx_inventario_alerta` (`existencia`, `minimo`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Comentario
ALTER TABLE `inventariosucursal`
COMMENT = 'Stock actual de productos por sucursal';


DROP TABLE IF EXISTS `MovimientosInventario`;

-- Crear tabla MovimientosInventario
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

  -- Índices para búsquedas rápidas
  INDEX `idx_movimientos_sucursal` (`sucursal_id`),
  INDEX `idx_movimientos_producto` (`producto_presentacion_id`),
  INDEX `idx_movimientos_tipo` (`tipo`),
  INDEX `idx_movimientos_fecha` (`created_at`),

  -- Índice compuesto para consultas comunes
  INDEX `idx_movimientos_consulta` (`sucursal_id`, `tipo`, `created_at`),
  INDEX `idx_movimientos_producto_fecha` (`producto_presentacion_id`, `created_at`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Comentario
ALTER TABLE `movimientosinventario`
COMMENT = 'Historial de todos los movimientos de inventario';

-- Constraint para validar tipos permitidos
ALTER TABLE `movimientosinventario`
ADD CONSTRAINT `chk_tipo_movimiento`
CHECK (`tipo` IN ('COMPRA', 'VENTA', 'AJUSTE', 'TRASLADO_ENTRADA', 'TRASLADO_SALIDA', 'DEVOLUCION'));






-- ============================================
-- SISTEMA DE FACTURAS Y PAGOS
-- Eliminar tablas si existen (orden inverso por FK)
-- ============================================

DROP TABLE IF EXISTS `pagos`;
DROP TABLE IF EXISTS `detallefactura`;
DROP TABLE IF EXISTS `facturas`;
DROP TABLE IF EXISTS `secuencias_facturas`;

-- ============================================
-- 1. TABLA DE SECUENCIAS (Control de correlativos)
-- ============================================
CREATE TABLE `secuencias_facturas` (
  `serie` VARCHAR(10) PRIMARY KEY,
  `ultimo_numero` INT NOT NULL DEFAULT 0,
  `descripcion` VARCHAR(100),
  `activa` BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar series iniciales
INSERT INTO `secuencias_facturas` (`serie`, `ultimo_numero`, `descripcion`, `activa`) VALUES
('A', 0, 'Facturas generales', TRUE),
('B', 0, 'Facturas corporativas', FALSE);

-- ============================================
-- 2. TABLA FACTURAS
-- ============================================
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

  -- Constraint único para número + serie
  UNIQUE KEY `unique_factura` (`numero`, `serie`),

  -- Índices para búsquedas rápidas
  INDEX `idx_facturas_cliente` (`cliente_id`),
  INDEX `idx_facturas_usuario` (`usuario_id`),
  INDEX `idx_facturas_sucursal` (`sucursal_id`),
  INDEX `idx_facturas_fecha` (`fecha_emision`),
  INDEX `idx_facturas_estado` (`estado`),
  INDEX `idx_facturas_numero_serie` (`numero`, `serie`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Facturas de venta emitidas';

-- ============================================
-- 3. TABLA DETALLE FACTURA
-- ============================================
CREATE TABLE `detallefactura` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `factura_id` INT NOT NULL,
  `producto_presentacion_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(12,2) NOT NULL,
  `descuento_pct_aplicado` DECIMAL(5,2) DEFAULT 0,
  `subtotal` DECIMAL(12,2) NOT NULL,

  -- Foreign Keys
  CONSTRAINT `fk_detalle_factura`
    FOREIGN KEY (`factura_id`)
    REFERENCES `facturas`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT `fk_detalle_producto_presentacion`
    FOREIGN KEY (`producto_presentacion_id`)
    REFERENCES `productopresentacion`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_detalle_factura` (`factura_id`),
  INDEX `idx_detalle_producto` (`producto_presentacion_id`),

  -- Validación: cantidad debe ser positiva
  CHECK (`cantidad` > 0),
  CHECK (`precio_unitario` >= 0),
  CHECK (`descuento_pct_aplicado` >= 0 AND `descuento_pct_aplicado` <= 100)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Detalle de productos vendidos por factura';

-- ============================================
-- 4. TABLA PAGOS
-- ============================================
CREATE TABLE `pagos` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `factura_id` INT NOT NULL,
  `tipo` ENUM('EFECTIVO', 'TARJETA_DEBITO', 'TARJETA_CREDITO', 'CHEQUE', 'TRANSFERENCIA', 'DEPOSITO') NOT NULL,
  `monto` DECIMAL(12,2) NOT NULL,
  `referencia` VARCHAR(80) COMMENT 'Número de cheque, voucher, etc.',
  `entidad` VARCHAR(80) COMMENT 'Banco o procesador de pago',
  `transaccion_gateway_id` VARCHAR(80) COMMENT 'ID de transacción del gateway',
  `autorizado_por` VARCHAR(120) COMMENT 'Persona que autorizó el pago',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,

  -- Foreign Key
  CONSTRAINT `fk_pagos_factura`
    FOREIGN KEY (`factura_id`)
    REFERENCES `facturas`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Índices
  INDEX `idx_pagos_factura` (`factura_id`),
  INDEX `idx_pagos_tipo` (`tipo`),
  INDEX `idx_pagos_fecha` (`created_at`),
  INDEX `idx_pagos_entidad` (`entidad`),

  -- Validación: monto debe ser positivo
  CHECK (`monto` > 0)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Pagos recibidos por factura (permite múltiples pagos por factura)';

-- ============================================
-- VERIFICACIÓN
-- ============================================
-- Verificar que las tablas se crearon correctamente
SELECT
  TABLE_NAME,
  TABLE_ROWS,
  TABLE_COMMENT
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'pinturas'
  AND TABLE_NAME IN ('facturas', 'detallefactura', 'pagos', 'secuencias_facturas')
ORDER BY TABLE_NAME;



SELECT * FROM clientes LIMIT 5;



-- ============================================
-- SISTEMA DE COMPRAS
-- Eliminar tablas si existen (orden inverso por FK)
-- ============================================

DROP TABLE IF EXISTS `detalle_recepciones`;
DROP TABLE IF EXISTS `recepciones`;
DROP TABLE IF EXISTS `pagos_proveedores`;
DROP TABLE IF EXISTS `detalle_orden_compra`;
DROP TABLE IF EXISTS `ordenes_compra`;
DROP TABLE IF EXISTS `proveedores`;

-- ============================================
-- 1. TABLA PROVEEDORES
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

-- ============================================
-- 2. TABLA ÓRDENES DE COMPRA
-- ============================================
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

  -- Constraint único para número + serie
  UNIQUE KEY `unique_orden` (`numero`, `serie`),

  -- Índices
  INDEX `idx_ordenes_proveedor` (`proveedor_id`),
  INDEX `idx_ordenes_sucursal` (`sucursal_id`),
  INDEX `idx_ordenes_usuario` (`usuario_id`),
  INDEX `idx_ordenes_fecha` (`fecha_orden`),
  INDEX `idx_ordenes_estado` (`estado`),
  INDEX `idx_ordenes_numero_serie` (`numero`, `serie`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Órdenes de compra a proveedores';

-- ============================================
-- 3. TABLA DETALLE ORDEN COMPRA
-- ============================================
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

-- ============================================
-- 4. TABLA RECEPCIONES
-- ============================================
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

-- ============================================
-- 5. TABLA DETALLE RECEPCIONES
-- ============================================
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
-- 6. AGREGAR SERIE 'OC' A SECUENCIAS (Reutilizamos tabla existente)
-- ============================================
INSERT INTO `secuencias_facturas` (`serie`, `ultimo_numero`, `descripcion`, `activa`)
VALUES ('OC', 0, 'Órdenes de Compra', TRUE)
ON DUPLICATE KEY UPDATE descripcion = 'Órdenes de Compra';

-- ============================================
-- VERIFICACIÓN
-- ============================================
SELECT
  TABLE_NAME,
  TABLE_ROWS,
  TABLE_COMMENT
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'pinturas'
  AND TABLE_NAME IN ('proveedores', 'ordenes_compra', 'detalle_orden_compra', 'recepciones', 'detalle_recepciones')
ORDER BY TABLE_NAME;

-- Ver secuencias
SELECT * FROM secuencias_facturas;




SELECT
    oc.id,
    oc.numero,
    oc.serie,
    oc.estado,
    doc.cantidad,
    doc.cantidad_recibida
FROM ordenes_compra oc
INNER JOIN detalle_orden_compra doc ON oc.id = doc.orden_compra_id
WHERE oc.numero = 2 AND oc.serie = 'OC';