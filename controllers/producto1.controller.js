// FUNCIONAMIENTO DE TODAS LAS RUTAS DE PRODUCTO

const models = require('../models/index');

module.exports = {

    // Obtener todos los productos con sus categorías y marcas
    listar: async (req, res, next) => {
        try {
            const productos = await models.producto.findAll({
                include: [
                    { model: models.categoria, attributes: ['nombre'] }, // Incluir categoría
                    { model: models.marca, attributes: ['nombre'] }      // Incluir marca
                ]
            });

            res.json({
                success: true,
                data: {
                    productos: productos
                }
            });

        } catch (err) {
            return next(err);
        }
    },

    // Obtener un producto por su ID con categoría y marca
    listarInfo: async (req, res, next) => {
        try {
            const producto = await models.producto.findByPk(req.params.id, {
                include: [
                    { model: models.categoria, attributes: ['nombre'] },
                    { model: models.marca, attributes: ['nombre'] }
                ]
            });

            if (!producto) {
                return res.status(404).json({ error: 'Producto no encontrado' });
            }

            res.json({
                success: true,
                data: {
                    producto: producto
                }
            });

        } catch (err) {
            return next(err);
        }
    },

    // Crear un nuevo producto con su categoría y marca
    crear: async (req, res, next) => {
        try {
            const { categoria_id, marca_id, codigo_sku, descripcion, tamano, duracion_anios, extension_m2, color } = req.body;

            // Verificar si la categoría y marca existen
            const categoria = await models.categoria.findByPk(categoria_id);
            const marca = await models.marca.findByPk(marca_id);

            if (!categoria || !marca) {
                return res.status(404).json({ error: 'Categoría o Marca no encontrados' });
            }

            // Crear el nuevo producto
            const nuevoProducto = await models.producto.create({
                categoria_id,
                marca_id,
                codigo_sku,
                descripcion,
                tamano,
                duracion_anios,
                extension_m2,
                color
            });

            res.json({
                success: true,
                data: {
                    id: nuevoProducto.id
                }
            });

        } catch (err) {
            return next(err);
        }
    },

    // Actualizar un producto existente
    actualizar: async (req, res, next) => {
        try {
            const { categoria_id, marca_id, codigo_sku, descripcion, tamano, duracion_anios, extension_m2, color } = req.body;
            const id = req.params.id;

            const producto = await models.producto.findByPk(id);
            if (!producto) {
                return res.status(404).json({ error: 'Producto no encontrado' });
            }

            producto.categoria_id = categoria_id || producto.categoria_id;
            producto.marca_id = marca_id || producto.marca_id;
            producto.codigo_sku = codigo_sku || producto.codigo_sku;
            producto.descripcion = descripcion || producto.descripcion;
            producto.tamano = tamano || producto.tamano;
            producto.duracion_anios = duracion_anios || producto.duracion_anios;
            producto.extension_m2 = extension_m2 || producto.extension_m2;
            producto.color = color || producto.color;

            await producto.save();

            res.json({
                success: true,
                data: {
                    producto: producto
                }
            });

        } catch (err) {
            return next(err);
        }
    },

    // Eliminar un producto por su ID
    eliminar: async (req, res, next) => {
        try {
            const id = req.params.id;

            const producto = await models.producto.findByPk(id);
            if (!producto) {
                return res.status(404).json({ error: 'Producto no encontrado' });
            }

            await producto.destroy();

            res.json({
                success: true,
                message: 'Producto eliminado correctamente'
            });

        } catch (err) {
            return next(err);
        }
    }
};
