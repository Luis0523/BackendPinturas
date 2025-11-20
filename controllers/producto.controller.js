const { Producto, Categoria, Marca } = require('../models/index');

exports.getProductos = async (req, res, next) => {
    try {
        const { incluir_inactivos } = req.query;

        
        const where = {};
        if (incluir_inactivos !== 'true') {
            where.activo = true;
        }

        const productos = await Producto.findAll({
            where,
            include: [
                {
                    model: Categoria,
                    as: 'categoria',  
                    attributes: ['id', 'nombre']
                },
                {
                    model: Marca,
                    as: 'marca',  
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
        const { ProductoPresentacion } = require('../models/index');

        const producto = await Producto.findByPk(id);

        if (!producto) {
            return res.status(404).json({
                success: false,
                message: 'Producto no encontrado'
            });
        }

        
        
        await producto.update({ activo: false });

        
        await ProductoPresentacion.update(
            { activo: false },
            { where: { producto_id: id } }
        );

        res.status(200).json({
            success: true,
            message: 'Producto desactivado exitosamente'
        });
    } catch (error) {
        console.error('Error en deleteProducto:', error);
        next(error);
    }
};

exports.reactivarProducto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { ProductoPresentacion } = require('../models/index');

        const producto = await Producto.findByPk(id);

        if (!producto) {
            return res.status(404).json({
                success: false,
                message: 'Producto no encontrado'
            });
        }

        
        await producto.update({ activo: true });

        
        await ProductoPresentacion.update(
            { activo: true },
            { where: { producto_id: id } }
        );

        res.status(200).json({
            success: true,
            message: 'Producto reactivado exitosamente'
        });
    } catch (error) {
        console.error('Error en reactivarProducto:', error);
        next(error);
    }
};
