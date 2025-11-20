-- SQL SIMPLIFICADO para crear tablas de pedidos en línea

-- 1. TABLA DE SECUENCIAS
CREATE TABLE IF NOT EXISTS secuencias_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ultimo_numero INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO secuencias_pedidos (id, ultimo_numero) VALUES (1, 0);

-- 2. TABLA DE PEDIDOS
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL UNIQUE,
    fecha_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cliente_id INT NULL,
    nombre_cliente VARCHAR(120) NOT NULL,
    email_cliente VARCHAR(80) NOT NULL,
    telefono_cliente VARCHAR(20) NOT NULL,
    nit_cliente VARCHAR(20) DEFAULT 'CF',
    direccion_envio TEXT NOT NULL,
    ciudad_envio VARCHAR(80) NOT NULL,
    departamento_envio VARCHAR(80) NOT NULL,
    codigo_postal VARCHAR(10) NULL,
    referencias_direccion TEXT NULL,
    sucursal_id INT NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
    descuento_total DECIMAL(12,2) NOT NULL DEFAULT 0,
    total DECIMAL(12,2) NOT NULL DEFAULT 0,
    estado ENUM('PENDIENTE', 'CONFIRMADO', 'EN_PREPARACION', 'ENVIADO', 'ENTREGADO', 'CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
    estado_pago ENUM('PENDIENTE', 'PAGADO', 'RECHAZADO', 'REEMBOLSADO') NOT NULL DEFAULT 'PENDIENTE',
    factura_id INT NULL,
    cancelado_fecha TIMESTAMP NULL,
    motivo_cancelacion TEXT NULL,
    notas_cliente TEXT NULL,
    notas_internas TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_pedido_email (email_cliente),
    INDEX idx_pedido_estado (estado),
    INDEX idx_pedido_sucursal (sucursal_id),
    INDEX idx_pedido_fecha (fecha_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. TABLA DE DETALLES
CREATE TABLE IF NOT EXISTS detallepedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_presentacion_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    descuento_pct_aplicado DECIMAL(5,2) DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,
    INDEX idx_detalle_pedido (pedido_id),
    INDEX idx_detalle_producto (producto_presentacion_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. AGREGAR COLUMNA pedido_id A pagos (solo si no existe)
-- Nota: Si esto falla, ignóralo y continúa con los siguientes pasos manualmente

SELECT 'Verificando columna pedido_id en tabla pagos...' AS paso;

-- 5. MODIFICAR factura_id PARA ACEPTAR NULL
-- Nota: Si esto falla porque ya acepta NULL, está bien

SELECT 'Modificando columna factura_id...' AS paso;

-- ============================================
-- EJECUTAR ESTOS COMANDOS MANUALMENTE SI ES NECESARIO:
-- ============================================
-- ALTER TABLE pagos MODIFY COLUMN factura_id INT NULL;
-- ALTER TABLE pagos ADD COLUMN pedido_id INT NULL AFTER factura_id;
-- ============================================

SELECT 'Tablas principales creadas correctamente' AS resultado;
SELECT 'Revisa las notas finales para completar la configuración' AS nota;
