
const express = require('express');
const router = express.Router();
const productoPresentacionController = require('../controllers/productos/productoPresentacion.controller');


router.get('/catalogo-vendible', productoPresentacionController.getCatalogoVendible);


router.get('/productos/:producto_id/presentaciones', productoPresentacionController.getPresentacionesDeProducto);


router.post('/productos/:producto_id/presentaciones', productoPresentacionController.agregarPresentacionesAProducto);


router.get('/producto-presentacion/:id', productoPresentacionController.getProductoPresentacionById);


router.post('/producto-presentacion', productoPresentacionController.createProductoPresentacion);


router.patch('/producto-presentacion/:id/desactivar', productoPresentacionController.desactivarProductoPresentacion);


router.patch('/producto-presentacion/:id/reactivar', productoPresentacionController.reactivarProductoPresentacion);


router.delete('/producto-presentacion/:id', productoPresentacionController.deleteProductoPresentacion);

module.exports = router;