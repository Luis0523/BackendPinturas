/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.0.2-MariaDB, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: pinturas
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `CampaniaAdjuntos`
--

DROP TABLE IF EXISTS `CampaniaAdjuntos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CampaniaAdjuntos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campania_id` int(11) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `campania_id` (`campania_id`),
  CONSTRAINT `CampaniaAdjuntos_ibfk_1` FOREIGN KEY (`campania_id`) REFERENCES `Campanias` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CampaniaAdjuntos`
--

LOCK TABLES `CampaniaAdjuntos` WRITE;
/*!40000 ALTER TABLE `CampaniaAdjuntos` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `CampaniaAdjuntos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `CampaniaDestinatarios`
--

DROP TABLE IF EXISTS `CampaniaDestinatarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CampaniaDestinatarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campania_id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `estado` varchar(20) DEFAULT 'PENDIENTE',
  `detalle` varchar(255) DEFAULT NULL,
  `enviado_en` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `CampaniaDestinatarios_index_32` (`campania_id`,`cliente_id`),
  KEY `CampaniaDestinatarios_index_31` (`campania_id`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `CampaniaDestinatarios_ibfk_1` FOREIGN KEY (`campania_id`) REFERENCES `Campanias` (`id`),
  CONSTRAINT `CampaniaDestinatarios_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CampaniaDestinatarios`
--

LOCK TABLES `CampaniaDestinatarios` WRITE;
/*!40000 ALTER TABLE `CampaniaDestinatarios` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `CampaniaDestinatarios` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Campanias`
--

DROP TABLE IF EXISTS `Campanias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Campanias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(120) NOT NULL,
  `cuerpo` text DEFAULT NULL,
  `creado_por` int(11) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `creado_por` (`creado_por`),
  CONSTRAINT `Campanias_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `Usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Campanias`
--

