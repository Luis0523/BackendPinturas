
const {
    Pedido,
    DetallePedido,
    Pago,
    Cliente,
    Sucursal,
    ProductoPresentacion,
    Producto,
    Presentacion,
    InventarioSucursal,
    MovimientoInventario,
    Factura,
    DetalleFactura
} = require('../../models/index');
const db = require('../../db/db');
const { Op } = require('sequelize');
const { enviarEmailConfirmacionPedido, enviarEmailNotificacionAdmin } = require('../../services/email.service');


const obtenerSiguienteNumeroPedido = async (transaction) => {
    
    const [secuencia] = await db.query(
        'SELECT ultimo_numero FROM secuencias_pedidos FOR UPDATE',
        {
            type: db.QueryTypes.SELECT,
            transaction
        }
    );

    if (!secuencia) {
        
        await db.query(
            'INSERT INTO secuencias_pedidos (ultimo_numero) VALUES (0)',
            { transaction }
        );
        return 1;
    }

    const nuevoNumero = secuencia.ultimo_numero + 1;

    
    await db.query(
        'UPDATE secuencias_pedidos SET ultimo_numero = ?',
        {
            replacements: [nuevoNumero],
            transaction
        }
    );

    return nuevoNumero;
};


const validarMetodosPagoOnline = (pagos) => {
    const metodosPermitidos = ['TARJETA_DEBITO', 'TARJETA_CREDITO', 'TRANSFERENCIA', 'DEPOSITO'];

    for (const pago of pagos) {
        if (!metodosPermitidos.includes(pago.tipo)) {
            return {
                valido: false,
                mensaje: `Método de pago ${pago.tipo} no permitido para pedidos en línea. Solo se acepta: ${metodosPermitidos.join(', ')}`
            };
        }
    }

    return { valido: true };
};


