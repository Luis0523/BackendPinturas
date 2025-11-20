
const express = require('express');
const router = express.Router();
const clienteController = require('../controllers/usuarios/cliente.controller');


router.get('/clientes', clienteController.getClientes);


router.get('/clientes/buscar', clienteController.buscarCliente);


router.get('/clientes/cercanos', clienteController.getClientesCercanos);


router.get('/clientes/:id', clienteController.getClienteById);


router.post('/clientes', clienteController.createCliente);


router.put('/clientes/:id', clienteController.updateCliente);


router.delete('/clientes/:id', clienteController.deleteCliente);


router.patch('/clientes/:id/verificar', clienteController.verificarCliente);

module.exports = router;