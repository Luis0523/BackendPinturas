CREATE DATABASE pinturas;
USE pinturas;
CREATE TABLE `Roles` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(30) UNIQUE NOT NULL
);

CREATE TABLE `Sucursales` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(120) UNIQUE NOT NULL,
  `direccion` varchar(255),
  `gps_lat` decimal(10,6),
  `gps_lng` decimal(10,6),
  `telefono` varchar(30),
  `activa` bool DEFAULT true
);

CREATE TABLE `Usuarios` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `dpi` varchar(20) UNIQUE NOT NULL,
  `email` varchar(150) UNIQUE NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol_id` int NOT NULL,
  `sucursal_id` int,
  `activo` bool DEFAULT true,
  `creado_en` datetime DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `Clientes` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `nit` varchar(25) UNIQUE,
  `email` varchar(150) UNIQUE,
  `password_hash` varchar(255),
  `opt_in_promos` bool DEFAULT false,
  `verificado` bool DEFAULT false,
  `telefono` varchar(30),
  `direccion` varchar(255),
  `gps_lat` decimal(10,6),
  `gps_lng` decimal(10,6),
  `creado_en` datetime DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `Categorias` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(60) UNIQUE NOT NULL,
  `descripcion` varchar(255)
);

CREATE TABLE `Marcas` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(80) UNIQUE NOT NULL,
  `activa` bool DEFAULT true
);

CREATE TABLE `Productos` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `categoria_id` int NOT NULL,
  `marca_id` int,
  `codigo_sku` varchar(50) UNIQUE,
  `descripcion` varchar(255) NOT NULL,
  `tamano` varchar(40),
  `duracion_anios` int,
  `extension_m2` decimal(10,2),
  `color` varchar(60),
  `activo` bool DEFAULT true,
  `creado_en` datetime DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `Presentaciones` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(40) UNIQUE NOT NULL,
  `unidad_base` varchar(20),
  `factor_galon` decimal(10,5),
  `activo` bool DEFAULT true
);

CREATE TABLE `ProductoPresentacion` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `presentacion_id` int NOT NULL,
  `activo` bool DEFAULT true
);

CREATE TABLE `Precios` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `producto_presentacion_id` int NOT NULL,
  `sucursal_id` int,
  `precio_venta` decimal(12,2) NOT NULL,
  `descuento_pct` decimal(5,2) DEFAULT 0,
  `vigente_desde` datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `vigente_hasta` datetime,
  `activo` bool DEFAULT true
);

CREATE TABLE `InventarioSucursal` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `sucursal_id` int NOT NULL,
  `producto_presentacion_id` int NOT NULL,
  `existencia` int NOT NULL DEFAULT 0,
  `minimo` int DEFAULT 0
);

CREATE TABLE `MovimientosInventario` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `sucursal_id` int NOT NULL,
  `producto_presentacion_id` int NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `cantidad` int NOT NULL,
  `referencia` varchar(60),
  `created_at` datetime DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `Facturas` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `numero` int NOT NULL,
  `serie` varchar(10) NOT NULL,
  `fecha_emision` datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `cliente_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `sucursal_id` int NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0,
  `total` decimal(12,2) NOT NULL DEFAULT 0,
  `estado` ENUM ('EMITIDA', 'ANULADA') NOT NULL DEFAULT 'EMITIDA',
  `anulada_por` int,
  `anulada_fecha` datetime,
  `motivo_anulacion` varchar(255)
);

