
const express = require('express');
const router = express.Router();
const usuarioController = require('../controllers/usuarios/usuario.controller');


router.get('/usuarios', usuarioController.getUsuarios);


router.get('/usuarios/buscar', usuarioController.buscarUsuario);








router.get('/usuarios/:id', usuarioController.getUsuarioById);


router.post('/usuarios', usuarioController.createUsuario);


router.put('/usuarios/:id', usuarioController.updateUsuario);


router.delete('/usuarios/:id', usuarioController.deleteUsuario);











router.post('/usuarios/login', usuarioController.login);
router.post('/usuarios/logout', usuarioController.logout);
router.post('/usuarios/refresh-token', usuarioController.refreshToken);
router.get('/usuarios/verify-token', usuarioController.verifyToken);
router.post('/usuarios/forgot-password', usuarioController.forgotPassword);
router.post('/usuarios/reset-password', usuarioController.resetPassword);
router.patch('/usuarios/:id/cambiar-password', usuarioController.cambiarPassword);

module.exports = router;