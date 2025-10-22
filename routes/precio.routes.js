// routes/precios.routes.js
const express = require('express');
const router = express.Router();
const precioController = require('../controllers/inventario/precio.controller');

// =============================================
// RUTAS ESPECIALES (Primero, antes de las genéricas)
// =============================================

/**
 * @route   GET /api/precios/catalogo-con-precios?sucursal_id=1
 * @desc    Obtener catálogo vendible con precios
 */
router.get('/catalogo-con-precios', precioController.getCatalogoConPrecios);

/**
 * @route   GET /api/precios/vigente/:producto_presentacion_id/:sucursal_id
 * @desc    Obtener precio vigente de un producto en una sucursal
 */
router.get('/vigente/:producto_presentacion_id/:sucursal_id', precioController.getPrecioVigenteProducto);

// =============================================
// RUTAS GENÉRICAS (Después de las específicas)
// =============================================

/**
 * @route   GET /api/precios
 * @desc    Obtener todos los precios vigentes
 * @query   sucursal_id, producto_presentacion_id
 */
router.get('/', precioController.getPreciosVigentes);

/**
 * @route   POST /api/precios
 * @desc    Crear nuevo precio
 */
router.post('/', precioController.createPrecio);

/**
 * @route   GET /api/precios/:id
 * @desc    Obtener precio por ID
 */
router.get('/:id', precioController.getPrecioById);

/**
 * @route   PUT /api/precios/:id
 * @desc    Actualizar precio
 */
router.put('/:id', precioController.updatePrecio);

/**
 * @route   PATCH /api/precios/:id/desactivar
 * @desc    Desactivar precio
 */
router.patch('/:id/desactivar', precioController.desactivarPrecio);

module.exports = router;