-- =====================================================
-- SCRIPT DE BACKUP ANTES DE LIMPIEZA
-- =====================================================
-- Este script crea tablas temporales con respaldo de todos los datos
-- que serán eliminados. Úsalo ANTES de ejecutar la limpieza.
--
-- Si algo sale mal, puedes restaurar desde estas tablas.
-- =====================================================

-- =====================================================
-- CREAR TABLAS DE RESPALDO
-- =====================================================

-- Respaldo de productos
DROP TABLE IF EXISTS backup_productos;
CREATE TABLE backup_productos AS SELECT * FROM productos;

-- Respaldo de producto-presentaciones
DROP TABLE IF EXISTS backup_productopresentacion;
CREATE TABLE backup_productopresentacion AS SELECT * FROM productopresentacion;

-- Respaldo de precios
DROP TABLE IF EXISTS backup_precios;
CREATE TABLE backup_precios AS SELECT * FROM precios;

-- Respaldo de inventario
DROP TABLE IF EXISTS backup_inventariosucursal;
CREATE TABLE backup_inventariosucursal AS SELECT * FROM inventariosucursal;

-- Respaldo de movimientos de inventario
DROP TABLE IF EXISTS backup_movimientosinventario;
CREATE TABLE backup_movimientosinventario AS SELECT * FROM movimientosinventario;

-- Respaldo de órdenes de compra
DROP TABLE IF EXISTS backup_ordenescompra;
CREATE TABLE backup_ordenescompra AS SELECT * FROM ordenescompra;

-- Respaldo de detalles de órdenes
DROP TABLE IF EXISTS backup_detalleordencompra;
CREATE TABLE backup_detalleordencompra AS SELECT * FROM detalleordencompra;

-- Respaldo de recepciones
DROP TABLE IF EXISTS backup_recepciones;
CREATE TABLE backup_recepciones AS SELECT * FROM recepciones;

-- Respaldo de detalles de recepciones
DROP TABLE IF EXISTS backup_detallerecepcion;
CREATE TABLE backup_detallerecepcion AS SELECT * FROM detallerecepcion;

-- =====================================================
-- VERIFICACIÓN DEL BACKUP
-- =====================================================
SELECT 'Backup creado exitosamente' AS Estado;

SELECT
    'backup_productos' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_productos

UNION ALL

SELECT
    'backup_productopresentacion' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_productopresentacion

UNION ALL

SELECT
    'backup_precios' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_precios

UNION ALL

SELECT
    'backup_inventariosucursal' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_inventariosucursal

UNION ALL

SELECT
    'backup_movimientosinventario' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_movimientosinventario

UNION ALL

SELECT
    'backup_ordenescompra' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_ordenescompra

UNION ALL

SELECT
    'backup_detalleordencompra' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_detalleordencompra

UNION ALL

SELECT
    'backup_recepciones' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_recepciones

UNION ALL

SELECT
    'backup_detallerecepcion' AS Tabla,
    COUNT(*) AS Total_Respaldado
FROM backup_detallerecepcion;

-- =====================================================
-- MENSAJE FINAL
-- =====================================================
SELECT
    '✅ BACKUP COMPLETADO' AS Estado,
    CONCAT('Total de ',
        (SELECT COUNT(*) FROM backup_productos),
        ' productos respaldados') AS Mensaje,
    'Ahora puedes ejecutar el script de limpieza de forma segura' AS Nota;

-- =====================================================
-- INSTRUCCIONES PARA RESTAURAR (NO EJECUTAR AHORA)
-- =====================================================
/*
-- Si necesitas restaurar los datos, ejecuta esto:

SET FOREIGN_KEY_CHECKS = 0;

-- Restaurar productos
TRUNCATE TABLE productos;
INSERT INTO productos SELECT * FROM backup_productos;

-- Restaurar productopresentacion
TRUNCATE TABLE productopresentacion;
INSERT INTO productopresentacion SELECT * FROM backup_productopresentacion;

-- Restaurar precios
TRUNCATE TABLE precios;
INSERT INTO precios SELECT * FROM backup_precios;

-- Restaurar inventario
TRUNCATE TABLE inventariosucursal;
INSERT INTO inventariosucursal SELECT * FROM backup_inventariosucursal;

-- Restaurar movimientos
TRUNCATE TABLE movimientosinventario;
INSERT INTO movimientosinventario SELECT * FROM backup_movimientosinventario;

-- Restaurar órdenes
TRUNCATE TABLE ordenescompra;
INSERT INTO ordenescompra SELECT * FROM backup_ordenescompra;

TRUNCATE TABLE detalleordencompra;
INSERT INTO detalleordencompra SELECT * FROM backup_detalleordencompra;

-- Restaurar recepciones
TRUNCATE TABLE recepciones;
INSERT INTO recepciones SELECT * FROM backup_recepciones;

TRUNCATE TABLE detallerecepcion;
INSERT INTO detallerecepcion SELECT * FROM backup_detallerecepcion;

SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Restauración completada' AS Estado;
*/
