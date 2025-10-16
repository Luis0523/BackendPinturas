// controllers/ventas/factura.controller.js
const { 
    Factura, 
    DetalleFactura, 
    Pago, 
    Cliente, 
    Usuario, 
    Sucursal,
    ProductoPresentacion,
    Producto,
    Presentacion,
    InventarioSucursal,
    MovimientoInventario,
    Precio
} = require('../../models/index');
const db = require('../../db/db');
const { Op } = require('sequelize');

// ===== FUNCIÓN AUXILIAR: Obtener siguiente número =====
const obtenerSiguienteNumero = async (serie, transaction) => {
    // Lock pesimista para evitar números duplicados
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

    // Actualizar secuencia
    await db.query(
        'UPDATE secuencias_facturas SET ultimo_numero = ? WHERE serie = ?',
        {
            replacements: [nuevoNumero, serie],
            transaction
        }
    );

    return nuevoNumero;
};

// ===== CREAR FACTURA =====
const createFactura = async (req, res, next) => {
    const transaction = await db.transaction();
    
    try {
        const { 
            cliente_id, 
            usuario_id, 
            sucursal_id, 
            serie = 'A',
            items,  // Array de productos
            pagos   // Array de pagos
        } = req.body;

        // ========== VALIDACIONES BÁSICAS ==========
        if (!cliente_id || !usuario_id || !sucursal_id) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'cliente_id, usuario_id y sucursal_id son obligatorios'
            });
        }

        if (!items || !Array.isArray(items) || items.length === 0) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'Debe proporcionar al menos un producto (items)'
            });
        }

        if (!pagos || !Array.isArray(pagos) || pagos.length === 0) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'Debe proporcionar al menos un método de pago'
            });
        }

        // ========== VERIFICAR ENTIDADES ==========
        const cliente = await Cliente.findByPk(cliente_id);
        if (!cliente) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Cliente no encontrado'
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

        const sucursal = await Sucursal.findByPk(sucursal_id);
        if (!sucursal || !sucursal.activa) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada o inactiva'
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

            // Verificar stock
            const inventario = await InventarioSucursal.findOne({
                where: {
                    sucursal_id,
                    producto_presentacion_id
                }
            });

            if (!inventario) {
                await transaction.rollback();
                return res.status(400).json({
                    success: false,
                    message: `No hay inventario del producto ${producto_presentacion_id} en esta sucursal`
                });
            }

            if (inventario.existencia < cantidad) {
                await transaction.rollback();
                return res.status(400).json({
                    success: false,
                    message: `Stock insuficiente. Disponible: ${inventario.existencia}, Solicitado: ${cantidad}`,
                    producto_presentacion_id
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
                descuento_pct_aplicado: descuento_pct,
                subtotal: subtotal_neto,
                inventario  // Guardar referencia para descontar después
            });
        }

        const total = subtotal - descuento_total;

        // ========== VALIDAR PAGOS ==========
        const suma_pagos = pagos.reduce((sum, pago) => sum + parseFloat(pago.monto), 0);

        if (Math.abs(suma_pagos - total) > 0.01) { // Tolerancia de 1 centavo por redondeo
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: `La suma de pagos (${suma_pagos.toFixed(2)}) no coincide con el total (${total.toFixed(2)})`,
                diferencia: (suma_pagos - total).toFixed(2)
            });
        }

        // ========== OBTENER NÚMERO CORRELATIVO ==========
        const numero = await obtenerSiguienteNumero(serie, transaction);

        // ========== CREAR FACTURA ==========
        const factura = await Factura.create({
            numero,
            serie,
            cliente_id,
            usuario_id,
            sucursal_id,
            subtotal,
            descuento_total,
            total,
            estado: 'EMITIDA'
        }, { transaction });

        // ========== CREAR DETALLES Y DESCONTAR INVENTARIO ==========
        for (const detalle of detallesParaCrear) {
            // Crear detalle
            await DetalleFactura.create({
                factura_id: factura.id,
                producto_presentacion_id: detalle.producto_presentacion_id,
                cantidad: detalle.cantidad,
                precio_unitario: detalle.precio_unitario,
                descuento_pct_aplicado: detalle.descuento_pct_aplicado,
                subtotal: detalle.subtotal
            }, { transaction });

            // Descontar inventario
            await detalle.inventario.update({
                existencia: detalle.inventario.existencia - detalle.cantidad
            }, { transaction });

            // Crear movimiento de inventario
            await MovimientoInventario.create({
                sucursal_id,
                producto_presentacion_id: detalle.producto_presentacion_id,
                tipo: 'VENTA',
                cantidad: -detalle.cantidad,
                referencia: `Factura ${serie}-${numero}`
            }, { transaction });
        }

        // ========== CREAR PAGOS ==========
        for (const pago of pagos) {
            await Pago.create({
                factura_id: factura.id,
                tipo: pago.tipo,
                monto: pago.monto,
                referencia: pago.referencia || null,
                entidad: pago.entidad || null,
                transaccion_gateway_id: pago.transaccion_gateway_id || null,
                autorizado_por: pago.autorizado_por || null
            }, { transaction });
        }

        // ========== COMMIT ==========
        await transaction.commit();

        // ========== OBTENER FACTURA COMPLETA ==========
        const facturaCompleta = await Factura.findByPk(factura.id, {
            include: [
                {
                    model: Cliente,
                    as: 'cliente',
                    attributes: ['id', 'nombre', 'nit', 'email']
                },
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['id', 'nombre', 'email']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre', 'direccion']
                },
                {
                    model: DetalleFactura,
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
                    model: Pago,
                    as: 'pagos'
                }
            ]
        });

        res.status(201).json({
            success: true,
            message: `Factura ${serie}-${numero} creada exitosamente`,
            data: facturaCompleta
        });

    } catch (error) {
        await transaction.rollback();
        console.error('Error en createFactura:', error);
        next(error);
    }
};

