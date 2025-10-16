// routes/movimiento.routes.js
const express = require('express');
const router = express.Router();
const movimientoController = require('../controllers/inventario/movimiento.controller');

// Obtener resumen de movimientos
router.get('/movimientos/resumen', movimientoController.getResumenMovimientos);

// Obtener todos los movimientos con filtros
router.get('/movimientos', movimientoController.getMovimientos);

// Obtener movimientos de una sucursal
router.get('/movimientos/sucursal/:sucursal_id', movimientoController.getMovimientosSucursal);

// Obtener movimientos de un producto
router.get('/movimientos/producto-presentacion/:producto_presentacion_id', movimientoController.getMovimientosProducto);

// Obtener movimientos por tipo
router.get('/movimientos/tipo/:tipo', movimientoController.getMovimientosPorTipo);

// Crear movimiento manual (raro - normalmente se crean automáticamente)
router.post('/movimientos', movimientoController.createMovimiento);

module.exports = router;