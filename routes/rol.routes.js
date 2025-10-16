// routes/rol.routes.js
const express = require('express');
const router = express.Router();
const rolController = require('../controllers/core/rol.controller');

// Obtener todos los roles
router.get('/roles', rolController.getRoles);

// Obtener rol por ID
router.get('/roles/:id', rolController.getRolById);

// Crear nuevo rol
router.post('/roles', rolController.createRol);

// Actualizar rol
router.put('/roles/:id', rolController.updateRol);

// Eliminar rol
router.delete('/roles/:id', rolController.deleteRol);

module.exports = router;