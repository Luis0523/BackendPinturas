const { Producto, Categoria, Marca } = require('../models/index');

exports.getProductos = async (req, res, next) => {
    try {
        const productos = await Producto.findAll({
            include: [
                { 
                    model: Categoria, 
                    as: 'categoria',  // Importante: usar el alias definido
                    attributes: ['id', 'nombre'] 
                },
                { 
                    model: Marca, 
                    as: 'marca',  // Importante: usar el alias definido
                    attributes: ['id', 'nombre', 'activa'] 
                }
            ]
        });

        res.status(200).json({
            success: true,
            count: productos.length,
            data: productos
        });
    } catch (error) {
        console.error('Error en getProductos:', error);
        next(error);
    }
};

exports.getProductoById = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        const producto = await Producto.findByPk(id, {
            include: [
                { model: Categoria, as: 'categoria' },
                { model: Marca, as: 'marca' }
            ]
        });

        if (!producto) {
            return res.status(404).json({
                success: false,
                message: 'Producto no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: producto
        });
    } catch (error) {
        console.error('Error en getProductoById:', error);
        next(error);
    }
};

exports.createProducto = async (req, res, next) => {
    try {
        const producto = await Producto.create(req.body);
        
        // Obtener el producto con sus relaciones
        const productoCompleto = await Producto.findByPk(producto.id, {
            include: [
                { model: Categoria, as: 'categoria' },
                { model: Marca, as: 'marca' }
            ]
        });

        res.status(201).json({
            success: true,
            message: 'Producto creado exitosamente',
            data: productoCompleto
        });
    } catch (error) {
        console.error('Error en createProducto:', error);
        next(error);
    }
};



// Al final de producto.controller.js, agrega:

exports.updateProducto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const producto = await Producto.findByPk(id);

        if (!producto) {
            return res.status(404).json({
                success: false,
                message: 'Producto no encontrado'
            });
        }

        await producto.update(req.body);

        const productoActualizado = await Producto.findByPk(id, {
            include: [
                { model: Categoria, as: 'categoria' },
                { model: Marca, as: 'marca' }
            ]
        });

        res.status(200).json({
            success: true,
            message: 'Producto actualizado',
            data: productoActualizado
        });
    } catch (error) {
        console.error('Error en updateProducto:', error);
        next(error);
    }
};

exports.deleteProducto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const producto = await Producto.findByPk(id);

        if (!producto) {
            return res.status(404).json({
                success: false,
                message: 'Producto no encontrado'
            });
        }

        await producto.destroy();

        res.status(200).json({
            success: true,
            message: 'Producto eliminado'
        });
    } catch (error) {
        console.error('Error en deleteProducto:', error);
        next(error);
    }
};
