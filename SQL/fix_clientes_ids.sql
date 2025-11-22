-- ============================================
-- SCRIPT DE CORRECCIÓN DE IDs DE CLIENTES
-- ============================================
-- Este script:
-- 1. Elimina TODAS las facturas y datos relacionados (para evitar foreign key errors)
-- 2. Elimina TODOS los clientes
-- 3. Resetea el auto_increment para que continúe desde el ID 1
-- 4. Re-inserta los clientes correctamente con IDs 1-11
-- ============================================

USE pinturas;

-- ============================================
-- PASO 1: DESHABILITAR VERIFICACIÓN DE FOREIGN KEYS
-- ============================================
SET FOREIGN_KEY_CHECKS=0;

-- ============================================
-- PASO 2: LIMPIAR DATOS RELACIONADOS CON CLIENTES
-- ============================================
-- Necesitamos limpiar las facturas porque tienen foreign keys a clientes

-- 2.1 Eliminar PAGOS
TRUNCATE TABLE pagos;

-- 2.2 Eliminar DETALLE FACTURAS
TRUNCATE TABLE detallefactura;

-- 2.3 Eliminar FACTURAS
TRUNCATE TABLE facturas;

-- ============================================
-- PASO 3: ELIMINAR TODOS LOS CLIENTES
-- ============================================
TRUNCATE TABLE clientes;

-- ============================================
-- PASO 4: RESETEAR AUTO_INCREMENT A 1
-- ============================================
-- Esto asegura que el siguiente cliente insertado tenga ID = 1
ALTER TABLE clientes AUTO_INCREMENT = 1;
ALTER TABLE facturas AUTO_INCREMENT = 1;

-- ============================================
-- PASO 5: RE-INSERTAR CLIENTES CON IDs CORRECTOS (1-11)
-- ============================================

INSERT INTO clientes (nombre, nit, email, telefono, direccion, opt_in_promos, verificado, creado_en) VALUES
-- Clientes regulares (IDs 1-10)
('María González', '12345678-9', 'maria.gonzalez@email.com', '5551-1111', 'Zona 10, Guatemala', 1, 1, '2025-10-15 10:00:00'),
('Carlos Rodríguez', '23456789-0', 'carlos.rodriguez@email.com', '5552-2222', 'Zona 15, Guatemala', 1, 1, '2025-10-16 11:30:00'),
('Ana Martínez', '34567890-1', 'ana.martinez@email.com', '5553-3333', 'Mixco, Guatemala', 0, 1, '2025-10-17 09:15:00'),
('Luis Pérez', '45678901-2', 'luis.perez@email.com', '5554-4444', 'Villa Nueva, Guatemala', 1, 1, '2025-10-18 14:20:00'),
('Carmen López', '56789012-3', 'carmen.lopez@email.com', '5555-5555', 'San Miguel Petapa', 1, 1, '2025-10-19 16:45:00'),
('Roberto Hernández', '67890123-4', 'roberto.hernandez@email.com', '5556-6666', 'Villa Canales', 0, 1, '2025-10-20 10:30:00'),
('Patricia Gómez', '78901234-5', 'patricia.gomez@email.com', '5557-7777', 'Amatitlán', 1, 1, '2025-10-21 13:00:00'),
('Jorge Ramírez', '89012345-6', 'jorge.ramirez@email.com', '5558-8888', 'Zona 18, Guatemala', 1, 1, '2025-10-22 15:30:00'),
('Sandra Morales', '90123456-7', 'sandra.morales@email.com', '5559-9999', 'Zona 7, Guatemala', 0, 1, '2025-10-23 11:45:00'),
('Fernando Castro', '01234567-8', 'fernando.castro@email.com', '5550-0000', 'Zona 11, Guatemala', 1, 1, '2025-10-24 09:00:00'),

-- Consumidor Final (ID 11)
('CONSUMIDOR FINAL', 'CF', NULL, NULL, NULL, 0, 1, '2025-01-01 00:00:00');

-- ============================================
-- PASO 6: REACTIVAR VERIFICACIÓN DE FOREIGN KEYS
-- ============================================
SET FOREIGN_KEY_CHECKS=1;

-- ============================================
-- PASO 7: VERIFICAR RESULTADOS
-- ============================================
SELECT 'Clientes insertados correctamente:' as mensaje;
SELECT id, nombre, nit, email FROM clientes ORDER BY id;

-- ============================================
-- RESUMEN
-- ============================================
-- Clientes eliminados: TODOS
-- Clientes re-insertados: IDs 1-11 (11 clientes)
-- Auto_increment configurado: 12 (el siguiente cliente será ID 12)
-- Facturas eliminadas: TODAS (se volverán a insertar con datos_prueba_noviembre_2025.sql)
--
-- SIGUIENTE PASO:
-- Ahora puedes ejecutar el script datos_prueba_noviembre_2025.sql
-- PERO SOLO A PARTIR DE LA SECCIÓN:
-- "6. INSERTAR VENTAS (FACTURAS) - NOVIEMBRE 2025"
--
-- Es decir, ejecuta desde la línea que dice:
-- INSERT INTO facturas (numero, serie, fecha_emision, cliente_id, usuario_id, sucursal_id, subtotal, descuento_total, total, estado) VALUES
-- ============================================
