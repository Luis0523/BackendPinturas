
const { InventarioSucursal, ProductoPresentacion, Producto, Presentacion, Sucursal, Categoria, Marca, MovimientoInventario, Precio } = require('../../models/index');
const { Op } = require('sequelize');
const db = require('../../db/db');


const getInventarioSucursal = async (req, res, next) => {
    try {
        const { sucursal_id } = req.params;
        const { alerta } = req.query; 

        
        const sucursal = await Sucursal.findByPk(sucursal_id);
        if (!sucursal) {
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada'
            });
        }

        const where = { sucursal_id };

        
        if (alerta === 'true') {
            where.existencia = {
                [Op.lt]: db.Sequelize.col('minimo')
            };
        }

        const inventario = await InventarioSucursal.findAll({
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
                        },
                        {
                            model: Precio,
                            as: 'precios',
                            where: {
                                sucursal_id: sucursal_id,
                                activo: true
                            },
                            required: false, 
                            order: [['vigente_desde', 'DESC']], 
                            limit: 1 
                        }
                    ]
                }
            ],
            order: [[{ model: ProductoPresentacion, as: 'productoPresentacion' }, { model: Producto, as: 'producto' }, 'descripcion', 'ASC']]
        });

        
        const total_productos = inventario.length;
        const con_stock = inventario.filter(i => i.existencia > 0).length;
        const sin_stock = inventario.filter(i => i.existencia === 0).length;
        const con_alerta = inventario.filter(i => i.existencia < i.minimo && i.existencia > 0).length;

        res.status(200).json({
            success: true,
            sucursal: {
                id: sucursal.id,
                nombre: sucursal.nombre
            },
            estadisticas: {
                total_productos,
                con_stock,
                sin_stock,
                con_alerta
            },
            data: inventario.map(inv => ({
                ...inv.toJSON(),
                estado: inv.existencia === 0 ? 'AGOTADO' :
                    inv.existencia < inv.minimo ? 'BAJO' : 'OK'
            }))
        });
    } catch (error) {
        console.error('Error en getInventarioSucursal:', error);
        next(error);
    }
};


const getStockProducto = async (req, res, next) => {
    try {
        const { producto_presentacion_id } = req.params;

        
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

        const inventarios = await InventarioSucursal.findAll({
            where: { producto_presentacion_id },
            include: [
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre', 'direccion']
                }
            ],
            order: [['existencia', 'DESC']]
        });

        const total_existencia = inventarios.reduce((sum, inv) => sum + inv.existencia, 0);
        const sucursales_con_stock = inventarios.filter(inv => inv.existencia > 0).length;

        res.status(200).json({
            success: true,
            producto: productoPresentacion,
            estadisticas: {
                total_existencia,
                total_sucursales: inventarios.length,
                sucursales_con_stock
            },
            data: inventarios.map(inv => ({
                ...inv.toJSON(),
                estado: inv.existencia === 0 ? 'AGOTADO' :
                    inv.existencia < inv.minimo ? 'BAJO' : 'OK'
            }))
        });
    } catch (error) {
        console.error('Error en getStockProducto:', error);
        next(error);
    }
};


const getAlertasStock = async (req, res, next) => {
    try {
        const { sucursal_id } = req.query;

        const where = {
            existencia: {
                [Op.lt]: db.Sequelize.col('minimo'),
                [Op.gt]: 0
            }
        };

        if (sucursal_id) {
            where.sucursal_id = sucursal_id;
        }

        const alertas = await InventarioSucursal.findAll({
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
            order: [
                [db.Sequelize.literal('(minimo - existencia)'), 'DESC']
            ]
        });

        res.status(200).json({
            success: true,
            count: alertas.length,
            data: alertas.map(alerta => ({
                ...alerta.toJSON(),
                faltante: alerta.minimo - alerta.existencia
            }))
        });
    } catch (error) {
        console.error('Error en getAlertasStock:', error);
        next(error);
    }
};


const getProductosAgotados = async (req, res, next) => {
    try {
        const { sucursal_id } = req.query;

        const where = { existencia: 0 };

        if (sucursal_id) {
            where.sucursal_id = sucursal_id;
        }

        const agotados = await InventarioSucursal.findAll({
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
            ]
        });

        res.status(200).json({
            success: true,
            count: agotados.length,
            data: agotados
        });
    } catch (error) {
        console.error('Error en getProductosAgotados:', error);
        next(error);
    }
};


