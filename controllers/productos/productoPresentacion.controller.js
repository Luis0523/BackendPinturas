// controllers/productos/productoPresentacion.controller.js
const { ProductoPresentacion, Producto, Presentacion, Categoria, Marca } = require('../../models/index');

// Obtener catálogo vendible completo (todos los productos con sus presentaciones)
exports.getCatalogoVendible = async (req, res, next) => {
    try {
        const { activo } = req.query;
        
        const where = {};
        if (activo !== undefined) {
            where.activo = activo === 'true';
        }

        const catalogo = await ProductoPresentacion.findAll({
            where,
            include: [
                {
                    model: Producto,
                    as: 'producto',
                    include: [
                        { model: Categoria, as: 'categoria', attributes: ['id', 'nombre'] },
                        { model: Marca, as: 'marca', attributes: ['id', 'nombre'] }
                    ]
                },
                {
                    model: Presentacion,
                    as: 'presentacion',
                    attributes: ['id', 'nombre', 'unidad_base', 'factor_galon']
                }
            ],
            order: [
                [{ model: Producto, as: 'producto' }, 'descripcion', 'ASC'],
                [{ model: Presentacion, as: 'presentacion' }, 'nombre', 'ASC']
            ]
        });

        res.status(200).json({
            success: true,
            count: catalogo.length,
            data: catalogo
        });
    } catch (error) {
        console.error('Error en getCatalogoVendible:', error);
        next(error);
    }
};

// Obtener presentaciones de un producto específico
exports.getPresentacionesDeProducto = async (req, res, next) => {
    try {
        const { producto_id } = req.params;

        // Verificar que el producto existe
        const producto = await Producto.findByPk(producto_id, {
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

        const presentaciones = await ProductoPresentacion.findAll({
            where: { producto_id },
            include: [
                {
                    model: Presentacion,
                    as: 'presentacion'
                }
            ]
        });

        res.status(200).json({
            success: true,
            producto: producto,
            presentaciones_disponibles: presentaciones.length,
            data: presentaciones
        });
    } catch (error) {
        console.error('Error en getPresentacionesDeProducto:', error);
        next(error);
    }
};

// Obtener un ProductoPresentacion por ID
exports.getProductoPresentacionById = async (req, res, next) => {
    try {
        const { id } = req.params;

        const productoPresentacion = await ProductoPresentacion.findByPk(id, {
            include: [
                {
                    model: Producto,
                    as: 'producto',
                    include: [
                        { model: Categoria, as: 'categoria' },
                        { model: Marca, as: 'marca' }
                    ]
                },
                {
                    model: Presentacion,
                    as: 'presentacion'
                }
            ]
        });

        if (!productoPresentacion) {
            return res.status(404).json({
                success: false,
                message: 'Combinación producto-presentación no encontrada'
            });
        }

        res.status(200).json({
            success: true,
            data: productoPresentacion
        });
    } catch (error) {
        console.error('Error en getProductoPresentacionById:', error);
        next(error);
    }
};

// Agregar presentaciones a un producto (batch)
exports.agregarPresentacionesAProducto = async (req, res, next) => {
    try {
        const { producto_id } = req.params;
        const { presentaciones } = req.body; // Array de IDs: [1, 2, 3]

        // Validación
        if (!presentaciones || !Array.isArray(presentaciones) || presentaciones.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'Debe proporcionar un array de IDs de presentaciones'
            });
        }

        // Verificar que el producto existe
        const producto = await Producto.findByPk(producto_id);
        if (!producto) {
            return res.status(404).json({
                success: false,
                message: 'Producto no encontrado'
            });
        }

        // Verificar que todas las presentaciones existen
        const presentacionesValidas = await Presentacion.findAll({
            where: {
                id: presentaciones,
                activo: true
            }
        });

        if (presentacionesValidas.length !== presentaciones.length) {
            return res.status(400).json({
                success: false,
                message: 'Una o más presentaciones no existen o están inactivas'
            });
        }

        // Crear las combinaciones (ignorar duplicados)
        const resultados = {
            creadas: [],
            duplicadas: []
        };

        for (const presentacion_id of presentaciones) {
            try {
                const [productoPresentacion, created] = await ProductoPresentacion.findOrCreate({
                    where: {
                        producto_id,
                        presentacion_id
                    },
                    defaults: {
                        activo: true
                    }
                });

                if (created) {
                    resultados.creadas.push(productoPresentacion);
                } else {
                    resultados.duplicadas.push(presentacion_id);
                }
            } catch (error) {
                console.error(`Error al crear combinación: ${error.message}`);
            }
        }

        res.status(201).json({
            success: true,
            message: `${resultados.creadas.length} presentaciones agregadas exitosamente`,
            creadas: resultados.creadas.length,
            duplicadas: resultados.duplicadas.length,
            data: resultados
        });
    } catch (error) {
        console.error('Error en agregarPresentacionesAProducto:', error);
        next(error);
    }
};

