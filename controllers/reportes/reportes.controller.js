// controllers/reportes/reportes.controller.js
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
const { Op } = require('sequelize');
const db = require('../../db/db');

/**
 * Dashboard: Resumen general
 */
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

        // Ventas del día
        const ventasHoy = await Factura.sum('total', {
            where: {
                fecha_emision: { [Op.between]: [inicioDia, finDia] },
                estado: 'EMITIDA'
            }
        }) || 0;

        // Ventas de la semana
        const ventasSemana = await Factura.sum('total', {
            where: {
                fecha_emision: { [Op.gte]: inicioSemana },
                estado: 'EMITIDA'
            }
        }) || 0;

        // Ventas del mes
        const ventasMes = await Factura.sum('total', {
            where: {
                fecha_emision: { [Op.gte]: inicioMes },
                estado: 'EMITIDA'
            }
        }) || 0;

        // Cantidad de facturas hoy
        const facturasHoy = await Factura.count({
            where: {
                fecha_emision: { [Op.between]: [inicioDia, finDia] },
                estado: 'EMITIDA'
            }
        });

        // Total de clientes
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

/**
 * Ventas por día de la semana actual
 */
exports.getVentasSemana = async (req, res, next) => {
    try {
        const hoy = new Date();
        const inicioSemana = new Date(hoy);
        inicioSemana.setDate(hoy.getDate() - hoy.getDay());
        inicioSemana.setHours(0, 0, 0, 0);

        const [results] = await db.query(`
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
            type: db.QueryTypes.SELECT
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

/**
 * Ventas del mes con detalle por día
 */
exports.getVentasMes = async (req, res, next) => {
    try {
        const { mes, anio } = req.query;
        const fecha = mes && anio ? new Date(anio, mes - 1, 1) : new Date();

        const inicioMes = new Date(fecha.getFullYear(), fecha.getMonth(), 1);
        const finMes = new Date(fecha.getFullYear(), fecha.getMonth() + 1, 0);

        const [results] = await db.query(`
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
            type: db.QueryTypes.SELECT
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

/**
 * Ventas detalladas de un día específico
 */
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

/**
 * Compras del mes (órdenes recibidas)
 */
exports.getComprasMes = async (req, res, next) => {
    try {
        const { mes, anio } = req.query;
        const fecha = mes && anio ? new Date(anio, mes - 1, 1) : new Date();

        const inicioMes = new Date(fecha.getFullYear(), fecha.getMonth(), 1);
        const finMes = new Date(fecha.getFullYear(), fecha.getMonth() + 1, 0);

        // Query from recepciones table and join with ordenes_compra to get totals
        const [results] = await db.query(`
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
            type: db.QueryTypes.SELECT
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
        // Si hay error, devolver array vacío
        res.json({
            success: true,
            data: [],
            error: error.message
        });
    }
};

/**
 * Ventas por categoría (gráfica de pastel)
 */
exports.getVentasPorCategoria = async (req, res, next) => {
    try {
        const { dias = 30 } = req.query;
        const fechaInicio = new Date();
        fechaInicio.setDate(fechaInicio.getDate() - parseInt(dias));

        const [results] = await db.query(`
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
            type: db.QueryTypes.SELECT
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

/**
 * Métodos de pago más usados (gráfica de pastel)
 */
exports.getMetodosPago = async (req, res, next) => {
    try {
        const { dias = 30 } = req.query;
        const fechaInicio = new Date();
        fechaInicio.setDate(fechaInicio.getDate() - parseInt(dias));

        const [results] = await db.query(`
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
            type: db.QueryTypes.SELECT
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

/**
 * Top productos más vendidos
 */
exports.getTopProductos = async (req, res, next) => {
    try {
        const { limit = 10, dias = 30 } = req.query;
        const fechaInicio = new Date();
        fechaInicio.setDate(fechaInicio.getDate() - parseInt(dias));

        const [results] = await db.query(`
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
            type: db.QueryTypes.SELECT
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
