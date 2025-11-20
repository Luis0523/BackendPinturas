-- ========================================
-- CORREGIR COLUMNA factura_id EN TABLA pagos
-- ========================================
-- Este script modifica la columna factura_id para que acepte valores NULL
-- Esto es necesario porque los pagos pueden estar asociados a:
-- - Una FACTURA (para ventas en POS)
-- - Un PEDIDO (para ventas en línea)

USE pinturas_db;

-- Verificar la estructura actual de la tabla pagos
SELECT
    COLUMN_NAME,
    IS_NULLABLE,
    COLUMN_TYPE,
    COLUMN_DEFAULT,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'pinturas_db'
AND TABLE_NAME = 'pagos'
AND COLUMN_NAME IN ('factura_id', 'pedido_id');

-- Modificar la columna factura_id para que acepte NULL
ALTER TABLE pagos
MODIFY COLUMN factura_id INT NULL
COMMENT 'ID de la factura (para ventas en POS)';

-- Verificar que pedido_id también acepte NULL (debería ser correcto)
ALTER TABLE pagos
MODIFY COLUMN pedido_id INT NULL
COMMENT 'ID del pedido (para ventas en línea)';

-- Verificar que el cambio se aplicó correctamente
SELECT
    COLUMN_NAME,
    IS_NULLABLE,
    COLUMN_TYPE,
    COLUMN_DEFAULT,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'pinturas_db'
AND TABLE_NAME = 'pagos'
AND COLUMN_NAME IN ('factura_id', 'pedido_id');

SELECT '✅ Columnas factura_id y pedido_id corregidas exitosamente en tabla pagos' AS resultado;
