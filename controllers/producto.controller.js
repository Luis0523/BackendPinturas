// producto.controller.js
const ProductoModel = require('../models/producto.model');

/**
 * Obtener todos los productos
 */
exports.getProductos = async (req, res) => {
    try {
        const productos = await ProductoModel.findAll();
        res.status(200).json(productos);
    } catch (error) {
        res.status(500).json({
            error: error.message,
            message: 'Error al obtener los productos'
        });
    }
};

/**
 * Obtener un producto por su ID
 */
exports.getProductoById = async (req, res) => {
    try {
        const id = req.params.id;
        const producto = await ProductoModel.findByPk(id);
        if (!producto) {
            return res.status(404).json({ error: 'Producto no encontrado' });
        }
        res.status(200).json(producto);
    } catch (error) {
        res.status(500).json({
            error: error.message,
            message: 'Error al obtener el producto'
        });
    }
};

/**
 * Agregar un nuevo producto
 */
exports.agregarProducto = async (req, res) => {
    try {
        const { nombre, descripcion, precio, stock, categoria } = req.body;
        const nuevoProducto = await ProductoModel.create({
            nombre,
            descripcion,
            precio,
            stock,
            categoria
        });
        res.status(201).json(nuevoProducto);
    } catch (error) {
        res.status(500).json({
            error: error.message,
            message: 'Error al agregar el producto'
        });
    }
};

/**
 * Actualizar la información de un producto
 */
exports.actualizarProducto = async (req, res) => {
    try {
        const id = req.params.id;
        const { nombre, descripcion, precio, stock, categoria } = req.body;

        const producto = await ProductoModel.findByPk(id);
        if (!producto) {
            return res.status(404).json({ error: 'Producto no encontrado' });
        }

        producto.nombre = nombre || producto.nombre;
        producto.descripcion = descripcion || producto.descripcion;
        producto.precio = precio || producto.precio;
        producto.stock = stock || producto.stock;
        producto.categoria = categoria || producto.categoria;

        await producto.save();
        res.status(200).json(producto);
    } catch (error) {
        res.status(500).json({
            error: error.message,
            message: 'Error al actualizar el producto'
        });
    }
};

/**
 * Eliminar un producto
 */
exports.eliminarProducto = async (req, res) => {
    try {
        const id = req.params.id;
        const producto = await ProductoModel.findByPk(id);
        if (!producto) {
            return res.status(404).json({ error: 'Producto no encontrado' });
        }
        await producto.destroy();
        res.status(200).json({ message: 'Producto eliminado' });
    } catch (error) {
        res.status(500).json({
            error: error.message,
            message: 'Error al eliminar el producto'
        });
    }
};
