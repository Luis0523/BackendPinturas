// controllers/core/rol.controller.js
const { Rol } = require('../../models/index');

// Obtener todos los roles
exports.getRoles = async (req, res, next) => {
    try {
        const roles = await Rol.findAll({
            order: [['nombre', 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: roles.length,
            data: roles
        });
    } catch (error) {
        console.error('Error en getRoles:', error);
        next(error);
    }
};

// Obtener rol por ID
exports.getRolById = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        const rol = await Rol.findByPk(id);

        if (!rol) {
            return res.status(404).json({
                success: false,
                message: 'Rol no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: rol
        });
    } catch (error) {
        console.error('Error en getRolById:', error);
        next(error);
    }
};

// Crear nuevo rol
exports.createRol = async (req, res, next) => {
    try {
        const { nombre } = req.body;

        // Validación básica
        if (!nombre) {
            return res.status(400).json({
                success: false,
                message: 'El nombre del rol es obligatorio'
            });
        }

        const rol = await Rol.create({ nombre });

        res.status(201).json({
            success: true,
            message: 'Rol creado exitosamente',
            data: rol
        });
    } catch (error) {
        // Error de duplicado (nombre único)
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe un rol con ese nombre'
            });
        }
        console.error('Error en createRol:', error);
        next(error);
    }
};

// Actualizar rol
exports.updateRol = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { nombre } = req.body;

        const rol = await Rol.findByPk(id);

        if (!rol) {
            return res.status(404).json({
                success: false,
                message: 'Rol no encontrado'
            });
        }

        if (!nombre) {
            return res.status(400).json({
                success: false,
                message: 'El nombre del rol es obligatorio'
            });
        }

        await rol.update({ nombre });

        res.status(200).json({
            success: true,
            message: 'Rol actualizado exitosamente',
            data: rol
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe un rol con ese nombre'
            });
        }
        console.error('Error en updateRol:', error);
        next(error);
    }
};

// Eliminar rol
exports.deleteRol = async (req, res, next) => {
    try {
        const { id } = req.params;

        const rol = await Rol.findByPk(id);

        if (!rol) {
            return res.status(404).json({
                success: false,
                message: 'Rol no encontrado'
            });
        }

        // Verificar si hay usuarios con este rol
        const { Usuario } = require('../../models/index');
        const usuariosConRol = await Usuario.count({
            where: { rol_id: id }
        });

        if (usuariosConRol > 0) {
            return res.status(400).json({
                success: false,
                message: `No se puede eliminar el rol. Hay ${usuariosConRol} usuario(s) asignado(s) a este rol`
            });
        }

        await rol.destroy();

        res.status(200).json({
            success: true,
            message: 'Rol eliminado exitosamente'
        });
    } catch (error) {
        console.error('Error en deleteRol:', error);
        next(error);
    }
};