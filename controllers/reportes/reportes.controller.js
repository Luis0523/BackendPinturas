
const {
    Factura,
    DetalleFactura,
    Pago,
    Cliente,
    Usuario,
    Sucursal,
    ProductoPresentacion,
    Producto,
    Categoria
} = require('../../models/index');
const { Op, QueryTypes } = require('sequelize');
const db = require('../../db/db');


exports.getDashboardStats = async (req, res, next) => {
    try {
        const hoy = new Date();
        const inicioDia = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate());
        const finDia = new Date(inicioDia);
        finDia.setDate(finDia.getDate() + 1);

        const inicioSemana = new Date(hoy);
        inicioSemana.setDate(hoy.getDate() - hoy.getDay());
        inicioSemana.setHours(0, 0, 0, 0);

        const inicioMes = new Date(hoy.getFullYear(), hoy.getMonth(), 1);

        
        const ventasHoy = await Factura.sum('total', {
            where: {
                fecha_emision: { [Op.between]: [inicioDia, finDia] },
                estado: 'EMITIDA'
            }
        }) || 0;

        
        const ventasSemana = await Factura.sum('total', {
            where: {
                fecha_emision: { [Op.gte]: inicioSemana },
                estado: 'EMITIDA'
            }
        }) || 0;

        
        const ventasMes = await Factura.sum('total', {
            where: {
                fecha_emision: { [Op.gte]: inicioMes },
                estado: 'EMITIDA'
            }
        }) || 0;

        
        const facturasHoy = await Factura.count({
            where: {
                fecha_emision: { [Op.between]: [inicioDia, finDia] },
                estado: 'EMITIDA'
            }
        });

        
        const clientesActivos = await Cliente.count();

        res.json({
            success: true,
            data: {
                ventasHoy,
                ventasSemana,
                ventasMes,
                facturasHoy,
                clientesActivos
            }
        });

    } catch (error) {
        console.error('Error en getDashboardStats:', error);
        next(error);
    }
};


exports.getVentasSemana = async (req, res, next) => {
    try {
        const hoy = new Date();
        const inicioSemana = new Date(hoy);
        inicioSemana.setDate(hoy.getDate() - hoy.getDay());
        inicioSemana.setHours(0, 0, 0, 0);

        const results = await db.query(`
            SELECT
                DATE(fecha_emision) as fecha,
                SUM(total) as total,
                COUNT(*) as cantidad_facturas
            FROM facturas
            WHERE fecha_emision >= :inicioSemana
              AND estado = 'EMITIDA'
            GROUP BY DATE(fecha_emision)
            ORDER BY fecha
        `, {
            replacements: { inicioSemana },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results
        });

    } catch (error) {
        console.error('Error en getVentasSemana:', error);
        next(error);
    }
};


exports.getVentasMes = async (req, res, next) => {
    try {
        const { mes, anio } = req.query;
        const fecha = mes && anio ? new Date(anio, mes - 1, 1) : new Date();

        const inicioMes = new Date(fecha.getFullYear(), fecha.getMonth(), 1);
        const finMes = new Date(fecha.getFullYear(), fecha.getMonth() + 1, 0);

        const results = await db.query(`
            SELECT
                DATE(fecha_emision) as fecha,
                SUM(total) as total,
                COUNT(*) as cantidad_facturas
            FROM facturas
            WHERE fecha_emision >= :inicioMes
              AND fecha_emision <= :finMes
              AND estado = 'EMITIDA'
            GROUP BY DATE(fecha_emision)
            ORDER BY fecha
        `, {
            replacements: { inicioMes, finMes },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results,
            periodo: {
                mes: fecha.getMonth() + 1,
                anio: fecha.getFullYear()
            }
        });

    } catch (error) {
        console.error('Error en getVentasMes:', error);
        next(error);
    }
};


