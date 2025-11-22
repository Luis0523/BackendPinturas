-- ============================================
-- DATOS DE PRUEBA PARA SISTEMA DE PINTURAS
-- Noviembre 2025
-- ============================================
-- Este script inserta datos de prueba para:
-- - Categorías y Marcas (si no existen)
-- - Presentaciones (si no existen)
-- - Productos variados
-- - Inventario en sucursales
-- - Precios
-- - Clientes
-- - Ventas (facturas) del 1 al 30 de noviembre 2025
-- ============================================
-- IMPORTANTE: Este script limpia datos de prueba previos
-- ============================================

USE pinturas;

-- ============================================
-- -1. VERIFICAR ESTADO ACTUAL DE LA BASE DE DATOS
-- ============================================
-- Antes de ejecutar este script, verifica tus datos actuales:
--
-- SELECT MAX(id) as ultimo_producto FROM productos;
-- SELECT MAX(id) as ultimo_cliente FROM clientes;
-- SELECT MAX(id) as ultimo_factura FROM facturas;
--
-- Si ya tienes productos, este script los insertará con IDs mayores
-- ASEGÚRATE DE AJUSTAR LOS IDs EN LAS SECCIONES SIGUIENTES

-- ============================================
-- -2. LIMPIAR DATOS DE PRUEBA PREVIOS (OPCIONAL)
-- ============================================
-- Descomenta estas líneas si quieres limpiar datos anteriores
-- ADVERTENCIA: Esto eliminará TODOS los datos de ventas, inventario y productos

-- SET FOREIGN_KEY_CHECKS=0;
-- DELETE FROM pagos WHERE factura_id IN (SELECT id FROM facturas WHERE numero >= 1001 AND numero <= 1062);
-- DELETE FROM detallefactura WHERE factura_id IN (SELECT id FROM facturas WHERE numero >= 1001 AND numero <= 1062);
-- DELETE FROM facturas WHERE numero >= 1001 AND numero <= 1062;
-- DELETE FROM precios WHERE producto_presentacion_id IN (SELECT id FROM productopresentacion WHERE producto_id >= 4);
-- DELETE FROM inventariosucursal WHERE producto_presentacion_id IN (SELECT id FROM productopresentacion WHERE producto_id >= 4);
-- DELETE FROM productopresentacion WHERE producto_id >= 4;
-- DELETE FROM productos WHERE id >= 4;
-- DELETE FROM clientes WHERE id >= 2;
-- SET FOREIGN_KEY_CHECKS=1;

-- ============================================
-- 0. INSERTAR CATEGORÍAS (si no existen)
-- ============================================
INSERT IGNORE INTO categorias (id, nombre, descripcion) VALUES
(1, 'Pinturas de Interior', 'Pinturas para uso interior'),
(2, 'Pinturas de Aceite', 'Esmaltes y pinturas de aceite'),
(3, 'Pinturas de Exterior', 'Pinturas para uso exterior'),
(4, 'Barnices y Selladores', 'Productos de protección'),
(5, 'Primers e Imprimantes', 'Bases y anticorrosivos');

-- ============================================
-- 0.2 INSERTAR MARCAS (si no existen)
-- ============================================
INSERT IGNORE INTO marcas (id, nombre, activa) VALUES
(1, 'Sherwin Williams', 1),
(2, 'Berel', 1),
(3, 'Comex', 1);

-- ============================================
-- 0.3 INSERTAR PRESENTACIONES (si no existen)
-- ============================================
INSERT IGNORE INTO presentaciones (id, nombre, unidad_base, factor_galon, activo) VALUES
(1, '1 Galón', 'galones', 1.00000, 1),
(2, '1/2 Galón', 'galones', 0.50000, 1),
(3, '1/4 Galón', 'galones', 0.25000, 1),
(4, 'Cubeta 5 Gal', 'galones', 5.00000, 1);

-- ============================================
-- 1. INSERTAR PRODUCTOS
-- ============================================
-- IMPORTANTE: Los productos se insertarán con IDs auto-incrementados
-- Si ya tienes productos (ej: IDs 1,2,3), los nuevos serán 4,5,6...
-- Este script ASUME que los nuevos productos tendrán IDs 4-18
-- Si tus IDs son diferentes, DEBES ajustar las secciones posteriores
-- ============================================