const upsertInventario = async (req, res, next) => {
    try {
        const { sucursal_id, producto_presentacion_id, existencia, minimo } = req.body;

        
        if (!sucursal_id || !producto_presentacion_id) {
            return res.status(400).json({
                success: false,
                message: 'sucursal_id y producto_presentacion_id son obligatorios'
            });
        }

        if (existencia === undefined) {
            return res.status(400).json({
                success: false,
                message: 'existencia es obligatoria'
            });
        }

        if (existencia < 0) {
            return res.status(400).json({
                success: false,
                message: 'La existencia no puede ser negativa'
            });
        }

        
        const sucursal = await Sucursal.findByPk(sucursal_id);
        if (!sucursal) {
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada'
            });
        }

        
        const productoPresentacion = await ProductoPresentacion.findByPk(producto_presentacion_id);
        if (!productoPresentacion) {
            return res.status(404).json({
                success: false,
                message: 'Producto-presentación no encontrado'
            });
        }

        
        let inventario = await InventarioSucursal.findOne({
            where: {
                sucursal_id,
                producto_presentacion_id
            }
        });

        if (inventario) {
            
            await inventario.update({
                existencia,
                minimo: minimo !== undefined ? minimo : inventario.minimo
            });
        } else {
            
            inventario = await InventarioSucursal.create({
                sucursal_id,
                producto_presentacion_id,
                existencia,
                minimo: minimo || 0
            });
        }

        
        const inventarioCompleto = await InventarioSucursal.findByPk(inventario.id, {
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

        res.status(200).json({
            success: true,
            message: 'Inventario actualizado exitosamente',
            data: inventarioCompleto
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe un registro de inventario para este producto en esta sucursal'
            });
        }
        console.error('Error en upsertInventario:', error);
        next(error);
    }
};



const ajustarInventario = async (req, res, next) => {
    const transaction = await db.transaction(); 

    try {
        const { sucursal_id, producto_presentacion_id, cantidad, motivo } = req.body;

        
        if (!sucursal_id || !producto_presentacion_id || cantidad === undefined) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'sucursal_id, producto_presentacion_id y cantidad son obligatorios'
            });
        }

        
        const inventario = await InventarioSucursal.findOne({
            where: {
                sucursal_id,
                producto_presentacion_id
            }
        });

        if (!inventario) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'No existe inventario para este producto en esta sucursal'
            });
        }

        const nueva_existencia = inventario.existencia + cantidad;

        if (nueva_existencia < 0) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: `No hay suficiente stock. Existencia actual: ${inventario.existencia}`
            });
        }

        
        await inventario.update({ existencia: nueva_existencia }, { transaction });

        
        await MovimientoInventario.create({
            sucursal_id,
            producto_presentacion_id,
            tipo: 'AJUSTE',
            cantidad,
            referencia: motivo || 'Ajuste manual'
        }, { transaction });

        
        await transaction.commit();

        
        const inventarioActualizado = await InventarioSucursal.findByPk(inventario.id, {
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

        res.status(200).json({
            success: true,
            message: `Inventario ajustado: ${cantidad > 0 ? '+' : ''}${cantidad}`,
            motivo: motivo || 'Sin motivo especificado',
            existencia_anterior: inventario.existencia,
            existencia_nueva: nueva_existencia,
            movimiento_registrado: true, 
            data: inventarioActualizado
        });
    } catch (error) {
        await transaction.rollback();
        console.error('Error en ajustarInventario:', error);
        next(error);
    }
};