// Crear una combinación individual
exports.createProductoPresentacion = async (req, res, next) => {
    try {
        const { producto_id, presentacion_id } = req.body;

        // Validaciones
        if (!producto_id || !presentacion_id) {
            return res.status(400).json({
                success: false,
                message: 'producto_id y presentacion_id son obligatorios'
            });
        }

        // Verificar que producto y presentación existen
        const producto = await Producto.findByPk(producto_id);
        const presentacion = await Presentacion.findByPk(presentacion_id);

        if (!producto) {
            return res.status(404).json({
                success: false,
                message: 'Producto no encontrado'
            });
        }

        if (!presentacion) {
            return res.status(404).json({
                success: false,
                message: 'Presentación no encontrada'
            });
        }

        // Crear la combinación
        const productoPresentacion = await ProductoPresentacion.create({
            producto_id,
            presentacion_id,
            activo: true
        });

        // Obtener con relaciones
        const resultado = await ProductoPresentacion.findByPk(productoPresentacion.id, {
            include: [
                { model: Producto, as: 'producto' },
                { model: Presentacion, as: 'presentacion' }
            ]
        });

        res.status(201).json({
            success: true,
            message: 'Combinación producto-presentación creada exitosamente',
            data: resultado
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Esta combinación producto-presentación ya existe'
            });
        }
        console.error('Error en createProductoPresentacion:', error);
        next(error);
    }
};

// Desactivar combinación
exports.desactivarProductoPresentacion = async (req, res, next) => {
    try {
        const { id } = req.params;

        const productoPresentacion = await ProductoPresentacion.findByPk(id);

        if (!productoPresentacion) {
            return res.status(404).json({
                success: false,
                message: 'Combinación no encontrada'
            });
        }

        await productoPresentacion.update({ activo: false });

        res.status(200).json({
            success: true,
            message: 'Combinación desactivada exitosamente'
        });
    } catch (error) {
        console.error('Error en desactivarProductoPresentacion:', error);
        next(error);
    }
};

// Reactivar combinación
exports.reactivarProductoPresentacion = async (req, res, next) => {
    try {
        const { id } = req.params;

        const productoPresentacion = await ProductoPresentacion.findByPk(id);

        if (!productoPresentacion) {
            return res.status(404).json({
                success: false,
                message: 'Combinación no encontrada'
            });
        }

        await productoPresentacion.update({ activo: true });

        res.status(200).json({
            success: true,
            message: 'Combinación reactivada exitosamente'
        });
    } catch (error) {
        console.error('Error en reactivarProductoPresentacion:', error);
        next(error);
    }
};

// Eliminar combinación (hard delete - usar con cuidado)
exports.deleteProductoPresentacion = async (req, res, next) => {
    try {
        const { id } = req.params;

        const productoPresentacion = await ProductoPresentacion.findByPk(id);

        if (!productoPresentacion) {
            return res.status(404).json({
                success: false,
                message: 'Combinación no encontrada'
            });
        }

        // TODO: Verificar que no haya inventario, precios o ventas asociados
        
        await productoPresentacion.destroy();

        res.status(200).json({
            success: true,
            message: 'Combinación eliminada exitosamente'
        });
    } catch (error) {
        console.error('Error en deleteProductoPresentacion:', error);
        next(error);
    }
};