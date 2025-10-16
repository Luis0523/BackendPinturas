// routes/index.js
const express = require('express');
const router = express.Router();

// Importar rutas por módulo
//const coreRoutes = require('./core.routes');
const productosRoutes = require('./producto.routes');
const presentacionRoutes = require('./presentacion.routes');
const rolRoutes = require('./rol.routes');
const sucursalRoutes = require('./sucursal.routes');
const clienteRoutes = require('./cliente.routes');
const usuarioRoutes = require('./usuario.routes');
const productoPresentacionRoutes = require('./productoPresentacion.routes');
const precioRoutes = require('./precio.routes'); // ← NUEVO

// Usar rutas
//router.use('/api', coreRoutes);
router.use('/api', productosRoutes);
router.use('/api', presentacionRoutes);
router.use('/api', rolRoutes);
router.use('/api', sucursalRoutes);
router.use('/api', clienteRoutes);
router.use('/api', usuarioRoutes);
router.use('/api', productoPresentacionRoutes);
router.use('/api', precioRoutes); // ← NUEVO

module.exports = router;