// ===== OBTENER TODAS LAS FACTURAS =====
const getFacturas = async (req, res, next) => {
    try {
        const { 
            sucursal_id, 
            cliente_id, 
            usuario_id, 
            estado, 
            desde, 
            hasta,
            limite = 50
        } = req.query;

        const where = {};

        if (sucursal_id) where.sucursal_id = sucursal_id;
        if (cliente_id) where.cliente_id = cliente_id;
        if (usuario_id) where.usuario_id = usuario_id;
        if (estado) where.estado = estado;

        if (desde) {
            where.fecha_emision = {
                [Op.gte]: new Date(desde)
            };
        }

        if (hasta) {
            where.fecha_emision = {
                ...where.fecha_emision,
                [Op.lte]: new Date(hasta)
            };
        }

        const facturas = await Factura.findAll({
            where,
            include: [
                {
                    model: Cliente,
                    as: 'cliente',
                    attributes: ['id', 'nombre', 'nit']
                },
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['id', 'nombre']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre']
                }
            ],
            order: [['fecha_emision', 'DESC']],
            limit: parseInt(limite)
        });

        res.status(200).json({
            success: true,
            count: facturas.length,
            data: facturas
        });
    } catch (error) {
        console.error('Error en getFacturas:', error);
        next(error);
    }
};

// ===== OBTENER FACTURA POR ID =====
const getFacturaById = async (req, res, next) => {
    try {
        const { id } = req.params;

        const factura = await Factura.findByPk(id, {
            include: [
                {
                    model: Cliente,
                    as: 'cliente'
                },
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['id', 'nombre', 'email']
                },
                {
                    model: Sucursal,
                    as: 'sucursal'
                },
                {
                    model: DetalleFactura,
                    as: 'detalles',
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
                                { model: Presentacion, as: 'presentacion' }
                            ]
                        }
                    ]
                },
                {
                    model: Pago,
                    as: 'pagos'
                },
                {
                    model: Usuario,
                    as: 'anulador',
                    attributes: ['id', 'nombre']
                }
            ]
        });

        if (!factura) {
            return res.status(404).json({
                success: false,
                message: 'Factura no encontrada'
            });
        }

        res.status(200).json({
            success: true,
            data: factura
        });
    } catch (error) {
        console.error('Error en getFacturaById:', error);
        next(error);
    }
};

