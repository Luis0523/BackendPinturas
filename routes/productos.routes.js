
const express = require('express');
const router = express.Router();
const productoController = require('../controllers/producto.controller');


router.get('/productos', productoController.getProductos);
router.get('/productos/:id', productoController.getProductoById);
router.post('/productos', productoController.createProducto);
router.put('/productos/:id', productoController.updateProducto);
router.delete('/productos/:id', productoController.deleteProducto);
router.patch('/productos/:id/reactivar', productoController.reactivarProducto);


module.exports = router;