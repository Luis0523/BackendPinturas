// producto.routes.js
const express = require('express');
const router = express.Router();
const productoController = require('../controllers/producto1.controller');

router.get('/productos', productoController.listar);
router.get('/productos/:id', productoController.listarInfo);
router.post('/productos', productoController.crear);
// Aquí puedes agregar rutas para actualizar y eliminar productos si es necesario   

module.exports = router;
