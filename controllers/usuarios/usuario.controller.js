
const { Usuario, Rol, Sucursal } = require('../../models/index');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');





exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Email y contraseña son requeridos'
            });
        }

        
        const usuario = await Usuario.findOne({
            where: { email },
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
            ]
        });

        
        if (!usuario) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales incorrectas'
            });
        }

        
        if (!usuario.activo) {
            return res.status(403).json({
                success: false,
                message: 'Usuario inactivo. Contacta al administrador'
            });
        }

        
        const passwordValida = await bcrypt.compare(password, usuario.password_hash);
        
        if (!passwordValida) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales incorrectas'
            });
        }

        
        const token = jwt.sign(
            {
                id: usuario.id,
                email: usuario.email,
                rol: usuario.rol ? usuario.rol.nombre : null,  
                rol_id: usuario.rol_id,
                sucursal_id: usuario.sucursal_id
            },
            process.env.JWT_SECRET || 'tu_clave_secreta_super_segura',
            { expiresIn: process.env.JWT_EXPIRES_IN || '8h' }
        );

        
        await usuario.update({ 
            ultimo_acceso: new Date() 
        });

        
        const userData = {
            id: usuario.id,
            nombre: usuario.nombre,
            email: usuario.email,
            dpi: usuario.dpi,
            rol: usuario.rol ? usuario.rol.nombre : null,          
            rol_id: usuario.rol_id,
            sucursal: usuario.sucursal ? usuario.sucursal.nombre : null,
            sucursal_id: usuario.sucursal_id,
            activo: usuario.activo
        };

        res.status(200).json({
            success: true,
            message: 'Login exitoso',
            token,
            user: userData
        });

    } catch (error) {
        console.error('Error en login:', error);
        next(error);
    }
};

exports.logout = async (req, res, next) => {
    try {
        
        
        
        
        
        
        res.status(200).json({
            success: true,
            message: 'Logout exitoso'
        });

    } catch (error) {
        console.error('Error en logout:', error);
        next(error);
    }
};


exports.refreshToken = async (req, res, next) => {
    try {
        const { token } = req.body;

        if (!token) {
            return res.status(400).json({
                success: false,
                message: 'Token requerido'
            });
        }

        
        const decoded = jwt.verify(
            token, 
            process.env.JWT_SECRET || 'tu_clave_secreta_super_segura'
        );

        
        const usuario = await Usuario.findByPk(decoded.id);
        
        if (!usuario || !usuario.activo) {
            return res.status(401).json({
                success: false,
                message: 'Usuario no encontrado o inactivo'
            });
        }

        
        const newToken = jwt.sign(
            {
                id: decoded.id,
                email: decoded.email,
                rol_id: decoded.rol_id,
                sucursal_id: decoded.sucursal_id
            },
            process.env.JWT_SECRET || 'tu_clave_secreta_super_segura',
            { expiresIn: process.env.JWT_EXPIRES_IN || '8h' }
        );

        res.status(200).json({
            success: true,
            message: 'Token renovado exitosamente',
            token: newToken
        });

    } catch (error) {
        if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
            return res.status(401).json({
                success: false,
                message: 'Token inválido o expirado'
            });
        }
        console.error('Error en refreshToken:', error);
        next(error);
    }
};


exports.verifyToken = async (req, res, next) => {
    try {
        
        const authHeader = req.headers.authorization;
        
        if (!authHeader) {
            return res.status(401).json({
                success: false,
                message: 'Token no proporcionado'
            });
        }

        const token = authHeader.replace('Bearer ', '');

        
        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET || 'tu_clave_secreta_super_segura'
        );

        
        const usuario = await Usuario.findByPk(decoded.id, {
            attributes: { exclude: ['password_hash'] },
            include: [
                { model: Rol, as: 'rol', attributes: ['id', 'nombre'] },
                { model: Sucursal, as: 'sucursal', attributes: ['id', 'nombre'] }
            ]
        });

        if (!usuario || !usuario.activo) {
            return res.status(401).json({
                success: false,
                valid: false,
                message: 'Usuario no encontrado o inactivo'
            });
        }

        res.status(200).json({
            success: true,
            valid: true,
            user: {
                id: usuario.id,
                nombre: usuario.nombre,
                email: usuario.email,
                rol: usuario.rol ? usuario.rol.nombre : null,
                sucursal: usuario.sucursal ? usuario.sucursal.nombre : null
            }
        });

    } catch (error) {
        if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
            return res.status(401).json({
                success: false,
                valid: false,
                message: 'Token inválido o expirado'
            });
        }
        console.error('Error en verifyToken:', error);
        next(error);
    }
};


