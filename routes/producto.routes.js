// producto.routes.js
const express = require('express');
const router = express.Router();
const productoController = require('../controllers/producto.controller');

/**
 * Ruta para obtener todos los productos
 * Ejemplo: GET /productos
 */
router.get('/productos', productoController.getProductos);

/**
 * Ruta para obtener un producto por su ID
 * Ejemplo: GET /productos/:id -> obtiene el producto con ID específico
 */
router.get('/productos/:id', productoController.getProductoById);

/**
 * Ruta para agregar un nuevo producto
 * Ejemplo: POST /productos -> agrega un nuevo producto
 * Requiere datos en el body: nombre, descripcion, precio, stock, categoria
 */
router.post('/productos', productoController.agregarProducto);

/**
 * Ruta para actualizar un producto por su ID
 * Ejemplo: PUT /productos/:id -> actualiza un producto
 * Requiere datos en el body: nombre, descripcion, precio, stock, categoria
 */
router.put('/productos/:id', productoController.actualizarProducto);

/**
 * Ruta para eliminar un producto por su ID
 * Ejemplo: DELETE /productos/:id -> elimina un producto
 */
router.delete('/productos/:id', productoController.eliminarProducto);

module.exports = router;
