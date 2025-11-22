-- Migración: Agregar campo imagen_url a la tabla productos
-- Fecha: 2025-11-21
-- Descripción: Agrega el campo imagen_url a la tabla de productos para almacenar
--              la URL de la imagen de presentación del producto en Firebase Storage

-- Para MySQL/MariaDB
-- Primero verificar si existe la columna
-- Si existe, comentar la línea ALTER TABLE

ALTER TABLE productos
ADD COLUMN imagen_url VARCHAR(500) DEFAULT NULL
COMMENT 'URL de la imagen de presentación del producto en Firebase Storage';

-- Verificar que se agregó correctamente
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'productos'
  AND COLUMN_NAME = 'imagen_url';
