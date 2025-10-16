// routes/sucursal.routes.js
const express = require('express');
const router = express.Router();
const sucursalController = require('../controllers/core/sucursal.controller');

// Obtener todas las sucursales activas
router.get('/sucursales', sucursalController.getSucursales);

// Obtener todas (incluyendo inactivas)
router.get('/sucursales/all', sucursalController.getAllSucursales);

// Buscar sucursales cercanas por GPS
router.get('/sucursales/cercanas', sucursalController.getSucursalesCercanas);

// Obtener sucursal por ID
router.get('/sucursales/:id', sucursalController.getSucursalById);

// Crear nueva sucursal
router.post('/sucursales', sucursalController.createSucursal);

// Actualizar sucursal
router.put('/sucursales/:id', sucursalController.updateSucursal);

// Desactivar sucursal (soft delete)
router.delete('/sucursales/:id', sucursalController.deleteSucursal);

// Reactivar sucursal
router.patch('/sucursales/:id/reactivar', sucursalController.reactivarSucursal);

module.exports = router;