
const {
    Recepcion,
    DetalleRecepcion,
    OrdenCompra,
    DetalleOrdenCompra,
    Sucursal,
    Usuario,
    InventarioSucursal,
    MovimientoInventario,
    ProductoPresentacion,
    Producto,
    Presentacion
} = require('../../models/index');
const db = require('../../db/db');


const createRecepcion = async (req, res, next) => {
    const transaction = await db.transaction();

    try {
        const {
            orden_compra_id,
            usuario_id,
            items, 
            observaciones
        } = req.body;

        
        if (!orden_compra_id || !usuario_id) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'orden_compra_id y usuario_id son obligatorios'
            });
        }

        if (!items || !Array.isArray(items) || items.length === 0) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'Debe proporcionar al menos un producto a recepcionar (items)'
            });
        }

        
        const orden = await OrdenCompra.findByPk(orden_compra_id, {
            include: [
                {
                    model: DetalleOrdenCompra,
                    as: 'detalles'
                }
            ]
        });

        if (!orden) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Orden de compra no encontrada'
            });
        }

        if (orden.estado === 'RECIBIDA') {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'La orden ya está completamente recibida'
            });
        }

        if (orden.estado === 'CANCELADA') {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'No se puede recepcionar una orden cancelada'
            });
        }

        
        const usuario = await Usuario.findByPk(usuario_id);
        if (!usuario) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        
        const sucursalesUsadas = new Set();

        for (const item of items) {
            const { detalle_orden_id, cantidad_recibida, sucursal_id } = item;

            if (!detalle_orden_id || !cantidad_recibida || !sucursal_id) {
                await transaction.rollback();
                return res.status(400).json({
                    success: false,
                    message: 'Cada item debe tener detalle_orden_id, cantidad_recibida y sucursal_id'
                });
            }

            if (cantidad_recibida <= 0) {
                await transaction.rollback();
                return res.status(400).json({
                    success: false,
                    message: 'cantidad_recibida debe ser mayor a 0'
                });
            }

            
            const sucursal = await Sucursal.findByPk(sucursal_id);
            if (!sucursal) {
                await transaction.rollback();
                return res.status(404).json({
                    success: false,
                    message: `Sucursal ${sucursal_id} no encontrada`
                });
            }
            sucursalesUsadas.add(sucursal_id);

            
            const detalleOrden = orden.detalles.find(d => d.id === detalle_orden_id);

            if (!detalleOrden) {
                await transaction.rollback();
                return res.status(404).json({
                    success: false,
                    message: `Detalle de orden ${detalle_orden_id} no encontrado en esta orden`
                });
            }

            
            const pendiente = detalleOrden.cantidad - detalleOrden.cantidad_recibida;

            if (cantidad_recibida > pendiente) {
                await transaction.rollback();
                return res.status(400).json({
                    success: false,
                    message: `No se pueden recibir ${cantidad_recibida} unidades. Pendiente de recibir: ${pendiente}`,
                    detalle_orden_id
                });
            }
        }

        
        const itemsPorSucursal = {};
        items.forEach(item => {
            const sucId = item.sucursal_id;
            if (!itemsPorSucursal[sucId]) {
                itemsPorSucursal[sucId] = [];
            }
            itemsPorSucursal[sucId].push(item);
        });

        console.log(`📦 Recibiendo en ${Object.keys(itemsPorSucursal).length} sucursal(es)`);

        const recepcionesCreadas = [];

        
        for (const [sucursal_id, itemsSucursal] of Object.entries(itemsPorSucursal)) {
            console.log(`📍 Procesando ${itemsSucursal.length} items para sucursal ${sucursal_id}`);

            
            const recepcion = await Recepcion.create({
                orden_compra_id,
                sucursal_id: parseInt(sucursal_id),
                usuario_id,
                observaciones: observaciones || null
            }, { transaction });

            
            for (const item of itemsSucursal) {
                const { detalle_orden_id, cantidad_recibida, observaciones: obs_item } = item;

                
                const detalleOrden = await DetalleOrdenCompra.findByPk(detalle_orden_id);

                
                await DetalleRecepcion.create({
                    recepcion_id: recepcion.id,
                    detalle_orden_id,
                    cantidad_recibida,
                    observaciones: obs_item || null
                }, { transaction });

                
                await detalleOrden.update({
                    cantidad_recibida: detalleOrden.cantidad_recibida + cantidad_recibida
                }, { transaction });

                
                const inventario = await InventarioSucursal.findOne({
                    where: {
                        sucursal_id: parseInt(sucursal_id),
                        producto_presentacion_id: detalleOrden.producto_presentacion_id
                    }
                });

                if (inventario) {
                    
                    await inventario.update({
                        existencia: inventario.existencia + cantidad_recibida
                    }, { transaction });
                } else {
                    
                    await InventarioSucursal.create({
                        sucursal_id: parseInt(sucursal_id),
                        producto_presentacion_id: detalleOrden.producto_presentacion_id,
                        existencia: cantidad_recibida,
                        minimo: 0
                    }, { transaction });
                }

                
                await MovimientoInventario.create({
                    sucursal_id: parseInt(sucursal_id),
                    producto_presentacion_id: detalleOrden.producto_presentacion_id,
                    tipo: 'COMPRA',
                    cantidad: cantidad_recibida,
                    referencia: `Recepción OC-${orden.numero}`
                }, { transaction });
            }

            recepcionesCreadas.push(recepcion.id);
        }

        
        const detallesActualizados = await DetalleOrdenCompra.findAll({
            where: { orden_compra_id },
            transaction
        });

        let todoRecibido = true;
        let algoRecibido = false;

        for (const detalle of detallesActualizados) {
            console.log(`📦 Producto ${detalle.id}: ${detalle.cantidad_recibida}/${detalle.cantidad}`);

            if (detalle.cantidad_recibida < detalle.cantidad) {
                todoRecibido = false;
            }
            if (detalle.cantidad_recibida > 0) {
                algoRecibido = true;
            }
        }

        let nuevoEstado = 'PENDIENTE';
        if (todoRecibido) {
            nuevoEstado = 'RECIBIDA';
        } else if (algoRecibido) {
            nuevoEstado = 'PARCIAL';
        }

        console.log(`✅ Estado calculado: ${nuevoEstado}`);

        await orden.update({ estado: nuevoEstado }, { transaction });

        
        await transaction.commit();

        
        const recepcionesCompletas = await Recepcion.findAll({
            where: { id: recepcionesCreadas },
            include: [
                {
                    model: OrdenCompra,
                    as: 'ordenCompra',
                    attributes: ['id', 'numero', 'serie', 'total', 'estado']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre']
                },
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['id', 'nombre', 'email']
                },
                {
                    model: DetalleRecepcion,
                    as: 'detalles',
                    include: [
                        {
                            model: DetalleOrdenCompra,
                            as: 'detalleOrden',
                            include: [
                                {
                                    model: ProductoPresentacion,
                                    as: 'productoPresentacion',
                                    include: [
                                        { model: Producto, as: 'producto' },
                                        { model: Presentacion, as: 'presentacion' }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        });

        res.status(201).json({
            success: true,
            message: `Recepción(es) registrada(s) exitosamente en ${Object.keys(itemsPorSucursal).length} sucursal(es). Estado de orden: ${nuevoEstado}`,
            data: recepcionesCompletas.length === 1 ? recepcionesCompletas[0] : recepcionesCompletas,
            recepciones_creadas: recepcionesCreadas.length
        });

    } catch (error) {
        await transaction.rollback();
        console.error('Error en createRecepcion:', error);
        next(error);
    }
};


const getRecepciones = async (req, res, next) => {
    try {
        const { orden_compra_id, sucursal_id, usuario_id } = req.query;

        const where = {};

        if (orden_compra_id) where.orden_compra_id = orden_compra_id;
        if (sucursal_id) where.sucursal_id = sucursal_id;
        if (usuario_id) where.usuario_id = usuario_id;

        const recepciones = await Recepcion.findAll({
            where,
            include: [
                {
                    model: OrdenCompra,
                    as: 'ordenCompra',
                    attributes: ['id', 'numero', 'serie', 'total']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre']
                },
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['id', 'nombre']
                }
            ],
            order: [['fecha_recepcion', 'DESC']]
        });

        res.status(200).json({
            success: true,
            count: recepciones.length,
            data: recepciones
        });

    } catch (error) {
        console.error('Error en getRecepciones:', error);
        next(error);
    }
};


const getRecepcionById = async (req, res, ReintentarLContinuarnext) => {
    try {
        const { id } = req.params;
        const recepcion = await Recepcion.findByPk(id, {
            include: [
                {
                    model: OrdenCompra,
                    as: 'ordenCompra',
                    include: [
                        {
                            model: Proveedor,
                            as: 'proveedor',
                            attributes: ['id', 'nombre', 'nit']
                        }
                    ]
                },
                {
                    model: Sucursal,
                    as: 'sucursal'
                },
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['id', 'nombre', 'email']
                },
                {
                    model: DetalleRecepcion,
                    as: 'detalles',
                    include: [
                        {
                            model: DetalleOrdenCompra,
                            as: 'detalleOrden',
                            include: [
                                {
                                    model: ProductoPresentacion,
                                    as: 'productoPresentacion',
                                    include: [
                                        { model: Producto, as: 'producto' },
                                        { model: Presentacion, as: 'presentacion' }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        });

        if (!recepcion) {
            return res.status(404).json({
                success: false,
                message: 'Recepción no encontrada'
            });
        }

        res.status(200).json({
            success: true,
            data: recepcion
        });

    } catch (error) {
        console.error('Error en getRecepcionById:', error);
        next(error);
    }
};
module.exports = {
    createRecepcion,
    getRecepciones,
    getRecepcionById
};