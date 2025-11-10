// routes/reportes.routes.js
const express = require('express');
const router = express.Router();
const reportesController = require('../controllers/reportes/reportes.controller');

// Dashboard
router.get('/reportes/dashboard', reportesController.getDashboardStats);

// Ventas
router.get('/reportes/ventas/semana', reportesController.getVentasSemana);
router.get('/reportes/ventas/mes', reportesController.getVentasMes);
router.get('/reportes/ventas/dia', reportesController.getVentasDia);
router.get('/reportes/ventas/categorias', reportesController.getVentasPorCategoria);
router.get('/reportes/ventas/top-productos', reportesController.getTopProductos);

// Compras
router.get('/reportes/compras/mes', reportesController.getComprasMes);

// Pagos
router.get('/reportes/pagos/metodos', reportesController.getMetodosPago);

module.exports = router;
