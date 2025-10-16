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
const MovimientoInventario = require('./inventario/movimientoInventario.model');

// ===== IMPORTAR MODELOS USUARIOS =====
const Usuario = require('./usuarios/usuario.model');
const Cliente = require('./usuarios/cliente.model');

// ===== IMPORTAR MODELOS VENTAS (NUEVOS) =====
const Factura = require('./ventas/factura.model');
const DetalleFactura = require('./ventas/detalleFactura.model');
const Pago = require('./ventas/pago.model');

// ===== DEFINIR RELACIONES EXISTENTES =====

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

// ===== RELACIONES FACTURAS (NUEVAS) =====

// Cliente -> Factura
Cliente.hasMany(Factura, {
    foreignKey: 'cliente_id',
    as: 'facturas'
});

Factura.belongsTo(Cliente, {
    foreignKey: 'cliente_id',
    as: 'cliente'
});

// Usuario -> Factura (vendedor)
Usuario.hasMany(Factura, {
    foreignKey: 'usuario_id',
    as: 'facturas'
});

Factura.belongsTo(Usuario, {
    foreignKey: 'usuario_id',
    as: 'usuario'
});

// Usuario -> Factura (quien anuló)
Usuario.hasMany(Factura, {
    foreignKey: 'anulada_por',
    as: 'facturas_anuladas'
});

Factura.belongsTo(Usuario, {
    foreignKey: 'anulada_por',
    as: 'anulador'
});

// Sucursal -> Factura
Sucursal.hasMany(Factura, {
    foreignKey: 'sucursal_id',
    as: 'facturas'
});

Factura.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});

// Factura -> DetalleFactura
Factura.hasMany(DetalleFactura, {
    foreignKey: 'factura_id',
    as: 'detalles'
});

DetalleFactura.belongsTo(Factura, {
    foreignKey: 'factura_id',
    as: 'factura'
});

// ProductoPresentacion -> DetalleFactura
ProductoPresentacion.hasMany(DetalleFactura, {
    foreignKey: 'producto_presentacion_id',
    as: 'detalles_factura'
});

DetalleFactura.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});

// Factura -> Pago
Factura.hasMany(Pago, {
    foreignKey: 'factura_id',
    as: 'pagos'
});

Pago.belongsTo(Factura, {
    foreignKey: 'factura_id',
    as: 'factura'
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
    MovimientoInventario,
    // Usuarios
    Usuario,
    Cliente,
    // Ventas (NUEVOS)
    Factura,
    DetalleFactura,
    Pago,
    // Sequelize
    sequelize: db
};