exports.getVentasDia = async (req, res, next) => {
    try {
        const { fecha } = req.query;

        if (!fecha) {
            return res.status(400).json({
                success: false,
                message: 'Fecha es requerida (formato: YYYY-MM-DD)'
            });
        }

        const inicioDia = new Date(fecha);
        const finDia = new Date(inicioDia);
        finDia.setDate(finDia.getDate() + 1);

        const facturas = await Factura.findAll({
            where: {
                fecha_emision: { [Op.between]: [inicioDia, finDia] },
                estado: 'EMITIDA'
            },
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
                },
                {
                    model: DetalleFactura,
                    as: 'detalles',
                    include: [
                        {
                            model: ProductoPresentacion,
                            as: 'productoPresentacion',
                            include: [
                                { model: Producto, as: 'producto' }
                            ]
                        }
                    ]
                },
                {
                    model: Pago,
                    as: 'pagos'
                }
            ],
            order: [['fecha_emision', 'DESC']]
        });

        const totalVentas = facturas.reduce((sum, f) => sum + parseFloat(f.total), 0);

        res.json({
            success: true,
            data: {
                facturas,
                resumen: {
                    cantidad: facturas.length,
                    total: totalVentas
                }
            }
        });

    } catch (error) {
        console.error('Error en getVentasDia:', error);
        next(error);
    }
};


exports.getComprasMes = async (req, res, next) => {
    try {
        const { mes, anio } = req.query;
        const fecha = mes && anio ? new Date(anio, mes - 1, 1) : new Date();

        const inicioMes = new Date(fecha.getFullYear(), fecha.getMonth(), 1);
        const finMes = new Date(fecha.getFullYear(), fecha.getMonth() + 1, 0);

        
        const results = await db.query(`
            SELECT
                DATE(r.fecha_recepcion) as fecha,
                SUM(oc.total) as total,
                COUNT(DISTINCT r.id) as cantidad_ordenes
            FROM recepciones r
            INNER JOIN ordenes_compra oc ON r.orden_compra_id = oc.id
            WHERE r.fecha_recepcion >= :inicioMes
              AND r.fecha_recepcion <= :finMes
            GROUP BY DATE(r.fecha_recepcion)
            ORDER BY fecha
        `, {
            replacements: { inicioMes, finMes },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results,
            periodo: {
                mes: fecha.getMonth() + 1,
                anio: fecha.getFullYear()
            }
        });

    } catch (error) {
        console.error('Error en getComprasMes:', error);
        
        res.json({
            success: true,
            data: [],
            error: error.message
        });
    }
};


exports.getVentasPorCategoria = async (req, res, next) => {
    try {
        const { dias = 30 } = req.query;
        const fechaInicio = new Date();
        fechaInicio.setDate(fechaInicio.getDate() - parseInt(dias));

        const results = await db.query(`
            SELECT
                c.nombre as categoria,
                SUM(df.subtotal) as total,
                COUNT(DISTINCT f.id) as cantidad_facturas
            FROM detallefactura df
            INNER JOIN facturas f ON df.factura_id = f.id
            INNER JOIN productopresentacion pp ON df.producto_presentacion_id = pp.id
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN categorias c ON p.categoria_id = c.id
            WHERE f.fecha_emision >= :fechaInicio
              AND f.estado = 'EMITIDA'
            GROUP BY c.id, c.nombre
            ORDER BY total DESC
        `, {
            replacements: { fechaInicio },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results
        });

    } catch (error) {
        console.error('Error en getVentasPorCategoria:', error);
        next(error);
    }
};


exports.getMetodosPago = async (req, res, next) => {
    try {
        const { dias = 30 } = req.query;
        const fechaInicio = new Date();
        fechaInicio.setDate(fechaInicio.getDate() - parseInt(dias));

        const results = await db.query(`
            SELECT
                p.tipo as metodo,
                SUM(p.monto) as total,
                COUNT(*) as cantidad
            FROM pagos p
            INNER JOIN facturas f ON p.factura_id = f.id
            WHERE f.fecha_emision >= :fechaInicio
              AND f.estado = 'EMITIDA'
            GROUP BY p.tipo
            ORDER BY total DESC
        `, {
            replacements: { fechaInicio },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results
        });

    } catch (error) {
        console.error('Error en getMetodosPago:', error);
        next(error);
    }
};


