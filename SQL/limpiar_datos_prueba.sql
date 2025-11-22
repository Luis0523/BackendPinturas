-- ============================================
-- SCRIPT DE LIMPIEZA COMPLETA
-- ============================================
-- Este script limpia TODOS los datos de prueba relacionados
-- con productos del ID 4 en adelante, manteniendo solo
-- los productos 1-3 que ya tenías.
--
-- IMPORTANTE: Ejecuta este script ANTES de volver a ejecutar
-- datos_prueba_noviembre_2025.sql desde la sección de
-- productopresentacion
-- ============================================

USE pinturas;

-- ============================================
-- PASO 1: DESHABILITAR VERIFICACIÓN DE FOREIGN KEYS
-- ============================================
SET FOREIGN_KEY_CHECKS=0;

-- ============================================
-- PASO 2: LIMPIAR DATOS EN ORDEN INVERSO DE DEPENDENCIAS
-- ============================================

-- 2.1 Eliminar PAGOS de facturas de prueba (1001-1062)
DELETE FROM pagos
WHERE factura_id IN (
    SELECT id FROM facturas
    WHERE numero >= 1001 AND numero <= 1062
);

-- 2.2 Eliminar DETALLES DE FACTURAS de prueba
DELETE FROM detallefactura
WHERE factura_id IN (
    SELECT id FROM facturas
    WHERE numero >= 1001 AND numero <= 1062
);

-- 2.3 Eliminar FACTURAS de prueba
DELETE FROM facturas
WHERE numero >= 1001 AND numero <= 1062;

-- 2.4 Eliminar CLIENTES de prueba (excepto CF que puede ya existir)
DELETE FROM clientes
WHERE id >= 2 AND nit != 'CF';

-- 2.5 Eliminar PRECIOS de productos >= 4
DELETE FROM precios
WHERE producto_presentacion_id IN (
    SELECT id FROM productopresentacion
    WHERE producto_id >= 4
);

-- 2.6 Eliminar INVENTARIO de productos >= 4
DELETE FROM inventariosucursal
WHERE producto_presentacion_id IN (
    SELECT id FROM productopresentacion
    WHERE producto_id >= 4
);

-- 2.7 Eliminar PRODUCTO-PRESENTACION de productos >= 4
DELETE FROM productopresentacion
WHERE producto_id >= 4;

-- 2.8 Eliminar PRODUCTOS del 4 en adelante
DELETE FROM productos
WHERE id >= 4;

-- ============================================
-- PASO 3: RESETEAR AUTO_INCREMENT A 4
-- ============================================
-- Esto asegura que el siguiente producto insertado tenga ID = 4
ALTER TABLE productos AUTO_INCREMENT = 4;

-- ============================================
-- PASO 4: REACTIVAR VERIFICACIÓN DE FOREIGN KEYS
-- ============================================
SET FOREIGN_KEY_CHECKS=1;

-- ============================================
-- PASO 5: VERIFICAR RESULTADOS
-- ============================================
SELECT 'Limpieza completada exitosamente' as mensaje;

SELECT
    'Productos restantes (deberían ser solo 1-3):' as verificacion,
    COUNT(*) as total_productos
FROM productos;

SELECT
    'ProductoPresentacion relacionados con productos >= 4:' as verificacion,
    COUNT(*) as total_registros
FROM productopresentacion
WHERE producto_id >= 4;

SELECT
    'Inventario relacionado con productos >= 4:' as verificacion,
    COUNT(*) as total_registros
FROM inventariosucursal
WHERE producto_presentacion_id IN (
    SELECT id FROM productopresentacion WHERE producto_id >= 4
);

-- ============================================
-- RESUMEN
-- ============================================
-- Tablas limpiadas:
-- ✓ pagos (facturas 1001-1062)
-- ✓ detallefactura (facturas 1001-1062)
-- ✓ facturas (1001-1062)
-- ✓ clientes (excepto los primeros y CF)
-- ✓ precios (productos >= 4)
-- ✓ inventariosucursal (productos >= 4)
-- ✓ productopresentacion (productos >= 4)
-- ✓ productos (id >= 4)
-- ✓ AUTO_INCREMENT reseteado a 4
--
-- SIGUIENTE PASO:
-- Ahora ejecuta el script datos_prueba_noviembre_2025.sql
-- PERO SOLO A PARTIR DE LA SECCIÓN:
-- "2. RELACIONAR PRODUCTOS CON PRESENTACIONES"
--
-- Es decir, ejecuta desde la línea que dice:
-- INSERT INTO productopresentacion (producto_id, presentacion_id, activo) VALUES
-- ============================================
