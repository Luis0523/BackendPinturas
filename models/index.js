// models/index.js
const db = require('../db/db');

// ===== IMPORTAR MODELOS CORE =====
const Categoria = require('./core/categoria.model');
const Marca = require('./core/marca.model');
const Presentacion = require('./core/presentacion.model');
const Rol = require('./core/rol.model');
const Sucursal = require('./core/sucursal.model');

// ===== IMPORTAR MODELOS PRODUCTOS =====
const Producto = require('./productos/producto.model');

// ===== IMPORTAR MODELOS USUARIOS =====
const Cliente = require('./usuarios/cliente.model'); // ← Agregar

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
    // Core
    Categoria,
    Marca,
    Presentacion,
    Rol,
    Sucursal,
    // Productos
    Producto,
    // Usuarios
    Cliente, // ← Agregar
    // Sequelize
    sequelize: db
};