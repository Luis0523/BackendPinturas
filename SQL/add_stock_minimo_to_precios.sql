-- Migración: Agregar campo stock_minimo a la tabla precios
-- Fecha: 2025-11-05
-- Descripción: Agrega el campo stock_minimo a la tabla de precios para almacenar
--              el stock mínimo configurado por sucursal

-- Para MySQL/MariaDB
-- Primero verificar si existe la columna
-- Si existe, comentar la línea ALTER TABLE

ALTER TABLE precios
ADD COLUMN stock_minimo INT DEFAULT 0
COMMENT 'Stock mínimo configurado para esta presentación en esta sucursal';

-- Agregar constraint de validación (MySQL 8.0.16+)
-- Si tienes una versión anterior, comenta esta línea
ALTER TABLE precios
ADD CONSTRAINT chk_stock_minimo CHECK (stock_minimo >= 0);

-- Verificar que se agregó correctamente
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'precios'
  AND COLUMN_NAME = 'stock_minimo';