const trasladarInventario = async (req, res, next) => {
    const transaction = await db.transaction(); 

    try {
        const { producto_presentacion_id, sucursal_origen_id, sucursal_destino_id, cantidad } = req.body;

        
        if (!producto_presentacion_id || !sucursal_origen_id || !sucursal_destino_id || !cantidad) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'Todos los campos son obligatorios'
            });
        }

        if (cantidad <= 0) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'La cantidad debe ser mayor a 0'
            });
        }

        if (sucursal_origen_id === sucursal_destino_id) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'La sucursal origen y destino no pueden ser la misma'
            });
        }

        
        const inventarioOrigen = await InventarioSucursal.findOne({
            where: {
                sucursal_id: sucursal_origen_id,
                producto_presentacion_id
            }
        });

        if (!inventarioOrigen) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'No existe inventario en la sucursal origen'
            });
        }

        if (inventarioOrigen.existencia < cantidad) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: `Stock insuficiente en origen. Disponible: ${inventarioOrigen.existencia}`
            });
        }

        
        let inventarioDestino = await InventarioSucursal.findOne({
            where: {
                sucursal_id: sucursal_destino_id,
                producto_presentacion_id
            }
        });

        if (!inventarioDestino) {
            inventarioDestino = await InventarioSucursal.create({
                sucursal_id: sucursal_destino_id,
                producto_presentacion_id,
                existencia: 0,
                minimo: 0
            }, { transaction });
        }

        
        await inventarioOrigen.update({
            existencia: inventarioOrigen.existencia - cantidad
        }, { transaction });

        
        await inventarioDestino.update({
            existencia: inventarioDestino.existencia + cantidad
        }, { transaction });

        
        await MovimientoInventario.create({
            sucursal_id: sucursal_origen_id,
            producto_presentacion_id,
            tipo: 'TRASLADO_SALIDA',
            cantidad: -cantidad,
            referencia: `Traslado a sucursal ID: ${sucursal_destino_id}`
        }, { transaction });

        
        await MovimientoInventario.create({
            sucursal_id: sucursal_destino_id,
            producto_presentacion_id,
            tipo: 'TRASLADO_ENTRADA',
            cantidad: cantidad,
            referencia: `Traslado desde sucursal ID: ${sucursal_origen_id}`
        }, { transaction });

        
        await transaction.commit();

        res.status(200).json({
            success: true,
            message: 'Traslado realizado exitosamente',
            movimientos_registrados: 2, 
            traslado: {
                cantidad,
                origen: {
                    sucursal_id: sucursal_origen_id,
                    existencia_anterior: inventarioOrigen.existencia + cantidad,
                    existencia_nueva: inventarioOrigen.existencia
                },
                destino: {
                    sucursal_id: sucursal_destino_id,
                    existencia_anterior: inventarioDestino.existencia - cantidad,
                    existencia_nueva: inventarioDestino.existencia
                }
            }
        });
    } catch (error) {
        await transaction.rollback();
        console.error('Error en trasladarInventario:', error);
        next(error);
    }
};

/**
 * Obtener inventario de todas las presentaciones de un producto
 */
const getInventarioProducto = async (req, res, next) => {
    try {
        const { producto_id } = req.params;

        // Verificar que el producto existe
        const producto = await Producto.findByPk(producto_id);
        if (!producto) {
            return res.status(404).json({
                success: false,
                message: 'Producto no encontrado'
            });
        }

        // Obtener todas las presentaciones del producto
        const presentaciones = await ProductoPresentacion.findAll({
            where: { producto_id, activo: true },
            include: [
                {
                    model: Presentacion,
                    as: 'presentacion'
                }
            ]
        });

        // Obtener inventario de todas las presentaciones en todas las sucursales
        const presentacionIds = presentaciones.map(p => p.id);

        const inventarios = await InventarioSucursal.findAll({
            where: {
                producto_presentacion_id: presentacionIds
            },
            include: [
                {
                    model: ProductoPresentacion,
                    as: 'productoPresentacion',
                    include: [
                        {
                            model: Presentacion,
                            as: 'presentacion'
                        },
                        {
                            model: Precio,
                            as: 'precios',
                            where: { activo: true },
                            required: false,
                            order: [['vigente_desde', 'DESC']],
                            limit: 1
                        }
                    ]
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre', 'direccion']
                }
            ],
            order: [
                [{ model: Sucursal, as: 'sucursal' }, 'nombre', 'ASC'],
                [{ model: ProductoPresentacion, as: 'productoPresentacion' }, { model: Presentacion, as: 'presentacion' }, 'nombre', 'ASC']
            ]
        });

        res.status(200).json({
            success: true,
            producto: {
                id: producto.id,
                descripcion: producto.descripcion,
                codigo_sku: producto.codigo_sku
            },
            count: inventarios.length,
            data: inventarios.map(inv => ({
                ...inv.toJSON(),
                stock_minimo: inv.minimo,
                stock_maximo: inv.maximo || null,
                estado: inv.existencia === 0 ? 'AGOTADO' :
                    inv.existencia < inv.minimo ? 'BAJO' : 'OK'
            }))
        });
    } catch (error) {
        console.error('Error en getInventarioProducto:', error);
        next(error);
    }
};

module.exports = {
    getInventarioSucursal,
    getStockProducto,
    getAlertasStock,
    getProductosAgotados,
    getInventarioProducto,
    upsertInventario,
    ajustarInventario,
    trasladarInventario
};