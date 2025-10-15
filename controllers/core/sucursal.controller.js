// controllers/core/sucursal.controller.js
const { Sucursal } = require('../../models/index');

// Obtener todas las sucursales activas
exports.getSucursales = async (req, res, next) => {
    try {
        const sucursales = await Sucursal.findAll({
            where: { activa: true },
            order: [['nombre', 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: sucursales.length,
            data: sucursales
        });
    } catch (error) {
        console.error('Error en getSucursales:', error);
        next(error);
    }
};

// Obtener todas (incluyendo inactivas)
exports.getAllSucursales = async (req, res, next) => {
    try {
        const sucursales = await Sucursal.findAll({
            order: [['nombre', 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: sucursales.length,
            data: sucursales
        });
    } catch (error) {
        console.error('Error en getAllSucursales:', error);
        next(error);
    }
};

// Obtener sucursal por ID
exports.getSucursalById = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        const sucursal = await Sucursal.findByPk(id);

        if (!sucursal) {
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada'
            });
        }

        res.status(200).json({
            success: true,
            data: sucursal
        });
    } catch (error) {
        console.error('Error en getSucursalById:', error);
        next(error);
    }
};

// Crear nueva sucursal
exports.createSucursal = async (req, res, next) => {
    try {
        const { nombre, direccion, gps_lat, gps_lng, telefono, activa } = req.body;

        // Validación básica
        if (!nombre) {
            return res.status(400).json({
                success: false,
                message: 'El nombre de la sucursal es obligatorio'
            });
        }

        // Validar coordenadas GPS si se proporcionan
        if (gps_lat && (gps_lat < -90 || gps_lat > 90)) {
            return res.status(400).json({
                success: false,
                message: 'Latitud inválida. Debe estar entre -90 y 90'
            });
        }

        if (gps_lng && (gps_lng < -180 || gps_lng > 180)) {
            return res.status(400).json({
                success: false,
                message: 'Longitud inválida. Debe estar entre -180 y 180'
            });
        }

        const sucursal = await Sucursal.create({
            nombre,
            direccion,
            gps_lat,
            gps_lng,
            telefono,
            activa: activa !== undefined ? activa : true
        });

        res.status(201).json({
            success: true,
            message: 'Sucursal creada exitosamente',
            data: sucursal
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una sucursal con ese nombre'
            });
        }
        console.error('Error en createSucursal:', error);
        next(error);
    }
};

// Actualizar sucursal
exports.updateSucursal = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { nombre, direccion, gps_lat, gps_lng, telefono, activa } = req.body;

        const sucursal = await Sucursal.findByPk(id);

        if (!sucursal) {
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada'
            });
        }

        // Validar coordenadas GPS si se proporcionan
        if (gps_lat !== undefined && (gps_lat < -90 || gps_lat > 90)) {
            return res.status(400).json({
                success: false,
                message: 'Latitud inválida. Debe estar entre -90 y 90'
            });
        }

        if (gps_lng !== undefined && (gps_lng < -180 || gps_lng > 180)) {
            return res.status(400).json({
                success: false,
                message: 'Longitud inválida. Debe estar entre -180 y 180'
            });
        }

        await sucursal.update({
            nombre: nombre || sucursal.nombre,
            direccion: direccion !== undefined ? direccion : sucursal.direccion,
            gps_lat: gps_lat !== undefined ? gps_lat : sucursal.gps_lat,
            gps_lng: gps_lng !== undefined ? gps_lng : sucursal.gps_lng,
            telefono: telefono !== undefined ? telefono : sucursal.telefono,
            activa: activa !== undefined ? activa : sucursal.activa
        });

        res.status(200).json({
            success: true,
            message: 'Sucursal actualizada exitosamente',
            data: sucursal
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una sucursal con ese nombre'
            });
        }
        console.error('Error en updateSucursal:', error);
        next(error);
    }
};

// Eliminar (soft delete - desactivar)
exports.deleteSucursal = async (req, res, next) => {
    try {
        const { id } = req.params;

        const sucursal = await Sucursal.findByPk(id);

        if (!sucursal) {
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada'
            });
        }

        // Soft delete: solo marcar como inactiva
        await sucursal.update({ activa: false });

        res.status(200).json({
            success: true,
            message: 'Sucursal desactivada exitosamente'
        });
    } catch (error) {
        console.error('Error en deleteSucursal:', error);
        next(error);
    }
};

// Reactivar sucursal
exports.reactivarSucursal = async (req, res, next) => {
    try {
        const { id } = req.params;

        const sucursal = await Sucursal.findByPk(id);

        if (!sucursal) {
            return res.status(404).json({
                success: false,
                message: 'Sucursal no encontrada'
            });
        }

        await sucursal.update({ activa: true });

        res.status(200).json({
            success: true,
            message: 'Sucursal reactivada exitosamente',
            data: sucursal
        });
    } catch (error) {
        console.error('Error en reactivarSucursal:', error);
        next(error);
    }
};

// Buscar sucursales cercanas (por GPS)
exports.getSucursalesCercanas = async (req, res, next) => {
    try {
        const { lat, lng, radio } = req.query;

        if (!lat || !lng) {
            return res.status(400).json({
                success: false,
                message: 'Se requieren las coordenadas (lat, lng)'
            });
        }

        const latitude = parseFloat(lat);
        const longitude = parseFloat(lng);
        const radioKm = parseFloat(radio) || 10; // Radio por defecto: 10km

        // Fórmula de Haversine para calcular distancia
        const sucursales = await Sucursal.findAll({
            where: { 
                activa: true,
                gps_lat: { [db.Sequelize.Op.ne]: null },
                gps_lng: { [db.Sequelize.Op.ne]: null }
            },
            attributes: [
                'id',
                'nombre',
                'direccion',
                'gps_lat',
                'gps_lng',
                'telefono',
                [
                    db.Sequelize.literal(`
                        6371 * acos(
                            cos(radians(${latitude})) 
                            * cos(radians(gps_lat)) 
                            * cos(radians(gps_lng) - radians(${longitude})) 
                            + sin(radians(${latitude})) 
                            * sin(radians(gps_lat))
                        )
                    `),
                    'distancia'
                ]
            ],
            having: db.Sequelize.literal(`distancia <= ${radioKm}`),
            order: [[db.Sequelize.literal('distancia'), 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: sucursales.length,
            radio_km: radioKm,
            data: sucursales
        });
    } catch (error) {
        console.error('Error en getSucursalesCercanas:', error);
        next(error);
    }
};