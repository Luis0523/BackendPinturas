-- EJECUTAR ESTOS COMANDOS UNO POR UNO EN LA CONSOLA DE MYSQL

-- 1. Verificar la estructura actual de la tabla pagos
DESCRIBE pagos;

-- 2. Modificar factura_id para que acepte NULL (si no lo acepta ya)
ALTER TABLE pagos MODIFY COLUMN factura_id INT NULL;

-- 3. Agregar columna pedido_id (si no existe)
ALTER TABLE pagos ADD COLUMN pedido_id INT NULL COMMENT 'ID del pedido en línea si aplica' AFTER factura_id;

-- 4. Verificar que se agregó correctamente
DESCRIBE pagos;

-- 5. Mostrar las tablas creadas
SHOW TABLES LIKE '%pedido%';

-- 6. Verificar estructura de pedidos
DESCRIBE pedidos;

-- 7. Verificar estructura de detallepedido
DESCRIBE detallepedido;

SELECT '✅ Modificaciones completadas correctamente' AS resultado;
