-- ============================================
-- SCRIPT DE CORRECCIÓN DE IDs DE PRODUCTOS
-- ============================================
-- Este script:
-- 1. Elimina productos del ID 19 en adelante
-- 2. Resetea el auto_increment para que continúe desde el ID 4
-- 3. Re-inserta los productos correctamente con IDs 4-18
-- ============================================

USE pinturas;

-- ============================================
-- PASO 1: DESHABILITAR VERIFICACIÓN DE FOREIGN KEYS
-- ============================================
SET FOREIGN_KEY_CHECKS=0;

-- ============================================
-- PASO 2: ELIMINAR PRODUCTOS DEL 19 EN ADELANTE
-- ============================================
DELETE FROM productos WHERE id >= 19;

-- ============================================
-- PASO 3: RESETEAR AUTO_INCREMENT A 4
-- ============================================
-- Esto asegura que el siguiente producto insertado tenga ID = 4
ALTER TABLE productos AUTO_INCREMENT = 4;

-- ============================================
-- PASO 4: RE-INSERTAR PRODUCTOS CON IDs CORRECTOS (4-18)
-- ============================================

INSERT INTO productos (categoria_id, marca_id, codigo_sku, descripcion, tamano, duracion_anios, extension_m2, color, activo, imagen_url) VALUES
-- Pinturas Látex (IDs 4-8)
(1, 1, 'PINT-LAT-BL-01', 'Pintura Látex Blanco Mate', '1 Galón', 5, 35.00, 'Blanco', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(1, 1, 'PINT-LAT-BG-01', 'Pintura Látex Beige', '1 Galón', 5, 35.00, 'Beige', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(1, 2, 'PINT-LAT-GR-01', 'Pintura Látex Gris Claro', '1 Galón', 5, 35.00, 'Gris Claro', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(1, 2, 'PINT-LAT-AZ-01', 'Pintura Látex Azul Cielo', '1 Galón', 5, 35.00, 'Azul Cielo', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(1, 3, 'PINT-LAT-VD-01', 'Pintura Látex Verde Menta', '1 Galón', 5, 35.00, 'Verde Menta', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),

-- Pinturas de Aceite (IDs 9-11)
(2, 1, 'PINT-ACE-BL-01', 'Esmalte Aceite Blanco Brillante', '1 Galón', 8, 25.00, 'Blanco', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(2, 2, 'PINT-ACE-NG-01', 'Esmalte Aceite Negro Mate', '1 Galón', 8, 25.00, 'Negro', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(2, 3, 'PINT-ACE-RJ-01', 'Esmalte Aceite Rojo Ferrari', '1 Galón', 8, 25.00, 'Rojo', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),

-- Pinturas Exteriores (IDs 12-14)
(3, 1, 'PINT-EXT-BL-01', 'Pintura Exterior Blanco', 'Cubeta 5 Gal', 10, 150.00, 'Blanco', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(3, 2, 'PINT-EXT-CR-01', 'Pintura Exterior Crema', 'Cubeta 5 Gal', 10, 150.00, 'Crema', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(3, 3, 'PINT-EXT-GR-01', 'Pintura Exterior Gris Piedra', 'Cubeta 5 Gal', 10, 150.00, 'Gris Piedra', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),

-- Barnices y Selladores (IDs 15-16)
(4, 1, 'BARN-MAD-NAT-01', 'Barniz para Madera Natural', '1 Galón', 3, 30.00, 'Natural', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(4, 2, 'SELL-PIS-TRP-01', 'Sellador para Pisos Transparente', '1 Galón', 5, 40.00, 'Transparente', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),

-- Primers e Imprimantes (IDs 17-18)
(5, 1, 'PRIM-PAR-BL-01', 'Primer para Paredes Blanco', '1 Galón', 0, 45.00, 'Blanco', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(5, 2, 'PRIM-MET-GR-01', 'Anticorrosivo para Metal Gris', '1 Galón', 0, 35.00, 'Gris', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg');

-- ============================================
-- PASO 5: REACTIVAR VERIFICACIÓN DE FOREIGN KEYS
-- ============================================
SET FOREIGN_KEY_CHECKS=1;

-- ============================================
-- PASO 6: VERIFICAR RESULTADOS
-- ============================================
SELECT 'Productos insertados correctamente:' as mensaje;
SELECT id, codigo_sku, descripcion FROM productos WHERE id >= 4 ORDER BY id;

-- ============================================
-- RESUMEN
-- ============================================
-- Productos eliminados: IDs 19-33
-- Productos re-insertados: IDs 4-18 (15 productos)
-- Auto_increment configurado: 19 (el siguiente producto será ID 19)
--
-- SIGUIENTE PASO:
-- Ahora puedes ejecutar el script datos_prueba_noviembre_2025.sql
-- PERO SOLO A PARTIR DE LA SECCIÓN:
-- "2. RELACIONAR PRODUCTOS CON PRESENTACIONES"
--
-- Es decir, ejecuta desde la línea que dice:
-- INSERT INTO productopresentacion (producto_id, presentacion_id, activo) VALUES
-- ============================================
