
const express = require('express');
const router = express.Router();
const inventarioController = require('../controllers/inventario/inventario.controller');


router.get('/inventario/sucursal/:sucursal_id', inventarioController.getInventarioSucursal);


router.get('/inventario/sucursal/:sucursal_id/alertas', inventarioController.getInventarioSucursal);


router.get('/inventario/producto-presentacion/:producto_presentacion_id', inventarioController.getStockProducto);


router.get('/inventario/alertas', inventarioController.getAlertasStock);


router.get('/inventario/agotados', inventarioController.getProductosAgotados);


router.post('/inventario', inventarioController.upsertInventario);


router.post('/inventario/ajuste', inventarioController.ajustarInventario);


router.post('/inventario/traslado', inventarioController.trasladarInventario);

module.exports = router;