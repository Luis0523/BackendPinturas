// routes/core.routes.js
const express = require('express');
const router = express.Router();

// ===== IMPORTAR CONTROLLERS =====
const categoriaController = require('../controllers/core/categoria.controller');
// Importa otros controllers de core si los tienes (marcas, presentaciones, etc.)

// =============================================
// RUTAS DE CATEGORÍAS
// =============================================

/**
 * @route   POST /api/core/categorias
 * @desc    Crear nueva categoría
 * @access  Private
 */
router.post('/categorias', categoriaController.createCategoria);

/**
 * @route   GET /api/core/categorias
 * @desc    Obtener todas las categorías
 * @query   buscar, incluir_productos
 * @access  Private
 */
router.get('/categorias', categoriaController.getCategorias);

/**
 * @route   GET /api/core/categorias/:id
 * @desc    Obtener categoría por ID con productos asociados
 * @access  Private
 */
router.get('/categorias/:id', categoriaController.getCategoriaById);

/**
 * @route   PUT /api/core/categorias/:id
 * @desc    Actualizar categoría
 * @access  Private
 */
router.put('/categorias/:id', categoriaController.updateCategoria);

/**
 * @route   DELETE /api/core/categorias/:id
 * @desc    Eliminar categoría (solo si no tiene productos)
 * @access  Private
 */
router.delete('/categorias/:id', categoriaController.deleteCategoria);

module.exports = router;