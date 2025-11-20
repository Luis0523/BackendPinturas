
const express = require('express');
const router = express.Router();


const {
    createProveedor,
    getProveedores,
    getProveedorById,
    updateProveedor,
    deleteProveedor
} = require('../controllers/compras/proveedor.controller');

const {
    createOrdenCompra,
    getOrdenesCompra,
    getOrdenCompraById,
    cancelarOrdenCompra
} = require('../controllers/compras/ordenCompra.controller');

const {
    createRecepcion,
    getRecepciones,
    getRecepcionById
} = require('../controllers/compras/recepcion.controller');






router.post('/proveedores', createProveedor);


router.get('/proveedores', getProveedores);


router.get('/proveedores/:id', getProveedorById);


router.put('/proveedores/:id', updateProveedor);


router.delete('/proveedores/:id', deleteProveedor);






router.post('/ordenes', createOrdenCompra);


router.get('/ordenes', getOrdenesCompra);


router.get('/ordenes/:id', getOrdenCompraById);


router.put('/ordenes/:id/cancelar', cancelarOrdenCompra);






router.post('/recepciones', createRecepcion);


router.get('/recepciones', getRecepciones);


router.get('/recepciones/:id', getRecepcionById);

module.exports = router;