const express = require('express');
const router = express.Router();



const marcaController = require('../controllers/core/marca.controller'); 





router.post('/marcas', marcaController.createMarca);
router.get('/marcas', marcaController.getMarcas);
router.get('/marcas/:id', marcaController.getMarcaById);
router.put('/marcas/:id', marcaController.updateMarca);
router.patch('/marcas/:id/desactivar', marcaController.desactivarMarca);
router.patch('/marcas/:id/reactivar', marcaController.reactivarMarca);
router.delete('/marcas/:id', marcaController.deleteMarca);

module.exports = router;