exports.getTopProductos = async (req, res, next) => {
    try {
        const { limit = 10, dias = 30 } = req.query;
        const fechaInicio = new Date();
        fechaInicio.setDate(fechaInicio.getDate() - parseInt(dias));

        const results = await db.query(`
            SELECT
                p.descripcion as producto,
                pr.nombre as presentacion,
                SUM(df.cantidad) as cantidad_vendida,
                SUM(df.subtotal) as total_vendido
            FROM detallefactura df
            INNER JOIN facturas f ON df.factura_id = f.id
            INNER JOIN productopresentacion pp ON df.producto_presentacion_id = pp.id
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN presentaciones pr ON pp.presentacion_id = pr.id
            WHERE f.fecha_emision >= :fechaInicio
              AND f.estado = 'EMITIDA'
            GROUP BY pp.id, p.descripcion, pr.nombre
            ORDER BY cantidad_vendida DESC
            LIMIT :limit
        `, {
            replacements: { fechaInicio, limit: parseInt(limit) },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results
        });

    } catch (error) {
        console.error('Error en getTopProductos:', error);
        next(error);
    }
};

exports.getVentasPorMetodoPago = async (req, res, next) => {
    try {
        const { desde, hasta } = req.query;

        if (!desde || !hasta) {
            return res.status(400).json({
                success: false,
                message: 'Fechas desde y hasta son requeridas'
            });
        }

        const fechaDesde = new Date(desde);
        const fechaHasta = new Date(hasta);
        fechaHasta.setDate(fechaHasta.getDate() + 1);

        const results = await db.query(`
            SELECT
                p.tipo as metodo_pago,
                SUM(p.monto) as total,
                COUNT(*) as cantidad_transacciones
            FROM pagos p
            INNER JOIN facturas f ON p.factura_id = f.id
            WHERE f.fecha_emision >= :desde
              AND f.fecha_emision < :hasta
              AND f.estado = 'EMITIDA'
            GROUP BY p.tipo
            ORDER BY total DESC
        `, {
            replacements: { desde: fechaDesde, hasta: fechaHasta },
            type: QueryTypes.SELECT
        });

        const totalGeneral = results.reduce((sum, r) => sum + parseFloat(r.total), 0);

        // Separar por tipo de pago
        const efectivo = results.find(r => r.metodo_pago === 'EFECTIVO')?.total || 0;
        const cheque = results.find(r => r.metodo_pago === 'CHEQUE')?.total || 0;

        // Sumar todas las tarjetas (débito + crédito)
        const tarjeta = results
            .filter(r => r.metodo_pago.includes('TARJETA'))
            .reduce((sum, r) => sum + parseFloat(r.total), 0);

        res.json({
            success: true,
            data: {
                total: totalGeneral,
                efectivo: parseFloat(efectivo),
                cheque: parseFloat(cheque),
                tarjeta: parseFloat(tarjeta),
                desglose: results.map(r => ({
                    metodo: r.metodo_pago,
                    total: parseFloat(r.total)
                }))
            }
        });

    } catch (error) {
        console.error('Error en getVentasPorMetodoPago:', error);
        next(error);
    }
};

exports.getProductosMasIngresos = async (req, res, next) => {
    try {
        const { desde, hasta, limit = 10 } = req.query;

        if (!desde || !hasta) {
            return res.status(400).json({
                success: false,
                message: 'Fechas desde y hasta son requeridas'
            });
        }

        const fechaDesde = new Date(desde);
        const fechaHasta = new Date(hasta);
        fechaHasta.setDate(fechaHasta.getDate() + 1);

        const results = await db.query(`
            SELECT
                p.descripcion as producto,
                pr.nombre as presentacion,
                SUM(df.subtotal) as total,
                SUM(df.cantidad) as cantidad,
                pr.unidad_base as unidad
            FROM detallefactura df
            INNER JOIN facturas f ON df.factura_id = f.id
            INNER JOIN productopresentacion pp ON df.producto_presentacion_id = pp.id
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN presentaciones pr ON pp.presentacion_id = pr.id
            WHERE f.fecha_emision >= :desde
              AND f.fecha_emision < :hasta
              AND f.estado = 'EMITIDA'
            GROUP BY pp.id, p.descripcion, pr.nombre, pr.unidad_base
            ORDER BY total DESC
            LIMIT :limit
        `, {
            replacements: { desde: fechaDesde, hasta: fechaHasta, limit: parseInt(limit) },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results
        });

    } catch (error) {
        console.error('Error en getProductosMasIngresos:', error);
        next(error);
    }
};