const createPedido = async (req, res, next) => {
    const transaction = await db.transaction();

    try {
        const {
            
            nombre_cliente,
            email_cliente,
            telefono_cliente,
            nit_cliente = 'CF',
            
            direccion_envio,
            ciudad_envio,
            departamento_envio,
            codigo_postal,
            referencias_direccion,
            
            sucursal_id,
            items,  
            pagos,  
            notas_cliente
        } = req.body;

        
        if (!nombre_cliente || !email_cliente || !telefono_cliente) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'Nombre, email y teléfono son obligatorios'
            });
        }

        if (!direccion_envio || !ciudad_envio || !departamento_envio) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'Dirección completa de envío es obligatoria'
            });
        }

        if (!sucursal_id) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'sucursal_id es obligatorio'
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

        
        const validacionPago = validarMetodosPagoOnline(pagos);
        if (!validacionPago.valido) {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: validacionPago.mensaje
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

        
        let cliente = await Cliente.findOne({
            where: { email: email_cliente }
        });

        let cliente_id = null;
        if (cliente) {
            cliente_id = cliente.id;
        }

        
        let subtotal = 0;
        let descuento_total = 0;
        const detallesParaCrear = [];

        for (const item of items) {
            const { producto_presentacion_id, cantidad, precio_unitario, descuento_pct = 0 } = item;

            
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

            
            const productoPresentacion = await ProductoPresentacion.findByPk(producto_presentacion_id);
            if (!productoPresentacion || !productoPresentacion.activo) {
                await transaction.rollback();
                return res.status(404).json({
                    success: false,
                    message: `Producto-presentación ${producto_presentacion_id} no encontrado o inactivo`
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

            
            const subtotal_item = cantidad * precio_unitario;
            const descuento_item = subtotal_item * (descuento_pct / 100);
            const subtotal_neto = subtotal_item - descuento_item;

            subtotal += subtotal_item;
            descuento_total += descuento_item;

            
            detallesParaCrear.push({
                producto_presentacion_id,
                cantidad,
                precio_unitario,
                descuento_pct_aplicado: descuento_pct,
                subtotal: subtotal_neto,
                inventario  
            });
        }

        const total = subtotal - descuento_total;

        
        const suma_pagos = pagos.reduce((sum, pago) => sum + parseFloat(pago.monto), 0);

        if (Math.abs(suma_pagos - total) > 0.01) { 
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: `La suma de pagos (${suma_pagos.toFixed(2)}) no coincide con el total (${total.toFixed(2)})`,
                diferencia: (suma_pagos - total).toFixed(2)
            });
        }

        
        const numero = await obtenerSiguienteNumeroPedido(transaction);

        
        const pedido = await Pedido.create({
            numero,
            cliente_id,
            nombre_cliente: nombre_cliente.trim(),
            email_cliente: email_cliente.trim().toLowerCase(),
            telefono_cliente: telefono_cliente.trim(),
            nit_cliente: nit_cliente.trim().toUpperCase(),
            direccion_envio: direccion_envio.trim(),
            ciudad_envio: ciudad_envio.trim(),
            departamento_envio: departamento_envio.trim(),
            codigo_postal: codigo_postal?.trim() || null,
            referencias_direccion: referencias_direccion?.trim() || null,
            sucursal_id,
            subtotal,
            descuento_total,
            total,
            estado: 'PENDIENTE',
            estado_pago: 'PENDIENTE',
            notas_cliente: notas_cliente?.trim() || null
        }, { transaction });

        
        for (const detalle of detallesParaCrear) {
            
            await DetallePedido.create({
                pedido_id: pedido.id,
                producto_presentacion_id: detalle.producto_presentacion_id,
                cantidad: detalle.cantidad,
                precio_unitario: detalle.precio_unitario,
                descuento_pct_aplicado: detalle.descuento_pct_aplicado,
                subtotal: detalle.subtotal
            }, { transaction });

            
            await detalle.inventario.update({
                existencia: detalle.inventario.existencia - detalle.cantidad
            }, { transaction });

            
            await MovimientoInventario.create({
                sucursal_id,
                producto_presentacion_id: detalle.producto_presentacion_id,
                tipo: 'VENTA',
                cantidad: -detalle.cantidad,
                referencia: `Pedido Web #${numero}`
            }, { transaction });
        }

        
        for (const pago of pagos) {
            await Pago.create({
                pedido_id: pedido.id,
                tipo: pago.tipo,
                monto: pago.monto,
                referencia: pago.referencia || null,
                entidad: pago.entidad || null,
                transaccion_gateway_id: pago.transaccion_gateway_id || null,
                autorizado_por: pago.autorizado_por || null
            }, { transaction });
        }

        
        await transaction.commit();

        
        const pedidoCompleto = await Pedido.findByPk(pedido.id, {
            include: [
                {
                    model: Cliente,
                    as: 'cliente',
                    attributes: ['id', 'nombre', 'nit', 'email']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre', 'direccion']
                },
                {
                    model: DetallePedido,
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

        
        
        
        enviarEmailConfirmacionPedido(pedidoCompleto.toJSON())
            .then(result => {
                if (result.success) {
                    console.log(`✅ Email de confirmación enviado a ${pedidoCompleto.email_cliente}`);
                } else {
                    console.warn(`⚠️ No se pudo enviar email de confirmación: ${result.message}`);
                }
            })
            .catch(error => {
                console.error('❌ Error al enviar email de confirmación:', error.message);
            });

        
        enviarEmailNotificacionAdmin(pedidoCompleto.toJSON())
            .then(result => {
                if (result.success) {
                    console.log('✅ Notificación admin enviada');
                } else {
                    console.warn(`⚠️ No se pudo enviar notificación admin: ${result.message}`);
                }
            })
            .catch(error => {
                console.error('❌ Error al enviar notificación admin:', error.message);
            });

        res.status(201).json({
            success: true,
            message: `Pedido #${numero} creado exitosamente`,
            data: pedidoCompleto
        });

    } catch (error) {
        await transaction.rollback();
        console.error('Error en createPedido:', error);
        next(error);
    }
};


const getPedidos = async (req, res, next) => {
    try {
        const {
            sucursal_id,
            email,
            estado,
            estado_pago,
            desde,
            hasta,
            limite = 50
        } = req.query;

        const where = {};

        if (sucursal_id) where.sucursal_id = sucursal_id;
        if (email) where.email_cliente = { [Op.like]: `%${email}%` };
        if (estado) where.estado = estado;
        if (estado_pago) where.estado_pago = estado_pago;

        if (desde) {
            where.fecha_pedido = {
                [Op.gte]: new Date(desde)
            };
        }

        if (hasta) {
            where.fecha_pedido = {
                ...where.fecha_pedido,
                [Op.lte]: new Date(hasta)
            };
        }

        const pedidos = await Pedido.findAll({
            where,
            include: [
                {
                    model: Cliente,
                    as: 'cliente',
                    attributes: ['id', 'nombre', 'nit']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre']
                }
            ],
            order: [['fecha_pedido', 'DESC']],
            limit: parseInt(limite)
        });

        res.status(200).json({
            success: true,
            count: pedidos.length,
            data: pedidos
        });
    } catch (error) {
        console.error('Error en getPedidos:', error);
        next(error);
    }
};


const getPedidoById = async (req, res, next) => {
    try {
        const { id } = req.params;

        const pedido = await Pedido.findByPk(id, {
            include: [
                {
                    model: Cliente,
                    as: 'cliente'
                },
                {
                    model: Sucursal,
                    as: 'sucursal'
                },
                {
                    model: DetallePedido,
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
                },
                {
                    model: Factura,
                    as: 'factura',
                    attributes: ['id', 'numero', 'serie', 'fecha_emision']
                }
            ]
        });

        if (!pedido) {
            return res.status(404).json({
                success: false,
                message: 'Pedido no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: pedido
        });
    } catch (error) {
        console.error('Error en getPedidoById:', error);
        next(error);
    }
};


const actualizarEstadoPedido = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { estado, notas_internas } = req.body;

        const estadosPermitidos = ['PENDIENTE', 'CONFIRMADO', 'EN_PREPARACION', 'ENVIADO', 'ENTREGADO', 'CANCELADO'];

        if (!estado || !estadosPermitidos.includes(estado)) {
            return res.status(400).json({
                success: false,
                message: `Estado inválido. Estados permitidos: ${estadosPermitidos.join(', ')}`
            });
        }

        const pedido = await Pedido.findByPk(id);
        if (!pedido) {
            return res.status(404).json({
                success: false,
                message: 'Pedido no encontrado'
            });
        }

        const actualizacion = { estado };

        if (notas_internas) {
            actualizacion.notas_internas = notas_internas;
        }

        if (estado === 'CANCELADO') {
            actualizacion.cancelado_fecha = new Date();
            actualizacion.motivo_cancelacion = notas_internas || 'Cancelado';
        }

        await pedido.update(actualizacion);

        res.status(200).json({
            success: true,
            message: `Pedido actualizado a estado: ${estado}`,
            data: pedido
        });
    } catch (error) {
        console.error('Error en actualizarEstadoPedido:', error);
        next(error);
    }
};


const cancelarPedido = async (req, res, next) => {
    const transaction = await db.transaction();

    try {
        const { id } = req.params;
        const { motivo_cancelacion } = req.body;

        if (!motivo_cancelacion || motivo_cancelacion.trim() === '') {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'motivo_cancelacion es obligatorio'
            });
        }

        const pedido = await Pedido.findByPk(id, {
            include: [
                {
                    model: DetallePedido,
                    as: 'detalles'
                }
            ]
        });

        if (!pedido) {
            await transaction.rollback();
            return res.status(404).json({
                success: false,
                message: 'Pedido no encontrado'
            });
        }

        if (pedido.estado === 'CANCELADO') {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'El pedido ya está cancelado'
            });
        }

        if (pedido.estado === 'ENTREGADO') {
            await transaction.rollback();
            return res.status(400).json({
                success: false,
                message: 'No se puede cancelar un pedido ya entregado'
            });
        }

        
        for (const detalle of pedido.detalles) {
            const inventario = await InventarioSucursal.findOne({
                where: {
                    sucursal_id: pedido.sucursal_id,
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

            await inventario.update({
                existencia: inventario.existencia + detalle.cantidad
            }, { transaction });

            await MovimientoInventario.create({
                sucursal_id: pedido.sucursal_id,
                producto_presentacion_id: detalle.producto_presentacion_id,
                tipo: 'AJUSTE',
                cantidad: detalle.cantidad,
                referencia: `Cancelación Pedido Web #${pedido.numero}`
            }, { transaction });
        }

        await pedido.update({
            estado: 'CANCELADO',
            cancelado_fecha: new Date(),
            motivo_cancelacion: motivo_cancelacion.trim()
        }, { transaction });

        await transaction.commit();

        res.status(200).json({
            success: true,
            message: `Pedido #${pedido.numero} cancelado exitosamente`,
            data: pedido
        });

    } catch (error) {
        await transaction.rollback();
        console.error('Error en cancelarPedido:', error);
        next(error);
    }
};

module.exports = {
    createPedido,
    getPedidos,
    getPedidoById,
    actualizarEstadoPedido,
    cancelarPedido
};
