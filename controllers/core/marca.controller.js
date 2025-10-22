// controllers/core/marca.controller.js
const { Marca, Producto } = require('../../models/index');
const { Op } = require('sequelize');

// ===== CREAR MARCA =====
const createMarca = async (req, res, next) => {
    try {
        const { nombre, activa } = req.body;

        // Validaciones
        if (!nombre || nombre.trim() === '') {
            return res.status(400).json({
                success: false,
                message: 'El nombre es obligatorio'
            });
        }

        // Verificar que no exista
        const marcaExistente = await Marca.findOne({
            where: { nombre: nombre.trim() }
        });

        if (marcaExistente) {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una marca con ese nombre'
            });
        }

        // Crear
        const marca = await Marca.create({
            nombre: nombre.trim(),
            activa: activa !== undefined ? activa : true
        });

        res.status(201).json({
            success: true,
            message: 'Marca creada exitosamente',
            data: marca
        });

    } catch (error) {
        console.error('Error en createMarca:', error);
        
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una marca con ese nombre'
            });
        }
        
        next(error);
    }
};

// ===== OBTENER TODAS LAS MARCAS =====
const getMarcas = async (req, res, next) => {
    try {
        const { buscar, activa, incluir_productos } = req.query;

        const where = {};

        // Búsqueda por nombre
        if (buscar) {
            where.nombre = { [Op.like]: `%${buscar}%` };
        }

        // Filtrar por estado
        if (activa !== undefined) {
            where.activa = activa === 'true';
        }

        const options = {
            where,
            order: [['nombre', 'ASC']]
        };

        // Incluir conteo de productos si se solicita
        if (incluir_productos === 'true') {
            options.include = [
                {
                    model: Producto,
                    as: 'productos',
                    attributes: ['id'],
                    required: false
                }
            ];
        }

        const marcas = await Marca.findAll(options);

        // Si se incluyeron productos, agregar conteo
        const marcasConConteo = marcas.map(marca => {
            const marcaJSON = marca.toJSON();
            if (incluir_productos === 'true') {
                marcaJSON.total_productos = marcaJSON.productos ? marcaJSON.productos.length : 0;
                delete marcaJSON.productos;
            }
            return marcaJSON;
        });

        res.status(200).json({
            success: true,
            count: marcasConConteo.length,
            data: incluir_productos === 'true' ? marcasConConteo : marcas
        });

    } catch (error) {
        console.error('Error en getMarcas:', error);
        next(error);
    }
};

// ===== OBTENER MARCA POR ID =====
const getMarcaById = async (req, res, next) => {
    try {
        const { id } = req.params;

        const marca = await Marca.findByPk(id, {
            include: [
                {
                    model: Producto,
                    as: 'productos',
                    attributes: ['id', 'codigo_sku', 'descripcion', 'activo']
                }
            ]
        });

        if (!marca) {
            return res.status(404).json({
                success: false,
                message: 'Marca no encontrada'
            });
        }

        const marcaJSON = marca.toJSON();
        marcaJSON.total_productos = marcaJSON.productos ? marcaJSON.productos.length : 0;

        res.status(200).json({
            success: true,
            data: marcaJSON
        });

    } catch (error) {
        console.error('Error en getMarcaById:', error);
        next(error);
    }
};

// ===== ACTUALIZAR MARCA =====
const updateMarca = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { nombre, activa } = req.body;

        const marca = await Marca.findByPk(id);

        if (!marca) {
            return res.status(404).json({
                success: false,
                message: 'Marca no encontrada'
            });
        }

        // Validar nombre
        if (nombre && nombre.trim() === '') {
            return res.status(400).json({
                success: false,
                message: 'El nombre no puede estar vacío'
            });
        }

        // Si se está cambiando el nombre, verificar que no exista
        if (nombre && nombre.trim() !== marca.nombre) {
            const nombreExistente = await Marca.findOne({
                where: {
                    nombre: nombre.trim(),
                    id: { [Op.ne]: id }
                }
            });

            if (nombreExistente) {
                return res.status(400).json({
                    success: false,
                    message: 'Ya existe una marca con ese nombre'
                });
            }
        }

        // Actualizar
        await marca.update({
            nombre: nombre ? nombre.trim() : marca.nombre,
            activa: activa !== undefined ? activa : marca.activa
        });

        res.status(200).json({
            success: true,
            message: 'Marca actualizada exitosamente',
            data: marca
        });

    } catch (error) {
        console.error('Error en updateMarca:', error);
        
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una marca con ese nombre'
            });
        }
        
        next(error);
    }
};

// ===== DESACTIVAR MARCA =====
const desactivarMarca = async (req, res, next) => {
    try {
        const { id } = req.params;

        const marca = await Marca.findByPk(id);

        if (!marca) {
            return res.status(404).json({
                success: false,
                message: 'Marca no encontrada'
            });
        }

        await marca.update({ activa: false });

        res.status(200).json({
            success: true,
            message: 'Marca desactivada exitosamente',
            data: marca
        });

    } catch (error) {
        console.error('Error en desactivarMarca:', error);
        next(error);
    }
};

// ===== REACTIVAR MARCA =====
const reactivarMarca = async (req, res, next) => {
    try {
        const { id } = req.params;

        const marca = await Marca.findByPk(id);

        if (!marca) {
            return res.status(404).json({
                success: false,
                message: 'Marca no encontrada'
            });
        }

        await marca.update({ activa: true });

        res.status(200).json({
            success: true,
            message: 'Marca reactivada exitosamente',
            data: marca
        });

    } catch (error) {
        console.error('Error en reactivarMarca:', error);
        next(error);
    }
};

// ===== ELIMINAR MARCA =====
const deleteMarca = async (req, res, next) => {
    try {
        const { id } = req.params;

        const marca = await Marca.findByPk(id, {
            include: [
                {
                    model: Producto,
                    as: 'productos',
                    attributes: ['id']
                }
            ]
        });

        if (!marca) {
            return res.status(404).json({
                success: false,
                message: 'Marca no encontrada'
            });
        }

        // Verificar si tiene productos asociados
        if (marca.productos && marca.productos.length > 0) {
            return res.status(400).json({
                success: false,
                message: `No se puede eliminar. La marca tiene ${marca.productos.length} producto(s) asociado(s)`,
                total_productos: marca.productos.length,
                sugerencia: 'Puede desactivar la marca en lugar de eliminarla'
            });
        }

        // Eliminar
        await marca.destroy();

        res.status(200).json({
            success: true,
            message: 'Marca eliminada exitosamente'
        });

    } catch (error) {
        console.error('Error en deleteMarca:', error);
        
        if (error.name === 'SequelizeForeignKeyConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'No se puede eliminar la marca porque tiene productos asociados',
                sugerencia: 'Puede desactivar la marca en lugar de eliminarla'
            });
        }
        
        next(error);
    }
};

module.exports = {
    createMarca,
    getMarcas,
    getMarcaById,
    updateMarca,
    desactivarMarca,
    reactivarMarca,
    deleteMarca
};