exports.getProductosMasVendidos = async (req, res, next) => {
    try {
        const { desde, hasta, limit = 10 } = req.query;

        if (!desde || !hasta) {
            return res.status(400).json({
                success: false,
                message: 'Fechas desde y hasta son requeridas'
            });
        }

        const fechaDesde = new Date(desde);
        const fechaHasta = new Date(hasta);
        fechaHasta.setDate(fechaHasta.getDate() + 1);

        const results = await db.query(`
            SELECT
                p.descripcion as producto,
                pr.nombre as presentacion,
                SUM(df.cantidad) as cantidad,
                SUM(df.subtotal) as total,
                pr.unidad_base as unidad
            FROM detallefactura df
            INNER JOIN facturas f ON df.factura_id = f.id
            INNER JOIN productopresentacion pp ON df.producto_presentacion_id = pp.id
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN presentaciones pr ON pp.presentacion_id = pr.id
            WHERE f.fecha_emision >= :desde
              AND f.fecha_emision < :hasta
              AND f.estado = 'EMITIDA'
            GROUP BY pp.id, p.descripcion, pr.nombre, pr.unidad_base
            ORDER BY cantidad DESC
            LIMIT :limit
        `, {
            replacements: { desde: fechaDesde, hasta: fechaHasta, limit: parseInt(limit) },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results
        });

    } catch (error) {
        console.error('Error en getProductosMasVendidos:', error);
        next(error);
    }
};

exports.getInventarioActual = async (req, res, next) => {
    try {
        const { sucursal_id, categoria_id } = req.query;

        let whereConditions = [];
        let replacements = {};

        if (sucursal_id) {
            whereConditions.push('inv.sucursal_id = :sucursal_id');
            replacements.sucursal_id = sucursal_id;
        }

        if (categoria_id) {
            whereConditions.push('p.categoria_id = :categoria_id');
            replacements.categoria_id = categoria_id;
        }

        const whereClause = whereConditions.length > 0
            ? 'WHERE ' + whereConditions.join(' AND ')
            : '';

        const results = await db.query(`
            SELECT
                p.codigo_sku,
                p.descripcion as producto,
                pr.nombre as presentacion,
                c.nombre as categoria,
                m.nombre as marca,
                s.nombre as sucursal,
                s.nombre as tienda,
                inv.existencia as stock,
                precio.stock_minimo,
                precio.precio_venta as precio,
                CASE
                    WHEN inv.existencia = 0 THEN 'SIN_STOCK'
                    WHEN inv.existencia <= precio.stock_minimo THEN 'STOCK_BAJO'
                    ELSE 'DISPONIBLE'
                END as estado_stock
            FROM inventariosucursal inv
            INNER JOIN productopresentacion pp ON inv.producto_presentacion_id = pp.id
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN presentaciones pr ON pp.presentacion_id = pr.id
            INNER JOIN categorias c ON p.categoria_id = c.id
            INNER JOIN marcas m ON p.marca_id = m.id
            INNER JOIN sucursales s ON inv.sucursal_id = s.id
            LEFT JOIN precios precio ON pp.id = precio.producto_presentacion_id AND precio.sucursal_id = inv.sucursal_id
            ${whereClause}
            ORDER BY inv.existencia ASC, p.descripcion
        `, {
            replacements,
            type: QueryTypes.SELECT
        });

        const resumen = {
            sin_stock: results.filter(r => r.estado_stock === 'SIN_STOCK').length,
            stock_bajo: results.filter(r => r.estado_stock === 'STOCK_BAJO').length,
            disponible: results.filter(r => r.estado_stock === 'DISPONIBLE').length
        };

        res.json({
            success: true,
            data: results,
            resumen
        });

    } catch (error) {
        console.error('Error en getInventarioActual:', error);
        next(error);
    }
};

