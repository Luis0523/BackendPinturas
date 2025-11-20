
const express = require('express');
const router = express.Router();
const sucursalController = require('../controllers/core/sucursal.controller');


router.get('/sucursales', sucursalController.getSucursales);


router.get('/sucursales/all', sucursalController.getAllSucursales);


router.get('/sucursales/cercanas', sucursalController.getSucursalesCercanas);


router.get('/sucursales/:id', sucursalController.getSucursalById);


router.post('/sucursales', sucursalController.createSucursal);


router.put('/sucursales/:id', sucursalController.updateSucursal);


router.delete('/sucursales/:id', sucursalController.deleteSucursal);


router.patch('/sucursales/:id/reactivar', sucursalController.reactivarSucursal);

module.exports = router;