// routes/index.js
const express = require('express');
const router = express.Router();

// Importar rutas por módulo
//const coreRoutes = require('./core.routes');
const productosRoutes = require('./producto.routes');
const presentacionRoutes = require('./presentacion.route');
const rolRoutes = require('./rol.route');
const sucursalRoutes = require('./sucursal.route');
const clienteRoutes = require('./cliente.route'); // ← Agregar

// Usar rutas
//router.use('/api', coreRoutes);
router.use('/api', productosRoutes);
router.use('/api', presentacionRoutes);
router.use('/api', rolRoutes);
router.use('/api', sucursalRoutes);
router.use('/api', clienteRoutes); // ← Agregar

module.exports = router;