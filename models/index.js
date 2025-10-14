// models/index.js
const db = require('../db/db');

// Importar todos los modelos
const Producto = require('./producto.model');
const Categoria = require('./categoria.model');
const Marca = require('./marca.model');

// ===== DEFINIR RELACIONES =====
// Categoria -> Producto
Categoria.hasMany(Producto, { 
    foreignKey: 'categoria_id',
    as: 'productos'
});

Producto.belongsTo(Categoria, { 
    foreignKey: 'categoria_id',
    as: 'categoria'
});

// Marca -> Producto
Marca.hasMany(Producto, { 
    foreignKey: 'marca_id',
    as: 'productos'
});

Producto.belongsTo(Marca, { 
    foreignKey: 'marca_id',
    as: 'marca'
});

// ===== EXPORTAR =====
module.exports = {
    Producto,
    Categoria,
    Marca,
    sequelize: db
};