// controllers/compras/ordenCompra.controller.js
const {
    OrdenCompra,
    DetalleOrdenCompra,
    Proveedor,
    Sucursal,
    Usuario,
    ProductoPresentacion,
    Producto,
    Presentacion,
    Recepcion,
    DetalleRecepcion
} = require('../../models/index');
const db = require('../../db/db');
const { Op } = require('sequelize');

// ===== FUNCIÓN AUXILIAR: Obtener siguiente número =====
const obtenerSiguienteNumero = async (serie, transaction) => {
    const [secuencia] = await db.query(
        'SELECT ultimo_numero FROM secuencias_facturas WHERE serie = ? FOR UPDATE',
        {
            replacements: [serie],
            type: db.QueryTypes.SELECT,
            transaction
        }
    );

    if (!secuencia) {
        throw new Error(`Serie ${serie} no existe`);
    }

    const nuevoNumero = secuencia.ultimo_numero + 1;

    await db.query(
        'UPDATE secuencias_facturas SET ultimo_numero = ? WHERE serie = ?',
        {
            replacements: [nuevoNumero, serie],
            transaction
        }
    );

    return nuevoNumero;
};

// ===== CREAR ORDEN DE COMPRA =====
const createOrdenCompra = async (req, res, next) => {
    const transaction = await db.transaction();

    try {
        const {
            proveedor_id,
            sucursal_id,
            usuario_id,
            fecha_orden,
            fecha_entrega_estimada,
            serie = 'OC',
            items,
            observaciones
        } = req.body;

        // ========== VALIDACIONES BÁSICAS ==========
        if (!proveedor_id || !sucursal_id || !usuario_id || !fecha_orden) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'proveedor_id, sucursal_id, usuario_id y fecha_orden son obligatorios'
            });
        }

        if (!items || !Array.isArray(items) || items.length === 0) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'Debe proporcionar al menos un producto (items)'
            });
        }

        // ========== VERIFICAR ENTIDADES ==========
        const proveedor = await Proveedor.findByPk(proveedor_id);
        if (!proveedor || !proveedor.activo) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Proveedor no encontrado o inactivo'
            });
        }

        const sucursal = await Sucursal.findByPk(sucursal_id);
        if (!sucursal || !sucursal.activa) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada o inactiva'
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

        // ========== VALIDAR Y CALCULAR ITEMS ==========
        let subtotal = 0;
        let descuento_total = 0;
        const detallesParaCrear = [];

        for (const item of items) {
            const { producto_presentacion_id, cantidad, precio_unitario, descuento_pct = 0 } = item;

            // Validaciones del item
            if (!producto_presentacion_id || !cantidad || precio_unitario === undefined) {
                await transaction.rollback();
                return res.status(400).json({
                    success: false,
                    message: 'Cada item debe tener producto_presentacion_id, cantidad y precio_unitario'
                });
            }

            if (cantidad <= 0) {
                await transaction.rollback();
                return res.status(400).json({
                    success: false,
                    message: 'La cantidad debe ser mayor a 0'
                });
            }

            if (precio_unitario < 0) {
                await transaction.rollback();
                return res.status(400).json({
                    success: false,
                    message: 'El precio no puede ser negativo'
                });
            }

            // Verificar que el producto existe
            const productoPresentacion = await ProductoPresentacion.findByPk(producto_presentacion_id);
            if (!productoPresentacion || !productoPresentacion.activo) {
                await transaction.rollback();
                return res.status(404).json({
                    success: false,
                    message: `Producto-presentación ${producto_presentacion_id} no encontrado o inactivo`
                });
            }

            // Calcular subtotal del item
            const subtotal_item = cantidad * precio_unitario;
            const descuento_item = subtotal_item * (descuento_pct / 100);
            const subtotal_neto = subtotal_item - descuento_item;

            subtotal += subtotal_item;
            descuento_total += descuento_item;

            // Guardar para crear después
            detallesParaCrear.push({
                producto_presentacion_id,
                cantidad,
                precio_unitario,
                descuento_pct,
                subtotal: subtotal_neto
            });
        }

        const total = subtotal - descuento_total;

        // ========== OBTENER NÚMERO CORRELATIVO ==========
        const numero = await obtenerSiguienteNumero(serie, transaction);

        // ========== CREAR ORDEN ==========
        const orden = await OrdenCompra.create({
            numero,
            serie,
            proveedor_id,
            sucursal_id,
            usuario_id,
            fecha_orden,
            fecha_entrega_estimada: fecha_entrega_estimada || null,
            subtotal,
            descuento_total,
            total,
            estado: 'PENDIENTE',
            observaciones: observaciones || null
        }, { transaction });

        // ========== CREAR DETALLES ==========
        for (const detalle of detallesParaCrear) {
            await DetalleOrdenCompra.create({
                orden_compra_id: orden.id,
                producto_presentacion_id: detalle.producto_presentacion_id,
                cantidad: detalle.cantidad,
                precio_unitario: detalle.precio_unitario,
                descuento_pct: detalle.descuento_pct,
                subtotal: detalle.subtotal,
                cantidad_recibida: 0
            }, { transaction });
        }

        // ========== COMMIT ==========
        await transaction.commit();

        // ========== OBTENER ORDEN COMPLETA ==========
        const ordenCompleta = await OrdenCompra.findByPk(orden.id, {
            include: [
                {
                    model: Proveedor,
                    as: 'proveedor',
                    attributes: ['id', 'nombre', 'nit', 'telefono']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre', 'direccion']
                },
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['id', 'nombre', 'email']
                },
                {
                    model: DetalleOrdenCompra,
                    as: 'detalles',
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
        });

        res.status(201).json({
            success: true,
            message: `Orden ${serie}-${numero} creada exitosamente`,
            data: ordenCompleta
        });

    } catch (error) {
        await transaction.rollback();
        console.error('Error en createOrdenCompra:', error);
        next(error);
    }
};

