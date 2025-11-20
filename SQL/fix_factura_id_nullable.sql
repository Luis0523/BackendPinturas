-- ========================================
-- CORREGIR COLUMNA factura_id EN TABLA pedidos
-- ========================================
-- Este script modifica la columna factura_id para que acepte valores NULL
-- Esto es necesario porque la factura se genera DESPUÉS cuando se confirma el pedido

USE pinturas_db;

-- Verificar la estructura actual
SELECT
    COLUMN_NAME,
    IS_NULLABLE,
    COLUMN_TYPE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'pinturas_db'
AND TABLE_NAME = 'pedidos'
AND COLUMN_NAME = 'factura_id';

-- Modificar la columna para que acepte NULL
ALTER TABLE pedidos
MODIFY COLUMN factura_id INT NULL
COMMENT 'Factura generada cuando se confirma el pedido';

-- Verificar que el cambio se aplicó correctamente
SELECT
    COLUMN_NAME,
    IS_NULLABLE,
    COLUMN_TYPE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'pinturas_db'
AND TABLE_NAME = 'pedidos'
AND COLUMN_NAME = 'factura_id';

SELECT 'Columna factura_id corregida exitosamente para aceptar NULL' AS resultado;
