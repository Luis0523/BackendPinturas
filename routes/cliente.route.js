// routes/cliente.routes.js
const express = require('express');
const router = express.Router();
const clienteController = require('../controllers/usuarios/cliente.controller');

// Obtener todos los clientes (con filtros opcionales)
router.get('/clientes', clienteController.getClientes);

// Buscar cliente por NIT o email
router.get('/clientes/buscar', clienteController.buscarCliente);

// Buscar clientes cercanos por GPS
router.get('/clientes/cercanos', clienteController.getClientesCercanos);

// Obtener cliente por ID
router.get('/clientes/:id', clienteController.getClienteById);

// Crear nuevo cliente
router.post('/clientes', clienteController.createCliente);

// Actualizar cliente
router.put('/clientes/:id', clienteController.updateCliente);

// Eliminar cliente
router.delete('/clientes/:id', clienteController.deleteCliente);

// Verificar cliente
router.patch('/clientes/:id/verificar', clienteController.verificarCliente);

module.exports = router;