INSERT INTO productos (categoria_id, marca_id, codigo_sku, descripcion, tamano, duracion_anios, extension_m2, color, activo, imagen_url) VALUES
-- Pinturas Látex
(1, 1, 'PINT-LAT-BL-01', 'Pintura Látex Blanco Mate', '1 Galón', 5, 35.00, 'Blanco', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(1, 1, 'PINT-LAT-BG-01', 'Pintura Látex Beige', '1 Galón', 5, 35.00, 'Beige', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(1, 2, 'PINT-LAT-GR-01', 'Pintura Látex Gris Claro', '1 Galón', 5, 35.00, 'Gris Claro', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(1, 2, 'PINT-LAT-AZ-01', 'Pintura Látex Azul Cielo', '1 Galón', 5, 35.00, 'Azul Cielo', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(1, 3, 'PINT-LAT-VD-01', 'Pintura Látex Verde Menta', '1 Galón', 5, 35.00, 'Verde Menta', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),

-- Pinturas de Aceite
(2, 1, 'PINT-ACE-BL-01', 'Esmalte Aceite Blanco Brillante', '1 Galón', 8, 25.00, 'Blanco', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(2, 2, 'PINT-ACE-NG-01', 'Esmalte Aceite Negro Mate', '1 Galón', 8, 25.00, 'Negro', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(2, 3, 'PINT-ACE-RJ-01', 'Esmalte Aceite Rojo Ferrari', '1 Galón', 8, 25.00, 'Rojo', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),

-- Pinturas Exteriores
(3, 1, 'PINT-EXT-BL-01', 'Pintura Exterior Blanco', 'Cubeta 5 Gal', 10, 150.00, 'Blanco', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(3, 2, 'PINT-EXT-CR-01', 'Pintura Exterior Crema', 'Cubeta 5 Gal', 10, 150.00, 'Crema', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(3, 3, 'PINT-EXT-GR-01', 'Pintura Exterior Gris Piedra', 'Cubeta 5 Gal', 10, 150.00, 'Gris Piedra', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),

-- Barnices y Selladores
(4, 1, 'BARN-MAD-NAT-01', 'Barniz para Madera Natural', '1 Galón', 3, 30.00, 'Natural', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(4, 2, 'SELL-PIS-TRP-01', 'Sellador para Pisos Transparente', '1 Galón', 5, 40.00, 'Transparente', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),

-- Primers e Imprimantes
(5, 1, 'PRIM-PAR-BL-01', 'Primer para Paredes Blanco', '1 Galón', 0, 45.00, 'Blanco', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(5, 2, 'PRIM-MET-GR-01', 'Anticorrosivo para Metal Gris', '1 Galón', 0, 35.00, 'Gris', 1, 'https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg');

-- ============================================
-- 2. RELACIONAR PRODUCTOS CON PRESENTACIONES
-- ============================================
-- Asumiendo presentaciones: 1=1 Galón, 2=1/2 Galón, 3=1/4 Galón, 4=Cubeta 5 Gal

-- Productos en 1 Galón (IDs 4-18, excepto los de cubeta)
INSERT INTO productopresentacion (producto_id, presentacion_id, activo) VALUES
-- Látex (1 Galón y fracciones)
(4, 1, 1), (4, 2, 1), (4, 3, 1),  -- Látex Blanco
(5, 1, 1), (5, 2, 1),              -- Látex Beige
(6, 1, 1), (6, 2, 1),              -- Látex Gris
(7, 1, 1), (7, 2, 1),              -- Látex Azul
(8, 1, 1), (8, 2, 1),              -- Látex Verde

-- Aceite (1 Galón y fracciones)
(9, 1, 1), (9, 2, 1), (9, 3, 1),   -- Aceite Blanco
(10, 1, 1), (10, 2, 1),            -- Aceite Negro
(11, 1, 1), (11, 2, 1),            -- Aceite Rojo

-- Exteriores (Cubeta 5 Gal)
(12, 4, 1),  -- Exterior Blanco
(13, 4, 1),  -- Exterior Crema
(14, 4, 1),  -- Exterior Gris

-- Barnices (1 Galón y fracciones)
(15, 1, 1), (15, 2, 1), (15, 3, 1),  -- Barniz Natural
(16, 1, 1), (16, 2, 1),              -- Sellador Piso

-- Primers (1 Galón)
(17, 1, 1), (17, 2, 1),  -- Primer Blanco
(18, 1, 1), (18, 2, 1);  -- Anticorrosivo

-- ============================================
-- 3. INSERTAR INVENTARIO EN SUCURSALES
-- ============================================
-- Asumiendo sucursales: 1=Sucursal Central, 2=Sucursal Norte

-- Inventario Sucursal 1 (Central)
INSERT INTO inventariosucursal (sucursal_id, producto_presentacion_id, existencia) VALUES
-- Látex Blanco (1 Gal, 1/2 Gal, 1/4 Gal)
(1, 1, 150), (1, 2, 80), (1, 3, 50),
-- Látex Beige
(1, 4, 100), (1, 5, 60),
-- Látex Gris
(1, 6, 90), (1, 7, 45),
-- Látex Azul
(1, 8, 70), (1, 9, 35),
-- Látex Verde
(1, 10, 60), (1, 11, 30),
-- Aceite Blanco
(1, 12, 80), (1, 13, 40), (1, 14, 25),
-- Aceite Negro
(1, 15, 50), (1, 16, 25),
-- Aceite Rojo
(1, 17, 45), (1, 18, 20),
-- Exteriores
(1, 19, 40), (1, 20, 35), (1, 21, 30),
-- Barniz
(1, 22, 55), (1, 23, 28), (1, 24, 15),
-- Sellador
(1, 25, 65), (1, 26, 32),
-- Primers
(1, 27, 75), (1, 28, 38),
(1, 29, 60), (1, 30, 30);

-- Inventario Sucursal 2 (Norte)
INSERT INTO inventariosucursal (sucursal_id, producto_presentacion_id, existencia) VALUES
-- Látex Blanco
(2, 1, 120), (2, 2, 65), (2, 3, 40),
-- Látex Beige
(2, 4, 85), (2, 5, 50),
-- Látex Gris
(2, 6, 75), (2, 7, 38),
-- Látex Azul
(2, 8, 60), (2, 9, 30),
-- Látex Verde
(2, 10, 50), (2, 11, 25),
-- Aceite Blanco
(2, 12, 65), (2, 13, 32), (2, 14, 20),
-- Aceite Negro
(2, 15, 40), (2, 16, 20),
-- Aceite Rojo
(2, 17, 38), (2, 18, 18),
-- Exteriores
(2, 19, 32), (2, 20, 28), (2, 21, 25),
-- Barniz
(2, 22, 45), (2, 23, 22), (2, 24, 12),
-- Sellador
(2, 25, 55), (2, 26, 28),
-- Primers
(2, 27, 62), (2, 28, 31),
(2, 29, 50), (2, 30, 25);

-- ============================================
-- 4. INSERTAR PRECIOS
-- ============================================
-- Precios por producto-presentación y sucursal

INSERT INTO precios (producto_presentacion_id, sucursal_id, precio_venta, descuento_pct, vigente_desde, activo, stock_minimo) VALUES
-- Látex Blanco (1 Gal: Q185, 1/2 Gal: Q95, 1/4 Gal: Q50)
(1, 1, 185.00, 0, '2025-11-01', 1, 20), (1, 2, 185.00, 0, '2025-11-01', 1, 15),
(2, 1, 95.00, 0, '2025-11-01', 1, 10), (2, 2, 95.00, 0, '2025-11-01', 1, 8),
(3, 1, 50.00, 0, '2025-11-01', 1, 5), (3, 2, 50.00, 0, '2025-11-01', 1, 5),

-- Látex Beige (1 Gal: Q190, 1/2 Gal: Q98)
(4, 1, 190.00, 0, '2025-11-01', 1, 15), (4, 2, 190.00, 0, '2025-11-01', 1, 12),
(5, 1, 98.00, 0, '2025-11-01', 1, 8), (5, 2, 98.00, 0, '2025-11-01', 1, 6),

-- Látex Gris (1 Gal: Q195, 1/2 Gal: Q100)
(6, 1, 195.00, 0, '2025-11-01', 1, 12), (6, 2, 195.00, 0, '2025-11-01', 1, 10),
(7, 1, 100.00, 0, '2025-11-01', 1, 6), (7, 2, 100.00, 0, '2025-11-01', 1, 5),

-- Látex Azul (1 Gal: Q200, 1/2 Gal: Q105)
(8, 1, 200.00, 0, '2025-11-01', 1, 10), (8, 2, 200.00, 0, '2025-11-01', 1, 8),
(9, 1, 105.00, 0, '2025-11-01', 1, 5), (9, 2, 105.00, 0, '2025-11-01', 1, 4),

-- Látex Verde (1 Gal: Q205, 1/2 Gal: Q108)
(10, 1, 205.00, 0, '2025-11-01', 1, 10), (10, 2, 205.00, 0, '2025-11-01', 1, 8),
(11, 1, 108.00, 0, '2025-11-01', 1, 5), (11, 2, 108.00, 0, '2025-11-01', 1, 4),

-- Aceite Blanco (1 Gal: Q265, 1/2 Gal: Q138, 1/4 Gal: Q72)
(12, 1, 265.00, 0, '2025-11-01', 1, 12), (12, 2, 265.00, 0, '2025-11-01', 1, 10),
(13, 1, 138.00, 0, '2025-11-01', 1, 6), (13, 2, 138.00, 0, '2025-11-01', 1, 5),
(14, 1, 72.00, 0, '2025-11-01', 1, 4), (14, 2, 72.00, 0, '2025-11-01', 1, 3),

-- Aceite Negro (1 Gal: Q275, 1/2 Gal: Q143)
(15, 1, 275.00, 0, '2025-11-01', 1, 8), (15, 2, 275.00, 0, '2025-11-01', 1, 6),
(16, 1, 143.00, 0, '2025-11-01', 1, 4), (16, 2, 143.00, 0, '2025-11-01', 1, 3),

-- Aceite Rojo (1 Gal: Q285, 1/2 Gal: Q148)
(17, 1, 285.00, 0, '2025-11-01', 1, 8), (17, 2, 285.00, 0, '2025-11-01', 1, 6),
(18, 1, 148.00, 0, '2025-11-01', 1, 4), (18, 2, 148.00, 0, '2025-11-01', 1, 3),

-- Exteriores (Cubeta 5 Gal: Q825)
(19, 1, 825.00, 0, '2025-11-01', 1, 5), (19, 2, 825.00, 0, '2025-11-01', 1, 4),
(20, 1, 850.00, 0, '2025-11-01', 1, 5), (20, 2, 850.00, 0, '2025-11-01', 1, 4),
(21, 1, 875.00, 0, '2025-11-01', 1, 5), (21, 2, 875.00, 0, '2025-11-01', 1, 4),

-- Barniz (1 Gal: Q225, 1/2 Gal: Q118, 1/4 Gal: Q62)
(22, 1, 225.00, 0, '2025-11-01', 1, 8), (22, 2, 225.00, 0, '2025-11-01', 1, 6),
(23, 1, 118.00, 0, '2025-11-01', 1, 4), (23, 2, 118.00, 0, '2025-11-01', 1, 3),
(24, 1, 62.00, 0, '2025-11-01', 1, 2), (24, 2, 62.00, 0, '2025-11-01', 1, 2),

-- Sellador (1 Gal: Q245, 1/2 Gal: Q128)
(25, 1, 245.00, 0, '2025-11-01', 1, 10), (25, 2, 245.00, 0, '2025-11-01', 1, 8),
(26, 1, 128.00, 0, '2025-11-01', 1, 5), (26, 2, 128.00, 0, '2025-11-01', 1, 4),

-- Primers (1 Gal: Q165, 1/2 Gal: Q88)
(27, 1, 165.00, 0, '2025-11-01', 1, 12), (27, 2, 165.00, 0, '2025-11-01', 1, 10),
(28, 1, 88.00, 0, '2025-11-01', 1, 6), (28, 2, 88.00, 0, '2025-11-01', 1, 5),
(29, 1, 175.00, 0, '2025-11-01', 1, 10), (29, 2, 175.00, 0, '2025-11-01', 1, 8),
(30, 1, 92.00, 0, '2025-11-01', 1, 5), (30, 2, 92.00, 0, '2025-11-01', 1, 4);

-- ============================================
-- 5. INSERTAR CLIENTES
-- ============================================
-- Los clientes se insertarán con IDs del 1 al 11
-- IMPORTANTE: Antes de ejecutar esto, asegúrate de haber ejecutado limpiar_todo_forzado.sql
-- que hace TRUNCATE de la tabla clientes para que los IDs empiecen en 1

INSERT INTO clientes (nombre, nit, email, telefono, direccion, opt_in_promos, verificado, creado_en) VALUES
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
('CONSUMIDOR FINAL', 'CF', NULL, NULL, NULL, 0, 1, '2025-01-01 00:00:00');

-- ============================================
-- 6. INSERTAR VENTAS (FACTURAS) - NOVIEMBRE 2025
-- ============================================
-- Distribuyendo ventas a lo largo del mes
-- Asumiendo usuario_id=1 para el vendedor

-- Semana 1 (1-7 Nov)
INSERT INTO facturas (numero, serie, fecha_emision, cliente_id, usuario_id, sucursal_id, subtotal, descuento_total, total, estado) VALUES
-- Día 1 Nov
(1001, 'A', '2025-11-01 09:30:00', 1, 1, 1, 555.00, 0, 555.00, 'EMITIDA'),
(1002, 'A', '2025-11-01 14:20:00', 11, 1, 1, 185.00, 0, 185.00, 'EMITIDA'),
(1003, 'A', '2025-11-01 16:45:00', 2, 1, 1, 825.00, 0, 825.00, 'EMITIDA'),

-- Día 2 Nov
(1004, 'A', '2025-11-02 10:15:00', 3, 1, 1, 370.00, 0, 370.00, 'EMITIDA'),
(1005, 'A', '2025-11-02 15:30:00', 11, 1, 1, 450.00, 0, 450.00, 'EMITIDA'),

-- Día 3 Nov
(1006, 'A', '2025-11-03 11:00:00', 4, 1, 2, 600.00, 0, 600.00, 'EMITIDA'),
(1007, 'A', '2025-11-03 16:20:00', 5, 1, 2, 285.00, 0, 285.00, 'EMITIDA'),

-- Día 4 Nov
(1008, 'A', '2025-11-04 09:45:00', 11, 1, 1, 195.00, 0, 195.00, 'EMITIDA'),
(1009, 'A', '2025-11-04 13:30:00', 6, 1, 1, 1650.00, 0, 1650.00, 'EMITIDA'),
(1010, 'A', '2025-11-04 17:00:00', 11, 1, 1, 100.00, 0, 100.00, 'EMITIDA'),

-- Día 5 Nov
(1011, 'A', '2025-11-05 10:30:00', 7, 1, 1, 530.00, 0, 530.00, 'EMITIDA'),
(1012, 'A', '2025-11-05 14:45:00', 11, 1, 1, 225.00, 0, 225.00, 'EMITIDA'),

-- Día 6 Nov
(1013, 'A', '2025-11-06 11:15:00', 8, 1, 2, 570.00, 0, 570.00, 'EMITIDA'),
(1014, 'A', '2025-11-06 15:20:00', 11, 1, 2, 380.00, 0, 380.00, 'EMITIDA'),

-- Día 7 Nov
(1015, 'A', '2025-11-07 09:00:00', 9, 1, 1, 850.00, 0, 850.00, 'EMITIDA'),
(1016, 'A', '2025-11-07 16:30:00', 11, 1, 1, 265.00, 0, 265.00, 'EMITIDA'),

-- Semana 2 (8-14 Nov)
(1017, 'A', '2025-11-08 10:00:00', 10, 1, 1, 410.00, 0, 410.00, 'EMITIDA'),
(1018, 'A', '2025-11-08 14:30:00', 11, 1, 1, 185.00, 0, 185.00, 'EMITIDA'),

(1019, 'A', '2025-11-09 11:20:00', 1, 1, 2, 950.00, 0, 950.00, 'EMITIDA'),
(1020, 'A', '2025-11-09 15:45:00', 11, 1, 2, 190.00, 0, 190.00, 'EMITIDA'),

(1021, 'A', '2025-11-10 09:30:00', 2, 1, 1, 825.00, 0, 825.00, 'EMITIDA'),
(1022, 'A', '2025-11-10 13:15:00', 11, 1, 1, 343.00, 0, 343.00, 'EMITIDA'),

(1023, 'A', '2025-11-11 10:45:00', 3, 1, 1, 590.00, 0, 590.00, 'EMITIDA'),
(1024, 'A', '2025-11-11 16:00:00', 11, 1, 1, 200.00, 0, 200.00, 'EMITIDA'),

(1025, 'A', '2025-11-12 11:30:00', 4, 1, 2, 725.00, 0, 725.00, 'EMITIDA'),
(1026, 'A', '2025-11-12 15:00:00', 11, 1, 2, 245.00, 0, 245.00, 'EMITIDA'),

(1027, 'A', '2025-11-13 09:15:00', 5, 1, 1, 875.00, 0, 875.00, 'EMITIDA'),
(1028, 'A', '2025-11-13 14:20:00', 11, 1, 1, 118.00, 0, 118.00, 'EMITIDA'),

(1029, 'A', '2025-11-14 10:00:00', 6, 1, 1, 640.00, 0, 640.00, 'EMITIDA'),
(1030, 'A', '2025-11-14 17:15:00', 11, 1, 1, 175.00, 0, 175.00, 'EMITIDA'),

-- Semana 3 (15-21 Nov)
(1031, 'A', '2025-11-15 11:00:00', 7, 1, 2, 470.00, 0, 470.00, 'EMITIDA'),
(1032, 'A', '2025-11-15 15:30:00', 11, 1, 2, 265.00, 0, 265.00, 'EMITIDA'),

(1033, 'A', '2025-11-16 09:45:00', 8, 1, 1, 825.00, 0, 825.00, 'EMITIDA'),
(1034, 'A', '2025-11-16 14:00:00', 11, 1, 1, 205.00, 0, 205.00, 'EMITIDA'),

(1035, 'A', '2025-11-17 10:30:00', 9, 1, 1, 550.00, 0, 550.00, 'EMITIDA'),
(1036, 'A', '2025-11-17 16:15:00', 11, 1, 1, 285.00, 0, 285.00, 'EMITIDA'),

(1037, 'A', '2025-11-18 11:20:00', 10, 1, 2, 680.00, 0, 680.00, 'EMITIDA'),
(1038, 'A', '2025-11-18 15:45:00', 11, 1, 2, 190.00, 0, 190.00, 'EMITIDA'),

(1039, 'A', '2025-11-19 09:00:00', 1, 1, 1, 750.00, 0, 750.00, 'EMITIDA'),
(1040, 'A', '2025-11-19 13:30:00', 11, 1, 1, 225.00, 0, 225.00, 'EMITIDA'),

(1041, 'A', '2025-11-20 10:15:00', 2, 1, 1, 850.00, 0, 850.00, 'EMITIDA'),
(1042, 'A', '2025-11-20 14:45:00', 11, 1, 1, 165.00, 0, 165.00, 'EMITIDA'),

(1043, 'A', '2025-11-21 11:00:00', 3, 1, 2, 520.00, 0, 520.00, 'EMITIDA'),
(1044, 'A', '2025-11-21 16:30:00', 11, 1, 2, 275.00, 0, 275.00, 'EMITIDA'),

-- Semana 4 (22-28 Nov)
(1045, 'A', '2025-11-22 09:30:00', 4, 1, 1, 610.00, 0, 610.00, 'EMITIDA'),
(1046, 'A', '2025-11-22 15:00:00', 11, 1, 1, 245.00, 0, 245.00, 'EMITIDA'),

(1047, 'A', '2025-11-23 10:45:00', 5, 1, 1, 825.00, 0, 825.00, 'EMITIDA'),
(1048, 'A', '2025-11-23 14:30:00', 11, 1, 1, 100.00, 0, 100.00, 'EMITIDA'),

(1049, 'A', '2025-11-24 11:15:00', 6, 1, 2, 700.00, 0, 700.00, 'EMITIDA'),
(1050, 'A', '2025-11-24 16:00:00', 11, 1, 2, 185.00, 0, 185.00, 'EMITIDA'),

(1051, 'A', '2025-11-25 09:00:00', 7, 1, 1, 875.00, 0, 875.00, 'EMITIDA'),
(1052, 'A', '2025-11-25 13:45:00', 11, 1, 1, 195.00, 0, 195.00, 'EMITIDA'),

(1053, 'A', '2025-11-26 10:30:00', 8, 1, 1, 530.00, 0, 530.00, 'EMITIDA'),
(1054, 'A', '2025-11-26 15:20:00', 11, 1, 1, 265.00, 0, 265.00, 'EMITIDA'),

(1055, 'A', '2025-11-27 11:00:00', 9, 1, 2, 660.00, 0, 660.00, 'EMITIDA'),
(1056, 'A', '2025-11-27 16:45:00', 11, 1, 2, 200.00, 0, 200.00, 'EMITIDA'),

(1057, 'A', '2025-11-28 09:15:00', 10, 1, 1, 825.00, 0, 825.00, 'EMITIDA'),
(1058, 'A', '2025-11-28 14:00:00', 11, 1, 1, 175.00, 0, 175.00, 'EMITIDA'),

-- Últimos días (29-30 Nov)
(1059, 'A', '2025-11-29 10:00:00', 1, 1, 1, 750.00, 0, 750.00, 'EMITIDA'),
(1060, 'A', '2025-11-29 15:30:00', 11, 1, 1, 225.00, 0, 225.00, 'EMITIDA'),

(1061, 'A', '2025-11-30 11:30:00', 2, 1, 2, 850.00, 0, 850.00, 'EMITIDA'),
(1062, 'A', '2025-11-30 16:00:00', 11, 1, 2, 190.00, 0, 190.00, 'EMITIDA');

-- ============================================
-- 7. INSERTAR DETALLES DE FACTURAS
-- ============================================

-- Factura 1001 (3 Látex Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(1, 1, 3, 185.00, 0, 555.00);

-- Factura 1002 (1 Látex Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(2, 1, 1, 185.00, 0, 185.00);

-- Factura 1003 (1 Exterior Blanco Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(3, 19, 1, 825.00, 0, 825.00);

-- Factura 1004 (2 Látex Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(4, 1, 2, 185.00, 0, 370.00);

-- Factura 1005 (1 Látex Gris 1 Gal, 1 Látex Azul 1 Gal, 1 Látex Verde 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(5, 6, 1, 195.00, 0, 195.00),
(5, 8, 1, 200.00, 0, 200.00),
(5, 11, 1, 108.00, 0, 108.00);

-- Factura 1006 (2 Látex Beige 1 Gal, 1 Barniz 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(6, 4, 2, 190.00, 0, 380.00),
(6, 22, 1, 225.00, 0, 225.00);

-- Factura 1007 (1 Aceite Rojo 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(7, 17, 1, 285.00, 0, 285.00);

-- Factura 1008 (1 Látex Gris 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(8, 6, 1, 195.00, 0, 195.00);

-- Factura 1009 (2 Exterior Blanco Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(9, 19, 2, 825.00, 0, 1650.00);

-- Factura 1010 (1 Látex Gris 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(10, 7, 1, 100.00, 0, 100.00);

-- Factura 1011 (1 Aceite Blanco 1 Gal, 1 Aceite Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(11, 12, 2, 265.00, 0, 530.00);

-- Factura 1012 (1 Barniz 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(12, 22, 1, 225.00, 0, 225.00);

-- Factura 1013 (3 Látex Beige 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(13, 4, 3, 190.00, 0, 570.00);

-- Factura 1014 (2 Látex Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(14, 1, 2, 185.00, 0, 370.00),
(14, 3, 1, 50.00, 0, 50.00);

-- Factura 1015 (1 Exterior Crema Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(15, 20, 1, 850.00, 0, 850.00);

-- Factura 1016 (1 Aceite Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(16, 12, 1, 265.00, 0, 265.00);

-- Factura 1017 (1 Látex Azul 1 Gal, 1 Látex Verde 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(17, 8, 1, 200.00, 0, 200.00),
(17, 10, 1, 205.00, 0, 205.00);

-- Factura 1018 (1 Látex Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(18, 1, 1, 185.00, 0, 185.00);

-- Factura 1019 (2 Sellador 1 Gal, 2 Primer Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(19, 25, 2, 245.00, 0, 490.00),
(19, 27, 2, 165.00, 0, 330.00);

-- Factura 1020 (1 Látex Beige 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(20, 4, 1, 190.00, 0, 190.00);

-- Factura 1021 (1 Exterior Blanco Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(21, 19, 1, 825.00, 0, 825.00);

-- Factura 1022 (1 Látex Gris 1/2 Gal, 1 Látex Blanco 1/4 Gal, 1 Látex Beige 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(22, 7, 1, 100.00, 0, 100.00),
(22, 3, 1, 50.00, 0, 50.00),
(22, 5, 2, 98.00, 0, 196.00);

-- Factura 1023 (3 Látex Gris 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(23, 6, 3, 195.00, 0, 585.00);

-- Factura 1024 (1 Látex Azul 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(24, 8, 1, 200.00, 0, 200.00);

-- Factura 1025 (1 Exterior Gris Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(25, 21, 1, 875.00, 0, 875.00);

-- Factura 1026 (1 Sellador 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(26, 25, 1, 245.00, 0, 245.00);

-- Factura 1027 (1 Exterior Gris Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(27, 21, 1, 875.00, 0, 875.00);

-- Factura 1028 (1 Barniz 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(28, 23, 1, 118.00, 0, 118.00);

-- Factura 1029 (2 Aceite Negro 1 Gal, 1 Látex Verde 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(29, 15, 2, 275.00, 0, 550.00),
(29, 11, 1, 108.00, 0, 108.00);

-- Factura 1030 (1 Anticorrosivo 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(30, 29, 1, 175.00, 0, 175.00);

-- Factura 1031 (2 Látex Blanco 1 Gal, 1 Látex Blanco 1/4 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(31, 1, 2, 185.00, 0, 370.00),
(31, 3, 2, 50.00, 0, 100.00);

-- Factura 1032 (1 Aceite Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(32, 12, 1, 265.00, 0, 265.00);

-- Factura 1033 (1 Exterior Blanco Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(33, 19, 1, 825.00, 0, 825.00);

-- Factura 1034 (1 Látex Verde 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(34, 10, 1, 205.00, 0, 205.00);

-- Factura 1035 (2 Aceite Blanco 1 Gal, 1 Látex Gris 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(35, 12, 2, 265.00, 0, 530.00);

-- Factura 1036 (1 Aceite Rojo 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(36, 17, 1, 285.00, 0, 285.00);

-- Factura 1037 (1 Exterior Crema, 1 Látex Azul 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(37, 20, 1, 850.00, 0, 850.00);

-- Factura 1038 (1 Látex Beige 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(38, 4, 1, 190.00, 0, 190.00);

-- Factura 1039 (3 Sellador 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(39, 25, 3, 245.00, 0, 735.00);

-- Factura 1040 (1 Barniz 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(40, 22, 1, 225.00, 0, 225.00);

-- Factura 1041 (1 Exterior Crema Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(41, 20, 1, 850.00, 0, 850.00);

-- Factura 1042 (1 Primer Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(42, 27, 1, 165.00, 0, 165.00);

-- Factura 1043 (2 Látex Azul 1 Gal, 1 Látex Gris 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(43, 8, 2, 200.00, 0, 400.00),
(43, 7, 1, 100.00, 0, 100.00);

-- Factura 1044 (1 Aceite Negro 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(44, 15, 1, 275.00, 0, 275.00);

-- Factura 1045 (3 Látex Blanco 1 Gal, 1 Látex Beige 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(45, 1, 3, 185.00, 0, 555.00),
(45, 5, 1, 98.00, 0, 98.00);

-- Factura 1046 (1 Sellador 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(46, 25, 1, 245.00, 0, 245.00);

-- Factura 1047 (1 Exterior Blanco Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(47, 19, 1, 825.00, 0, 825.00);

-- Factura 1048 (1 Látex Gris 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(48, 7, 1, 100.00, 0, 100.00);

-- Factura 1049 (2 Anticorrosivo 1 Gal, 2 Primer Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(49, 29, 2, 175.00, 0, 350.00),
(49, 27, 2, 165.00, 0, 330.00);

-- Factura 1050 (1 Látex Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(50, 1, 1, 185.00, 0, 185.00);

-- Factura 1051 (1 Exterior Gris Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(51, 21, 1, 875.00, 0, 875.00);

-- Factura 1052 (1 Látex Gris 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(52, 6, 1, 195.00, 0, 195.00);

-- Factura 1053 (2 Aceite Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(53, 12, 2, 265.00, 0, 530.00);

-- Factura 1054 (1 Aceite Blanco 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(54, 12, 1, 265.00, 0, 265.00);

-- Factura 1055 (2 Látex Verde 1 Gal, 1 Sellador 1/2 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(55, 10, 2, 205.00, 0, 410.00),
(55, 26, 2, 128.00, 0, 256.00);

-- Factura 1056 (1 Látex Azul 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(56, 8, 1, 200.00, 0, 200.00);

-- Factura 1057 (1 Exterior Blanco Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(57, 19, 1, 825.00, 0, 825.00);

-- Factura 1058 (1 Anticorrosivo 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(58, 29, 1, 175.00, 0, 175.00);

-- Factura 1059 (3 Sellador 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(59, 25, 3, 245.00, 0, 735.00);

-- Factura 1060 (1 Barniz 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(60, 22, 1, 225.00, 0, 225.00);

-- Factura 1061 (1 Exterior Crema Cubeta)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(61, 20, 1, 850.00, 0, 850.00);

-- Factura 1062 (1 Látex Beige 1 Gal)
INSERT INTO detallefactura (factura_id, producto_presentacion_id, cantidad, precio_unitario, descuento_pct_aplicado, subtotal) VALUES
(62, 4, 1, 190.00, 0, 190.00);

-- ============================================
-- 8. INSERTAR PAGOS
-- ============================================
-- Asumiendo tipos de pago: 1=EFECTIVO, 2=TARJETA_DEBITO, 3=TARJETA_CREDITO,
--                           4=CHEQUE, 5=TRANSFERENCIA, 6=DEPOSITO

-- Pagos variados (efectivo, tarjeta, mixtos)
INSERT INTO pagos (factura_id, tipo, monto, referencia) VALUES
-- Día 1 Nov
(1, 1, 555.00, NULL),
(2, 1, 185.00, NULL),
(3, 2, 825.00, 'VISA-1234'),

-- Día 2 Nov
(4, 1, 370.00, NULL),
(5, 3, 450.00, 'MC-5678'),

-- Día 3 Nov
(6, 1, 600.00, NULL),
(7, 1, 285.00, NULL),

-- Día 4 Nov
(8, 1, 195.00, NULL),
(9, 5, 1650.00, 'TRANSF-001'),
(10, 1, 100.00, NULL),

-- Día 5 Nov
(11, 2, 530.00, 'VISA-2345'),
(12, 1, 225.00, NULL),

-- Día 6 Nov
(13, 1, 570.00, NULL),
(14, 1, 380.00, NULL),

-- Día 7 Nov
(15, 3, 850.00, 'MC-6789'),
(16, 1, 265.00, NULL),

-- Día 8 Nov
(17, 1, 410.00, NULL),
(18, 1, 185.00, NULL),

-- Día 9 Nov
(19, 5, 950.00, 'TRANSF-002'),
(20, 1, 190.00, NULL),

-- Día 10 Nov
(21, 2, 825.00, 'VISA-3456'),
(22, 1, 343.00, NULL),

-- Día 11 Nov
(23, 1, 590.00, NULL),
(24, 1, 200.00, NULL),

-- Día 12 Nov
(25, 3, 725.00, 'MC-7890'),
(26, 1, 245.00, NULL),

-- Día 13 Nov
(27, 2, 875.00, 'VISA-4567'),
(28, 1, 118.00, NULL),

-- Día 14 Nov
(29, 1, 640.00, NULL),
(30, 1, 175.00, NULL),

-- Día 15 Nov
(31, 1, 470.00, NULL),
(32, 1, 265.00, NULL),

-- Día 16 Nov
(33, 5, 825.00, 'TRANSF-003'),
(34, 1, 205.00, NULL),

-- Día 17 Nov
(35, 1, 550.00, NULL),
(36, 1, 285.00, NULL),

-- Día 18 Nov
(37, 3, 680.00, 'MC-8901'),
(38, 1, 190.00, NULL),

-- Día 19 Nov
(39, 2, 750.00, 'VISA-5678'),
(40, 1, 225.00, NULL),

-- Día 20 Nov
(41, 3, 850.00, 'MC-9012'),
(42, 1, 165.00, NULL),

-- Día 21 Nov
(43, 1, 520.00, NULL),
(44, 1, 275.00, NULL),

-- Día 22 Nov
(45, 1, 610.00, NULL),
(46, 1, 245.00, NULL),

-- Día 23 Nov
(47, 5, 825.00, 'TRANSF-004'),
(48, 1, 100.00, NULL),

-- Día 24 Nov
(49, 2, 700.00, 'VISA-6789'),
(50, 1, 185.00, NULL),

-- Día 25 Nov
(51, 3, 875.00, 'MC-0123'),
(52, 1, 195.00, NULL),

-- Día 26 Nov
(53, 1, 530.00, NULL),
(54, 1, 265.00, NULL),

-- Día 27 Nov
(55, 2, 660.00, 'VISA-7890'),
(56, 1, 200.00, NULL),

-- Día 28 Nov
(57, 5, 825.00, 'TRANSF-005'),
(58, 1, 175.00, NULL),

-- Día 29 Nov
(59, 1, 750.00, NULL),
(60, 1, 225.00, NULL),

-- Día 30 Nov
(61, 3, 850.00, 'MC-1234'),
(62, 1, 190.00, NULL);

-- ============================================
-- DATOS INSERTADOS EXITOSAMENTE
-- ============================================
-- Total de categorías: 5
-- Total de marcas: 3
-- Total de presentaciones: 4
-- Total de productos: 15
-- Total de producto-presentaciones: 30
-- Total de inventario: 60 registros
-- Total de precios configurados: 60
-- Total de clientes: 11 (incluyendo CF)
-- Total de facturas: 62 (distribuidas en Nov 2025)
-- Total de detalles: ~90 items
-- Total de pagos: 62
-- ============================================

-- ============================================
-- NOTAS IMPORTANTES
-- ============================================
-- 1. Este script usa INSERT IGNORE para categorías, marcas y presentaciones
--    por lo que NO duplicará estos datos si ya existen
--
-- 2. Los productos se insertarán con IDs auto-incrementados
--    Si ya tienes productos en tu BD, los nuevos tendrán IDs mayores
--
-- 3. REQUISITOS PREVIOS:
--    - Debes tener sucursales con id=1 (Central) y id=2 (Norte)
--    - Debes tener un usuario con id=1 (vendedor)
--    - Si no tienes estas sucursales/usuarios, créalos primero o ajusta los IDs en el script
--
-- 4. Para limpiar datos previos, descomenta las líneas DELETE
--    en la sección -1 al inicio del script
--
-- 5. Todas las imágenes usan la misma URL de Firebase Storage
--
-- 6. Las fechas están en noviembre 2025 (1-30 Nov)
--
-- ============================================
