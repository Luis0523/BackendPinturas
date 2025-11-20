
const { Precio, ProductoPresentacion, Producto, Presentacion, Sucursal, Categoria, Marca } = require('../../models/index');
const { Op } = require('sequelize');


const getPreciosVigentes = async (req, res, next) => {
    try {
        const { sucursal_id, producto_presentacion_id } = req.query;
        
        const where = {
            activo: true,
            vigente_desde: { [Op.lte]: new Date() },
            [Op.or]: [
                { vigente_hasta: null },
                { vigente_hasta: { [Op.gte]: new Date() } }
            ]
        };
        
        if (sucursal_id) {
            where.sucursal_id = sucursal_id;
        }
        
        if (producto_presentacion_id) {
            where.producto_presentacion_id = producto_presentacion_id;
        }

        const precios = await Precio.findAll({
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
            order: [['vigente_desde', 'DESC']]
        });

        res.status(200).json({
            success: true,
            count: precios.length,
            data: precios
        });
    } catch (error) {
        console.error('Error en getPreciosVigentes:', error);
        next(error);
    }
};


const getPrecioById = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        const precio = await Precio.findByPk(id, {
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

        if (!precio) {
            return res.status(404).json({
                success: false,
                message: 'Precio no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: precio
        });
    } catch (error) {
        console.error('Error en getPrecioById:', error);
        next(error);
    }
};



const getPrecioVigenteProducto = async (req, res, next) => {
    console.log('HOLA, ENTRE AL CONTROLADOR');
    try {
        const { producto_presentacion_id, sucursal_id } = req.params;
        console.log('AQUI, FUI LLAMADO');
        
        const ppId = parseInt(producto_presentacion_id);
        const sucId = parseInt(sucursal_id);

        
        if (isNaN(ppId) || isNaN(sucId)) {
            return res.status(400).json({
                success: false,
                message: 'IDs inválidos. Deben ser números'
            });
        }

        console.log('🔍 Buscando precio para:', {
            producto_presentacion_id: ppId,
            sucursal_id: sucId
        });

        
        let precio = await Precio.findOne({
            where: {
                producto_presentacion_id: ppId,  
                sucursal_id: sucId,               
                activo: true,
                vigente_desde: { [Op.lte]: new Date() },
                [Op.or]: [
                    { vigente_hasta: null },
                    { vigente_hasta: { [Op.gte]: new Date() } }
                ]
            },
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
                    as: 'sucursal'
                }
            ],
            order: [['vigente_desde', 'DESC']]
        });

        console.log('✅ Precio encontrado (específico):', precio ? precio.id : 'No encontrado');

        
        if (!precio) {
            console.log('🔍 Buscando precio global (sucursal_id = NULL)...');
            
            precio = await Precio.findOne({
                where: {
                    producto_presentacion_id: ppId,  
                    sucursal_id: null,
                    activo: true,
                    vigente_desde: { [Op.lte]: new Date() },
                    [Op.or]: [
                        { vigente_hasta: null },
                        { vigente_hasta: { [Op.gte]: new Date() } }
                    ]
                },
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
                    }
                ],
                order: [['vigente_desde', 'DESC']]
            });

            console.log('✅ Precio encontrado (global):', precio ? precio.id : 'No encontrado');
        }

        if (!precio) {
            return res.status(404).json({
                success: false,
                message: `No se encontró precio vigente para producto_presentacion_id=${ppId} en sucursal_id=${sucId}`
            });
        }

        
        const precio_final = parseFloat(precio.precio_venta) * (1 - parseFloat(precio.descuento_pct) / 100);

        res.status(200).json({
            success: true,
            data: {
                ...precio.toJSON(),
                precio_final: parseFloat(precio_final.toFixed(2))
            }
        });

    } catch (error) {
        console.error('❌ Error en getPrecioVigenteProducto:', error);
        next(error);
    }
};


const createPrecio = async (req, res, next) => {
    try {
        const {
            producto_presentacion_id,
            sucursal_id,
            precio_venta,
            descuento_pct,
            stock_minimo,
            vigente_desde,
            vigente_hasta
        } = req.body;

        
        if (!producto_presentacion_id || !precio_venta) {
            return res.status(400).json({
                success: false,
                message: 'producto_presentacion_id y precio_venta son obligatorios'
            });
        }

        if (precio_venta <= 0) {
            return res.status(400).json({
                success: false,
                message: 'El precio debe ser mayor a 0'
            });
        }

        if (descuento_pct && (descuento_pct < 0 || descuento_pct > 100)) {
            return res.status(400).json({
                success: false,
                message: 'El descuento debe estar entre 0 y 100'
            });
        }

        
        const productoPresentacion = await ProductoPresentacion.findByPk(producto_presentacion_id);
        if (!productoPresentacion) {
            return res.status(404).json({
                success: false,
                message: 'Producto-presentación no encontrado'
            });
        }

        
        if (sucursal_id) {
            const sucursal = await Sucursal.findByPk(sucursal_id);
            if (!sucursal) {
                return res.status(404).json({
                    success: false,
                    message: 'Sucursal no encontrada'
                });
            }
        }

        
        const precio = await Precio.create({
            producto_presentacion_id,
            sucursal_id: sucursal_id || null,
            precio_venta,
            descuento_pct: descuento_pct || 0,
            stock_minimo: stock_minimo || 0,
            vigente_desde: vigente_desde || new Date(),
            vigente_hasta: vigente_hasta || null,
            activo: true
        });

        
        const precioCreado = await Precio.findByPk(precio.id, {
            include: [
                {
                    model: ProductoPresentacion,
                    as: 'productoPresentacion',
                    include: [
                        { model: Producto, as: 'producto' },
                        { model: Presentacion, as: 'presentacion' }
                    ]
                },
                { model: Sucursal, as: 'sucursal' }
            ]
        });

        res.status(201).json({
            success: true,
            message: 'Precio creado exitosamente',
            data: precioCreado
        });
    } catch (error) {
        console.error('Error en createPrecio:', error);
        next(error);
    }
};


