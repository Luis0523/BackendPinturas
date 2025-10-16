// routes/ventas.routes.js
const express = require('express');
const router = express.Router();

// ===== IMPORTAR CONTROLLERS =====
const {
    createFactura,
    getFacturas,
    getFacturaById,
    getPagosFactura,
    anularFactura
} = require('../controllers/ventas/factura.controller');

// Si tienes otros controllers de ventas, impórtalos aquí
// const carritoController = require('../controllers/ventas/carrito.controller');
// const cotizacionController = require('../controllers/ventas/cotizacion.controller');

// =============================================
// RUTAS DE FACTURAS
// =============================================

/**
 * @route   POST /api/ventas/facturas
 * @desc    Crear nueva factura con detalles y pagos
 * @access  Private
 */
router.post('/facturas', createFactura);

/**
 * @route   GET /api/ventas/facturas
 * @desc    Obtener todas las facturas con filtros opcionales
 * @query   sucursal_id, cliente_id, usuario_id, estado, desde, hasta, limite
 * @access  Private
 */
router.get('/facturas', getFacturas);

/**
 * @route   GET /api/ventas/facturas/:id
 * @desc    Obtener factura por ID con todos los detalles
 * @access  Private
 */
router.get('/facturas/:id', getFacturaById);

/**
 * @route   GET /api/ventas/facturas/:id/pagos
 * @desc    Obtener todos los pagos de una factura específica
 * @access  Private
 */
router.get('/facturas/:id/pagos', getPagosFactura);

// =============================================
// RUTAS DE CARRITO (Si las tienes)
// =============================================
// router.post('/carrito', carritoController.create);
// router.get('/carrito/:id', carritoController.getById);

// =============================================
// RUTAS DE COTIZACIONES (Si las tienes)
// =============================================
// router.post('/cotizaciones', cotizacionController.create);
// router.get('/cotizaciones', cotizacionController.getAll);


router.put('/facturas/:id/anular', anularFactura); 
module.exports = router;