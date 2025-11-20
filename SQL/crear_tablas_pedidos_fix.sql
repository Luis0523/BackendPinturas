-- SQL para crear tablas de pedidos en línea (VERSION CORREGIDA)

-- ========================================
-- 1. CREAR TABLA DE SECUENCIAS PARA PEDIDOS
-- ========================================
CREATE TABLE IF NOT EXISTS secuencias_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ultimo_numero INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar secuencia inicial si no existe
INSERT INTO secuencias_pedidos (ultimo_numero)
SELECT 0
WHERE NOT EXISTS (SELECT 1 FROM secuencias_pedidos LIMIT 1);

-- ========================================
-- 2. CREAR TABLA DE PEDIDOS
-- ========================================
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL UNIQUE COMMENT 'Número correlativo del pedido',
    fecha_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Cliente (puede ser null si no está registrado)
    cliente_id INT NULL,

    -- Datos del comprador (obligatorios para pedidos en línea)
    nombre_cliente VARCHAR(120) NOT NULL COMMENT 'Nombre completo del comprador',
    email_cliente VARCHAR(80) NOT NULL COMMENT 'Email para notificaciones',
    telefono_cliente VARCHAR(20) NOT NULL COMMENT 'Teléfono de contacto',
    nit_cliente VARCHAR(20) DEFAULT 'CF' COMMENT 'NIT del cliente para facturación',

    -- Dirección de envío
    direccion_envio TEXT NOT NULL COMMENT 'Dirección completa de entrega',
    ciudad_envio VARCHAR(80) NOT NULL,
    departamento_envio VARCHAR(80) NOT NULL,
    codigo_postal VARCHAR(10) NULL,
    referencias_direccion TEXT NULL COMMENT 'Referencias adicionales para encontrar la dirección',

    -- Sucursal que procesará el pedido
    sucursal_id INT NOT NULL,

    -- Montos
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (subtotal >= 0),
    descuento_total DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (descuento_total >= 0),
    total DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (total >= 0),

    -- Estado del pedido
    estado ENUM('PENDIENTE', 'CONFIRMADO', 'EN_PREPARACION', 'ENVIADO', 'ENTREGADO', 'CANCELADO')
        NOT NULL DEFAULT 'PENDIENTE' COMMENT 'Estado actual del pedido',
    estado_pago ENUM('PENDIENTE', 'PAGADO', 'RECHAZADO', 'REEMBOLSADO')
        NOT NULL DEFAULT 'PENDIENTE',

    -- Factura asociada (se crea cuando se confirma el pedido)
    factura_id INT NULL COMMENT 'Factura generada cuando se confirma el pedido',

    -- Cancelación
    cancelado_fecha TIMESTAMP NULL,
    motivo_cancelacion TEXT NULL,

    -- Notas
    notas_cliente TEXT NULL COMMENT 'Notas o instrucciones del cliente',
    notas_internas TEXT NULL COMMENT 'Notas internas del personal',

    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Foreign keys
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL,
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id) ON DELETE RESTRICT,
    FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE SET NULL,

    -- Índices
    INDEX idx_pedido_email (email_cliente),
    INDEX idx_pedido_estado (estado),
    INDEX idx_pedido_sucursal (sucursal_id),
    INDEX idx_pedido_fecha (fecha_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- 3. CREAR TABLA DE DETALLES DE PEDIDO
-- ========================================
CREATE TABLE IF NOT EXISTS detallepedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_presentacion_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >= 1),
    precio_unitario DECIMAL(12,2) NOT NULL CHECK (precio_unitario >= 0),
    descuento_pct_aplicado DECIMAL(5,2) DEFAULT 0 CHECK (descuento_pct_aplicado >= 0 AND descuento_pct_aplicado <= 100),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),

    -- Foreign keys
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_presentacion_id) REFERENCES productopresentacion(id) ON DELETE RESTRICT,

    -- Índices
    INDEX idx_detalle_pedido (pedido_id),
    INDEX idx_detalle_producto (producto_presentacion_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- 4. MODIFICAR TABLA DE PAGOS (SI NO EXISTE LA COLUMNA)
-- ========================================

-- Verificar si la columna pedido_id ya existe, si no, agregarla
SET @column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'pagos'
    AND COLUMN_NAME = 'pedido_id'
);

-- Solo agregar la columna si no existe
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE pagos ADD COLUMN pedido_id INT NULL COMMENT "ID del pedido en línea si aplica" AFTER factura_id',
    'SELECT "La columna pedido_id ya existe en la tabla pagos" AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar foreign key solo si no existe
SET @fk_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'pagos'
    AND COLUMN_NAME = 'pedido_id'
    AND REFERENCED_TABLE_NAME = 'pedidos'
);

SET @sql_fk = IF(@fk_exists = 0,
    'ALTER TABLE pagos ADD FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE',
    'SELECT "La foreign key pedido_id ya existe en la tabla pagos" AS mensaje'
);

PREPARE stmt_fk FROM @sql_fk;
EXECUTE stmt_fk;
DEALLOCATE PREPARE stmt_fk;

-- ========================================
-- 5. MODIFICAR FACTURA_ID PARA QUE ACEPTE NULL (SI ES NECESARIO)
-- ========================================

-- Verificar si factura_id ya acepta NULL
SET @factura_nullable = (
    SELECT IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'pagos'
    AND COLUMN_NAME = 'factura_id'
);

SET @sql_nullable = IF(@factura_nullable = 'NO',
    'ALTER TABLE pagos MODIFY COLUMN factura_id INT NULL',
    'SELECT "La columna factura_id ya acepta NULL" AS mensaje'
);

PREPARE stmt_nullable FROM @sql_nullable;
EXECUTE stmt_nullable;
DEALLOCATE PREPARE stmt_nullable;

-- ========================================
-- VERIFICACIÓN FINAL
-- ========================================
SELECT 'Tablas de pedidos creadas/actualizadas exitosamente' AS resultado;

-- Mostrar estructura de las tablas creadas
DESCRIBE pedidos;
DESCRIBE detallepedido;
SHOW COLUMNS FROM pagos WHERE Field IN ('factura_id', 'pedido_id');