exports.getProductosMenosVendidos = async (req, res, next) => {
    try {
        const { desde, hasta, limit = 10 } = req.query;

        if (!desde || !hasta) {
            return res.status(400).json({
                success: false,
                message: 'Fechas desde y hasta son requeridas'
            });
        }

        const fechaDesde = new Date(desde);
        const fechaHasta = new Date(hasta);
        fechaHasta.setDate(fechaHasta.getDate() + 1);

        const results = await db.query(`
            SELECT
                p.descripcion as producto,
                pr.nombre as presentacion,
                COALESCE(SUM(df.cantidad), 0) as cantidad,
                COALESCE(SUM(df.subtotal), 0) as total,
                pr.unidad_base as unidad
            FROM productopresentacion pp
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN presentaciones pr ON pp.presentacion_id = pr.id
            LEFT JOIN detallefactura df ON pp.id = df.producto_presentacion_id
            LEFT JOIN facturas f ON df.factura_id = f.id
                AND f.fecha_emision >= :desde
                AND f.fecha_emision < :hasta
                AND f.estado = 'EMITIDA'
            WHERE pp.activo = true
            GROUP BY pp.id, p.descripcion, pr.nombre, pr.unidad_base
            ORDER BY cantidad ASC, p.descripcion
            LIMIT :limit
        `, {
            replacements: { desde: fechaDesde, hasta: fechaHasta, limit: parseInt(limit) },
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results
        });

    } catch (error) {
        console.error('Error en getProductosMenosVendidos:', error);
        next(error);
    }
};

exports.getProductosSinStock = async (req, res, next) => {
    try {
        const { sucursal_id } = req.query;

        let whereClause = '';
        let replacements = {};

        if (sucursal_id) {
            whereClause = 'AND inv.sucursal_id = :sucursal_id';
            replacements.sucursal_id = sucursal_id;
        }

        const results = await db.query(`
            SELECT
                p.codigo_sku,
                p.descripcion as producto,
                pr.nombre as presentacion,
                c.nombre as categoria,
                m.nombre as marca,
                s.nombre as sucursal,
                inv.existencia,
                precio.stock_minimo,
                precio.precio_venta
            FROM inventariosucursal inv
            INNER JOIN productopresentacion pp ON inv.producto_presentacion_id = pp.id
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN presentaciones pr ON pp.presentacion_id = pr.id
            INNER JOIN categorias c ON p.categoria_id = c.id
            INNER JOIN marcas m ON p.marca_id = m.id
            INNER JOIN sucursales s ON inv.sucursal_id = s.id
            LEFT JOIN precios precio ON pp.id = precio.producto_presentacion_id AND precio.sucursal_id = inv.sucursal_id
            WHERE inv.existencia = 0
              AND pp.activo = true
              ${whereClause}
            ORDER BY p.descripcion, pr.nombre
        `, {
            replacements,
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results,
            total: results.length
        });

    } catch (error) {
        console.error('Error en getProductosSinStock:', error);
        next(error);
    }
};

exports.buscarFacturaPorNumero = async (req, res, next) => {
    try {
        const { numero, serie = 'A' } = req.query;

        if (!numero) {
            return res.status(400).json({
                success: false,
                message: 'Número de factura es requerido'
            });
        }

        const factura = await Factura.findOne({
            where: {
                numero: parseInt(numero),
                serie: serie
            },
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
                                        { model: Categoria, as: 'categoria' }
                                    ]
                                }
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

        if (!factura) {
            return res.status(404).json({
                success: false,
                message: `Factura ${serie}-${numero} no encontrada`
            });
        }

        res.json({
            success: true,
            data: factura
        });

    } catch (error) {
        console.error('Error en buscarFacturaPorNumero:', error);
        next(error);
    }
};