CREATE TABLE `DetalleFactura` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `factura_id` int NOT NULL,
  `producto_presentacion_id` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento_pct_aplicado` decimal(5,2) DEFAULT 0,
  `subtotal` decimal(12,2) NOT NULL
);

CREATE TABLE `MediosPago` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `efectivo` decimal(12,2) NOT NULL DEFAULT 0,
  `tarjeta` decimal(12,2) NOT NULL DEFAULT 0,
  `cheque` decimal(12,2) NOT NULL DEFAULT 0,
  `transferencia` decimal(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE `Pagos` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `factura_id` int NOT NULL,
  `tipo` int NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `referencia` varchar(80),
  `entidad` varchar(80),
  `transaccion_gateway_id` varchar(80),
  `autorizado_por` varchar(120),
  `created_at` datetime DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `Cotizaciones` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `numero` int NOT NULL,
  `serie` varchar(10) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `cliente_id` int,
  `usuario_id` int NOT NULL,
  `sucursal_id` int NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0,
  `total` decimal(12,2) NOT NULL DEFAULT 0,
  `vigente_hasta` datetime,
  `estado` varchar(20) DEFAULT 'ABIERTA'
);

CREATE TABLE `DetalleCotizacion` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `cotizacion_id` int NOT NULL,
  `producto_presentacion_id` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento_pct_aplicado` decimal(5,2) DEFAULT 0,
  `subtotal` decimal(12,2) NOT NULL
);

CREATE TABLE `Proveedores` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(150) UNIQUE NOT NULL,
  `contacto` varchar(120),
  `telefono` varchar(30),
  `email` varchar(150),
  `direccion` varchar(255),
  `activo` bool DEFAULT true
);

CREATE TABLE `ProductoProveedor` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `proveedor_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `codigo_prov` varchar(60),
  `precio_compra` decimal(12,2),
  `activo` bool DEFAULT true
);

CREATE TABLE `Ingresos` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `proveedor_id` int NOT NULL,
  `sucursal_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `fecha` datetime DEFAULT (CURRENT_TIMESTAMP),
  `documento` varchar(60),
  `total` decimal(12,2)
);

CREATE TABLE `DetalleIngreso` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `ingreso_id` int NOT NULL,
  `producto_presentacion_id` int NOT NULL,
  `cantidad` int NOT NULL,
  `costo_unitario` decimal(12,2),
  `subtotal` decimal(12,2)
);

CREATE TABLE `Carritos` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `sucursal_id` int,
  `estado` varchar(20) DEFAULT 'ABIERTO',
  `creado_en` datetime DEFAULT (CURRENT_TIMESTAMP),
  `actualizado_en` datetime
);

CREATE TABLE `CarritoItems` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `carrito_id` int NOT NULL,
  `producto_presentacion_id` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(12,2),
  `descuento_pct` decimal(5,2) DEFAULT 0,
  `subtotal` decimal(12,2)
);

CREATE TABLE `Campanias` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `titulo` varchar(120) NOT NULL,
  `cuerpo` text,
  `creado_por` int,
  `creado_en` datetime DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `CampaniaAdjuntos` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `campania_id` int NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `descripcion` varchar(255)
);

