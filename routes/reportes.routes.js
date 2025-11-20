
const express = require('express');
const router = express.Router();
const reportesController = require('../controllers/reportes/reportes.controller');


router.get('/reportes/dashboard', reportesController.getDashboardStats);


router.get('/reportes/ventas/semana', reportesController.getVentasSemana);
router.get('/reportes/ventas/mes', reportesController.getVentasMes);
router.get('/reportes/ventas/dia', reportesController.getVentasDia);
router.get('/reportes/ventas/categorias', reportesController.getVentasPorCategoria);
router.get('/reportes/ventas/top-productos', reportesController.getTopProductos);
router.get('/reportes/ventas/metodo-pago', reportesController.getVentasPorMetodoPago);
router.get('/reportes/productos/mas-ingresos', reportesController.getProductosMasIngresos);
router.get('/reportes/productos/mas-vendidos', reportesController.getProductosMasVendidos);
router.get('/reportes/productos/menos-vendidos', reportesController.getProductosMenosVendidos);


router.get('/reportes/compras/mes', reportesController.getComprasMes);


router.get('/reportes/pagos/metodos', reportesController.getMetodosPago);


router.get('/reportes/inventario/actual', reportesController.getInventarioActual);
router.get('/reportes/inventario/sin-stock', reportesController.getProductosSinStock);


router.get('/reportes/factura/buscar', reportesController.buscarFacturaPorNumero);


router.get('/reportes/ingresos-inventario', reportesController.getIngresosInventario);


router.get('/reportes/productos-stock-minimo', reportesController.getProductosStockMinimo);

module.exports = router;