/**
 * Reporte 8: Ingresos al inventario (historial de compras/recepciones)
 */
exports.getIngresosInventario = async (req, res, next) => {
    try {
        const { desde, hasta, proveedor_id } = req.query;

        if (!desde || !hasta) {
            return res.status(400).json({
                success: false,
                message: 'Fechas desde y hasta son requeridas'
            });
        }

        const fechaDesde = new Date(desde);
        const fechaHasta = new Date(hasta);
        fechaHasta.setDate(fechaHasta.getDate() + 1);

        let whereClause = '';
        let replacements = { desde: fechaDesde, hasta: fechaHasta };

        if (proveedor_id) {
            whereClause = 'AND oc.proveedor_id = :proveedor_id';
            replacements.proveedor_id = proveedor_id;
        }

        const results = await db.query(`
            SELECT
                r.fecha_recepcion as fecha,
                CONCAT('REC-', r.id) as documento,
                prov.nombre as proveedor,
                p.descripcion as producto,
                pr.nombre as presentacion,
                dr.cantidad_recibida as cantidad,
                doc.precio_unitario as precio,
                (dr.cantidad_recibida * doc.precio_unitario) as total
            FROM recepciones r
            INNER JOIN ordenes_compra oc ON r.orden_compra_id = oc.id
            INNER JOIN proveedores prov ON oc.proveedor_id = prov.id
            INNER JOIN detalle_recepciones dr ON dr.recepcion_id = r.id
            INNER JOIN detalle_orden_compra doc ON dr.detalle_orden_id = doc.id
            INNER JOIN productopresentacion pp ON doc.producto_presentacion_id = pp.id
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN presentaciones pr ON pp.presentacion_id = pr.id
            WHERE r.fecha_recepcion >= :desde
              AND r.fecha_recepcion < :hasta
              ${whereClause}
            ORDER BY r.fecha_recepcion DESC, r.id DESC
        `, {
            replacements,
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results,
            total: results.length
        });

    } catch (error) {
        console.error('Error en getIngresosInventario:', error);
        next(error);
    }
};

/**
 * Reporte 9: Productos con stock mínimo o menor
 */
exports.getProductosStockMinimo = async (req, res, next) => {
    try {
        const { sucursal_id } = req.query;

        let whereClause = '';
        let replacements = {};

        if (sucursal_id) {
            whereClause = 'AND inv.sucursal_id = :sucursal_id';
            replacements.sucursal_id = sucursal_id;
        }

        const results = await db.query(`
            SELECT
                p.codigo_sku,
                p.descripcion as producto,
                pr.nombre as presentacion,
                c.nombre as categoria,
                s.nombre as sucursal,
                inv.existencia as stock,
                precio.stock_minimo,
                precio.precio_venta
            FROM inventariosucursal inv
            INNER JOIN productopresentacion pp ON inv.producto_presentacion_id = pp.id
            INNER JOIN productos p ON pp.producto_id = p.id
            INNER JOIN presentaciones pr ON pp.presentacion_id = pr.id
            INNER JOIN categorias c ON p.categoria_id = c.id
            INNER JOIN sucursales s ON inv.sucursal_id = s.id
            LEFT JOIN precios precio ON pp.id = precio.producto_presentacion_id AND precio.sucursal_id = inv.sucursal_id
            WHERE precio.stock_minimo IS NOT NULL
              AND inv.existencia <= precio.stock_minimo
              AND pp.activo = true
              ${whereClause}
            ORDER BY inv.existencia ASC, p.descripcion
        `, {
            replacements,
            type: QueryTypes.SELECT
        });

        res.json({
            success: true,
            data: results,
            total: results.length
        });

    } catch (error) {
        console.error('Error en getProductosStockMinimo:', error);
        next(error);
    }
};