// ===== OBTENER TODAS LAS ÓRDENES =====
const getOrdenesCompra = async (req, res, next) => {
    try {
        const {
            proveedor_id,
            sucursal_id,
            usuario_id,
            estado,
            desde,
            hasta,
            limite = 50
        } = req.query;

        const where = {};

        if (proveedor_id) where.proveedor_id = proveedor_id;
        if (sucursal_id) where.sucursal_id = sucursal_id;
        if (usuario_id) where.usuario_id = usuario_id;
        if (estado) where.estado = estado;

        if (desde) {
            where.fecha_orden = {
                [Op.gte]: desde
            };
        }

        if (hasta) {
            where.fecha_orden = {
                ...where.fecha_orden,
                [Op.lte]: hasta
            };
        }

        const ordenes = await OrdenCompra.findAll({
            where,
            include: [
                {
                    model: Proveedor,
                    as: 'proveedor',
                    attributes: ['id', 'nombre', 'nit']
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
            order: [['fecha_orden', 'DESC']],
            limit: parseInt(limite)
        });

        res.status(200).json({
            success: true,
            count: ordenes.length,
            data: ordenes
        });

    } catch (error) {
        console.error('Error en getOrdenesCompra:', error);
        next(error);
    }
};

// ===== OBTENER ORDEN POR ID =====
const getOrdenCompraById = async (req, res, next) => {
    try {
        const { id } = req.params;

        const orden = await OrdenCompra.findByPk(id, {
            include: [
                {
                    model: Proveedor,
                    as: 'proveedor'
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
                    model: DetalleOrdenCompra,
                    as: 'detalles',
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
                },
                {
                    model: Recepcion,
                    as: 'recepciones',
                    include: [
                        {
                            model: Usuario,
                            as: 'usuario',
                            attributes: ['id', 'nombre']
                        },
                        {
                            model: DetalleRecepcion,
                            as: 'detalles'
                        }
                    ]
                }
            ]
        });

        if (!orden) {
            return res.status(404).json({
                success: false,
                message: 'Orden de compra no encontrada'
            });
        }

        res.status(200).json({
            success: true,
            data: orden
        });

    } catch (error) {
        console.error('Error en getOrdenCompraById:', error);
        next(error);
    }
};

// ===== CANCELAR ORDEN =====
const cancelarOrdenCompra = async (req, res, next) => {
    try {
        const { id } = req.params;

        const orden = await OrdenCompra.findByPk(id);

        if (!orden) {
            return res.status(404).json({
                success: false,
                message: 'Orden de compra no encontrada'
            });
        }

        if (orden.estado !== 'PENDIENTE') {
            return res.status(400).json({
                success: false,
                message: 'Solo se pueden cancelar órdenes en estado PENDIENTE',
                estado_actual: orden.estado
            });
        }

        await orden.update({ estado: 'CANCELADA' });

        res.status(200).json({
            success: true,
            message: `Orden ${orden.serie}-${orden.numero} cancelada exitosamente`,
            data: orden
        });

    } catch (error) {
        console.error('Error en cancelarOrdenCompra:', error);
        next(error);
    }
};

module.exports = {
    createOrdenCompra,
    getOrdenesCompra,
    getOrdenCompraById,
    cancelarOrdenCompra
};