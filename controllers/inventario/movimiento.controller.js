// controllers/inventario/movimiento.controller.js
const { MovimientoInventario, ProductoPresentacion, Producto, Presentacion, Sucursal, Categoria, Marca } = require('../../models/index');
const { Op } = require('sequelize');

// Obtener todos los movimientos con filtros
const getMovimientos = async (req, res, next) => {
    try {
        const { sucursal_id, producto_presentacion_id, tipo, desde, hasta, limit } = req.query;
        
        const where = {};
        
        if (sucursal_id) {
            where.sucursal_id = sucursal_id;
        }
        
        if (producto_presentacion_id) {
            where.producto_presentacion_id = producto_presentacion_id;
        }
        
        if (tipo) {
            where.tipo = tipo;
        }
        
        if (desde) {
            where.created_at = {
                [Op.gte]: new Date(desde)
            };
        }
        
        if (hasta) {
            where.created_at = {
                ...where.created_at,
                [Op.lte]: new Date(hasta)
            };
        }

        const movimientos = await MovimientoInventario.findAll({
            where,
            include: [
                {
                    model: ProductoPresentacion,
                    as: 'productoPresentacion',
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
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre']
                }
            ],
            order: [['created_at', 'DESC']],
            limit: limit ? parseInt(limit) : 100
        });

        res.status(200).json({
            success: true,
            count: movimientos.length,
            data: movimientos
        });
    } catch (error) {
        console.error('Error en getMovimientos:', error);
        next(error);
    }
};

// Obtener movimientos de una sucursal
const getMovimientosSucursal = async (req, res, next) => {
    try {
        const { sucursal_id } = req.params;
        const { tipo, desde, hasta } = req.query;

        const sucursal = await Sucursal.findByPk(sucursal_id);
        if (!sucursal) {
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada'
            });
        }

        const where = { sucursal_id };
        
        if (tipo) {
            where.tipo = tipo;
        }
        
        if (desde) {
            where.created_at = {
                [Op.gte]: new Date(desde)
            };
        }
        
        if (hasta) {
            where.created_at = {
                ...where.created_at,
                [Op.lte]: new Date(hasta)
            };
        }

        const movimientos = await MovimientoInventario.findAll({
            where,
            include: [
                {
                    model: ProductoPresentacion,
                    as: 'productoPresentacion',
                    include: [
                        { model: Producto, as: 'producto' },
                        { model: Presentacion, as: 'presentacion' }
                    ]
                }
            ],
            order: [['created_at', 'DESC']]
        });

        res.status(200).json({
            success: true,
            sucursal: {
                id: sucursal.id,
                nombre: sucursal.nombre
            },
            count: movimientos.length,
            data: movimientos
        });
    } catch (error) {
        console.error('Error en getMovimientosSucursal:', error);
        next(error);
    }
};

// Obtener movimientos de un producto
const getMovimientosProducto = async (req, res, next) => {
    try {
        const { producto_presentacion_id } = req.params;
        const { sucursal_id, tipo, desde, hasta } = req.query;

        const productoPresentacion = await ProductoPresentacion.findByPk(producto_presentacion_id, {
            include: [
                { model: Producto, as: 'producto' },
                { model: Presentacion, as: 'presentacion' }
            ]
        });

        if (!productoPresentacion) {
            return res.status(404).json({
                success: false,
                message: 'Producto-presentación no encontrado'
            });
        }

        const where = { producto_presentacion_id };
        
        if (sucursal_id) {
            where.sucursal_id = sucursal_id;
        }
        
        if (tipo) {
            where.tipo = tipo;
        }
        
        if (desde) {
            where.created_at = {
                [Op.gte]: new Date(desde)
            };
        }
        
        if (hasta) {
            where.created_at = {
                ...where.created_at,
                [Op.lte]: new Date(hasta)
            };
        }

        const movimientos = await MovimientoInventario.findAll({
            where,
            include: [
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre']
                }
            ],
            order: [['created_at', 'DESC']]
        });

        res.status(200).json({
            success: true,
            producto: productoPresentacion,
            count: movimientos.length,
            data: movimientos
        });
    } catch (error) {
        console.error('Error en getMovimientosProducto:', error);
        next(error);
    }
};

