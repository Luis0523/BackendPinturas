// routes/productoPresentacion.routes.js
const express = require('express');
const router = express.Router();
const productoPresentacionController = require('../controllers/productos/productoPresentacion.controller');

// Catálogo vendible completo
router.get('/catalogo-vendible', productoPresentacionController.getCatalogoVendible);

// Presentaciones de un producto específico
router.get('/productos/:producto_id/presentaciones', productoPresentacionController.getPresentacionesDeProducto);

// Agregar múltiples presentaciones a un producto
router.post('/productos/:producto_id/presentaciones', productoPresentacionController.agregarPresentacionesAProducto);

// Obtener una combinación por ID
router.get('/producto-presentacion/:id', productoPresentacionController.getProductoPresentacionById);

// Crear combinación individual
router.post('/producto-presentacion', productoPresentacionController.createProductoPresentacion);

// Desactivar combinación
router.patch('/producto-presentacion/:id/desactivar', productoPresentacionController.desactivarProductoPresentacion);

// Reactivar combinación
router.patch('/producto-presentacion/:id/reactivar', productoPresentacionController.reactivarProductoPresentacion);

// Eliminar combinación (hard delete)
router.delete('/producto-presentacion/:id', productoPresentacionController.deleteProductoPresentacion);

module.exports = router;