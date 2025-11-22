-- ============================================
-- SCRIPT DE LIMPIEZA FORZADA COMPLETA
-- ============================================
-- Este script ELIMINA TODO sin usar subqueries
-- Limpia COMPLETAMENTE todas las tablas relacionadas
-- ============================================

USE pinturas;

-- ============================================
-- PASO 1: DESHABILITAR VERIFICACIÓN DE FOREIGN KEYS
-- ============================================
SET FOREIGN_KEY_CHECKS=0;

-- ============================================
-- PASO 2: TRUNCAR/LIMPIAR TABLAS COMPLETAMENTE
-- ============================================
-- IMPORTANTE: Esto eliminará TODOS los datos de ventas, inventario
-- y productos >= 4, pero mantendrá productos 1-3

-- 2.1 Limpiar PAGOS (todos)
TRUNCATE TABLE pagos;

-- 2.2 Limpiar DETALLE FACTURAS (todos)
TRUNCATE TABLE detallefactura;

-- 2.3 Limpiar FACTURAS (todos)
TRUNCATE TABLE facturas;

-- 2.4 Limpiar CLIENTES (todos)
TRUNCATE TABLE clientes;

-- 2.5 Limpiar PRECIOS (todos)
TRUNCATE TABLE precios;

-- 2.6 Limpiar INVENTARIO (todos)
TRUNCATE TABLE inventariosucursal;

-- 2.7 Limpiar PRODUCTO-PRESENTACION (todos)
TRUNCATE TABLE productopresentacion;

-- 2.8 Eliminar PRODUCTOS del 4 en adelante
DELETE FROM productos WHERE id >= 4;

-- ============================================
-- PASO 3: RESETEAR AUTO_INCREMENTS
-- ============================================
ALTER TABLE productos AUTO_INCREMENT = 4;
ALTER TABLE facturas AUTO_INCREMENT = 1;
ALTER TABLE clientes AUTO_INCREMENT = 1;

-- ============================================
-- PASO 4: REACTIVAR VERIFICACIÓN DE FOREIGN KEYS
-- ============================================
SET FOREIGN_KEY_CHECKS=1;

-- ============================================
-- PASO 5: VERIFICAR RESULTADOS
-- ============================================
SELECT '✓ Limpieza forzada completada' as mensaje;

SELECT 'Productos (solo 1-3):' as tabla, COUNT(*) as registros FROM productos;
SELECT 'ProductoPresentacion:' as tabla, COUNT(*) as registros FROM productopresentacion;
SELECT 'InventarioSucursal:' as tabla, COUNT(*) as registros FROM inventariosucursal;
SELECT 'Precios:' as tabla, COUNT(*) as registros FROM precios;
SELECT 'Facturas:' as tabla, COUNT(*) as registros FROM facturas;
SELECT 'DetalleFactura:' as tabla, COUNT(*) as registros FROM detallefactura;
SELECT 'Pagos:' as tabla, COUNT(*) as registros FROM pagos;
SELECT 'Clientes:' as tabla, COUNT(*) as registros FROM clientes;

-- ============================================
-- RESUMEN
-- ============================================
-- ✓ Todas las tablas de transacciones limpiadas (TRUNCATE)
-- ✓ Productos >= 4 eliminados
-- ✓ AUTO_INCREMENT reseteado a 4
--
-- RESULTADO ESPERADO:
-- - productos: 3 registros (tus productos originales 1-3)
-- - productopresentacion: 0 registros
-- - inventariosucursal: 0 registros
-- - precios: 0 registros
-- - facturas: 0 registros
-- - detallefactura: 0 registros
-- - pagos: 0 registros
-- - clientes: 0 registros (TODOS eliminados para re-insertar con IDs correctos)
--
-- SIGUIENTE PASO:
-- 1. Ejecuta fix_productos_ids.sql (insertar productos 4-18)
-- 2. Ejecuta datos_prueba_noviembre_2025.sql desde la línea 116
--    (sección "2. RELACIONAR PRODUCTOS CON PRESENTACIONES")
-- ============================================
