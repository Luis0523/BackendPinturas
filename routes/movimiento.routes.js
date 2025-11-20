
const express = require('express');
const router = express.Router();
const movimientoController = require('../controllers/inventario/movimiento.controller');


router.get('/movimientos/resumen', movimientoController.getResumenMovimientos);


router.get('/movimientos', movimientoController.getMovimientos);


router.get('/movimientos/sucursal/:sucursal_id', movimientoController.getMovimientosSucursal);


router.get('/movimientos/producto-presentacion/:producto_presentacion_id', movimientoController.getMovimientosProducto);


router.get('/movimientos/tipo/:tipo', movimientoController.getMovimientosPorTipo);


router.post('/movimientos', movimientoController.createMovimiento);

module.exports = router;