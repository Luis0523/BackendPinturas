// controllers/usuarios/usuario.controller.js
const { Usuario, Rol, Sucursal } = require('../../models/index');
const bcrypt = require('bcrypt');

// Obtener todos los usuarios
exports.getUsuarios = async (req, res, next) => {
    try {
        const { activo, rol_id, sucursal_id } = req.query;
        
        const where = {};
        
        if (activo !== undefined) {
            where.activo = activo === 'true';
        }
        
        if (rol_id) {
            where.rol_id = rol_id;
        }
        
        if (sucursal_id) {
            where.sucursal_id = sucursal_id;
        }

        const usuarios = await Usuario.findAll({
            where,
            attributes: { exclude: ['password_hash'] },
            include: [
                {
                    model: Rol,
                    as: 'rol',
                    attributes: ['id', 'nombre']
                },
                {
                    model: Sucursal,
                    as: 'sucursal',
                    attributes: ['id', 'nombre', 'direccion']
                }
            ],
            order: [['nombre', 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: usuarios.length,
            data: usuarios
        });
    } catch (error) {
        console.error('Error en getUsuarios:', error);
        next(error);
    }
};

// Obtener usuario por ID
exports.getUsuarioById = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        const usuario = await Usuario.findByPk(id, {
            attributes: { exclude: ['password_hash'] },
            include: [
                {
                    model: Rol,
                    as: 'rol'
                },
                {
                    model: Sucursal,
                    as: 'sucursal'
                }
            ]
        });

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: usuario
        });
    } catch (error) {
        console.error('Error en getUsuarioById:', error);
        next(error);
    }
};

// Buscar usuario por email o DPI
exports.buscarUsuario = async (req, res, next) => {
    try {
        const { email, dpi } = req.query;

        if (!email && !dpi) {
            return res.status(400).json({
                success: false,
                message: 'Debe proporcionar email o DPI para buscar'
            });
        }

        const where = {};
        if (email) where.email = email;
        if (dpi) where.dpi = dpi;

        const usuario = await Usuario.findOne({
            where,
            attributes: { exclude: ['password_hash'] },
            include: [
                { model: Rol, as: 'rol' },
                { model: Sucursal, as: 'sucursal' }
            ]
        });

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: usuario
        });
    } catch (error) {
        console.error('Error en buscarUsuario:', error);
        next(error);
    }
};

// Crear nuevo usuario
exports.createUsuario = async (req, res, next) => {
    try {
        const { nombre, dpi, email, password, rol_id, sucursal_id, activo } = req.body;

        // Validaciones básicas
        if (!nombre || !dpi || !email || !password || !rol_id) {
            return res.status(400).json({
                success: false,
                message: 'Nombre, DPI, email, password y rol_id son obligatorios'
            });
        }

        // Validar que el rol existe
        const rol = await Rol.findByPk(rol_id);
        if (!rol) {
            return res.status(404).json({
                success: false,
                message: 'Rol no encontrado'
            });
        }

        // Validar que la sucursal existe (si se proporciona)
        if (sucursal_id) {
            const sucursal = await Sucursal.findByPk(sucursal_id);
            if (!sucursal) {
                return res.status(404).json({
                    success: false,
                    message: 'Sucursal no encontrada'
                });
            }
        }

        // Validar longitud mínima de password
        if (password.length < 6) {
            return res.status(400).json({
                success: false,
                message: 'El password debe tener al menos 6 caracteres'
            });
        }

        // Hashear password
        const password_hash = await bcrypt.hash(password, 10);

        // Crear usuario
        const usuario = await Usuario.create({
            nombre,
            dpi,
            email,
            password_hash,
            rol_id,
            sucursal_id: sucursal_id || null,
            activo: activo !== undefined ? activo : true
        });

        // Obtener usuario con relaciones (sin password)
        const usuarioCreado = await Usuario.findByPk(usuario.id, {
            attributes: { exclude: ['password_hash'] },
            include: [
                { model: Rol, as: 'rol' },
                { model: Sucursal, as: 'sucursal' }
            ]
        });

        res.status(201).json({
            success: true,
            message: 'Usuario creado exitosamente',
            data: usuarioCreado
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            const field = error.errors[0].path;
            return res.status(400).json({
                success: false,
                message: `Ya existe un usuario con ese ${field === 'dpi' ? 'DPI' : 'email'}`
            });
        }
        if (error.name === 'SequelizeValidationError') {
            return res.status(400).json({
                success: false,
                message: 'Email inválido'
            });
        }
        console.error('Error en createUsuario:', error);
        next(error);
    }
};

// Actualizar usuario
exports.updateUsuario = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { nombre, dpi, email, password, rol_id, sucursal_id, activo } = req.body;

        const usuario = await Usuario.findByPk(id);

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        // Validar rol si se proporciona
        if (rol_id) {
            const rol = await Rol.findByPk(rol_id);
            if (!rol) {
                return res.status(404).json({
                    success: false,
                    message: 'Rol no encontrado'
                });
            }
        }

        // Validar sucursal si se proporciona
        if (sucursal_id) {
            const sucursal = await Sucursal.findByPk(sucursal_id);
            if (!sucursal) {
                return res.status(404).json({
                    success: false,
                    message: 'Sucursal no encontrada'
                });
            }
        }

        // Preparar datos para actualizar
        const updateData = {
            nombre: nombre || usuario.nombre,
            dpi: dpi || usuario.dpi,
            email: email || usuario.email,
            rol_id: rol_id || usuario.rol_id,
            sucursal_id: sucursal_id !== undefined ? sucursal_id : usuario.sucursal_id,
            activo: activo !== undefined ? activo : usuario.activo
        };

        // Actualizar password si se proporciona
        if (password) {
            if (password.length < 6) {
                return res.status(400).json({
                    success: false,
                    message: 'El password debe tener al menos 6 caracteres'
                });
            }
            updateData.password_hash = await bcrypt.hash(password, 10);
        }

        await usuario.update(updateData);

        // Obtener usuario actualizado con relaciones
        const usuarioActualizado = await Usuario.findByPk(id, {
            attributes: { exclude: ['password_hash'] },
            include: [
                { model: Rol, as: 'rol' },
                { model: Sucursal, as: 'sucursal' }
            ]
        });

        res.status(200).json({
            success: true,
            message: 'Usuario actualizado exitosamente',
            data: usuarioActualizado
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            const field = error.errors[0].path;
            return res.status(400).json({
                success: false,
                message: `Ya existe un usuario con ese ${field === 'dpi' ? 'DPI' : 'email'}`
            });
        }
        if (error.name === 'SequelizeValidationError') {
            return res.status(400).json({
                success: false,
                message: 'Email inválido'
            });
        }
        console.error('Error en updateUsuario:', error);
        next(error);
    }
};

// Eliminar usuario (soft delete)
exports.deleteUsuario = async (req, res, next) => {
    try {
        const { id } = req.params;

        const usuario = await Usuario.findByPk(id);

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        // Soft delete: marcar como inactivo
        await usuario.update({ activo: false });

        res.status(200).json({
            success: true,
            message: 'Usuario desactivado exitosamente'
        });
    } catch (error) {
        console.error('Error en deleteUsuario:', error);
        next(error);
    }
}