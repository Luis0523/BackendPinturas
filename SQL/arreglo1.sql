--Con esto, arreglamos de lo de propiedades y demas. 
USE pinturas;
-- Eliminar tablas si existen (en orden correcto)
DROP TABLE IF EXISTS `productos`;
DROP TABLE IF EXISTS `categorias`;
DROP TABLE IF EXISTS `marcas`;

-- Tabla Categorias
CREATE TABLE `categorias` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(60) UNIQUE NOT NULL,
  `descripcion` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Marcas
CREATE TABLE `marcas` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(80) UNIQUE NOT NULL,
  `activa` BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Productos
CREATE TABLE `productos` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `categoria_id` INT,
  `marca_id` INT,
  `codigo_sku` VARCHAR(50) UNIQUE NOT NULL,
  `descripcion` VARCHAR(255) NOT NULL,
  `tamano` VARCHAR(40),
  `duracion_anios` INT,
  `extension_m2` DECIMAL(10,2),
  `color` VARCHAR(60),
  `activo` BOOLEAN DEFAULT TRUE,
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Foreign Keys
  CONSTRAINT `fk_productos_categoria`
    FOREIGN KEY (`categoria_id`)
    REFERENCES `categorias`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  CONSTRAINT `fk_productos_marca`
    FOREIGN KEY (`marca_id`)
    REFERENCES `marcas`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  -- Índices para mejorar performance
  INDEX `idx_categoria_id` (`categoria_id`),
  INDEX `idx_marca_id` (`marca_id`),
  INDEX `idx_activo` (`activo`),
  INDEX `idx_codigo_sku` (`codigo_sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar datos de prueba (opcional)
INSERT INTO `categorias` (`nombre`, `descripcion`) VALUES
('Pinturas de Interior', 'Pinturas para uso en interiores'),
('Pinturas de Exterior', 'Pinturas resistentes al clima'),
('Esmaltes', 'Esmaltes y barnices'),
('Impermeabilizantes', 'Productos para impermeabilización');

INSERT INTO `marcas` (`nombre`, `activa`) VALUES
('Sherwin Williams', TRUE),
('Comex', TRUE),
('Berel', TRUE),
('Pintuco', TRUE);

INSERT INTO `productos` (`categoria_id`, `marca_id`, `codigo_sku`, `descripcion`, `tamano`, `duracion_anios`, `extension_m2`, `color`, `activo`) VALUES
(1, 1, 'SKU-001', 'Pintura Acrílica Interior Premium', '1 Galón', 5, 35.00, 'Blanco', TRUE),
(2, 2, 'SKU-002', 'Pintura Exterior Vinil Acrílico', '19 Litros', 7, 120.00, 'Beige', TRUE),
(3, 3, 'SKU-003', 'Esmalte Brillante Alquidal', '4 Litros', 3, 25.00, 'Negro', TRUE),
(4, 4, 'SKU-004', 'Impermeabilizante Acrílico', '20 Litros', 10, 150.00, 'Terracota', TRUE);
