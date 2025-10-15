// controllers/usuarios/cliente.controller.js
const { Cliente } = require('../../models/index');
const bcrypt = require('bcrypt');

// Obtener todos los clientes
exports.getClientes = async (req, res, next) => {
    try {
        const { verificado, opt_in_promos } = req.query;
        
        const where = {};
        
        if (verificado !== undefined) {
            where.verificado = verificado === 'true';
        }
        
        if (opt_in_promos !== undefined) {
            where.opt_in_promos = opt_in_promos === 'true';
        }

        const clientes = await Cliente.findAll({
            where,
            attributes: { exclude: ['password_hash'] }, // No exponer passwords
            order: [['nombre', 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: clientes.length,
            data: clientes
        });
    } catch (error) {
        console.error('Error en getClientes:', error);
        next(error);
    }
};

// Obtener cliente por ID
exports.getClienteById = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        const cliente = await Cliente.findByPk(id, {
            attributes: { exclude: ['password_hash'] }
        });

        if (!cliente) {
            return res.status(404).json({
                success: false,
                message: 'Cliente no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: cliente
        });
    } catch (error) {
        console.error('Error en getClienteById:', error);
        next(error);
    }
};

// Buscar cliente por NIT o email
exports.buscarCliente = async (req, res, next) => {
    try {
        const { nit, email } = req.query;

        if (!nit && !email) {
            return res.status(400).json({
                success: false,
                message: 'Debe proporcionar NIT o email para buscar'
            });
        }

        const where = {};
        if (nit) where.nit = nit;
        if (email) where.email = email;

        const cliente = await Cliente.findOne({
            where,
            attributes: { exclude: ['password_hash'] }
        });

        if (!cliente) {
            return res.status(404).json({
                success: false,
                message: 'Cliente no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: cliente
        });
    } catch (error) {
        console.error('Error en buscarCliente:', error);
        next(error);
    }
};

// Crear nuevo cliente
exports.createCliente = async (req, res, next) => {
    try {
        const { 
            nombre, 
            nit, 
            email, 
            password, 
            opt_in_promos, 
            telefono, 
            direccion, 
            gps_lat, 
            gps_lng 
        } = req.body;

        // Validación básica
        if (!nombre) {
            return res.status(400).json({
                success: false,
                message: 'El nombre es obligatorio'
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

        // Hashear password si se proporciona
        let password_hash = null;
        if (password) {
            password_hash = await bcrypt.hash(password, 10);
        }

        const cliente = await Cliente.create({
            nombre,
            nit: nit || null,
            email: email || null,
            password_hash,
            opt_in_promos: opt_in_promos || false,
            verificado: false, // Por defecto no verificado
            telefono,
            direccion,
            gps_lat,
            gps_lng
        });

        // No devolver el password_hash
        const clienteResponse = cliente.toJSON();
        delete clienteResponse.password_hash;

        res.status(201).json({
            success: true,
            message: 'Cliente creado exitosamente',
            data: clienteResponse
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            const field = error.errors[0].path;
            return res.status(400).json({
                success: false,
                message: `Ya existe un cliente con ese ${field === 'nit' ? 'NIT' : 'email'}`
            });
        }
        if (error.name === 'SequelizeValidationError') {
            return res.status(400).json({
                success: false,
                message: 'Email inválido'
            });
        }
        console.error('Error en createCliente:', error);
        next(error);
    }
};

// Actualizar cliente
exports.updateCliente = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { 
            nombre, 
            nit, 
            email, 
            password, 
            opt_in_promos, 
            telefono, 
            direccion, 
            gps_lat, 
            gps_lng 
        } = req.body;

        const cliente = await Cliente.findByPk(id);

        if (!cliente) {
            return res.status(404).json({
                success: false,
                message: 'Cliente no encontrado'
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

        // Preparar datos para actualizar
        const updateData = {
            nombre: nombre || cliente.nombre,
            nit: nit !== undefined ? nit : cliente.nit,
            email: email !== undefined ? email : cliente.email,
            opt_in_promos: opt_in_promos !== undefined ? opt_in_promos : cliente.opt_in_promos,
            telefono: telefono !== undefined ? telefono : cliente.telefono,
            direccion: direccion !== undefined ? direccion : cliente.direccion,
            gps_lat: gps_lat !== undefined ? gps_lat : cliente.gps_lat,
            gps_lng: gps_lng !== undefined ? gps_lng : cliente.gps_lng
        };

        // Actualizar password si se proporciona
        if (password) {
            updateData.password_hash = await bcrypt.hash(password, 10);
        }

        await cliente.update(updateData);

        // No devolver el password_hash
        const clienteResponse = cliente.toJSON();
        delete clienteResponse.password_hash;

        res.status(200).json({
            success: true,
            message: 'Cliente actualizado exitosamente',
            data: clienteResponse
        });
    } catch (error) {
        if (error.name === 'SequelizeUniqueConstraintError') {
            const field = error.errors[0].path;
            return res.status(400).json({
                success: false,
                message: `Ya existe un cliente con ese ${field === 'nit' ? 'NIT' : 'email'}`
            });
        }
        if (error.name === 'SequelizeValidationError') {
            return res.status(400).json({
                success: false,
                message: 'Email inválido'
            });
        }
        console.error('Error en updateCliente:', error);
        next(error);
    }
};

// Eliminar cliente
exports.deleteCliente = async (req, res, next) => {
    try {
        const { id } = req.params;

        const cliente = await Cliente.findByPk(id);

        if (!cliente) {
            return res.status(404).json({
                success: false,
                message: 'Cliente no encontrado'
            });
        }

        // Verificar si el cliente tiene facturas
        // (esto se implementará después cuando tengas el modelo Factura)
        
        await cliente.destroy();

        res.status(200).json({
            success: true,
            message: 'Cliente eliminado exitosamente'
        });
    } catch (error) {
        console.error('Error en deleteCliente:', error);
        next(error);
    }
};

// Verificar cliente (marcar como verificado)
exports.verificarCliente = async (req, res, next) => {
    try {
        const { id } = req.params;

        const cliente = await Cliente.findByPk(id);

        if (!cliente) {
            return res.status(404).json({
                success: false,
                message: 'Cliente no encontrado'
            });
        }

        await cliente.update({ verificado: true });

        const clienteResponse = cliente.toJSON();
        delete clienteResponse.password_hash;

        res.status(200).json({
            success: true,
            message: 'Cliente verificado exitosamente',
            data: clienteResponse
        });
    } catch (error) {
        console.error('Error en verificarCliente:', error);
        next(error);
    }
};

// Buscar clientes cercanos (por GPS)
exports.getClientesCercanos = async (req, res, next) => {
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
        const radioKm = parseFloat(radio) || 10;

        const clientes = await Cliente.findAll({
            where: {
                gps_lat: { [db.Sequelize.Op.ne]: null },
                gps_lng: { [db.Sequelize.Op.ne]: null }
            },
            attributes: {
                exclude: ['password_hash'],
                include: [
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
                ]
            },
            having: db.Sequelize.literal(`distancia <= ${radioKm}`),
            order: [[db.Sequelize.literal('distancia'), 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: clientes.length,
            radio_km: radioKm,
            data: clientes
        });
    } catch (error) {
        console.error('Error en getClientesCercanos:', error);
        next(error);
    }
};