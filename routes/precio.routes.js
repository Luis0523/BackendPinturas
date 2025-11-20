
const express = require('express');
const router = express.Router();
const precioController = require('../controllers/inventario/precio.controller');






router.get('/catalogo-con-precios', precioController.getCatalogoConPrecios);


router.get('/vigente/:producto_presentacion_id/:sucursal_id', precioController.getPrecioVigenteProducto);






router.get('/', precioController.getPreciosVigentes);


router.post('/', precioController.createPrecio);


router.get('/:id', precioController.getPrecioById);


router.put('/:id', precioController.updatePrecio);


router.patch('/:id/desactivar', precioController.desactivarPrecio);

module.exports = router;