// Obtener movimientos por tipo
const getMovimientosPorTipo = async (req, res, next) => {
    try {
        const { tipo } = req.params;
        const { sucursal_id, desde, hasta } = req.query;

        const tiposPermitidos = ['COMPRA', 'VENTA', 'AJUSTE', 'TRASLADO_ENTRADA', 'TRASLADO_SALIDA', 'DEVOLUCION'];
        
        if (!tiposPermitidos.includes(tipo)) {
            return res.status(400).json({
                success: false,
                message: `Tipo inválido. Permitidos: ${tiposPermitidos.join(', ')}`
            });
        }

        const where = { tipo };
        
        if (sucursal_id) {
            where.sucursal_id = sucursal_id;
        }
        
        if (desde) {
            where.created_at = {
                [Op.gte]: new Date(desde)
            };
        }
        
        if (hasta) {
            where.created_at = {
                ...where.created_at,
                [Op.lte]: new Date(hasta)
            };
        }

        const movimientos = await MovimientoInventario.findAll({
            where,
            include: [
                {
                    model: ProductoPresentacion,
                    as: 'productoPresentacion',
                    include: [
                        { model: Producto, as: 'producto' },
                        { model: Presentacion, as: 'presentacion' }
                    ]
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre']
                }
            ],
            order: [['created_at', 'DESC']]
        });

        res.status(200).json({
            success: true,
            tipo,
            count: movimientos.length,
            data: movimientos
        });
    } catch (error) {
        console.error('Error en getMovimientosPorTipo:', error);
        next(error);
    }
};

// Reporte resumido por tipo
const getResumenMovimientos = async (req, res, next) => {
    try {
        const { sucursal_id, desde, hasta } = req.query;

        const where = {};
        
        if (sucursal_id) {
            where.sucursal_id = sucursal_id;
        }
        
        if (desde) {
            where.created_at = {
                [Op.gte]: new Date(desde)
            };
        }
        
        if (hasta) {
            where.created_at = {
                ...where.created_at,
                [Op.lte]: new Date(hasta)
            };
        }

        const resumen = await MovimientoInventario.findAll({
            where,
            attributes: [
                'tipo',
                [db.Sequelize.fn('COUNT', db.Sequelize.col('id')), 'cantidad_movimientos'],
                [db.Sequelize.fn('SUM', db.Sequelize.col('cantidad')), 'total_unidades']
            ],
            group: ['tipo'],
            raw: true
        });

        res.status(200).json({
            success: true,
            filtros: {
                sucursal_id: sucursal_id || 'todas',
                desde: desde || 'inicio',
                hasta: hasta || 'hoy'
            },
            data: resumen
        });
    } catch (error) {
        console.error('Error en getResumenMovimientos:', error);
        next(error);
    }
};

// Crear movimiento manual (normalmente se crean automáticamente)
const createMovimiento = async (req, res, next) => {
    try {
        const { sucursal_id, producto_presentacion_id, tipo, cantidad, referencia } = req.body;

        // Validaciones
        if (!sucursal_id || !producto_presentacion_id || !tipo || cantidad === undefined) {
            return res.status(400).json({
                success: false,
                message: 'Todos los campos son obligatorios excepto referencia'
            });
        }

        const tiposPermitidos = ['COMPRA', 'VENTA', 'AJUSTE', 'TRASLADO_ENTRADA', 'TRASLADO_SALIDA', 'DEVOLUCION'];
        if (!tiposPermitidos.includes(tipo)) {
            return res.status(400).json({
                success: false,
                message: `Tipo inválido. Permitidos: ${tiposPermitidos.join(', ')}`
            });
        }

        // Verificar que sucursal existe
        const sucursal = await Sucursal.findByPk(sucursal_id);
        if (!sucursal) {
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada'
            });
        }

        // Verificar que producto-presentación existe
        const productoPresentacion = await ProductoPresentacion.findByPk(producto_presentacion_id);
        if (!productoPresentacion) {
            return res.status(404).json({
                success: false,
                message: 'Producto-presentación no encontrado'
            });
        }

        // Crear movimiento
        const movimiento = await MovimientoInventario.create({
            sucursal_id,
            producto_presentacion_id,
            tipo,
            cantidad,
            referencia
        });

        // Obtener con relaciones
        const movimientoCompleto = await MovimientoInventario.findByPk(movimiento.id, {
            include: [
                {
                    model: ProductoPresentacion,
                    as: 'productoPresentacion',
                    include: [
                        { model: Producto, as: 'producto' },
                        { model: Presentacion, as: 'presentacion' }
                    ]
                },
                {
                    model: Sucursal,
                    as: 'sucursal'
                }
            ]
        });

        res.status(201).json({
            success: true,
            message: 'Movimiento registrado exitosamente',
            data: movimientoCompleto
        });
    } catch (error) {
        console.error('Error en createMovimiento:', error);
        next(error);
    }
};

module.exports = {
    getMovimientos,
    getMovimientosSucursal,
    getMovimientosProducto,
    getMovimientosPorTipo,
    getResumenMovimientos,
    createMovimiento
};