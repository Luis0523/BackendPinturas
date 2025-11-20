
const express = require('express');
const router = express.Router();
const presentacionController = require('../controllers/core/presentacion.controller');


router.get('/presentaciones', presentacionController.getPresentaciones);


router.get('/presentaciones/all', presentacionController.getAllPresentaciones);


router.get('/presentaciones/:id', presentacionController.getPresentacionById);


router.post('/presentaciones', presentacionController.createPresentacion);


router.put('/presentaciones/:id', presentacionController.updatePresentacion);


router.delete('/presentaciones/:id', presentacionController.deletePresentacion);


router.patch('/presentaciones/:id/reactivar', presentacionController.reactivarPresentacion);

module.exports = router;