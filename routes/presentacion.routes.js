// routes/presentacion.routes.js
const express = require('express');
const router = express.Router();
const presentacionController = require('../controllers/core/presentacion.controller');

// Obtener todas las presentaciones activas
router.get('/presentaciones', presentacionController.getPresentaciones);

// Obtener todas (incluyendo inactivas)
router.get('/presentaciones/all', presentacionController.getAllPresentaciones);

// Obtener presentación por ID
router.get('/presentaciones/:id', presentacionController.getPresentacionById);

// Crear nueva presentación
router.post('/presentaciones', presentacionController.createPresentacion);

// Actualizar presentación
router.put('/presentaciones/:id', presentacionController.updatePresentacion);

// Desactivar presentación (soft delete)
router.delete('/presentaciones/:id', presentacionController.deletePresentacion);

// Reactivar presentación
router.patch('/presentaciones/:id/reactivar', presentacionController.reactivarPresentacion);

module.exports = router;