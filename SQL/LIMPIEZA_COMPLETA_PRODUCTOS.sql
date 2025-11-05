-- =====================================================
-- SCRIPT DE LIMPIEZA COMPLETA DE PRODUCTOS E INVENTARIO
-- =====================================================
-- ADVERTENCIA: Este script eliminará TODOS los datos de:
-- - Productos
-- - Presentaciones de productos
-- - Precios
-- - Inventario de todas las sucursales
-- - Movimientos de inventario
-- - Detalles de órdenes de compra
-- - Recepciones de compras
-- - Órdenes de compra
--
-- CONSERVARÁ:
-- - Sucursales
-- - Categorías
-- - Marcas
-- - Presentaciones (tipos: Galón, Cuarto, etc.)
-- - Proveedores
-- - Usuarios
-- - Roles
-- - Clientes
-- - Configuraciones
-- =====================================================

-- Desactivar verificación de llaves foráneas temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- PASO 1: LIMPIAR RECEPCIONES Y DETALLES
-- =====================================================
TRUNCATE TABLE detallerecepcion;
TRUNCATE TABLE recepciones;

-- =====================================================
-- PASO 2: LIMPIAR ÓRDENES DE COMPRA Y DETALLES
-- =====================================================
TRUNCATE TABLE detalleordencompra;
TRUNCATE TABLE ordenescompra;

-- =====================================================
-- PASO 3: LIMPIAR MOVIMIENTOS DE INVENTARIO
-- =====================================================
TRUNCATE TABLE movimientosinventario;

-- =====================================================
-- PASO 4: LIMPIAR INVENTARIO POR SUCURSAL
-- =====================================================
TRUNCATE TABLE inventariosucursal;

-- =====================================================
-- PASO 5: LIMPIAR PRECIOS
-- =====================================================
TRUNCATE TABLE precios;

-- =====================================================
-- PASO 6: LIMPIAR PRODUCTO-PRESENTACIONES (RELACIÓN)
-- =====================================================
TRUNCATE TABLE productopresentacion;

-- =====================================================
-- PASO 7: LIMPIAR PRODUCTOS
-- =====================================================
TRUNCATE TABLE productos;

-- Reactivar verificación de llaves foráneas
SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- VERIFICACIÓN DE LIMPIEZA
-- =====================================================
SELECT 'Verificación de limpieza' AS Proceso;

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
FROM inventariosucursal

UNION ALL

SELECT
    'movimientosinventario' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM movimientosinventario

UNION ALL

SELECT
    'ordenescompra' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM ordenescompra

UNION ALL

SELECT
    'detalleordencompra' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM detalleordencompra

UNION ALL

SELECT
    'recepciones' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM recepciones

UNION ALL

SELECT
    'detallerecepcion' AS Tabla,
    COUNT(*) AS Registros_Restantes
FROM detallerecepcion;

-- =====================================================
-- VERIFICACIÓN DE DATOS CONSERVADOS
-- =====================================================
SELECT 'Datos conservados (NO eliminados)' AS Proceso;

SELECT
    'categorias' AS Tabla,
    COUNT(*) AS Total
FROM categorias

UNION ALL

SELECT
    'marcas' AS Tabla,
    COUNT(*) AS Total
FROM marcas

UNION ALL

SELECT
    'presentaciones' AS Tabla,
    COUNT(*) AS Total
FROM presentaciones

UNION ALL

SELECT
    'sucursales' AS Tabla,
    COUNT(*) AS Total
FROM sucursales

UNION ALL

SELECT
    'proveedores' AS Tabla,
    COUNT(*) AS Total
FROM proveedores

UNION ALL

SELECT
    'usuarios' AS Tabla,
    COUNT(*) AS Total
FROM usuarios;

-- =====================================================
-- MENSAJE FINAL
-- =====================================================
SELECT
    '✅ LIMPIEZA COMPLETADA' AS Estado,
    'Todos los productos, inventario, precios y órdenes han sido eliminados' AS Mensaje,
    'Las categorías, marcas, presentaciones, sucursales, proveedores y usuarios se mantienen intactos' AS Nota;
