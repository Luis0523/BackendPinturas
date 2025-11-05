-- =====================================================
-- SCRIPT DE LIMPIEZA SOLO PRODUCTOS (CONSERVADOR)
-- =====================================================
-- Este script limpia SOLO productos e inventario actual
-- CONSERVA el historial de órdenes de compra y recepciones
--
-- ELIMINARÁ:
-- - Productos
-- - Presentaciones de productos
-- - Precios actuales
-- - Inventario actual de todas las sucursales
--
-- CONSERVARÁ:
-- - Historial de órdenes de compra (para auditoría)
-- - Historial de recepciones (para auditoría)
-- - Movimientos de inventario históricos (para trazabilidad)
-- - Sucursales, Categorías, Marcas, Presentaciones
-- - Proveedores, Usuarios, Roles, Clientes
-- =====================================================

-- Desactivar verificación de llaves foráneas temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- PASO 1: LIMPIAR INVENTARIO ACTUAL
-- =====================================================
TRUNCATE TABLE inventariosucursal;

-- =====================================================
-- PASO 2: LIMPIAR PRECIOS ACTUALES
-- =====================================================
TRUNCATE TABLE precios;

-- =====================================================
-- PASO 3: LIMPIAR PRODUCTO-PRESENTACIONES (RELACIÓN)
-- =====================================================
TRUNCATE TABLE productopresentacion;

-- =====================================================
-- PASO 4: LIMPIAR PRODUCTOS
-- =====================================================
TRUNCATE TABLE productos;

-- Reactivar verificación de llaves foráneas
SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- VERIFICACIÓN DE LIMPIEZA
-- =====================================================
SELECT 'Tablas limpiadas' AS Proceso;

SELECT
    'productos' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM productos

UNION ALL

SELECT
    'productopresentacion' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM productopresentacion

UNION ALL

SELECT
    'precios' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM precios

UNION ALL

SELECT
    'inventariosucursal' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM inventariosucursal;

-- =====================================================
-- VERIFICACIÓN DE DATOS HISTÓRICOS CONSERVADOS
-- =====================================================
SELECT 'Historial conservado' AS Proceso;

SELECT
    'ordenescompra' AS Tabla,
    COUNT(*) AS Total
FROM ordenescompra

UNION ALL

SELECT
    'recepciones' AS Tabla,
    COUNT(*) AS Total
FROM recepciones

UNION ALL

SELECT
    'movimientosinventario' AS Tabla,
    COUNT(*) AS Total
FROM movimientosinventario;

-- =====================================================
-- MENSAJE FINAL
-- =====================================================
SELECT
    '✅ LIMPIEZA COMPLETADA' AS Estado,
    'Los productos actuales han sido eliminados' AS Mensaje,
    'El historial de compras y movimientos se mantiene para auditoría' AS Nota;
