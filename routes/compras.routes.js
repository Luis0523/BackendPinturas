// routes/compras.routes.js
const express = require('express');
const router = express.Router();

// ===== IMPORTAR CONTROLLERS =====
const {
    createProveedor,
    getProveedores,
    getProveedorById,
    updateProveedor,
    deleteProveedor
} = require('../controllers/compras/proveedor.controller');

const {
    createOrdenCompra,
    getOrdenesCompra,
    getOrdenCompraById,
    cancelarOrdenCompra
} = require('../controllers/compras/ordenCompra.controller');

const {
    createRecepcion,
    getRecepciones,
    getRecepcionById
} = require('../controllers/compras/recepcion.controller');

// =============================================
// RUTAS DE PROVEEDORES
// =============================================

/**
 * @route   POST /api/compras/proveedores
 * @desc    Crear nuevo proveedor
 * @access  Private
 */
router.post('/proveedores', createProveedor);

/**
 * @route   GET /api/compras/proveedores
 * @desc    Obtener todos los proveedores
 * @query   activo, buscar
 * @access  Private
 */
router.get('/proveedores', getProveedores);

/**
 * @route   GET /api/compras/proveedores/:id
 * @desc    Obtener proveedor por ID
 * @access  Private
 */
router.get('/proveedores/:id', getProveedorById);

/**
 * @route   PUT /api/compras/proveedores/:id
 * @desc    Actualizar proveedor
 * @access  Private
 */
router.put('/proveedores/:id', updateProveedor);

/**
 * @route   DELETE /api/compras/proveedores/:id
 * @desc    Desactivar proveedor
 * @access  Private
 */
router.delete('/proveedores/:id', deleteProveedor);

// =============================================
// RUTAS DE ÓRDENES DE COMPRA
// =============================================

/**
 * @route   POST /api/compras/ordenes
 * @desc    Crear nueva orden de compra
 * @access  Private
 */
router.post('/ordenes', createOrdenCompra);

/**
 * @route   GET /api/compras/ordenes
 * @desc    Obtener todas las órdenes de compra
 * @query   proveedor_id, sucursal_id, usuario_id, estado, desde, hasta, limite
 * @access  Private
 */
router.get('/ordenes', getOrdenesCompra);

/**
 * @route   GET /api/compras/ordenes/:id
 * @desc    Obtener orden de compra por ID con todos los detalles
 * @access  Private
 */
router.get('/ordenes/:id', getOrdenCompraById);

/**
 * @route   PUT /api/compras/ordenes/:id/cancelar
 * @desc    Cancelar orden de compra
 * @access  Private
 */
router.put('/ordenes/:id/cancelar', cancelarOrdenCompra);

// =============================================
// RUTAS DE RECEPCIONES
// =============================================

/**
 * @route   POST /api/compras/recepciones
 * @desc    Crear nueva recepción de productos
 * @access  Private
 */
router.post('/recepciones', createRecepcion);

/**
 * @route   GET /api/compras/recepciones
 * @desc    Obtener todas las recepciones
 * @query   orden_compra_id, sucursal_id, usuario_id
 * @access  Private
 */
router.get('/recepciones', getRecepciones);

/**
 * @route   GET /api/compras/recepciones/:id
 * @desc    Obtener recepción por ID con todos los detalles
 * @access  Private
 */
router.get('/recepciones/:id', getRecepcionById);

module.exports = router;