LOCK TABLES `Campanias` WRITE;
/*!40000 ALTER TABLE `Campanias` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Campanias` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `CarritoItems`
--

DROP TABLE IF EXISTS `CarritoItems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CarritoItems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carrito_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(12,2) DEFAULT NULL,
  `descuento_pct` decimal(5,2) DEFAULT 0.00,
  `subtotal` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `CarritoItems_index_30` (`carrito_id`,`producto_presentacion_id`),
  KEY `CarritoItems_index_29` (`carrito_id`),
  KEY `producto_presentacion_id` (`producto_presentacion_id`),
  CONSTRAINT `CarritoItems_ibfk_1` FOREIGN KEY (`carrito_id`) REFERENCES `Carritos` (`id`),
  CONSTRAINT `CarritoItems_ibfk_2` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CarritoItems`
--

LOCK TABLES `CarritoItems` WRITE;
/*!40000 ALTER TABLE `CarritoItems` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `CarritoItems` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Carritos`
--

DROP TABLE IF EXISTS `Carritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Carritos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) NOT NULL,
  `sucursal_id` int(11) DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'ABIERTO',
  `creado_en` datetime DEFAULT current_timestamp(),
  `actualizado_en` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Carritos_index_28` (`cliente_id`,`estado`),
  KEY `sucursal_id` (`sucursal_id`),
  CONSTRAINT `Carritos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`),
  CONSTRAINT `Carritos_ibfk_2` FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Carritos`
--

LOCK TABLES `Carritos` WRITE;
/*!40000 ALTER TABLE `Carritos` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Carritos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Categorias`
--

DROP TABLE IF EXISTS `Categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categorias`
--

LOCK TABLES `Categorias` WRITE;
/*!40000 ALTER TABLE `Categorias` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Categorias` VALUES
(1,'Pinturas','Productos para pintar superficies como paredes y techos.'),
(2,'Solventes','Productos químicos para la limpieza y dilución de pinturas.'),
(3,'Accesorios','Herramientas y materiales auxiliares para pintar como brochas y rodillos');
/*!40000 ALTER TABLE `Categorias` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Clientes`
--

DROP TABLE IF EXISTS `Clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `nit` varchar(25) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `opt_in_promos` tinyint(1) DEFAULT 0,
  `verificado` tinyint(1) DEFAULT 0,
  `telefono` varchar(30) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `gps_lat` decimal(10,6) DEFAULT NULL,
  `gps_lng` decimal(10,6) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `nit` (`nit`),
  UNIQUE KEY `email` (`email`),
  KEY `Clientes_index_2` (`email`),
  KEY `Clientes_index_3` (`gps_lat`,`gps_lng`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clientes`
--

LOCK TABLES `Clientes` WRITE;
/*!40000 ALTER TABLE `Clientes` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Clientes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Cotizaciones`
--

DROP TABLE IF EXISTS `Cotizaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cotizaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` int(11) NOT NULL,
  `serie` varchar(10) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `cliente_id` int(11) DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `vigente_hasta` datetime DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'ABIERTA',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Cotizaciones_index_20` (`numero`,`serie`),
  KEY `Cotizaciones_index_21` (`cliente_id`,`fecha`),
  KEY `usuario_id` (`usuario_id`),
  KEY `sucursal_id` (`sucursal_id`),
  CONSTRAINT `Cotizaciones_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`),
  CONSTRAINT `Cotizaciones_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`id`),
  CONSTRAINT `Cotizaciones_ibfk_3` FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cotizaciones`
--

LOCK TABLES `Cotizaciones` WRITE;
/*!40000 ALTER TABLE `Cotizaciones` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Cotizaciones` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `DetalleCotizacion`
--

DROP TABLE IF EXISTS `DetalleCotizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DetalleCotizacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cotizacion_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento_pct_aplicado` decimal(5,2) DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `DetalleCotizacion_index_23` (`cotizacion_id`,`producto_presentacion_id`),
  KEY `DetalleCotizacion_index_22` (`cotizacion_id`),
  KEY `producto_presentacion_id` (`producto_presentacion_id`),
  CONSTRAINT `DetalleCotizacion_ibfk_1` FOREIGN KEY (`cotizacion_id`) REFERENCES `Cotizaciones` (`id`),
  CONSTRAINT `DetalleCotizacion_ibfk_2` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DetalleCotizacion`
--

LOCK TABLES `DetalleCotizacion` WRITE;
/*!40000 ALTER TABLE `DetalleCotizacion` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `DetalleCotizacion` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `DetalleFactura`
--

DROP TABLE IF EXISTS `DetalleFactura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DetalleFactura` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `factura_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento_pct_aplicado` decimal(5,2) DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `DetalleFactura_index_17` (`factura_id`,`producto_presentacion_id`),
  KEY `DetalleFactura_index_16` (`factura_id`),
  KEY `producto_presentacion_id` (`producto_presentacion_id`),
  CONSTRAINT `DetalleFactura_ibfk_1` FOREIGN KEY (`factura_id`) REFERENCES `Facturas` (`id`),
  CONSTRAINT `DetalleFactura_ibfk_2` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DetalleFactura`
--

LOCK TABLES `DetalleFactura` WRITE;
/*!40000 ALTER TABLE `DetalleFactura` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `DetalleFactura` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `DetalleIngreso`
--

DROP TABLE IF EXISTS `DetalleIngreso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DetalleIngreso` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ingreso_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `costo_unitario` decimal(12,2) DEFAULT NULL,
  `subtotal` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `DetalleIngreso_index_27` (`ingreso_id`),
  KEY `producto_presentacion_id` (`producto_presentacion_id`),
  CONSTRAINT `DetalleIngreso_ibfk_1` FOREIGN KEY (`ingreso_id`) REFERENCES `Ingresos` (`id`),
  CONSTRAINT `DetalleIngreso_ibfk_2` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DetalleIngreso`
--

LOCK TABLES `DetalleIngreso` WRITE;
/*!40000 ALTER TABLE `DetalleIngreso` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `DetalleIngreso` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Facturas`
--

DROP TABLE IF EXISTS `Facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Facturas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` int(11) NOT NULL,
  `serie` varchar(10) NOT NULL,
  `fecha_emision` datetime NOT NULL DEFAULT current_timestamp(),
  `cliente_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `estado` enum('EMITIDA','ANULADA') NOT NULL DEFAULT 'EMITIDA',
  `anulada_por` int(11) DEFAULT NULL,
  `anulada_fecha` datetime DEFAULT NULL,
  `motivo_anulacion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Facturas_index_13` (`numero`,`serie`),
  KEY `Facturas_index_14` (`fecha_emision`),
  KEY `Facturas_index_15` (`cliente_id`,`fecha_emision`),
  KEY `usuario_id` (`usuario_id`),
  KEY `sucursal_id` (`sucursal_id`),
  KEY `anulada_por` (`anulada_por`),
  CONSTRAINT `Facturas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`),
  CONSTRAINT `Facturas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`id`),
  CONSTRAINT `Facturas_ibfk_3` FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`),
  CONSTRAINT `Facturas_ibfk_4` FOREIGN KEY (`anulada_por`) REFERENCES `Usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Facturas`
--

LOCK TABLES `Facturas` WRITE;
/*!40000 ALTER TABLE `Facturas` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Facturas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Ingresos`
--

DROP TABLE IF EXISTS `Ingresos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ingresos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proveedor_id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `documento` varchar(60) DEFAULT NULL,
  `total` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Ingresos_index_25` (`fecha`),
  KEY `Ingresos_index_26` (`proveedor_id`,`fecha`),
  KEY `sucursal_id` (`sucursal_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `Ingresos_ibfk_1` FOREIGN KEY (`proveedor_id`) REFERENCES `Proveedores` (`id`),
  CONSTRAINT `Ingresos_ibfk_2` FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`),
  CONSTRAINT `Ingresos_ibfk_3` FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Al confirmar: generar MovimientosInventario tipo COMPRA (+cantidad)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ingresos`
--

LOCK TABLES `Ingresos` WRITE;
/*!40000 ALTER TABLE `Ingresos` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Ingresos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `InventarioSucursal`
--

DROP TABLE IF EXISTS `InventarioSucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `InventarioSucursal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sucursal_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `existencia` int(11) NOT NULL DEFAULT 0,
  `minimo` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `InventarioSucursal_index_10` (`sucursal_id`,`producto_presentacion_id`),
  KEY `producto_presentacion_id` (`producto_presentacion_id`),
  CONSTRAINT `InventarioSucursal_ibfk_1` FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`),
  CONSTRAINT `InventarioSucursal_ibfk_2` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `ProductoPresentacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InventarioSucursal`
--

LOCK TABLES `InventarioSucursal` WRITE;
/*!40000 ALTER TABLE `InventarioSucursal` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `InventarioSucursal` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `LogsSistema`
--

DROP TABLE IF EXISTS `LogsSistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `LogsSistema` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp(),
  `usuario_id` int(11) DEFAULT NULL,
  `tabla_afectada` varchar(100) DEFAULT NULL,
  `accion` varchar(50) DEFAULT NULL,
  `registro_afectado_id` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `valores_antes` text DEFAULT NULL,
  `valores_despues` text DEFAULT NULL,
  `ip_origen` varchar(64) DEFAULT NULL,
  `dispositivo` varchar(100) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `LogsSistema_index_33` (`fecha_hora`),
  KEY `LogsSistema_index_34` (`usuario_id`,`fecha_hora`),
  KEY `LogsSistema_index_35` (`tabla_afectada`,`accion`),
  CONSTRAINT `LogsSistema_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LogsSistema`
--

LOCK TABLES `LogsSistema` WRITE;
/*!40000 ALTER TABLE `LogsSistema` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `LogsSistema` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Marcas`
--

DROP TABLE IF EXISTS `Marcas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Marcas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(80) NOT NULL,
  `activa` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Marcas`
--

LOCK TABLES `Marcas` WRITE;
/*!40000 ALTER TABLE `Marcas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Marcas` VALUES
(1,'Marca A',1),
(2,'Marca B',1),
(3,'Marca C',1);
/*!40000 ALTER TABLE `Marcas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `MediosPago`
--

DROP TABLE IF EXISTS `MediosPago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MediosPago` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `efectivo` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tarjeta` decimal(12,2) NOT NULL DEFAULT 0.00,
  `cheque` decimal(12,2) NOT NULL DEFAULT 0.00,
  `transferencia` decimal(12,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MediosPago`
--

LOCK TABLES `MediosPago` WRITE;
/*!40000 ALTER TABLE `MediosPago` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `MediosPago` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Pagos`
--

DROP TABLE IF EXISTS `Pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pagos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `factura_id` int(11) NOT NULL,
  `tipo` int(11) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `referencia` varchar(80) DEFAULT NULL,
  `entidad` varchar(80) DEFAULT NULL,
  `transaccion_gateway_id` varchar(80) DEFAULT NULL,
  `autorizado_por` varchar(120) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Pagos_index_19` (`tipo`),
  KEY `Pagos_index_18` (`factura_id`),
  CONSTRAINT `Pagos_ibfk_1` FOREIGN KEY (`factura_id`) REFERENCES `Facturas` (`id`),
  CONSTRAINT `Pagos_ibfk_2` FOREIGN KEY (`tipo`) REFERENCES `MediosPago` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pagos`
--

LOCK TABLES `Pagos` WRITE;
/*!40000 ALTER TABLE `Pagos` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Pagos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Presentaciones`
--

DROP TABLE IF EXISTS `Presentaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Presentaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(40) NOT NULL,
  `unidad_base` varchar(20) DEFAULT NULL,
  `factor_galon` decimal(10,5) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Presentaciones`
--

LOCK TABLES `Presentaciones` WRITE;
/*!40000 ALTER TABLE `Presentaciones` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Presentaciones` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ProductoPresentacion`
--

DROP TABLE IF EXISTS `ProductoPresentacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductoPresentacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producto_id` int(11) NOT NULL,
  `presentacion_id` int(11) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ProductoPresentacion_index_7` (`producto_id`,`presentacion_id`),
  KEY `ProductoPresentacion_index_8` (`presentacion_id`),
  CONSTRAINT `ProductoPresentacion_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `Productos` (`id`),
  CONSTRAINT `ProductoPresentacion_ibfk_2` FOREIGN KEY (`presentacion_id`) REFERENCES `Presentaciones` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Catálogo vendible (Producto + Presentación)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductoPresentacion`
--

LOCK TABLES `ProductoPresentacion` WRITE;
/*!40000 ALTER TABLE `ProductoPresentacion` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ProductoPresentacion` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ProductoProveedor`
--

DROP TABLE IF EXISTS `ProductoProveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductoProveedor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proveedor_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `codigo_prov` varchar(60) DEFAULT NULL,
  `precio_compra` decimal(12,2) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ProductoProveedor_index_24` (`proveedor_id`,`producto_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `ProductoProveedor_ibfk_1` FOREIGN KEY (`proveedor_id`) REFERENCES `Proveedores` (`id`),
  CONSTRAINT `ProductoProveedor_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `Productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductoProveedor`
--

LOCK TABLES `ProductoProveedor` WRITE;
/*!40000 ALTER TABLE `ProductoProveedor` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ProductoProveedor` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Productos`
--

DROP TABLE IF EXISTS `Productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria_id` int(11) NOT NULL,
  `marca_id` int(11) DEFAULT NULL,
  `codigo_sku` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) NOT NULL,
  `tamano` varchar(40) DEFAULT NULL,
  `duracion_anios` int(11) DEFAULT NULL,
  `extension_m2` decimal(10,2) DEFAULT NULL,
  `color` varchar(60) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_sku` (`codigo_sku`),
  UNIQUE KEY `Productos_pk` (`codigo_sku`),
  KEY `Productos_index_4` (`categoria_id`),
  KEY `Productos_index_5` (`marca_id`),
  KEY `Productos_index_6` (`codigo_sku`),
  CONSTRAINT `Productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `Categorias` (`id`),
  CONSTRAINT `Productos_ibfk_2` FOREIGN KEY (`marca_id`) REFERENCES `Marcas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Productos`
--

LOCK TABLES `Productos` WRITE;
/*!40000 ALTER TABLE `Productos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Productos` VALUES
(1,1,2,'SKU12345','Pintura de alta calidad para exteriores.','1 galón',5,30.00,'Rojo',1,'2025-10-14 08:02:14','2025-10-14 08:02:14');
/*!40000 ALTER TABLE `Productos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Proveedores`
--

DROP TABLE IF EXISTS `Proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `contacto` varchar(120) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proveedores`
--

LOCK TABLES `Proveedores` WRITE;
/*!40000 ALTER TABLE `Proveedores` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Proveedores` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Roles`
--

DROP TABLE IF EXISTS `Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Roles`
--

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Roles` VALUES
(1,'admin'),
(2,'cajero'),
(4,'digitador'),
(3,'gerente');
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Sucursales`
--

DROP TABLE IF EXISTS `Sucursales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sucursales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `gps_lat` decimal(10,6) DEFAULT NULL,
  `gps_lng` decimal(10,6) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `activa` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `Sucursales_index_0` (`gps_lat`,`gps_lng`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sucursales`
--

LOCK TABLES `Sucursales` WRITE;
/*!40000 ALTER TABLE `Sucursales` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Sucursales` VALUES
(1,'Pradera Chimaltenango','Dirección 1',14.634900,-90.678000,'123456789',1),
(2,'Pradera Escuintla','Dirección 2',13.935000,-89.995000,'987654321',1),
(3,'Las Américas Mazatenango','Dirección 3',14.607000,-91.516000,'456789123',1),
(4,'La Trinidad Coatepeque','Dirección 4',14.783000,-91.563000,'321654987',1),
(5,'Pradera Xela','Dirección 5',14.839000,-91.514000,'654321789',1),
(6,'Centro Comercial Miraflores','Dirección 6',14.634900,-90.678000,'789123456',1);
/*!40000 ALTER TABLE `Sucursales` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Usuarios`
--

DROP TABLE IF EXISTS `Usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `dpi` varchar(20) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol_id` int(11) NOT NULL,
  `sucursal_id` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `creado_en` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `dpi` (`dpi`),
  UNIQUE KEY `email` (`email`),
  KEY `Usuarios_index_1` (`rol_id`,`sucursal_id`),
  KEY `sucursal_id` (`sucursal_id`),
  CONSTRAINT `Usuarios_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `Roles` (`id`),
  CONSTRAINT `Usuarios_ibfk_2` FOREIGN KEY (`sucursal_id`) REFERENCES `Sucursales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuarios`
--

LOCK TABLES `Usuarios` WRITE;
/*!40000 ALTER TABLE `Usuarios` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Usuarios` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `backup_inventariosucursal`
--

DROP TABLE IF EXISTS `backup_inventariosucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_inventariosucursal` (
  `id` int(11) NOT NULL DEFAULT 0,
  `sucursal_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `existencia` int(11) NOT NULL DEFAULT 0,
  `minimo` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_inventariosucursal`
--

LOCK TABLES `backup_inventariosucursal` WRITE;
/*!40000 ALTER TABLE `backup_inventariosucursal` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `backup_inventariosucursal` VALUES
(1,1,1,106,10),
(2,1,2,36,10),
(3,4,4,40,0),
(4,3,5,60,0),
(5,1,4,70,0),
(6,1,6,140,0),
(7,1,8,120,0),
(8,3,8,200,0);
/*!40000 ALTER TABLE `backup_inventariosucursal` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `backup_movimientosinventario`
--

DROP TABLE IF EXISTS `backup_movimientosinventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_movimientosinventario` (
  `id` int(11) NOT NULL DEFAULT 0,
  `sucursal_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `tipo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` int(11) NOT NULL,
  `referencia` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_movimientosinventario`
--

LOCK TABLES `backup_movimientosinventario` WRITE;
/*!40000 ALTER TABLE `backup_movimientosinventario` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `backup_movimientosinventario` VALUES
(1,1,1,'AJUSTE',10,'Nueva compra de proveedor ABC','2025-10-16 02:00:57'),
(2,1,1,'VENTA',-2,'Factura A-1','2025-10-16 18:15:51'),
(3,1,1,'VENTA',-2,'Factura A-2','2025-10-16 18:40:41'),
(4,1,2,'VENTA',-2,'Factura A-3','2025-10-16 18:41:13'),
(5,1,2,'VENTA',-2,'Factura A-4','2025-10-16 18:41:41'),
(6,1,1,'AJUSTE',2,'Anulación Factura A-1','2025-10-16 18:47:31'),
(7,1,1,'COMPRA',50,'Recepción OC-1','2025-10-18 02:29:14'),
(8,4,4,'COMPRA',40,'Recepción OC-2','2025-10-18 03:15:39'),
(9,3,5,'COMPRA',60,'Recepción OC-3','2025-10-18 03:22:35'),
(10,1,4,'COMPRA',40,'Recepción OC-4','2025-10-20 22:27:29'),
(11,1,4,'COMPRA',30,'Recepción OC-5','2025-10-20 22:36:47'),
(12,1,6,'COMPRA',40,'Recepción OC-6','2025-10-21 23:34:59'),
(13,1,6,'COMPRA',100,'Recepción OC-7','2025-10-22 23:53:37'),
(14,1,2,'VENTA',-1,'Factura A-5','2025-10-23 00:14:21'),
(15,1,2,'VENTA',-2,'Factura A-6','2025-10-23 00:26:47'),
(16,1,2,'VENTA',-2,'Factura A-7','2025-10-23 00:29:49'),
(17,1,2,'VENTA',-2,'Factura A-8','2025-10-23 00:51:20'),
(18,1,1,'VENTA',-1,'Factura A-8','2025-10-23 00:51:20'),
(19,1,2,'VENTA',-1,'Factura A-9','2025-10-23 01:34:56'),
(20,1,2,'VENTA',-1,'Factura A-10','2025-10-23 01:36:14'),
(21,1,1,'VENTA',-1,'Factura A-11','2025-10-23 01:37:11'),
(22,1,2,'VENTA',-1,'Factura A-12','2025-10-23 01:42:42'),
(23,1,2,'VENTA',-2,'Factura A-13','2025-10-23 02:08:59'),
(24,1,8,'COMPRA',120,'Recepción OC-8','2025-11-05 15:10:22'),
(25,3,8,'COMPRA',200,'Recepción OC-9','2025-11-05 15:17:09');
/*!40000 ALTER TABLE `backup_movimientosinventario` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `backup_precios`
--

DROP TABLE IF EXISTS `backup_precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_precios` (
  `id` int(11) NOT NULL DEFAULT 0,
  `producto_presentacion_id` int(11) NOT NULL,
  `sucursal_id` int(11) DEFAULT NULL,
  `precio_venta` decimal(12,2) NOT NULL,
  `descuento_pct` decimal(5,2) DEFAULT 0.00,
  `vigente_desde` datetime NOT NULL DEFAULT current_timestamp(),
  `vigente_hasta` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `stock_minimo` int(11) DEFAULT 0 COMMENT 'Stock mínimo configurado para esta presentación en esta sucursal'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_precios`
--

LOCK TABLES `backup_precios` WRITE;
/*!40000 ALTER TABLE `backup_precios` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `backup_precios` VALUES
(1,1,NULL,30.00,0.00,'2025-10-16 01:04:54',NULL,1,0),
(2,1,1,32.00,10.00,'2025-10-16 01:05:46',NULL,1,0),
(3,1,1,150.00,0.00,'2025-10-21 05:33:56',NULL,1,0),
(4,2,1,70.00,0.00,'2025-10-21 05:35:24',NULL,1,0),
(5,7,1,190.00,0.00,'2025-10-22 16:01:42',NULL,1,0),
(6,3,1,300.00,0.00,'2025-11-05 06:35:12',NULL,1,0),
(7,6,1,90.00,0.00,'2025-11-05 06:35:46',NULL,1,0),
(8,8,1,150.00,0.00,'2025-11-05 15:08:58',NULL,1,0),
(9,9,1,80.00,0.00,'2025-11-05 15:43:32',NULL,1,10);
/*!40000 ALTER TABLE `backup_precios` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `backup_productopresentacion`
--

DROP TABLE IF EXISTS `backup_productopresentacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_productopresentacion` (
  `id` int(11) NOT NULL DEFAULT 0,
  `producto_id` int(11) NOT NULL,
  `presentacion_id` int(11) NOT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_productopresentacion`
--

LOCK TABLES `backup_productopresentacion` WRITE;
/*!40000 ALTER TABLE `backup_productopresentacion` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `backup_productopresentacion` VALUES
(1,1,1,1),
(2,1,2,1),
(3,1,3,1),
(4,6,1,0),
(5,6,7,0),
(6,1,6,1),
(7,2,3,1),
(8,7,1,0),
(9,8,2,0);
/*!40000 ALTER TABLE `backup_productopresentacion` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `backup_productos`
--

DROP TABLE IF EXISTS `backup_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_productos` (
  `id` int(11) NOT NULL DEFAULT 0,
  `categoria_id` int(11) DEFAULT NULL,
  `marca_id` int(11) DEFAULT NULL,
  `codigo_sku` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tamano` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duracion_anios` int(11) DEFAULT NULL,
  `extension_m2` decimal(10,2) DEFAULT NULL,
  `color` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_productos`
--

LOCK TABLES `backup_productos` WRITE;
/*!40000 ALTER TABLE `backup_productos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `backup_productos` VALUES
(1,1,1,'SKU-001','Pintura Acrílica Interior Premium','1 Galón',5,35.00,'Blanco',1,'2025-10-14 18:00:30','2025-11-05 06:35:48'),
(2,2,2,'SKU-002','Pintura Exterior Vinil Acrílico','19 Litros',7,120.00,'Beige',1,'2025-10-14 18:00:30','2025-10-22 16:01:44'),
(3,3,3,'SKU-003','Esmalte Brillante Alquidal','4 Litros',3,25.00,'Negro',0,'2025-10-14 18:00:30','2025-11-05 16:28:24'),
(4,4,4,'SKU-004','Impermeabilizante Acrílico','20 Litros',10,150.00,'Terracota',0,'2025-10-14 18:00:30','2025-11-05 06:31:59'),
(6,2,1,'004','Impermeabilizannte No acrilico','1 Galon',2,30.00,'Rojo',0,'2025-10-17 17:47:50','2025-11-05 06:31:52'),
(7,1,2,'PINT-102','Pintura Para metales interior','1 Galon',3,35.00,'Cafe',0,'2025-11-05 15:08:40','2025-11-05 16:25:42'),
(8,2,3,'PINT-103','Pintura Metal exterior','1 Galonn',5,120.00,'Cafe',0,'2025-11-05 15:42:40','2025-11-05 16:17:16');
/*!40000 ALTER TABLE `backup_productos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `backup_recepciones`
--

DROP TABLE IF EXISTS `backup_recepciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_recepciones` (
  `id` int(11) NOT NULL DEFAULT 0,
  `orden_compra_id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_recepcion` timestamp NULL DEFAULT current_timestamp(),
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_recepciones`
--

LOCK TABLES `backup_recepciones` WRITE;
/*!40000 ALTER TABLE `backup_recepciones` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `backup_recepciones` VALUES
(1,1,1,1,'2025-10-18 02:29:14','Recepción completa de la orden OC-1'),
(2,2,4,1,'2025-10-18 03:15:39','Todo ha llegado correctamente'),
(3,3,3,1,'2025-10-18 03:22:35','Lllego todo bien, recibimos todo'),
(4,4,1,1,'2025-10-20 22:27:29','Todo estuvo correctamente'),
(5,5,1,1,'2025-10-20 22:36:47','todo bien'),
(6,6,1,1,'2025-10-21 23:34:59','VIno todo bien'),
(7,7,1,1,'2025-10-22 23:53:37','Todo vino bien, pero 1 caja no venia sellada'),
(8,8,1,1,'2025-11-05 15:10:22','Todo vino bien'),
(9,9,3,1,'2025-11-05 15:17:09','Todas las cajas vinieron bien');
/*!40000 ALTER TABLE `backup_recepciones` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  UNIQUE KEY `nombre_2` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `categorias` VALUES
(1,'Pinturas de Interior','Pinturas para uso en interiores'),
(2,'Pinturas de Exterior','Pinturas resistentes al clima'),
(3,'Esmaltes','Esmaltes y barnices'),
(4,'Impermeabilizantes','Productos para impermeabilización'),
(5,'Primers e Imprimantes','Bases y anticorrosivos');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `nit` varchar(25) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `opt_in_promos` tinyint(1) DEFAULT 0,
  `verificado` tinyint(1) DEFAULT 0,
  `telefono` varchar(30) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `gps_lat` decimal(10,6) DEFAULT NULL,
  `gps_lng` decimal(10,6) DEFAULT NULL,
  `creado_en` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nit` (`nit`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `clientes` VALUES
(1,'María González','12345678-9','maria.gonzalez@email.com',NULL,1,1,'5551-1111','Zona 10, Guatemala',NULL,NULL,'2025-10-15 10:00:00'),
(2,'Carlos Rodríguez','23456789-0','carlos.rodriguez@email.com',NULL,1,1,'5552-2222','Zona 15, Guatemala',NULL,NULL,'2025-10-16 11:30:00'),
(3,'Ana Martínez','34567890-1','ana.martinez@email.com',NULL,0,1,'5553-3333','Mixco, Guatemala',NULL,NULL,'2025-10-17 09:15:00'),
(4,'Luis Pérez','45678901-2','luis.perez@email.com',NULL,1,1,'5554-4444','Villa Nueva, Guatemala',NULL,NULL,'2025-10-18 14:20:00'),
(5,'Carmen López','56789012-3','carmen.lopez@email.com',NULL,1,1,'5555-5555','San Miguel Petapa',NULL,NULL,'2025-10-19 16:45:00'),
(6,'Roberto Hernández','67890123-4','roberto.hernandez@email.com',NULL,0,1,'5556-6666','Villa Canales',NULL,NULL,'2025-10-20 10:30:00'),
(7,'Patricia Gómez','78901234-5','patricia.gomez@email.com',NULL,1,1,'5557-7777','Amatitlán',NULL,NULL,'2025-10-21 13:00:00'),
(8,'Jorge Ramírez','89012345-6','jorge.ramirez@email.com',NULL,1,1,'5558-8888','Zona 18, Guatemala',NULL,NULL,'2025-10-22 15:30:00'),
(9,'Sandra Morales','90123456-7','sandra.morales@email.com',NULL,0,1,'5559-9999','Zona 7, Guatemala',NULL,NULL,'2025-10-23 11:45:00'),
(10,'Fernando Castro','01234567-8','fernando.castro@email.com',NULL,1,1,'5550-0000','Zona 11, Guatemala',NULL,NULL,'2025-10-24 09:00:00'),
(11,'CONSUMIDOR FINAL','CF',NULL,NULL,0,1,NULL,NULL,NULL,NULL,'2025-01-01 00:00:00');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `detalle_orden_compra`
--

DROP TABLE IF EXISTS `detalle_orden_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_orden_compra` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orden_compra_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento_pct` decimal(5,2) DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL,
  `cantidad_recibida` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_detalle_orden` (`orden_compra_id`),
  KEY `idx_detalle_producto_pres` (`producto_presentacion_id`),
  CONSTRAINT `fk_detalle_orden` FOREIGN KEY (`orden_compra_id`) REFERENCES `ordenes_compra` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_producto_pres` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `productopresentacion` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `CONSTRAINT_1` CHECK (`cantidad` > 0),
  CONSTRAINT `CONSTRAINT_2` CHECK (`precio_unitario` >= 0),
  CONSTRAINT `CONSTRAINT_3` CHECK (`descuento_pct` >= 0 and `descuento_pct` <= 100),
  CONSTRAINT `CONSTRAINT_4` CHECK (`cantidad_recibida` >= 0),
  CONSTRAINT `CONSTRAINT_5` CHECK (`cantidad_recibida` <= `cantidad`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detalle de productos en órdenes de compra';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_orden_compra`
--

LOCK TABLES `detalle_orden_compra` WRITE;
/*!40000 ALTER TABLE `detalle_orden_compra` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `detalle_orden_compra` VALUES
(1,1,1,50,100.00,0.00,5000.00,50),
(2,2,4,40,12.00,0.00,480.00,40),
(3,3,5,60,30.00,0.00,1800.00,60),
(4,4,4,40,20.00,0.00,800.00,40),
(5,5,4,30,30.00,0.00,900.00,30),
(6,6,6,40,30.00,0.00,1200.00,40),
(7,7,6,100,120.00,0.00,12000.00,100),
(8,8,8,120,80.00,0.00,9600.00,120),
(9,9,8,200,80.00,0.00,16000.00,200),
(10,1,1,200,70.00,0.00,14000.00,200),
(11,2,1,100,80.00,0.00,8000.00,100),
(12,3,1,100,80.00,0.00,8000.00,100),
(13,4,2,50,30.00,0.00,1500.00,50),
(14,4,3,90,40.00,0.00,3600.00,90);
/*!40000 ALTER TABLE `detalle_orden_compra` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `detalle_recepciones`
--

DROP TABLE IF EXISTS `detalle_recepciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_recepciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recepcion_id` int(11) NOT NULL,
  `detalle_orden_id` int(11) NOT NULL,
  `cantidad_recibida` int(11) NOT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_detalle_recep_recepcion` (`recepcion_id`),
  KEY `idx_detalle_recep_orden` (`detalle_orden_id`),
  CONSTRAINT `fk_detalle_recep_orden` FOREIGN KEY (`detalle_orden_id`) REFERENCES `detalle_orden_compra` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_recep_recepcion` FOREIGN KEY (`recepcion_id`) REFERENCES `recepciones` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `CONSTRAINT_1` CHECK (`cantidad_recibida` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detalle de productos recibidos en cada recepción';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_recepciones`
--

LOCK TABLES `detalle_recepciones` WRITE;
/*!40000 ALTER TABLE `detalle_recepciones` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `detalle_recepciones` VALUES
(1,1,10,200,NULL),
(2,2,11,80,NULL),
(3,3,11,20,NULL),
(4,4,12,50,NULL),
(5,5,12,50,NULL),
(6,6,13,50,NULL),
(7,6,14,90,NULL);
/*!40000 ALTER TABLE `detalle_recepciones` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `detallefactura`
--

DROP TABLE IF EXISTS `detallefactura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `detallefactura` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `factura_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento_pct_aplicado` decimal(5,2) DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_detalle_factura` (`factura_id`),
  KEY `idx_detalle_producto` (`producto_presentacion_id`),
  CONSTRAINT `fk_detalle_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_producto_presentacion` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `productopresentacion` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `CONSTRAINT_1` CHECK (`cantidad` > 0),
  CONSTRAINT `CONSTRAINT_2` CHECK (`precio_unitario` >= 0),
  CONSTRAINT `CONSTRAINT_3` CHECK (`descuento_pct_aplicado` >= 0 and `descuento_pct_aplicado` <= 100)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detalle de productos vendidos por factura';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detallefactura`
--

LOCK TABLES `detallefactura` WRITE;
/*!40000 ALTER TABLE `detallefactura` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `detallefactura` VALUES
(1,1,1,3,185.00,0.00,555.00),
(2,2,1,1,185.00,0.00,185.00),
(3,3,19,1,825.00,0.00,825.00),
(4,4,1,2,185.00,0.00,370.00),
(5,5,6,1,195.00,0.00,195.00),
(6,5,8,1,200.00,0.00,200.00),
(7,5,11,1,108.00,0.00,108.00),
(8,6,4,2,190.00,0.00,380.00),
(9,6,22,1,225.00,0.00,225.00),
(10,7,17,1,285.00,0.00,285.00),
(11,8,6,1,195.00,0.00,195.00),
(12,9,19,2,825.00,0.00,1650.00),
(13,10,7,1,100.00,0.00,100.00),
(14,11,12,2,265.00,0.00,530.00),
(15,12,22,1,225.00,0.00,225.00),
(16,13,4,3,190.00,0.00,570.00),
(17,14,1,2,185.00,0.00,370.00),
(18,14,3,1,50.00,0.00,50.00),
(19,15,20,1,850.00,0.00,850.00),
(20,16,12,1,265.00,0.00,265.00),
(21,17,8,1,200.00,0.00,200.00),
(22,17,10,1,205.00,0.00,205.00),
(23,18,1,1,185.00,0.00,185.00),
(24,19,25,2,245.00,0.00,490.00),
(25,19,27,2,165.00,0.00,330.00),
(26,20,4,1,190.00,0.00,190.00),
(27,21,19,1,825.00,0.00,825.00),
(28,22,7,1,100.00,0.00,100.00),
(29,22,3,1,50.00,0.00,50.00),
(30,22,5,2,98.00,0.00,196.00),
(31,23,6,3,195.00,0.00,585.00),
(32,24,8,1,200.00,0.00,200.00),
(33,25,21,1,875.00,0.00,875.00),
(34,26,25,1,245.00,0.00,245.00),
(35,27,21,1,875.00,0.00,875.00),
(36,28,23,1,118.00,0.00,118.00),
(37,29,15,2,275.00,0.00,550.00),
(38,29,11,1,108.00,0.00,108.00),
(39,30,29,1,175.00,0.00,175.00),
(40,31,1,2,185.00,0.00,370.00),
(41,31,3,2,50.00,0.00,100.00),
(42,32,12,1,265.00,0.00,265.00),
(43,33,19,1,825.00,0.00,825.00),
(44,34,10,1,205.00,0.00,205.00),
(45,35,12,2,265.00,0.00,530.00),
(46,36,17,1,285.00,0.00,285.00),
(47,37,20,1,850.00,0.00,850.00),
(48,38,4,1,190.00,0.00,190.00),
(49,39,25,3,245.00,0.00,735.00),
(50,40,22,1,225.00,0.00,225.00),
(51,41,20,1,850.00,0.00,850.00),
(52,42,27,1,165.00,0.00,165.00),
(53,43,8,2,200.00,0.00,400.00),
(54,43,7,1,100.00,0.00,100.00),
(55,44,15,1,275.00,0.00,275.00),
(56,45,1,3,185.00,0.00,555.00),
(57,45,5,1,98.00,0.00,98.00),
(58,46,25,1,245.00,0.00,245.00),
(59,47,19,1,825.00,0.00,825.00),
(60,48,7,1,100.00,0.00,100.00),
(61,49,29,2,175.00,0.00,350.00),
(62,49,27,2,165.00,0.00,330.00),
(63,50,1,1,185.00,0.00,185.00),
(64,51,21,1,875.00,0.00,875.00),
(65,52,6,1,195.00,0.00,195.00),
(66,53,12,2,265.00,0.00,530.00),
(67,54,12,1,265.00,0.00,265.00),
(68,55,10,2,205.00,0.00,410.00),
(69,55,26,2,128.00,0.00,256.00),
(70,56,8,1,200.00,0.00,200.00),
(71,57,19,1,825.00,0.00,825.00),
(72,58,29,1,175.00,0.00,175.00),
(73,59,25,3,245.00,0.00,735.00),
(74,60,22,1,225.00,0.00,225.00),
(75,61,20,1,850.00,0.00,850.00),
(76,62,4,1,190.00,0.00,190.00);
/*!40000 ALTER TABLE `detallefactura` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `detallepedido`
--

DROP TABLE IF EXISTS `detallepedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `detallepedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento_pct_aplicado` decimal(5,2) DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pedido_id` (`pedido_id`),
  KEY `producto_presentacion_id` (`producto_presentacion_id`),
  CONSTRAINT `detallepedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`),
  CONSTRAINT `detallepedido_ibfk_2` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `productopresentacion` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detallepedido`
--

LOCK TABLES `detallepedido` WRITE;
/*!40000 ALTER TABLE `detallepedido` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `detallepedido` VALUES
(7,7,1,3,100.00,0.00,300.00),
(8,8,1,1,100.00,0.00,100.00);
/*!40000 ALTER TABLE `detallepedido` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` int(11) NOT NULL,
  `serie` varchar(10) NOT NULL,
  `fecha_emision` datetime NOT NULL DEFAULT current_timestamp(),
  `cliente_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `estado` enum('EMITIDA','ANULADA') NOT NULL DEFAULT 'EMITIDA',
  `anulada_por` int(11) DEFAULT NULL,
  `anulada_fecha` datetime DEFAULT NULL,
  `motivo_anulacion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_factura` (`numero`,`serie`),
  KEY `fk_facturas_anulada_por` (`anulada_por`),
  KEY `idx_facturas_cliente` (`cliente_id`),
  KEY `idx_facturas_usuario` (`usuario_id`),
  KEY `idx_facturas_sucursal` (`sucursal_id`),
  KEY `idx_facturas_fecha` (`fecha_emision`),
  KEY `idx_facturas_estado` (`estado`),
  KEY `idx_facturas_numero_serie` (`numero`,`serie`),
  CONSTRAINT `fk_facturas_anulada_por` FOREIGN KEY (`anulada_por`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_facturas_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_facturas_sucursal` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_facturas_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Facturas de venta emitidas';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `facturas` VALUES
(1,1001,'A','2025-11-01 09:30:00',1,1,1,555.00,0.00,555.00,'EMITIDA',NULL,NULL,NULL),
(2,1002,'A','2025-11-01 14:20:00',11,1,1,185.00,0.00,185.00,'EMITIDA',NULL,NULL,NULL),
(3,1003,'A','2025-11-01 16:45:00',2,1,1,825.00,0.00,825.00,'EMITIDA',NULL,NULL,NULL),
(4,1004,'A','2025-11-02 10:15:00',3,1,1,370.00,0.00,370.00,'EMITIDA',NULL,NULL,NULL),
(5,1005,'A','2025-11-02 15:30:00',11,1,1,450.00,0.00,450.00,'EMITIDA',NULL,NULL,NULL),
(6,1006,'A','2025-11-03 11:00:00',4,1,2,600.00,0.00,600.00,'EMITIDA',NULL,NULL,NULL),
(7,1007,'A','2025-11-03 16:20:00',5,1,2,285.00,0.00,285.00,'EMITIDA',NULL,NULL,NULL),
(8,1008,'A','2025-11-04 09:45:00',11,1,1,195.00,0.00,195.00,'EMITIDA',NULL,NULL,NULL),
(9,1009,'A','2025-11-04 13:30:00',6,1,1,1650.00,0.00,1650.00,'EMITIDA',NULL,NULL,NULL),
(10,1010,'A','2025-11-04 17:00:00',11,1,1,100.00,0.00,100.00,'EMITIDA',NULL,NULL,NULL),
(11,1011,'A','2025-11-05 10:30:00',7,1,1,530.00,0.00,530.00,'EMITIDA',NULL,NULL,NULL),
(12,1012,'A','2025-11-05 14:45:00',11,1,1,225.00,0.00,225.00,'EMITIDA',NULL,NULL,NULL),
(13,1013,'A','2025-11-06 11:15:00',8,1,2,570.00,0.00,570.00,'EMITIDA',NULL,NULL,NULL),
(14,1014,'A','2025-11-06 15:20:00',11,1,2,380.00,0.00,380.00,'EMITIDA',NULL,NULL,NULL),
(15,1015,'A','2025-11-07 09:00:00',9,1,1,850.00,0.00,850.00,'EMITIDA',NULL,NULL,NULL),
(16,1016,'A','2025-11-07 16:30:00',11,1,1,265.00,0.00,265.00,'EMITIDA',NULL,NULL,NULL),
(17,1017,'A','2025-11-08 10:00:00',10,1,1,410.00,0.00,410.00,'EMITIDA',NULL,NULL,NULL),
(18,1018,'A','2025-11-08 14:30:00',11,1,1,185.00,0.00,185.00,'EMITIDA',NULL,NULL,NULL),
(19,1019,'A','2025-11-09 11:20:00',1,1,2,950.00,0.00,950.00,'EMITIDA',NULL,NULL,NULL),
(20,1020,'A','2025-11-09 15:45:00',11,1,2,190.00,0.00,190.00,'EMITIDA',NULL,NULL,NULL),
(21,1021,'A','2025-11-10 09:30:00',2,1,1,825.00,0.00,825.00,'EMITIDA',NULL,NULL,NULL),
(22,1022,'A','2025-11-10 13:15:00',11,1,1,343.00,0.00,343.00,'EMITIDA',NULL,NULL,NULL),
(23,1023,'A','2025-11-11 10:45:00',3,1,1,590.00,0.00,590.00,'EMITIDA',NULL,NULL,NULL),
(24,1024,'A','2025-11-11 16:00:00',11,1,1,200.00,0.00,200.00,'EMITIDA',NULL,NULL,NULL),
(25,1025,'A','2025-11-12 11:30:00',4,1,2,725.00,0.00,725.00,'EMITIDA',NULL,NULL,NULL),
(26,1026,'A','2025-11-12 15:00:00',11,1,2,245.00,0.00,245.00,'EMITIDA',NULL,NULL,NULL),
(27,1027,'A','2025-11-13 09:15:00',5,1,1,875.00,0.00,875.00,'EMITIDA',NULL,NULL,NULL),
(28,1028,'A','2025-11-13 14:20:00',11,1,1,118.00,0.00,118.00,'EMITIDA',NULL,NULL,NULL),
(29,1029,'A','2025-11-14 10:00:00',6,1,1,640.00,0.00,640.00,'EMITIDA',NULL,NULL,NULL),
(30,1030,'A','2025-11-14 17:15:00',11,1,1,175.00,0.00,175.00,'EMITIDA',NULL,NULL,NULL),
(31,1031,'A','2025-11-15 11:00:00',7,1,2,470.00,0.00,470.00,'EMITIDA',NULL,NULL,NULL),
(32,1032,'A','2025-11-15 15:30:00',11,1,2,265.00,0.00,265.00,'EMITIDA',NULL,NULL,NULL),
(33,1033,'A','2025-11-16 09:45:00',8,1,1,825.00,0.00,825.00,'EMITIDA',NULL,NULL,NULL),
(34,1034,'A','2025-11-16 14:00:00',11,1,1,205.00,0.00,205.00,'EMITIDA',NULL,NULL,NULL),
(35,1035,'A','2025-11-17 10:30:00',9,1,1,550.00,0.00,550.00,'EMITIDA',NULL,NULL,NULL),
(36,1036,'A','2025-11-17 16:15:00',11,1,1,285.00,0.00,285.00,'EMITIDA',NULL,NULL,NULL),
(37,1037,'A','2025-11-18 11:20:00',10,1,2,680.00,0.00,680.00,'EMITIDA',NULL,NULL,NULL),
(38,1038,'A','2025-11-18 15:45:00',11,1,2,190.00,0.00,190.00,'EMITIDA',NULL,NULL,NULL),
(39,1039,'A','2025-11-19 09:00:00',1,1,1,750.00,0.00,750.00,'EMITIDA',NULL,NULL,NULL),
(40,1040,'A','2025-11-19 13:30:00',11,1,1,225.00,0.00,225.00,'EMITIDA',NULL,NULL,NULL),
(41,1041,'A','2025-11-20 10:15:00',2,1,1,850.00,0.00,850.00,'EMITIDA',NULL,NULL,NULL),
(42,1042,'A','2025-11-20 14:45:00',11,1,1,165.00,0.00,165.00,'EMITIDA',NULL,NULL,NULL),
(43,1043,'A','2025-11-21 11:00:00',3,1,2,520.00,0.00,520.00,'EMITIDA',NULL,NULL,NULL),
(44,1044,'A','2025-11-21 16:30:00',11,1,2,275.00,0.00,275.00,'EMITIDA',NULL,NULL,NULL),
(45,1045,'A','2025-11-22 09:30:00',4,1,1,610.00,0.00,610.00,'EMITIDA',NULL,NULL,NULL),
(46,1046,'A','2025-11-22 15:00:00',11,1,1,245.00,0.00,245.00,'EMITIDA',NULL,NULL,NULL),
(47,1047,'A','2025-11-23 10:45:00',5,1,1,825.00,0.00,825.00,'EMITIDA',NULL,NULL,NULL),
(48,1048,'A','2025-11-23 14:30:00',11,1,1,100.00,0.00,100.00,'EMITIDA',NULL,NULL,NULL),
(49,1049,'A','2025-11-24 11:15:00',6,1,2,700.00,0.00,700.00,'EMITIDA',NULL,NULL,NULL),
(50,1050,'A','2025-11-24 16:00:00',11,1,2,185.00,0.00,185.00,'EMITIDA',NULL,NULL,NULL),
(51,1051,'A','2025-11-25 09:00:00',7,1,1,875.00,0.00,875.00,'EMITIDA',NULL,NULL,NULL),
(52,1052,'A','2025-11-25 13:45:00',11,1,1,195.00,0.00,195.00,'EMITIDA',NULL,NULL,NULL),
(53,1053,'A','2025-11-26 10:30:00',8,1,1,530.00,0.00,530.00,'EMITIDA',NULL,NULL,NULL),
(54,1054,'A','2025-11-26 15:20:00',11,1,1,265.00,0.00,265.00,'EMITIDA',NULL,NULL,NULL),
(55,1055,'A','2025-11-27 11:00:00',9,1,2,660.00,0.00,660.00,'EMITIDA',NULL,NULL,NULL),
(56,1056,'A','2025-11-27 16:45:00',11,1,2,200.00,0.00,200.00,'EMITIDA',NULL,NULL,NULL),
(57,1057,'A','2025-11-28 09:15:00',10,1,1,825.00,0.00,825.00,'EMITIDA',NULL,NULL,NULL),
(58,1058,'A','2025-11-28 14:00:00',11,1,1,175.00,0.00,175.00,'EMITIDA',NULL,NULL,NULL),
(59,1059,'A','2025-11-29 10:00:00',1,1,1,750.00,0.00,750.00,'EMITIDA',NULL,NULL,NULL),
(60,1060,'A','2025-11-29 15:30:00',11,1,1,225.00,0.00,225.00,'EMITIDA',NULL,NULL,NULL),
(61,1061,'A','2025-11-30 11:30:00',2,1,2,850.00,0.00,850.00,'EMITIDA',NULL,NULL,NULL),
(62,1062,'A','2025-11-30 16:00:00',11,1,2,190.00,0.00,190.00,'EMITIDA',NULL,NULL,NULL);
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `inventariosucursal`
--

DROP TABLE IF EXISTS `inventariosucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventariosucursal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sucursal_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `existencia` int(11) NOT NULL DEFAULT 0,
  `minimo` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_sucursal_producto` (`sucursal_id`,`producto_presentacion_id`),
  KEY `idx_inventario_sucursal` (`sucursal_id`),
  KEY `idx_inventario_producto` (`producto_presentacion_id`),
  KEY `idx_inventario_existencia` (`existencia`),
  KEY `idx_inventario_alerta` (`existencia`,`minimo`),
  CONSTRAINT `fk_inventario_producto_presentacion` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `productopresentacion` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_inventario_sucursal` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stock actual de productos por sucursal';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventariosucursal`
--

LOCK TABLES `inventariosucursal` WRITE;
/*!40000 ALTER TABLE `inventariosucursal` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `inventariosucursal` VALUES
(1,1,1,150,0),
(2,1,2,80,0),
(3,1,3,50,0),
(4,1,4,100,0),
(5,1,5,60,0),
(6,1,6,90,0),
(7,1,7,45,0),
(8,1,8,70,0),
(9,1,9,35,0),
(10,1,10,60,0),
(11,1,11,30,0),
(12,1,12,80,0),
(13,1,13,40,0),
(14,1,14,25,0),
(15,1,15,50,0),
(16,1,16,25,0),
(17,1,17,45,0),
(18,1,18,20,0),
(19,1,19,40,0),
(20,1,20,35,0),
(21,1,21,30,0),
(22,1,22,55,0),
(23,1,23,28,0),
(24,1,24,15,0),
(25,1,25,65,0),
(26,1,26,32,0),
(27,1,27,75,0),
(28,1,28,38,0),
(29,1,29,60,0),
(30,1,30,30,0),
(31,2,1,120,0),
(32,2,2,65,0),
(33,2,3,40,0),
(34,2,4,85,0),
(35,2,5,50,0),
(36,2,6,75,0),
(37,2,7,38,0),
(38,2,8,60,0),
(39,2,9,30,0),
(40,2,10,50,0),
(41,2,11,25,0),
(42,2,12,65,0),
(43,2,13,32,0),
(44,2,14,20,0),
(45,2,15,40,0),
(46,2,16,20,0),
(47,2,17,38,0),
(48,2,18,18,0),
(49,2,19,32,0),
(50,2,20,28,0),
(51,2,21,25,0),
(52,2,22,45,0),
(53,2,23,22,0),
(54,2,24,12,0),
(55,2,25,55,0),
(56,2,26,28,0),
(57,2,27,62,0),
(58,2,28,31,0),
(59,2,29,50,0),
(60,2,30,25,0);
/*!40000 ALTER TABLE `inventariosucursal` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `marcas`
--

DROP TABLE IF EXISTS `marcas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(80) NOT NULL,
  `activa` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  UNIQUE KEY `nombre_2` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marcas`
--

LOCK TABLES `marcas` WRITE;
/*!40000 ALTER TABLE `marcas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `marcas` VALUES
(1,'Sherwin Williams',1),
(2,'Comex',1),
(3,'Berel',1),
(4,'Pintuco',1);
/*!40000 ALTER TABLE `marcas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `migrations` VALUES
(1,'2025_10_24_015610_create_CampaniaAdjuntos_table',0),
(2,'2025_10_24_015610_create_CampaniaDestinatarios_table',0),
(3,'2025_10_24_015610_create_Campanias_table',0),
(4,'2025_10_24_015610_create_CarritoItems_table',0),
(5,'2025_10_24_015610_create_Carritos_table',0),
(6,'2025_10_24_015610_create_Categorias_table',0),
(7,'2025_10_24_015610_create_Clientes_table',0),
(8,'2025_10_24_015610_create_Cotizaciones_table',0),
(9,'2025_10_24_015610_create_DetalleCotizacion_table',0),
(10,'2025_10_24_015610_create_DetalleFactura_table',0),
(11,'2025_10_24_015610_create_DetalleIngreso_table',0),
(12,'2025_10_24_015610_create_Facturas_table',0),
(13,'2025_10_24_015610_create_Ingresos_table',0),
(14,'2025_10_24_015610_create_InventarioSucursal_table',0),
(15,'2025_10_24_015610_create_LogsSistema_table',0),
(16,'2025_10_24_015610_create_Marcas_table',0),
(17,'2025_10_24_015610_create_MediosPago_table',0),
(18,'2025_10_24_015610_create_Pagos_table',0),
(19,'2025_10_24_015610_create_Presentaciones_table',0),
(20,'2025_10_24_015610_create_ProductoPresentacion_table',0),
(21,'2025_10_24_015610_create_ProductoProveedor_table',0),
(22,'2025_10_24_015610_create_Productos_table',0),
(23,'2025_10_24_015610_create_Proveedores_table',0),
(24,'2025_10_24_015610_create_Roles_table',0),
(25,'2025_10_24_015610_create_Sucursales_table',0),
(26,'2025_10_24_015610_create_Usuarios_table',0),
(27,'2025_10_24_015610_create_categorias_table',0),
(28,'2025_10_24_015610_create_clientes_table',0),
(29,'2025_10_24_015610_create_detalle_orden_compra_table',0),
(30,'2025_10_24_015610_create_detalle_recepciones_table',0),
(31,'2025_10_24_015610_create_detallefactura_table',0),
(32,'2025_10_24_015610_create_facturas_table',0),
(33,'2025_10_24_015610_create_inventariosucursal_table',0),
(34,'2025_10_24_015610_create_marcas_table',0),
(35,'2025_10_24_015610_create_movimientosinventario_table',0),
(36,'2025_10_24_015610_create_ordenes_compra_table',0),
(37,'2025_10_24_015610_create_pagos_table',0),
(38,'2025_10_24_015610_create_precios_table',0),
(39,'2025_10_24_015610_create_presentaciones_table',0),
(40,'2025_10_24_015610_create_productopresentacion_table',0),
(41,'2025_10_24_015610_create_productos_table',0),
(42,'2025_10_24_015610_create_proveedores_table',0),
(43,'2025_10_24_015610_create_recepciones_table',0),
(44,'2025_10_24_015610_create_roles_table',0),
(45,'2025_10_24_015610_create_secuencias_facturas_table',0),
(46,'2025_10_24_015610_create_sucursales_table',0),
(47,'2025_10_24_015610_create_usuarios_table',0),
(48,'2025_10_24_015613_add_foreign_keys_to_CampaniaAdjuntos_table',0),
(49,'2025_10_24_015613_add_foreign_keys_to_CampaniaDestinatarios_table',0),
(50,'2025_10_24_015613_add_foreign_keys_to_Campanias_table',0),
(51,'2025_10_24_015613_add_foreign_keys_to_CarritoItems_table',0),
(52,'2025_10_24_015613_add_foreign_keys_to_Carritos_table',0),
(53,'2025_10_24_015613_add_foreign_keys_to_Cotizaciones_table',0),
(54,'2025_10_24_015613_add_foreign_keys_to_DetalleCotizacion_table',0),
(55,'2025_10_24_015613_add_foreign_keys_to_DetalleFactura_table',0),
(56,'2025_10_24_015613_add_foreign_keys_to_DetalleIngreso_table',0),
(57,'2025_10_24_015613_add_foreign_keys_to_Facturas_table',0),
(58,'2025_10_24_015613_add_foreign_keys_to_Ingresos_table',0),
(59,'2025_10_24_015613_add_foreign_keys_to_InventarioSucursal_table',0),
(60,'2025_10_24_015613_add_foreign_keys_to_LogsSistema_table',0),
(61,'2025_10_24_015613_add_foreign_keys_to_Pagos_table',0),
(62,'2025_10_24_015613_add_foreign_keys_to_ProductoPresentacion_table',0),
(63,'2025_10_24_015613_add_foreign_keys_to_ProductoProveedor_table',0),
(64,'2025_10_24_015613_add_foreign_keys_to_Productos_table',0),
(65,'2025_10_24_015613_add_foreign_keys_to_Usuarios_table',0),
(66,'2025_10_24_015613_add_foreign_keys_to_detalle_orden_compra_table',0),
(67,'2025_10_24_015613_add_foreign_keys_to_detalle_recepciones_table',0),
(68,'2025_10_24_015613_add_foreign_keys_to_detallefactura_table',0),
(69,'2025_10_24_015613_add_foreign_keys_to_facturas_table',0),
(70,'2025_10_24_015613_add_foreign_keys_to_inventariosucursal_table',0),
(71,'2025_10_24_015613_add_foreign_keys_to_movimientosinventario_table',0),
(72,'2025_10_24_015613_add_foreign_keys_to_ordenes_compra_table',0),
(73,'2025_10_24_015613_add_foreign_keys_to_pagos_table',0),
(74,'2025_10_24_015613_add_foreign_keys_to_precios_table',0),
(75,'2025_10_24_015613_add_foreign_keys_to_productopresentacion_table',0),
(76,'2025_10_24_015613_add_foreign_keys_to_productos_table',0),
(77,'2025_10_24_015613_add_foreign_keys_to_recepciones_table',0),
(78,'2025_10_24_015613_add_foreign_keys_to_usuarios_table',0),
(79,'0001_01_01_000000_create_users_table',1),
(80,'0001_01_01_000001_create_cache_table',1),
(81,'0001_01_01_000002_create_jobs_table',1),
(82,'2025_10_25_052759_create_producto_presentacion_table',2),
(83,'2025_10_25_060634_add_password_reset_fields_to_usuarios_table',3);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `movimientosinventario`
--

DROP TABLE IF EXISTS `movimientosinventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimientosinventario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sucursal_id` int(11) NOT NULL,
  `producto_presentacion_id` int(11) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `referencia` varchar(60) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_movimientos_sucursal` (`sucursal_id`),
  KEY `idx_movimientos_producto` (`producto_presentacion_id`),
  KEY `idx_movimientos_tipo` (`tipo`),
  KEY `idx_movimientos_fecha` (`created_at`),
  KEY `idx_movimientos_consulta` (`sucursal_id`,`tipo`,`created_at`),
  KEY `idx_movimientos_producto_fecha` (`producto_presentacion_id`,`created_at`),
  CONSTRAINT `fk_movimientos_producto_presentacion` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `productopresentacion` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_movimientos_sucursal` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `chk_tipo_movimiento` CHECK (`tipo` in ('COMPRA','VENTA','AJUSTE','TRASLADO_ENTRADA','TRASLADO_SALIDA','DEVOLUCION'))
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Historial de todos los movimientos de inventario';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientosinventario`
--

LOCK TABLES `movimientosinventario` WRITE;
/*!40000 ALTER TABLE `movimientosinventario` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `movimientosinventario` VALUES
(1,1,1,'COMPRA',200,'Recepción OC-10','2025-11-05 18:02:39'),
(2,1,1,'VENTA',-5,'Factura A-14','2025-11-05 21:12:05'),
(3,1,1,'VENTA',-3,'Factura A-15','2025-11-05 23:12:25'),
(4,1,1,'VENTA',-24,'Factura A-16','2025-11-06 01:54:46'),
(5,1,1,'COMPRA',80,'Recepción OC-11','2025-11-06 02:00:44'),
(6,1,1,'COMPRA',20,'Recepción OC-11','2025-11-06 02:01:04'),
(7,4,1,'COMPRA',50,'Recepción OC-12','2025-11-07 00:26:18'),
(8,3,1,'COMPRA',50,'Recepción OC-12','2025-11-07 00:27:00'),
(15,1,1,'VENTA',-3,'Pedido Web #1','2025-11-10 15:14:51'),
(16,1,1,'VENTA',-1,'Pedido Web #2','2025-11-10 15:31:06'),
(17,1,2,'COMPRA',50,'Recepción OC-13','2025-11-22 05:35:28'),
(18,1,3,'COMPRA',90,'Recepción OC-13','2025-11-22 05:35:28');
/*!40000 ALTER TABLE `movimientosinventario` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ordenes_compra`
--

DROP TABLE IF EXISTS `ordenes_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordenes_compra` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` int(11) NOT NULL,
  `serie` varchar(10) NOT NULL DEFAULT 'OC',
  `proveedor_id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_orden` date NOT NULL,
  `fecha_entrega_estimada` date DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `estado` enum('PENDIENTE','PARCIAL','RECIBIDA','CANCELADA') NOT NULL DEFAULT 'PENDIENTE',
  `observaciones` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_orden` (`numero`,`serie`),
  KEY `idx_ordenes_proveedor` (`proveedor_id`),
  KEY `idx_ordenes_sucursal` (`sucursal_id`),
  KEY `idx_ordenes_usuario` (`usuario_id`),
  KEY `idx_ordenes_fecha` (`fecha_orden`),
  KEY `idx_ordenes_estado` (`estado`),
  KEY `idx_ordenes_numero_serie` (`numero`,`serie`),
  CONSTRAINT `fk_ordenes_proveedor` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ordenes_sucursal` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ordenes_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Órdenes de compra a proveedores';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordenes_compra`
--

LOCK TABLES `ordenes_compra` WRITE;
/*!40000 ALTER TABLE `ordenes_compra` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ordenes_compra` VALUES
(1,10,'OC',2,1,1,'2025-11-04','2025-11-05',14000.00,0.00,14000.00,'RECIBIDA',NULL,'2025-11-05 18:02:24','2025-11-05 18:02:39'),
(2,11,'OC',3,1,1,'2025-11-03','2025-11-06',8000.00,0.00,8000.00,'RECIBIDA','NInguna','2025-11-06 02:00:32','2025-11-06 02:01:04'),
(3,12,'OC',2,1,1,'2025-11-05','2025-11-06',8000.00,0.00,8000.00,'RECIBIDA','ninguna','2025-11-07 00:25:28','2025-11-07 00:27:00'),
(4,13,'OC',2,1,1,'2025-11-19','2025-11-21',5100.00,0.00,5100.00,'RECIBIDA',NULL,'2025-11-22 05:35:18','2025-11-22 05:35:28');
/*!40000 ALTER TABLE `ordenes_compra` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `factura_id` int(11) DEFAULT NULL COMMENT 'ID de la factura (para ventas en POS)',
  `pedido_id` int(11) DEFAULT NULL COMMENT 'ID del pedido (para ventas en línea)',
  `tipo` enum('EFECTIVO','TARJETA_DEBITO','TARJETA_CREDITO','CHEQUE','TRANSFERENCIA','DEPOSITO') NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `referencia` varchar(80) DEFAULT NULL COMMENT 'Número de cheque, voucher, etc.',
  `entidad` varchar(80) DEFAULT NULL COMMENT 'Banco o procesador de pago',
  `transaccion_gateway_id` varchar(80) DEFAULT NULL COMMENT 'ID de transacción del gateway',
  `autorizado_por` varchar(120) DEFAULT NULL COMMENT 'Persona que autorizó el pago',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pagos_factura` (`factura_id`),
  KEY `idx_pagos_tipo` (`tipo`),
  KEY `idx_pagos_fecha` (`created_at`),
  KEY `idx_pagos_entidad` (`entidad`),
  CONSTRAINT `fk_pagos_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `CONSTRAINT_1` CHECK (`monto` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pagos recibidos por factura (permite múltiples pagos por factura)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `pagos` VALUES
(1,1,NULL,'EFECTIVO',555.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(2,2,NULL,'EFECTIVO',185.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(3,3,NULL,'TARJETA_DEBITO',825.00,'VISA-1234',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(4,4,NULL,'EFECTIVO',370.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(5,5,NULL,'TARJETA_CREDITO',450.00,'MC-5678',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(6,6,NULL,'EFECTIVO',600.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(7,7,NULL,'EFECTIVO',285.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(8,8,NULL,'EFECTIVO',195.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(9,9,NULL,'TRANSFERENCIA',1650.00,'TRANSF-001',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(10,10,NULL,'EFECTIVO',100.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(11,11,NULL,'TARJETA_DEBITO',530.00,'VISA-2345',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(12,12,NULL,'EFECTIVO',225.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(13,13,NULL,'EFECTIVO',570.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(14,14,NULL,'EFECTIVO',380.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(15,15,NULL,'TARJETA_CREDITO',850.00,'MC-6789',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(16,16,NULL,'EFECTIVO',265.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(17,17,NULL,'EFECTIVO',410.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(18,18,NULL,'EFECTIVO',185.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(19,19,NULL,'TRANSFERENCIA',950.00,'TRANSF-002',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(20,20,NULL,'EFECTIVO',190.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(21,21,NULL,'TARJETA_DEBITO',825.00,'VISA-3456',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(22,22,NULL,'EFECTIVO',343.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(23,23,NULL,'EFECTIVO',590.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(24,24,NULL,'EFECTIVO',200.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(25,25,NULL,'TARJETA_CREDITO',725.00,'MC-7890',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(26,26,NULL,'EFECTIVO',245.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(27,27,NULL,'TARJETA_DEBITO',875.00,'VISA-4567',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(28,28,NULL,'EFECTIVO',118.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(29,29,NULL,'EFECTIVO',640.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(30,30,NULL,'EFECTIVO',175.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(31,31,NULL,'EFECTIVO',470.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(32,32,NULL,'EFECTIVO',265.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(33,33,NULL,'TRANSFERENCIA',825.00,'TRANSF-003',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(34,34,NULL,'EFECTIVO',205.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(35,35,NULL,'EFECTIVO',550.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(36,36,NULL,'EFECTIVO',285.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(37,37,NULL,'TARJETA_CREDITO',680.00,'MC-8901',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(38,38,NULL,'EFECTIVO',190.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(39,39,NULL,'TARJETA_DEBITO',750.00,'VISA-5678',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(40,40,NULL,'EFECTIVO',225.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(41,41,NULL,'TARJETA_CREDITO',850.00,'MC-9012',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(42,42,NULL,'EFECTIVO',165.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(43,43,NULL,'EFECTIVO',520.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(44,44,NULL,'EFECTIVO',275.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(45,45,NULL,'EFECTIVO',610.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(46,46,NULL,'EFECTIVO',245.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(47,47,NULL,'TRANSFERENCIA',825.00,'TRANSF-004',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(48,48,NULL,'EFECTIVO',100.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(49,49,NULL,'TARJETA_DEBITO',700.00,'VISA-6789',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(50,50,NULL,'EFECTIVO',185.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(51,51,NULL,'TARJETA_CREDITO',875.00,'MC-0123',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(52,52,NULL,'EFECTIVO',195.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(53,53,NULL,'EFECTIVO',530.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(54,54,NULL,'EFECTIVO',265.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(55,55,NULL,'TARJETA_DEBITO',660.00,'VISA-7890',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(56,56,NULL,'EFECTIVO',200.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(57,57,NULL,'TRANSFERENCIA',825.00,'TRANSF-005',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(58,58,NULL,'EFECTIVO',175.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(59,59,NULL,'EFECTIVO',750.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(60,60,NULL,'EFECTIVO',225.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43'),
(61,61,NULL,'TARJETA_CREDITO',850.00,'MC-1234',NULL,NULL,NULL,'2025-11-22 06:27:43'),
(62,62,NULL,'EFECTIVO',190.00,NULL,NULL,NULL,NULL,'2025-11-22 06:27:43');
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` int(11) NOT NULL COMMENT 'Número correlativo del pedido',
  `fecha_pedido` datetime NOT NULL,
  `cliente_id` int(11) DEFAULT NULL COMMENT 'ID del cliente si está registrado',
  `nombre_cliente` varchar(120) NOT NULL COMMENT 'Nombre completo del comprador',
  `email_cliente` varchar(80) NOT NULL COMMENT 'Email para notificaciones',
  `telefono_cliente` varchar(20) NOT NULL COMMENT 'Teléfono de contacto',
  `nit_cliente` varchar(20) DEFAULT 'CF' COMMENT 'NIT del cliente para facturación',
  `direccion_envio` text NOT NULL COMMENT 'Dirección completa de entrega',
  `ciudad_envio` varchar(80) NOT NULL,
  `departamento_envio` varchar(80) NOT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `referencias_direccion` text DEFAULT NULL COMMENT 'Referencias adicionales para encontrar la dirección',
  `sucursal_id` int(11) NOT NULL COMMENT 'Sucursal desde donde se enviará',
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `descuento_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `estado` enum('PENDIENTE','CONFIRMADO','EN_PREPARACION','ENVIADO','ENTREGADO','CANCELADO') NOT NULL DEFAULT 'PENDIENTE' COMMENT 'Estado actual del pedido',
  `estado_pago` enum('PENDIENTE','PAGADO','RECHAZADO','REEMBOLSADO') NOT NULL DEFAULT 'PENDIENTE',
  `factura_id` int(11) DEFAULT NULL COMMENT 'Factura generada cuando se confirma el pedido',
  `cancelado_fecha` datetime DEFAULT NULL,
  `motivo_cancelacion` text DEFAULT NULL,
  `notas_cliente` text DEFAULT NULL COMMENT 'Notas o instrucciones del cliente',
  `notas_internas` text DEFAULT NULL COMMENT 'Notas internas del personal',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_pedido_numero` (`numero`),
  KEY `cliente_id` (`cliente_id`),
  KEY `factura_id` (`factura_id`),
  KEY `idx_pedido_email` (`email_cliente`),
  KEY `idx_pedido_estado` (`estado`),
  KEY `idx_pedido_sucursal` (`sucursal_id`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`),
  CONSTRAINT `pedidos_ibfk_3` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `pedidos` VALUES
(7,1,'2025-11-10 15:14:51',NULL,'Carlos Garcia','luiscolop90@gmail.com','54345516','CF','xela','Quetzaltenango','Quetzaltenango',NULL,NULL,1,300.00,0.00,300.00,'PENDIENTE','PENDIENTE',NULL,NULL,NULL,NULL,NULL,'2025-11-10 15:14:51','2025-11-10 15:14:51'),
(8,2,'2025-11-10 15:31:06',NULL,'Carlos Garcia','lufpilufpi47@gmail.com','54345516','CF','XEla','Quetzaltenango','Quetzaltenango',NULL,NULL,1,100.00,0.00,100.00,'PENDIENTE','PENDIENTE',NULL,NULL,NULL,NULL,NULL,'2025-11-10 15:31:06','2025-11-10 15:31:06');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `precios`
--

DROP TABLE IF EXISTS `precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `precios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producto_presentacion_id` int(11) NOT NULL,
  `sucursal_id` int(11) DEFAULT NULL,
  `precio_venta` decimal(12,2) NOT NULL,
  `descuento_pct` decimal(5,2) DEFAULT 0.00,
  `vigente_desde` datetime NOT NULL DEFAULT current_timestamp(),
  `vigente_hasta` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `stock_minimo` int(11) DEFAULT 0 COMMENT 'Stock mínimo configurado para esta presentación en esta sucursal',
  PRIMARY KEY (`id`),
  KEY `idx_precios_producto_presentacion` (`producto_presentacion_id`),
  KEY `idx_precios_sucursal` (`sucursal_id`),
  KEY `idx_precios_vigencia` (`vigente_desde`,`vigente_hasta`),
  KEY `idx_precios_activo` (`activo`),
  KEY `idx_precios_consulta` (`producto_presentacion_id`,`sucursal_id`,`vigente_desde`),
  CONSTRAINT `fk_precios_producto_presentacion` FOREIGN KEY (`producto_presentacion_id`) REFERENCES `productopresentacion` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_precios_sucursal` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `chk_stock_minimo` CHECK (`stock_minimo` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Precios de productos por sucursal con vigencia temporal';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `precios`
--

LOCK TABLES `precios` WRITE;
/*!40000 ALTER TABLE `precios` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `precios` VALUES
(1,1,1,185.00,0.00,'2025-11-01 00:00:00',NULL,1,20),
(2,1,2,185.00,0.00,'2025-11-01 00:00:00',NULL,1,15),
(3,2,1,95.00,0.00,'2025-11-01 00:00:00',NULL,1,10),
(4,2,2,95.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(5,3,1,50.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(6,3,2,50.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(7,4,1,190.00,0.00,'2025-11-01 00:00:00',NULL,1,15),
(8,4,2,190.00,0.00,'2025-11-01 00:00:00',NULL,1,12),
(9,5,1,98.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(10,5,2,98.00,0.00,'2025-11-01 00:00:00',NULL,1,6),
(11,6,1,195.00,0.00,'2025-11-01 00:00:00',NULL,1,12),
(12,6,2,195.00,0.00,'2025-11-01 00:00:00',NULL,1,10),
(13,7,1,100.00,0.00,'2025-11-01 00:00:00',NULL,1,6),
(14,7,2,100.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(15,8,1,200.00,0.00,'2025-11-01 00:00:00',NULL,1,10),
(16,8,2,200.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(17,9,1,105.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(18,9,2,105.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(19,10,1,205.00,0.00,'2025-11-01 00:00:00',NULL,1,10),
(20,10,2,205.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(21,11,1,108.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(22,11,2,108.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(23,12,1,265.00,0.00,'2025-11-01 00:00:00',NULL,1,12),
(24,12,2,265.00,0.00,'2025-11-01 00:00:00',NULL,1,10),
(25,13,1,138.00,0.00,'2025-11-01 00:00:00',NULL,1,6),
(26,13,2,138.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(27,14,1,72.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(28,14,2,72.00,0.00,'2025-11-01 00:00:00',NULL,1,3),
(29,15,1,275.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(30,15,2,275.00,0.00,'2025-11-01 00:00:00',NULL,1,6),
(31,16,1,143.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(32,16,2,143.00,0.00,'2025-11-01 00:00:00',NULL,1,3),
(33,17,1,285.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(34,17,2,285.00,0.00,'2025-11-01 00:00:00',NULL,1,6),
(35,18,1,148.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(36,18,2,148.00,0.00,'2025-11-01 00:00:00',NULL,1,3),
(37,19,1,825.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(38,19,2,825.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(39,20,1,850.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(40,20,2,850.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(41,21,1,875.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(42,21,2,875.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(43,22,1,225.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(44,22,2,225.00,0.00,'2025-11-01 00:00:00',NULL,1,6),
(45,23,1,118.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(46,23,2,118.00,0.00,'2025-11-01 00:00:00',NULL,1,3),
(47,24,1,62.00,0.00,'2025-11-01 00:00:00',NULL,1,2),
(48,24,2,62.00,0.00,'2025-11-01 00:00:00',NULL,1,2),
(49,25,1,245.00,0.00,'2025-11-01 00:00:00',NULL,1,10),
(50,25,2,245.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(51,26,1,128.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(52,26,2,128.00,0.00,'2025-11-01 00:00:00',NULL,1,4),
(53,27,1,165.00,0.00,'2025-11-01 00:00:00',NULL,1,12),
(54,27,2,165.00,0.00,'2025-11-01 00:00:00',NULL,1,10),
(55,28,1,88.00,0.00,'2025-11-01 00:00:00',NULL,1,6),
(56,28,2,88.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(57,29,1,175.00,0.00,'2025-11-01 00:00:00',NULL,1,10),
(58,29,2,175.00,0.00,'2025-11-01 00:00:00',NULL,1,8),
(59,30,1,92.00,0.00,'2025-11-01 00:00:00',NULL,1,5),
(60,30,2,92.00,0.00,'2025-11-01 00:00:00',NULL,1,4);
/*!40000 ALTER TABLE `precios` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `presentaciones`
--

DROP TABLE IF EXISTS `presentaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `presentaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(40) NOT NULL,
  `unidad_base` varchar(20) DEFAULT NULL,
  `factor_galon` decimal(10,5) DEFAULT NULL COMMENT 'Factor de conversión a galones',
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presentaciones`
--

LOCK TABLES `presentaciones` WRITE;
/*!40000 ALTER TABLE `presentaciones` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `presentaciones` VALUES
(1,'1 Galón','Galones',1.00000,1),
(2,'1/4 Galón','Galones',0.25000,1),
(3,'4 Litros','Litros',1.05700,1),
(4,'Cubeta 19 Litros','Litros',5.01900,1),
(5,'Tambor 200 Litros','Litros',52.83400,1),
(6,'1 Litro','Litros',0.26417,1),
(7,'1/2 Galón','Galones',0.50000,1),
(8,'Balde 5 Galones',NULL,NULL,1),
(9,'Galón','gl',1.00000,1);
/*!40000 ALTER TABLE `presentaciones` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `producto_presentacion`
--

DROP TABLE IF EXISTS `producto_presentacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto_presentacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producto_id` int(11) NOT NULL,
  `presentacion_id` int(11) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_producto_presentacion` (`producto_id`,`presentacion_id`),
  KEY `idx_producto_id` (`producto_id`),
  KEY `idx_presentacion_id` (`presentacion_id`),
  KEY `idx_activo` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto_presentacion`
--

LOCK TABLES `producto_presentacion` WRITE;
/*!40000 ALTER TABLE `producto_presentacion` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `producto_presentacion` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `productopresentacion`
--

DROP TABLE IF EXISTS `productopresentacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `productopresentacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producto_id` int(11) NOT NULL,
  `presentacion_id` int(11) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_producto_presentacion` (`producto_id`,`presentacion_id`),
  KEY `idx_producto_id` (`producto_id`),
  KEY `idx_presentacion_id` (`presentacion_id`),
  KEY `idx_activo` (`activo`),
  CONSTRAINT `fk_pp_presentacion` FOREIGN KEY (`presentacion_id`) REFERENCES `presentaciones` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pp_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabla intermedia: relaciona productos con sus presentaciones disponibles para venta';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productopresentacion`
--

LOCK TABLES `productopresentacion` WRITE;
/*!40000 ALTER TABLE `productopresentacion` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `productopresentacion` VALUES
(1,4,1,1),
(2,4,2,1),
(3,4,3,1),
(4,5,1,1),
(5,5,2,1),
(6,6,1,1),
(7,6,2,1),
(8,7,1,1),
(9,7,2,1),
(10,8,1,1),
(11,8,2,1),
(12,9,1,1),
(13,9,2,1),
(14,9,3,1),
(15,10,1,1),
(16,10,2,1),
(17,11,1,1),
(18,11,2,1),
(19,12,4,1),
(20,13,4,1),
(21,14,4,1),
(22,15,1,1),
(23,15,2,1),
(24,15,3,1),
(25,16,1,1),
(26,16,2,1),
(27,17,1,1),
(28,17,2,1),
(29,18,1,1),
(30,18,2,1);
/*!40000 ALTER TABLE `productopresentacion` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria_id` int(11) DEFAULT NULL,
  `marca_id` int(11) DEFAULT NULL,
  `codigo_sku` varchar(50) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `tamano` varchar(40) DEFAULT NULL,
  `duracion_anios` int(11) DEFAULT NULL,
  `extension_m2` decimal(10,2) DEFAULT NULL,
  `color` varchar(60) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `imagen_url` varchar(500) DEFAULT NULL COMMENT 'URL de la imagen de presentación del producto en Firebase Storage',
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_sku` (`codigo_sku`),
  KEY `idx_categoria_id` (`categoria_id`),
  KEY `idx_marca_id` (`marca_id`),
  KEY `idx_activo` (`activo`),
  KEY `idx_codigo_sku` (`codigo_sku`),
  CONSTRAINT `fk_productos_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_productos_marca` FOREIGN KEY (`marca_id`) REFERENCES `marcas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `productos` VALUES
(1,1,3,'PINT-100','Pintura Metales 1','1',2,1.00,'Blanco',1,'2025-11-05 18:00:05','2025-11-22 05:30:25','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(2,1,3,'PINT-110','Pintura azul','1 Galon',2,12.00,'Azul',1,'2025-11-22 05:11:27','2025-11-22 05:34:27','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(3,1,3,'PINT-111','Pintura verde','1 Galon',4,12.00,'verde',1,'2025-11-22 05:24:48','2025-11-22 05:34:38','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763789142858.jpeg'),
(4,1,1,'PINT-LAT-BL-01','Pintura Látex Blanco Mate','1 Galón',5,35.00,'Blanco',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(5,1,1,'PINT-LAT-BG-01','Pintura Látex Beige','1 Galón',5,35.00,'Beige',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(6,1,2,'PINT-LAT-GR-01','Pintura Látex Gris Claro','1 Galón',5,35.00,'Gris Claro',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(7,1,2,'PINT-LAT-AZ-01','Pintura Látex Azul Cielo','1 Galón',5,35.00,'Azul Cielo',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(8,1,3,'PINT-LAT-VD-01','Pintura Látex Verde Menta','1 Galón',5,35.00,'Verde Menta',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(9,2,1,'PINT-ACE-BL-01','Esmalte Aceite Blanco Brillante','1 Galón',8,25.00,'Blanco',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(10,2,2,'PINT-ACE-NG-01','Esmalte Aceite Negro Mate','1 Galón',8,25.00,'Negro',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(11,2,3,'PINT-ACE-RJ-01','Esmalte Aceite Rojo Ferrari','1 Galón',8,25.00,'Rojo',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(12,3,1,'PINT-EXT-BL-01','Pintura Exterior Blanco','Cubeta 5 Gal',10,150.00,'Blanco',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(13,3,2,'PINT-EXT-CR-01','Pintura Exterior Crema','Cubeta 5 Gal',10,150.00,'Crema',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(14,3,3,'PINT-EXT-GR-01','Pintura Exterior Gris Piedra','Cubeta 5 Gal',10,150.00,'Gris Piedra',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(15,4,1,'BARN-MAD-NAT-01','Barniz para Madera Natural','1 Galón',3,30.00,'Natural',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(16,4,2,'SELL-PIS-TRP-01','Sellador para Pisos Transparente','1 Galón',5,40.00,'Transparente',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(17,5,1,'PRIM-PAR-BL-01','Primer para Paredes Blanco','1 Galón',0,45.00,'Blanco',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg'),
(18,5,2,'PRIM-MET-GR-01','Anticorrosivo para Metal Gris','1 Galón',0,35.00,'Gris',1,'2025-11-22 06:11:45','2025-11-22 06:11:45','https://storage.googleapis.com/arco21.firebasestorage.app/productos/1763788287692.jpeg');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `razon_social` varchar(200) DEFAULT NULL,
  `nit` varchar(20) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `contacto_principal` varchar(100) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_proveedores_nombre` (`nombre`),
  KEY `idx_proveedores_nit` (`nit`),
  KEY `idx_proveedores_activo` (`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Proveedores de productos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `proveedores` VALUES
(1,'Pinturas ABC S.A.','Pinturas ABC Sociedad Anónima','12345678-9','2234-5678','ventas@pinturasabc.com','Zona 10, Ciudad de Guatemala','Roberto Méndez',1,'2025-10-18 02:24:07','2025-10-18 02:24:07'),
(2,'Distribuidora XYZ','XYZ Distribuidora Limitada','98765432-1','2345-6789','compras@xyz.com','Carretera a El Salvador Km 15','Ana García',1,'2025-10-18 02:24:43','2025-10-18 02:24:43'),
(3,'Importadora Color',NULL,'55555555-5','2456-7890','info@importadoracolor.com','Zona 4, Mixco','Carlos López',1,'2025-10-18 02:24:56','2025-10-18 02:24:56');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `recepciones`
--

DROP TABLE IF EXISTS `recepciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `recepciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orden_compra_id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_recepcion` timestamp NULL DEFAULT current_timestamp(),
  `observaciones` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_recepcion_orden` (`orden_compra_id`),
  KEY `idx_recepcion_sucursal` (`sucursal_id`),
  KEY `idx_recepcion_usuario` (`usuario_id`),
  KEY `idx_recepcion_fecha` (`fecha_recepcion`),
  CONSTRAINT `fk_recepcion_orden` FOREIGN KEY (`orden_compra_id`) REFERENCES `ordenes_compra` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_recepcion_sucursal` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_recepcion_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Recepciones de productos de órdenes de compra';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recepciones`
--

LOCK TABLES `recepciones` WRITE;
/*!40000 ALTER TABLE `recepciones` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `recepciones` VALUES
(1,1,1,1,'2025-11-05 18:02:39','Todo bien'),
(2,2,1,1,'2025-11-06 02:00:44',NULL),
(3,2,1,1,'2025-11-06 02:01:04',NULL),
(4,3,4,1,'2025-11-07 00:26:17','todo bien'),
(5,3,3,1,'2025-11-07 00:27:00',NULL),
(6,4,1,1,'2025-11-22 05:35:28',NULL);
/*!40000 ALTER TABLE `recepciones` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `roles` VALUES
(1,'Administrador'),
(5,'Bodeguero'),
(4,'Cajero'),
(2,'Gerente'),
(6,'Supervisor'),
(3,'Vendedor');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `secuencias_facturas`
--

DROP TABLE IF EXISTS `secuencias_facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `secuencias_facturas` (
  `serie` varchar(10) NOT NULL,
  `ultimo_numero` int(11) NOT NULL DEFAULT 0,
  `descripcion` varchar(100) DEFAULT NULL,
  `activa` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`serie`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secuencias_facturas`
--

LOCK TABLES `secuencias_facturas` WRITE;
/*!40000 ALTER TABLE `secuencias_facturas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `secuencias_facturas` VALUES
('A',16,'Facturas generales',1),
('B',0,'Facturas corporativas',0),
('OC',13,'Órdenes de Compra',1);
/*!40000 ALTER TABLE `secuencias_facturas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `secuencias_pedidos`
--

DROP TABLE IF EXISTS `secuencias_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `secuencias_pedidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ultimo_numero` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secuencias_pedidos`
--

LOCK TABLES `secuencias_pedidos` WRITE;
/*!40000 ALTER TABLE `secuencias_pedidos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `secuencias_pedidos` VALUES
(1,2,'2025-11-10 07:55:10','2025-11-10 15:31:06');
/*!40000 ALTER TABLE `secuencias_pedidos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `sessions` VALUES
('Pw8BJeJuxQHQHTiHrJXqtTzzN4BRzggU3UHPldSR',NULL,'127.0.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZlpsQllNQkUzR1p5R1FvU1d4eThjUG5pWk9CaTVmOUxnUUVDMVJOSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1761345294);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sucursales`
--

DROP TABLE IF EXISTS `sucursales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sucursales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `gps_lat` decimal(10,6) DEFAULT NULL,
  `gps_lng` decimal(10,6) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `activa` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursales`
--

LOCK TABLES `sucursales` WRITE;
/*!40000 ALTER TABLE `sucursales` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `sucursales` VALUES
(1,'Centro Xela','14 Avenida 3-51 Zona 1, Quetzaltenango',14.833300,-91.516700,'7765-4321',1),
(2,'Periférico Xela','Km 210 Carretera Interamericana',14.850000,-91.480000,'7765-5555',1),
(3,'Totonicapán','8 Calle 7-22 Zona 1, Totonicapán',14.916700,-91.366700,'7766-1234',1),
(4,'San Marcos','5 Avenida 10-50 Zona 1, San Marcos',14.966700,-91.783300,'7760-9876',1),
(5,'Sucursal Polanco','Av. Masaryk 111, Polanco, CDMX',19.432600,-99.193200,'555-1234-5678',1);
/*!40000 ALTER TABLE `sucursales` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `dpi` varchar(20) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol_id` int(11) NOT NULL,
  `sucursal_id` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `ultimo_acceso` datetime DEFAULT NULL,
  `reset_token` varchar(500) DEFAULT NULL,
  `reset_token_expira` datetime DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `dpi` (`dpi`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_usuarios_rol` (`rol_id`),
  KEY `idx_usuarios_sucursal` (`sucursal_id`),
  KEY `idx_usuarios_email` (`email`),
  KEY `idx_usuarios_dpi` (`dpi`),
  KEY `idx_usuarios_activo` (`activo`),
  CONSTRAINT `fk_usuarios_rol` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_usuarios_sucursal` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `usuarios` VALUES
(1,'Juan Pérez','2545123450101','juan@pinturas.com','$2b$10$L22S.szFzMhCPatqYTZCoeVzOOLVaRfpIMMValUd2bBklTqanwGCK',1,NULL,1,NULL,NULL,NULL,'2025-10-15 06:20:50'),
(2,'Admin Test','1234567890123','admin@test.com','$2y$12$xfup955lIBGZGXKdOAGLwuR1dugCcjL7nIp8X3E26tniLhyw8XTum',1,1,1,NULL,NULL,NULL,'2025-10-25 06:12:42'),
(3,'Julio Aguirre','3629982710291','julioaguirre@gmail.com','$2b$10$cVWKp0yIMHVLniKn9TVyv.aYdh7NH4BBOoWUJfZeLHxI40uypjm36',4,1,1,NULL,NULL,NULL,'2025-11-10 02:52:15');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-11-22  0:43:15
