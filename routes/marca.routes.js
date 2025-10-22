const express = require('express');
const router = express.Router();

// ===== IMPORTAR CONTROLLERS =====

const marcaController = require('../controllers/core/marca.controller'); // ✅ NUEVO


// =============================================
// RUTAS DE MARCAS
// =============================================
router.post('/marcas', marcaController.createMarca);
router.get('/marcas', marcaController.getMarcas);
router.get('/marcas/:id', marcaController.getMarcaById);
router.put('/marcas/:id', marcaController.updateMarca);
router.patch('/marcas/:id/desactivar', marcaController.desactivarMarca);
router.patch('/marcas/:id/reactivar', marcaController.reactivarMarca);
router.delete('/marcas/:id', marcaController.deleteMarca);

module.exports = router;