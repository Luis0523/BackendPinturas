// routes/usuario.routes.js
const express = require('express');
const router = express.Router();
const usuarioController = require('../controllers/usuarios/usuario.controller');

// Obtener todos los usuarios (con filtros opcionales)
router.get('/usuarios', usuarioController.getUsuarios);

// Buscar usuario por email o DPI
router.get('/usuarios/buscar', usuarioController.buscarUsuario);

// Obtener usuarios por rol
//router.get('/usuarios/rol/:rol_id', usuarioController.getUsuariosPorRol);

// Obtener usuarios por sucursal
//router.get('/usuarios/sucursal/:sucursal_id', usuarioController.getUsuariosPorSucursal);

// Obtener usuario por ID
router.get('/usuarios/:id', usuarioController.getUsuarioById);

// Crear nuevo usuario
router.post('/usuarios', usuarioController.createUsuario);

// Actualizar usuario
router.put('/usuarios/:id', usuarioController.updateUsuario);

// Desactivar usuario (soft delete)
router.delete('/usuarios/:id', usuarioController.deleteUsuario);

// Reactivar usuario
//router.patch('/usuarios/:id/reactivar', usuarioController.reactivarUsuario);

// Cambiar password
//router.patch('/usuarios/:id/cambiar-password', usuarioController.cambiarPassword);

module.exports = router;