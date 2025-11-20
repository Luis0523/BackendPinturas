
const { Presentacion } = require('../../models/index');


exports.getPresentaciones = async (req, res, next) => {
    try {
        const presentaciones = await Presentacion.findAll({
            where: { activo: true },
            order: [['nombre', 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: presentaciones.length,
            data: presentaciones
        });
    } catch (error) {
        console.error('Error en getPresentaciones:', error);
        next(error);
    }
};


exports.getAllPresentaciones = async (req, res, next) => {
    try {
        const presentaciones = await Presentacion.findAll({
            order: [['nombre', 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: presentaciones.length,
            data: presentaciones
        });
    } catch (error) {
        console.error('Error en getAllPresentaciones:', error);
        next(error);
    }
};


exports.getPresentacionById = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        const presentacion = await Presentacion.findByPk(id);

        if (!presentacion) {
            return res.status(404).json({
                success: false,
                message: 'Presentación no encontrada'
            });
        }

        res.status(200).json({
            success: true,
            data: presentacion
        });
    } catch (error) {
        console.error('Error en getPresentacionById:', error);
        next(error);
    }
};


exports.createPresentacion = async (req, res, next) => {
    try {
        const { nombre, unidad_base, factor_galon, activo } = req.body;

        
        if (!nombre) {
            return res.status(400).json({
                success: false,
                message: 'El nombre es obligatorio'
            });
        }

        const presentacion = await Presentacion.create({
            nombre,
            unidad_base,
            factor_galon,
            activo: activo !== undefined ? activo : true
        });

        res.status(201).json({
            success: true,
            message: 'Presentación creada exitosamente',
            data: presentacion
        });
    } catch (error) {
        
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una presentación con ese nombre'
            });
        }
        console.error('Error en createPresentacion:', error);
        next(error);
    }
};


exports.updatePresentacion = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { nombre, unidad_base, factor_galon, activo } = req.body;

        const presentacion = await Presentacion.findByPk(id);

        if (!presentacion) {
            return res.status(404).json({
                success: false,
                message: 'Presentación no encontrada'
            });
        }

        await presentacion.update({
            nombre: nombre || presentacion.nombre,
            unidad_base: unidad_base !== undefined ? unidad_base : presentacion.unidad_base,
            factor_galon: factor_galon !== undefined ? factor_galon : presentacion.factor_galon,
            activo: activo !== undefined ? activo : presentacion.activo
        });

        res.status(200).json({
            success: true,
            message: 'Presentación actualizada exitosamente',
            data: presentacion
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una presentación con ese nombre'
            });
        }
        console.error('Error en updatePresentacion:', error);
        next(error);
    }
};


exports.deletePresentacion = async (req, res, next) => {
    try {
        const { id } = req.params;

        const presentacion = await Presentacion.findByPk(id);

        if (!presentacion) {
            return res.status(404).json({
                success: false,
                message: 'Presentación no encontrada'
            });
        }

        
        await presentacion.update({ activo: false });

        res.status(200).json({
            success: true,
            message: 'Presentación desactivada exitosamente'
        });
    } catch (error) {
        console.error('Error en deletePresentacion:', error);
        next(error);
    }
};


exports.reactivarPresentacion = async (req, res, next) => {
    try {
        const { id } = req.params;

        const presentacion = await Presentacion.findByPk(id);

        if (!presentacion) {
            return res.status(404).json({
                success: false,
                message: 'Presentación no encontrada'
            });
        }

        await presentacion.update({ activo: true });

        res.status(200).json({
            success: true,
            message: 'Presentación reactivada exitosamente',
            data: presentacion
        });
    } catch (error) {
        console.error('Error en reactivarPresentacion:', error);
        next(error);
    }
};