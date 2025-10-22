// controllers/core/categoria.controller.js
const { Categoria, Producto } = require('../../models/index');
const { Op } = require('sequelize');

// ===== CREAR CATEGORÍA =====
const createCategoria = async (req, res, next) => {
    try {
        const { nombre, descripcion } = req.body;

        // Validaciones
        if (!nombre || nombre.trim() === '') {
            return res.status(400).json({
                success: false,
                message: 'El nombre es obligatorio'
            });
        }

        // Verificar que no exista
        const categoriaExistente = await Categoria.findOne({
            where: { nombre: nombre.trim() }
        });

        if (categoriaExistente) {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una categoría con ese nombre'
            });
        }

        // Crear
        const categoria = await Categoria.create({
            nombre: nombre.trim(),
            descripcion: descripcion?.trim() || null
        });

        res.status(201).json({
            success: true,
            message: 'Categoría creada exitosamente',
            data: categoria
        });

    } catch (error) {
        console.error('Error en createCategoria:', error);
        
        // Error de unique constraint
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una categoría con ese nombre'
            });
        }
        
        next(error);
    }
};

// ===== OBTENER TODAS LAS CATEGORÍAS =====
const getCategorias = async (req, res, next) => {
    try {
        const { buscar, incluir_productos } = req.query;

        const where = {};

        // Búsqueda por nombre
        if (buscar) {
            where.nombre = { [Op.like]: `%${buscar}%` };
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

        const categorias = await Categoria.findAll(options);

        // Si se incluyeron productos, agregar conteo
        const categoriasConConteo = categorias.map(cat => {
            const catJSON = cat.toJSON();
            if (incluir_productos === 'true') {
                catJSON.total_productos = catJSON.productos ? catJSON.productos.length : 0;
                delete catJSON.productos; // No devolver el array completo
            }
            return catJSON;
        });

        res.status(200).json({
            success: true,
            count: categoriasConConteo.length,
            data: incluir_productos === 'true' ? categoriasConConteo : categorias
        });

    } catch (error) {
        console.error('Error en getCategorias:', error);
        next(error);
    }
};

// ===== OBTENER CATEGORÍA POR ID =====
const getCategoriaById = async (req, res, next) => {
    try {
        const { id } = req.params;

        const categoria = await Categoria.findByPk(id, {
            include: [
                {
                    model: Producto,
                    as: 'productos',
                    attributes: ['id', 'codigo_sku', 'descripcion', 'activo']
                }
            ]
        });

        if (!categoria) {
            return res.status(404).json({
                success: false,
                message: 'Categoría no encontrada'
            });
        }

        const categoriaJSON = categoria.toJSON();
        categoriaJSON.total_productos = categoriaJSON.productos ? categoriaJSON.productos.length : 0;

        res.status(200).json({
            success: true,
            data: categoriaJSON
        });

    } catch (error) {
        console.error('Error en getCategoriaById:', error);
        next(error);
    }
};

// ===== ACTUALIZAR CATEGORÍA =====
const updateCategoria = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { nombre, descripcion } = req.body;

        const categoria = await Categoria.findByPk(id);

        if (!categoria) {
            return res.status(404).json({
                success: false,
                message: 'Categoría no encontrada'
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
        if (nombre && nombre.trim() !== categoria.nombre) {
            const nombreExistente = await Categoria.findOne({
                where: {
                    nombre: nombre.trim(),
                    id: { [Op.ne]: id }
                }
            });

            if (nombreExistente) {
                return res.status(400).json({
                    success: false,
                    message: 'Ya existe una categoría con ese nombre'
                });
            }
        }

        // Actualizar
        await categoria.update({
            nombre: nombre ? nombre.trim() : categoria.nombre,
            descripcion: descripcion !== undefined ? (descripcion?.trim() || null) : categoria.descripcion
        });

        res.status(200).json({
            success: true,
            message: 'Categoría actualizada exitosamente',
            data: categoria
        });

    } catch (error) {
        console.error('Error en updateCategoria:', error);
        
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una categoría con ese nombre'
            });
        }
        
        next(error);
    }
};

// ===== ELIMINAR CATEGORÍA =====
const deleteCategoria = async (req, res, next) => {
    try {
        const { id } = req.params;

        const categoria = await Categoria.findByPk(id, {
            include: [
                {
                    model: Producto,
                    as: 'productos',
                    attributes: ['id']
                }
            ]
        });

        if (!categoria) {
            return res.status(404).json({
                success: false,
                message: 'Categoría no encontrada'
            });
        }

        // Verificar si tiene productos asociados
        if (categoria.productos && categoria.productos.length > 0) {
            return res.status(400).json({
                success: false,
                message: `No se puede eliminar. La categoría tiene ${categoria.productos.length} producto(s) asociado(s)`,
                total_productos: categoria.productos.length
            });
        }

        // Eliminar
        await categoria.destroy();

        res.status(200).json({
            success: true,
            message: 'Categoría eliminada exitosamente'
        });

    } catch (error) {
        console.error('Error en deleteCategoria:', error);
        
        // Error de foreign key constraint
        if (error.name === 'SequelizeForeignKeyConstraintError') {
            return res.status(400).json({
                success: false,
                message: 'No se puede eliminar la categoría porque tiene productos asociados'
            });
        }
        
        next(error);
    }
};

module.exports = {
    createCategoria,
    getCategorias,
    getCategoriaById,
    updateCategoria,
    deleteCategoria
};