const updatePrecio = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { precio_venta, descuento_pct, stock_minimo, vigente_hasta, activo } = req.body;

        const precio = await Precio.findByPk(id);

        if (!precio) {
            return res.status(404).json({
                success: false,
                message: 'Precio no encontrado'
            });
        }

        
        if (precio_venta !== undefined && precio_venta <= 0) {
            return res.status(400).json({
                success: false,
                message: 'El precio debe ser mayor a 0'
            });
        }

        if (descuento_pct !== undefined && (descuento_pct < 0 || descuento_pct > 100)) {
            return res.status(400).json({
                success: false,
                message: 'El descuento debe estar entre 0 y 100'
            });
        }

        
        await precio.update({
            precio_venta: precio_venta !== undefined ? precio_venta : precio.precio_venta,
            descuento_pct: descuento_pct !== undefined ? descuento_pct : precio.descuento_pct,
            stock_minimo: stock_minimo !== undefined ? stock_minimo : precio.stock_minimo,
            vigente_hasta: vigente_hasta !== undefined ? vigente_hasta : precio.vigente_hasta,
            activo: activo !== undefined ? activo : precio.activo
        });

        
        const precioActualizado = await Precio.findByPk(id, {
            include: [
                {
                    model: ProductoPresentacion,
                    as: 'productoPresentacion',
                    include: [
                        { model: Producto, as: 'producto' },
                        { model: Presentacion, as: 'presentacion' }
                    ]
                },
                { model: Sucursal, as: 'sucursal' }
            ]
        });

        res.status(200).json({
            success: true,
            message: 'Precio actualizado exitosamente',
            data: precioActualizado
        });
    } catch (error) {
        console.error('Error en updatePrecio:', error);
        next(error);
    }
};


const desactivarPrecio = async (req, res, next) => {
    try {
        const { id } = req.params;

        const precio = await Precio.findByPk(id);

        if (!precio) {
            return res.status(404).json({
                success: false,
                message: 'Precio no encontrado'
            });
        }

        await precio.update({ 
            activo: false,
            vigente_hasta: new Date()
        });

        res.status(200).json({
            success: true,
            message: 'Precio desactivado exitosamente'
        });
    } catch (error) {
        console.error('Error en desactivarPrecio:', error);
        next(error);
    }
};


const getCatalogoConPrecios = async (req, res, next) => {
    try {
        const { sucursal_id } = req.query;

        if (!sucursal_id) {
            return res.status(400).json({
                success: false,
                message: 'sucursal_id es obligatorio'
            });
        }

        
        const productoPresentaciones = await ProductoPresentacion.findAll({
            where: { activo: true },
            include: [
                {
                    model: Producto,
                    as: 'producto',
                    where: { activo: true },
                    include: [
                        { model: Categoria, as: 'categoria' },
                        { model: Marca, as: 'marca' }
                    ]
                },
                {
                    model: Presentacion,
                    as: 'presentacion',
                    where: { activo: true }
                }
            ]
        });

        
        const catalogoConPrecios = await Promise.all(
            productoPresentaciones.map(async (pp) => {
                
                let precio = await Precio.findOne({
                    where: {
                        producto_presentacion_id: pp.id,
                        sucursal_id: sucursal_id,
                        activo: true,
                        vigente_desde: { [Op.lte]: new Date() },
                        [Op.or]: [
                            { vigente_hasta: null },
                            { vigente_hasta: { [Op.gte]: new Date() } }
                        ]
                    },
                    order: [['vigente_desde', 'DESC']]
                });

                
                if (!precio) {
                    precio = await Precio.findOne({
                        where: {
                            producto_presentacion_id: pp.id,
                            sucursal_id: null,
                            activo: true,
                            vigente_desde: { [Op.lte]: new Date() },
                            [Op.or]: [
                                { vigente_hasta: null },
                                { vigente_hasta: { [Op.gte]: new Date() } }
                            ]
                        },
                        order: [['vigente_desde', 'DESC']]
                    });
                }

                const precio_final = precio 
                    ? precio.precio_venta * (1 - precio.descuento_pct / 100)
                    : null;

                return {
                    ...pp.toJSON(),
                    precio: precio ? {
                        precio_venta: parseFloat(precio.precio_venta),
                        descuento_pct: parseFloat(precio.descuento_pct),
                        precio_final: precio_final ? parseFloat(precio_final.toFixed(2)) : null,
                        sucursal_especifico: precio.sucursal_id !== null
                    } : null
                };
            })
        );

        res.status(200).json({
            success: true,
            sucursal_id: parseInt(sucursal_id),
            count: catalogoConPrecios.length,
            con_precio: catalogoConPrecios.filter(p => p.precio).length,
            sin_precio: catalogoConPrecios.filter(p => !p.precio).length,
            data: catalogoConPrecios
        });
    } catch (error) {
        console.error('Error en getCatalogoConPrecios:', error);
        next(error);
    }
};

module.exports = {
    getPreciosVigentes,
    getPrecioById,
    getPrecioVigenteProducto,
    createPrecio,
    updatePrecio,
    desactivarPrecio,
    getCatalogoConPrecios
};