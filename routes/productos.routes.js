
const express = require('express');
const router = express.Router();
const productoController = require('../controllers/producto.controller');
const { upload } = require('../services/imageUpload.service');


router.get('/productos', productoController.getProductos);
router.get('/productos/:id', productoController.getProductoById);
router.post('/productos', productoController.createProducto);
router.put('/productos/:id', productoController.updateProducto);
router.delete('/productos/:id', productoController.deleteProducto);
router.patch('/productos/:id/reactivar', productoController.reactivarProducto);

// Rutas para manejo de imágenes
router.post('/productos/:id/imagen', upload.single('imagen'), productoController.uploadProductoImagen);
router.delete('/productos/:id/imagen', productoController.deleteProductoImagen);


module.exports = router;