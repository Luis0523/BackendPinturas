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
const ProductoPresentacion = require('./productos/productoPresentacion.model');

// ===== IMPORTAR MODELOS INVENTARIO =====
const Precio = require('./inventario/precio.model');
const InventarioSucursal = require('./inventario/inventarioSucursal.model');
const MovimientoInventario = require('./inventario/movimientoInventario.model'); // ← NUEVO

// ===== IMPORTAR MODELOS USUARIOS =====
const Usuario = require('./usuarios/usuario.model');
const Cliente = require('./usuarios/cliente.model');

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

// Rol -> Usuario
Rol.hasMany(Usuario, {
    foreignKey: 'rol_id',
    as: 'usuarios'
});

Usuario.belongsTo(Rol, {
    foreignKey: 'rol_id',
    as: 'rol'
});

// Sucursal -> Usuario
Sucursal.hasMany(Usuario, {
    foreignKey: 'sucursal_id',
    as: 'usuarios'
});

Usuario.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});

// Producto -> ProductoPresentacion
Producto.hasMany(ProductoPresentacion, {
    foreignKey: 'producto_id',
    as: 'presentaciones'
});

ProductoPresentacion.belongsTo(Producto, {
    foreignKey: 'producto_id',
    as: 'producto'
});

// Presentacion -> ProductoPresentacion
Presentacion.hasMany(ProductoPresentacion, {
    foreignKey: 'presentacion_id',
    as: 'productos'
});

ProductoPresentacion.belongsTo(Presentacion, {
    foreignKey: 'presentacion_id',
    as: 'presentacion'
});

// ===== RELACIONES PRECIOS =====

// ProductoPresentacion -> Precio
ProductoPresentacion.hasMany(Precio, {
    foreignKey: 'producto_presentacion_id',
    as: 'precios'
});

Precio.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});

// Sucursal -> Precio
Sucursal.hasMany(Precio, {
    foreignKey: 'sucursal_id',
    as: 'precios'
});

Precio.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});

// ===== RELACIONES INVENTARIO =====

// Sucursal -> InventarioSucursal
Sucursal.hasMany(InventarioSucursal, {
    foreignKey: 'sucursal_id',
    as: 'inventarios'
});

InventarioSucursal.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});

// ProductoPresentacion -> InventarioSucursal
ProductoPresentacion.hasMany(InventarioSucursal, {
    foreignKey: 'producto_presentacion_id',
    as: 'inventarios'
});

InventarioSucursal.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});

// ===== RELACIONES MOVIMIENTOS INVENTARIO (NUEVAS) =====

// Sucursal -> MovimientoInventario
Sucursal.hasMany(MovimientoInventario, {
    foreignKey: 'sucursal_id',
    as: 'movimientos'
});

MovimientoInventario.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});

// ProductoPresentacion -> MovimientoInventario
ProductoPresentacion.hasMany(MovimientoInventario, {
    foreignKey: 'producto_presentacion_id',
    as: 'movimientos'
});

MovimientoInventario.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
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
    ProductoPresentacion,
    // Inventario
    Precio,
    InventarioSucursal,
    MovimientoInventario, // ← NUEVO
    // Usuarios
    Usuario,
    Cliente,
    // Sequelize
    sequelize: db
};