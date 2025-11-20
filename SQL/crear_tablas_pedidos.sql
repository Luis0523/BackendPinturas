-- SQL para crear tablas de pedidos en línea

-- Crear tabla de secuencias para pedidos
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

-- Crear tabla de pedidos
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

-- Crear tabla de detalles de pedido
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

-- Modificar tabla de pagos para soportar pedidos
-- (Si ya existe, usar ALTER TABLE en lugar de CREATE TABLE)
ALTER TABLE pagos
ADD COLUMN pedido_id INT NULL COMMENT 'ID del pedido en línea si aplica' AFTER factura_id,
ADD FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE;

-- Modificar la constraint de factura_id para que pueda ser null
ALTER TABLE pagos
MODIFY COLUMN factura_id INT NULL;

-- Verificar que las tablas se crearon correctamente
SELECT 'Tablas de pedidos creadas exitosamente' AS mensaje;