CREATE TABLE `CampaniaDestinatarios` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `campania_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `estado` varchar(20) DEFAULT 'PENDIENTE',
  `detalle` varchar(255),
  `enviado_en` datetime
);

CREATE TABLE `LogsSistema` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `fecha_hora` datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `usuario_id` int,
  `tabla_afectada` varchar(100),
  `accion` varchar(50),
  `registro_afectado_id` varchar(100),
  `descripcion` text,
  `valores_antes` text,
  `valores_despues` text,
  `ip_origen` varchar(64),
  `dispositivo` varchar(100),
  `estado` varchar(20)
);

CREATE INDEX `Sucursales_index_0` ON `Sucursales` (`gps_lat`, `gps_lng`);

CREATE INDEX `Usuarios_index_1` ON `Usuarios` (`rol_id`, `sucursal_id`);

CREATE INDEX `Clientes_index_2` ON `Clientes` (`email`);

CREATE INDEX `Clientes_index_3` ON `Clientes` (`gps_lat`, `gps_lng`);

CREATE INDEX `Productos_index_4` ON `Productos` (`categoria_id`);

CREATE INDEX `Productos_index_5` ON `Productos` (`marca_id`);

CREATE INDEX `Productos_index_6` ON `Productos` (`codigo_sku`);

CREATE UNIQUE INDEX `ProductoPresentacion_index_7` ON `ProductoPresentacion` (`producto_id`, `presentacion_id`);

CREATE INDEX `ProductoPresentacion_index_8` ON `ProductoPresentacion` (`presentacion_id`);

CREATE INDEX `Precios_index_9` ON `Precios` (`producto_presentacion_id`, `sucursal_id`, `vigente_desde`);

CREATE UNIQUE INDEX `InventarioSucursal_index_10` ON `InventarioSucursal` (`sucursal_id`, `producto_presentacion_id`);

CREATE INDEX `MovimientosInventario_index_11` ON `MovimientosInventario` (`sucursal_id`, `producto_presentacion_id`, `created_at`);

CREATE INDEX `MovimientosInventario_index_12` ON `MovimientosInventario` (`tipo`);

CREATE UNIQUE INDEX `Facturas_index_13` ON `Facturas` (`numero`, `serie`);

CREATE INDEX `Facturas_index_14` ON `Facturas` (`fecha_emision`);

CREATE INDEX `Facturas_index_15` ON `Facturas` (`cliente_id`, `fecha_emision`);

CREATE INDEX `DetalleFactura_index_16` ON `DetalleFactura` (`factura_id`);

CREATE UNIQUE INDEX `DetalleFactura_index_17` ON `DetalleFactura` (`factura_id`, `producto_presentacion_id`);

CREATE INDEX `Pagos_index_18` ON `Pagos` (`factura_id`);

CREATE UNIQUE INDEX `Pagos_index_19` ON `Pagos` (`tipo`);

CREATE UNIQUE INDEX `Cotizaciones_index_20` ON `Cotizaciones` (`numero`, `serie`);

CREATE INDEX `Cotizaciones_index_21` ON `Cotizaciones` (`cliente_id`, `fecha`);

CREATE INDEX `DetalleCotizacion_index_22` ON `DetalleCotizacion` (`cotizacion_id`);

CREATE UNIQUE INDEX `DetalleCotizacion_index_23` ON `DetalleCotizacion` (`cotizacion_id`, `producto_presentacion_id`);

CREATE UNIQUE INDEX `ProductoProveedor_index_24` ON `ProductoProveedor` (`proveedor_id`, `producto_id`);

CREATE INDEX `Ingresos_index_25` ON `Ingresos` (`fecha`);

CREATE INDEX `Ingresos_index_26` ON `Ingresos` (`proveedor_id`, `fecha`);

CREATE INDEX `DetalleIngreso_index_27` ON `DetalleIngreso` (`ingreso_id`);

CREATE INDEX `Carritos_index_28` ON `Carritos` (`cliente_id`, `estado`);

CREATE INDEX `CarritoItems_index_29` ON `CarritoItems` (`carrito_id`);

CREATE UNIQUE INDEX `CarritoItems_index_30` ON `CarritoItems` (`carrito_id`, `producto_presentacion_id`);

CREATE INDEX `CampaniaDestinatarios_index_31` ON `CampaniaDestinatarios` (`campania_id`);

CREATE UNIQUE INDEX `CampaniaDestinatarios_index_32` ON `CampaniaDestinatarios` (`campania_id`, `cliente_id`);

CREATE INDEX `LogsSistema_index_33` ON `LogsSistema` (`fecha_hora`);

CREATE INDEX `LogsSistema_index_34` ON `LogsSistema` (`usuario_id`, `fecha_hora`);

CREATE INDEX `LogsSistema_index_35` ON `LogsSistema` (`tabla_afectada`, `accion`);

ALTER TABLE `ProductoPresentacion` COMMENT = 'Catálogo vendible (Producto + Presentación)';

ALTER TABLE `Ingresos` COMMENT = 'Al confirmar: generar MovimientosInventario tipo COMPRA (+cantidad)';

ALTER TABLE `Usuarios` ADD FOREIGN KEY (`rol_id`) REFERENCES `Roles` (`id`);

ALTER TABLE `Usuarios` ADD FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`);

