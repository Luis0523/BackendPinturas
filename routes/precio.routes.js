// routes/precio.routes.js
const express = require('express');
const router = express.Router();
const precioController = require('../controllers/inventario/precio.controller');

// Obtener catálogo vendible con precios (endpoint especial)
router.get('/catalogo-con-precios', precioController.getCatalogoConPrecios);

// Obtener todos los precios vigentes
router.get('/precios', precioController.getPreciosVigentes);

// Obtener precio vigente de un producto en una sucursal
router.get('/precios/vigente/:producto_presentacion_id/:sucursal_id', precioController.getPrecioVigenteProducto);

// Obtener precio por ID
router.get('/precios/:id', precioController.getPrecioById);

// Crear nuevo precio
router.post('/precios', precioController.createPrecio);

// Actualizar precio
router.put('/precios/:id', precioController.updatePrecio);

// Desactivar precio
router.patch('/precios/:id/desactivar', precioController.desactivarPrecio);

module.exports = router;