// ===== OBTENER PAGOS DE UNA FACTURA =====
const getPagosFactura = async (req, res, next) => {
    try {
        const { id } = req.params;

        const factura = await Factura.findByPk(id, {
            attributes: ['id', 'numero', 'serie', 'total']
        });

        if (!factura) {
            return res.status(404).json({
                success: false,
                message: 'Factura no encontrada'
            });
        }

        const pagos = await Pago.findAll({
            where: { factura_id: id },
            order: [['created_at', 'ASC']]
        });

        const total_pagado = pagos.reduce((sum, pago) => sum + parseFloat(pago.monto), 0);

        res.status(200).json({
            success: true,
            factura: {
                numero: factura.numero,
                serie: factura.serie,
                total: parseFloat(factura.total)
            },
            pagos,
            total_pagado: parseFloat(total_pagado.toFixed(2))
        });
    } catch (error) {
        console.error('Error en getPagosFactura:', error);
        next(error);
    }
};

// ===== ANULAR FACTURA =====
const anularFactura = async (req, res, next) => {
    const transaction = await db.transaction();
    
    try {
        const { id } = req.params;
        const { usuario_id, motivo_anulacion } = req.body;

        // ========== VALIDACIONES ==========
        if (!usuario_id) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'usuario_id es obligatorio (quien anula)'
            });
        }

        if (!motivo_anulacion || motivo_anulacion.trim() === '') {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'motivo_anulacion es obligatorio'
            });
        }

        // ========== VERIFICAR QUE LA FACTURA EXISTE ==========
        const factura = await Factura.findByPk(id, {
            include: [
                {
                    model: DetalleFactura,
                    as: 'detalles'
                }
            ]
        });

        if (!factura) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Factura no encontrada'
            });
        }

        // ========== VERIFICAR QUE NO ESTÉ YA ANULADA ==========
        if (factura.estado === 'ANULADA') {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'La factura ya está anulada',
                anulada_fecha: factura.anulada_fecha,
                anulada_por: factura.anulada_por,
                motivo: factura.motivo_anulacion
            });
        }

        // ========== VERIFICAR QUE EL USUARIO EXISTE ==========
        const usuario = await Usuario.findByPk(usuario_id);
        if (!usuario) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        // ========== DEVOLVER INVENTARIO ==========
        for (const detalle of factura.detalles) {
            // Buscar inventario
            const inventario = await InventarioSucursal.findOne({
                where: {
                    sucursal_id: factura.sucursal_id,
                    producto_presentacion_id: detalle.producto_presentacion_id
                }
            });

            if (!inventario) {
                await transaction.rollback();
                return res.status(500).json({
                    success: false,
                    message: `No se encontró inventario para el producto ${detalle.producto_presentacion_id}`
                });
            }

            // Devolver cantidad al inventario
            await inventario.update({
                existencia: inventario.existencia + detalle.cantidad
            }, { transaction });

            // Crear movimiento de reversa
            await MovimientoInventario.create({
                sucursal_id: factura.sucursal_id,
                producto_presentacion_id: detalle.producto_presentacion_id,
                tipo: 'AJUSTE',
                cantidad: detalle.cantidad, // Positivo porque devuelve
                referencia: `Anulación Factura ${factura.serie}-${factura.numero}`
            }, { transaction });
        }

        // ========== MARCAR FACTURA COMO ANULADA ==========
        await factura.update({
            estado: 'ANULADA',
            anulada_por: usuario_id,
            anulada_fecha: new Date(),
            motivo_anulacion: motivo_anulacion.trim()
        }, { transaction });

        // ========== COMMIT ==========
        await transaction.commit();

        // ========== OBTENER FACTURA ACTUALIZADA ==========
        const facturaAnulada = await Factura.findByPk(id, {
            include: [
                {
                    model: Cliente,
                    as: 'cliente',
                    attributes: ['id', 'nombre', 'nit']
                },
                {
                    model: Usuario,
                    as: 'usuario',
                    attributes: ['id', 'nombre']
                },
                {
                    model: Usuario,
                    as: 'anulador',
                    attributes: ['id', 'nombre', 'email']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre']
                },
                {
                    model: DetalleFactura,
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
                    model: Pago,
                    as: 'pagos'
                }
            ]
        });

        res.status(200).json({
            success: true,
            message: `Factura ${factura.serie}-${factura.numero} anulada exitosamente`,
            data: facturaAnulada
        });

    } catch (error) {
        await transaction.rollback();
        console.error('Error en anularFactura:', error);
        next(error);
    }
};

module.exports = {
    createFactura,
    getFacturas,
    getFacturaById,
    getPagosFactura,
    anularFactura
};