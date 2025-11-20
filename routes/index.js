
const express = require('express');
const router = express.Router();



const productosRoutes = require('./productos.routes');
const presentacionRoutes = require('./presentacion.routes');
const rolRoutes = require('./rol.routes');
const sucursalRoutes = require('./sucursal.routes');
const clienteRoutes = require('./cliente.routes');
const usuarioRoutes = require('./usuario.routes');
const productoPresentacionRoutes = require('./productoPresentacion.routes');
const precioRoutes = require('./precio.routes');
const inventarioRoutes = require('./inventario.routes');
const movimientoRoutes = require('./movimiento.routes'); 
const comprasRoutes = require('./compras.routes'); 
const categoriasRoutes = require('./categoria.routes');
const marcaRoutes = require('./marca.routes');

const ventasRoutes = require('./ventas.routes');
const reportesRoutes = require('./reportes.routes');



router.use('/api', productosRoutes);
router.use('/api', presentacionRoutes);
router.use('/api', rolRoutes);
router.use('/api', sucursalRoutes);
router.use('/api', clienteRoutes);
router.use('/api', usuarioRoutes);
router.use('/api', productoPresentacionRoutes);
router.use('/api/precios', precioRoutes);
router.use('/api', inventarioRoutes);
router.use('/api', movimientoRoutes); 
router.use('/api/ventas', ventasRoutes); 
router.use('/api/compras', comprasRoutes);
router.use('/api', categoriasRoutes);
router.use('/api', marcaRoutes);
router.use('/api', reportesRoutes);

module.exports = router;