ALTER TABLE `Productos` ADD FOREIGN KEY (`categoria_id`) REFERENCES `Categorias` (`id`);

ALTER TABLE `Productos` ADD FOREIGN KEY (`marca_id`) REFERENCES `Marcas` (`id`);

ALTER TABLE `ProductoPresentacion` ADD FOREIGN KEY (`producto_id`) REFERENCES `Productos` (`id`);

ALTER TABLE `ProductoPresentacion` ADD FOREIGN KEY (`presentacion_id`) REFERENCES `Presentaciones` (`id`);

ALTER TABLE `Precios` ADD FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`);

ALTER TABLE `Precios` ADD FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`);

ALTER TABLE `InventarioSucursal` ADD FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`);

ALTER TABLE `InventarioSucursal` ADD FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`);

ALTER TABLE `MovimientosInventario` ADD FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`);

ALTER TABLE `MovimientosInventario` ADD FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`);

ALTER TABLE `Facturas` ADD FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`);

ALTER TABLE `Facturas` ADD FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`id`);

ALTER TABLE `Facturas` ADD FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`);

ALTER TABLE `Facturas` ADD FOREIGN KEY (`anulada_por`) REFERENCES `Usuarios` (`id`);

ALTER TABLE `DetalleFactura` ADD FOREIGN KEY (`factura_id`) REFERENCES `Facturas` (`id`);

ALTER TABLE `DetalleFactura` ADD FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`);

ALTER TABLE `Pagos` ADD FOREIGN KEY (`factura_id`) REFERENCES `Facturas` (`id`);

ALTER TABLE `Pagos` ADD FOREIGN KEY (`tipo`) REFERENCES `MediosPago` (`id`);

ALTER TABLE `Cotizaciones` ADD FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`);

ALTER TABLE `Cotizaciones` ADD FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`id`);

ALTER TABLE `Cotizaciones` ADD FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`);

ALTER TABLE `DetalleCotizacion` ADD FOREIGN KEY (`cotizacion_id`) REFERENCES `Cotizaciones` (`id`);

ALTER TABLE `DetalleCotizacion` ADD FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`);

ALTER TABLE `ProductoProveedor` ADD FOREIGN KEY (`proveedor_id`) REFERENCES `Proveedores` (`id`);

ALTER TABLE `ProductoProveedor` ADD FOREIGN KEY (`producto_id`) REFERENCES `Productos` (`id`);

ALTER TABLE `Ingresos` ADD FOREIGN KEY (`proveedor_id`) REFERENCES `Proveedores` (`id`);

ALTER TABLE `Ingresos` ADD FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`);

ALTER TABLE `Ingresos` ADD FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`id`);

ALTER TABLE `DetalleIngreso` ADD FOREIGN KEY (`ingreso_id`) REFERENCES `Ingresos` (`id`);

ALTER TABLE `DetalleIngreso` ADD FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`);

ALTER TABLE `Carritos` ADD FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`);

ALTER TABLE `Carritos` ADD FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`);

ALTER TABLE `CarritoItems` ADD FOREIGN KEY (`carrito_id`) REFERENCES `Carritos` (`id`);

ALTER TABLE `CarritoItems` ADD FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`);

ALTER TABLE `Campanias` ADD FOREIGN KEY (`creado_por`) REFERENCES `Usuarios` (`id`);

ALTER TABLE `CampaniaAdjuntos` ADD FOREIGN KEY (`campania_id`) REFERENCES `Campanias` (`id`);

ALTER TABLE `CampaniaDestinatarios` ADD FOREIGN KEY (`campania_id`) REFERENCES `Campanias` (`id`);

ALTER TABLE `CampaniaDestinatarios` ADD FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`);

ALTER TABLE `LogsSistema` ADD FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`id`);