exports.cambiarPassword = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { currentPassword, newPassword } = req.body;

        
        if (!currentPassword || !newPassword) {
            return res.status(400).json({
                success: false,
                message: 'Contraseña actual y nueva contraseña son requeridas'
            });
        }

        if (newPassword.length < 6) {
            return res.status(400).json({
                success: false,
                message: 'La nueva contraseña debe tener al menos 6 caracteres'
            });
        }

        
        const usuario = await Usuario.findByPk(id);

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        
        const passwordValida = await bcrypt.compare(currentPassword, usuario.password_hash);
        
        if (!passwordValida) {
            return res.status(401).json({
                success: false,
                message: 'Contraseña actual incorrecta'
            });
        }

        
        const password_hash = await bcrypt.hash(newPassword, 10);

        
        await usuario.update({ password_hash });

        res.status(200).json({
            success: true,
            message: 'Contraseña actualizada exitosamente'
        });

    } catch (error) {
        console.error('Error en cambiarPassword:', error);
        next(error);
    }
};


exports.forgotPassword = async (req, res, next) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                success: false,
                message: 'Email requerido'
            });
        }

        
        const usuario = await Usuario.findOne({ where: { email } });

        
        const mensaje = 'Si el email existe, recibirás instrucciones para recuperar tu contraseña';

        if (!usuario) {
            return res.status(200).json({
                success: true,
                message: mensaje
            });
        }

        
        const resetToken = jwt.sign(
            { id: usuario.id, email: usuario.email },
            process.env.JWT_SECRET || 'tu_clave_secreta_super_segura',
            { expiresIn: '1h' }
        );

        
        await usuario.update({
            reset_token: resetToken,
            reset_token_expira: new Date(Date.now() + 3600000) 
        });

        
        

        res.status(200).json({
            success: true,
            message: mensaje,
            
            ...(process.env.NODE_ENV === 'development' && {
                debug_token: resetToken,
                debug_link: `${process.env.FRONTEND_URL}/reset-password?token=${resetToken}`
            })
        });

    } catch (error) {
        console.error('Error en forgotPassword:', error);
        next(error);
    }
};


exports.resetPassword = async (req, res, next) => {
    try {
        const { token, newPassword } = req.body;

        if (!token || !newPassword) {
            return res.status(400).json({
                success: false,
                message: 'Token y nueva contraseña son requeridos'
            });
        }

        
        if (newPassword.length < 6) {
            return res.status(400).json({
                success: false,
                message: 'La contraseña debe tener al menos 6 caracteres'
            });
        }

        
        let decoded;
        try {
            decoded = jwt.verify(
                token,
                process.env.JWT_SECRET || 'tu_clave_secreta_super_segura'
            );
        } catch (error) {
            return res.status(401).json({
                success: false,
                message: 'Token inválido o expirado'
            });
        }

        
        const usuario = await Usuario.findOne({
            where: {
                id: decoded.id,
                reset_token: token
            }
        });

        if (!usuario) {
            return res.status(401).json({
                success: false,
                message: 'Token inválido o expirado'
            });
        }

        
        if (usuario.reset_token_expira && new Date() > usuario.reset_token_expira) {
            return res.status(401).json({
                success: false,
                message: 'Token expirado'
            });
        }

        
        const password_hash = await bcrypt.hash(newPassword, 10);

        
        await usuario.update({
            password_hash,
            reset_token: null,
            reset_token_expira: null
        });

        res.status(200).json({
            success: true,
            message: 'Contraseña actualizada exitosamente'
        });

    } catch (error) {
        console.error('Error en resetPassword:', error);
        next(error);
    }
};




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


exports.createUsuario = async (req, res, next) => {
    try {
        const { nombre, dpi, email, password, rol_id, sucursal_id, activo } = req.body;

        
        if (!nombre || !dpi || !email || !password || !rol_id) {
            return res.status(400).json({
                success: false,
                message: 'Nombre, DPI, email, password y rol_id son obligatorios'
            });
        }

        
        const rol = await Rol.findByPk(rol_id);
        if (!rol) {
            return res.status(404).json({
                success: false,
                message: 'Rol no encontrado'
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

        
        if (password.length < 6) {
            return res.status(400).json({
                success: false,
                message: 'El password debe tener al menos 6 caracteres'
            });
        }

        
        const password_hash = await bcrypt.hash(password, 10);

        
        const usuario = await Usuario.create({
            nombre,
            dpi,
            email,
            password_hash,
            rol_id,
            sucursal_id: sucursal_id || null,
            activo: activo !== undefined ? activo : true
        });

        
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

        
        if (rol_id) {
            const rol = await Rol.findByPk(rol_id);
            if (!rol) {
                return res.status(404).json({
                    success: false,
                    message: 'Rol no encontrado'
                });
            }
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

        
        const updateData = {
            nombre: nombre || usuario.nombre,
            dpi: dpi || usuario.dpi,
            email: email || usuario.email,
            rol_id: rol_id || usuario.rol_id,
            sucursal_id: sucursal_id !== undefined ? sucursal_id : usuario.sucursal_id,
            activo: activo !== undefined ? activo : usuario.activo
        };

        
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

        
        await usuario.update({ activo: false });

        res.status(200).json({
            success: true,
            message: 'Usuario desactivado exitosamente'
        });
    } catch (error) {
        console.error('Error en deleteUsuario:', error);
        next(error);
    }
};