
const express = require('express');
const router = express.Router();


const {
    createFactura,
    getFacturas,
    getFacturaById,
    getPagosFactura,
    anularFactura
} = require('../controllers/ventas/factura.controller');

const {
    createPedido,
    getPedidos,
    getPedidoById,
    actualizarEstadoPedido,
    cancelarPedido
} = require('../controllers/ventas/pedido.controller');










router.post('/facturas', createFactura);


router.get('/facturas', getFacturas);


router.get('/facturas/:id', getFacturaById);


router.get('/facturas/:id/pagos', getPagosFactura);














router.put('/facturas/:id/anular', anularFactura);






router.post('/pedidos', createPedido);


router.get('/pedidos', getPedidos);


router.get('/pedidos/:id', getPedidoById);


router.put('/pedidos/:id/estado', actualizarEstadoPedido);


router.put('/pedidos/:id/cancelar', cancelarPedido);

module.exports = router;