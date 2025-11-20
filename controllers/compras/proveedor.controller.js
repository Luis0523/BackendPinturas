
const { Proveedor } = require('../../models/index');
const { Op } = require('sequelize');


const createProveedor = async (req, res, next) => {
    try {
        const {
            nombre,
            razon_social,
            nit,
            telefono,
            email,
            direccion,
            contacto_principal
        } = req.body;

        
        if (!nombre || nombre.trim() === '') {
            return res.status(400).json({
                success: false,
                message: 'El nombre es obligatorio'
            });
        }

        
        const proveedor = await Proveedor.create({
            nombre: nombre.trim(),
            razon_social: razon_social?.trim() || null,
            nit: nit?.trim() || null,
            telefono: telefono?.trim() || null,
            email: email?.trim() || null,
            direccion: direccion?.trim() || null,
            contacto_principal: contacto_principal?.trim() || null,
            activo: true
        });

        res.status(201).json({
            success: true,
            message: 'Proveedor creado exitosamente',
            data: proveedor
        });

    } catch (error) {
        console.error('Error en createProveedor:', error);
        next(error);
    }
};


const getProveedores = async (req, res, next) => {
    try {
        const { activo, buscar } = req.query;

        const where = {};

        
        if (activo !== undefined) {
            where.activo = activo === 'true';
        }

        
        if (buscar) {
            where[Op.or] = [
                { nombre: { [Op.like]: `%${buscar}%` } },
                { razon_social: { [Op.like]: `%${buscar}%` } },
                { nit: { [Op.like]: `%${buscar}%` } }
            ];
        }

        const proveedores = await Proveedor.findAll({
            where,
            order: [['nombre', 'ASC']]
        });

        res.status(200).json({
            success: true,
            count: proveedores.length,
            data: proveedores
        });

    } catch (error) {
        console.error('Error en getProveedores:', error);
        next(error);
    }
};


const getProveedorById = async (req, res, next) => {
    try {
        const { id } = req.params;

        const proveedor = await Proveedor.findByPk(id);

        if (!proveedor) {
            return res.status(404).json({
                success: false,
                message: 'Proveedor no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            data: proveedor
        });

    } catch (error) {
        console.error('Error en getProveedorById:', error);
        next(error);
    }
};


const updateProveedor = async (req, res, next) => {
    try {
        const { id } = req.params;
        const {
            nombre,
            razon_social,
            nit,
            telefono,
            email,
            direccion,
            contacto_principal,
            activo
        } = req.body;

        const proveedor = await Proveedor.findByPk(id);

        if (!proveedor) {
            return res.status(404).json({
                success: false,
                message: 'Proveedor no encontrado'
            });
        }

        
        await proveedor.update({
            nombre: nombre?.trim() || proveedor.nombre,
            razon_social: razon_social?.trim() || proveedor.razon_social,
            nit: nit?.trim() || proveedor.nit,
            telefono: telefono?.trim() || proveedor.telefono,
            email: email?.trim() || proveedor.email,
            direccion: direccion?.trim() || proveedor.direccion,
            contacto_principal: contacto_principal?.trim() || proveedor.contacto_principal,
            activo: activo !== undefined ? activo : proveedor.activo
        });

        res.status(200).json({
            success: true,
            message: 'Proveedor actualizado exitosamente',
            data: proveedor
        });

    } catch (error) {
        console.error('Error en updateProveedor:', error);
        next(error);
    }
};


const deleteProveedor = async (req, res, next) => {
    try {
        const { id } = req.params;

        const proveedor = await Proveedor.findByPk(id);

        if (!proveedor) {
            return res.status(404).json({
                success: false,
                message: 'Proveedor no encontrado'
            });
        }

        
        await proveedor.update({ activo: false });

        res.status(200).json({
            success: true,
            message: 'Proveedor desactivado exitosamente'
        });

    } catch (error) {
        console.error('Error en deleteProveedor:', error);
        next(error);
    }
};

module.exports = {
    createProveedor,
    getProveedores,
    getProveedorById,
    updateProveedor,
    deleteProveedor
};