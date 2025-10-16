// routes/inventario.routes.js
const express = require('express');
const router = express.Router();
const inventarioController = require('../controllers/inventario/inventario.controller');

// Obtener inventario completo de una sucursal
router.get('/inventario/sucursal/:sucursal_id', inventarioController.getInventarioSucursal);

// Obtener inventario con alertas de una sucursal
router.get('/inventario/sucursal/:sucursal_id/alertas', inventarioController.getInventarioSucursal);

// Obtener stock de un producto en todas las sucursales
router.get('/inventario/producto-presentacion/:producto_presentacion_id', inventarioController.getStockProducto);

// Obtener todas las alertas de stock bajo
router.get('/inventario/alertas', inventarioController.getAlertasStock);

// Obtener productos agotados
router.get('/inventario/agotados', inventarioController.getProductosAgotados);

// Crear o actualizar inventario
router.post('/inventario', inventarioController.upsertInventario);

// Ajustar inventario (sumar o restar)
router.post('/inventario/ajuste', inventarioController.ajustarInventario);

// Trasladar stock entre sucursales
router.post('/inventario/traslado', inventarioController.trasladarInventario);

module.exports = router;