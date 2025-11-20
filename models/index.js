
const db = require('../db/db');


const Categoria = require('./core/categoria.model');
const Marca = require('./core/marca.model');
const Presentacion = require('./core/presentacion.model');
const Rol = require('./core/rol.model');
const Sucursal = require('./core/sucursal.model');


const Producto = require('./productos/producto.model');
const ProductoPresentacion = require('./productos/productoPresentacion.model');


const Precio = require('./inventario/precio.model');
const InventarioSucursal = require('./inventario/inventarioSucursal.model');
const MovimientoInventario = require('./inventario/movimientoInventario.model');


const Usuario = require('./usuarios/usuario.model');
const Cliente = require('./usuarios/cliente.model');


const Factura = require('./ventas/factura.model');
const DetalleFactura = require('./ventas/detalleFactura.model');
const Pago = require('./ventas/pago.model');
const Pedido = require('./ventas/pedido.model');
const DetallePedido = require('./ventas/detallePedido.model');


const Proveedor = require('./compras/proveedor.model');
const OrdenCompra = require('./compras/ordenCompra.model');
const DetalleOrdenCompra = require('./compras/detalleOrdenCompra.model');
const Recepcion = require('./compras/recepcion.model');
const DetalleRecepcion = require('./compras/detalleRecepcion.model');




Categoria.hasMany(Producto, { 
    foreignKey: 'categoria_id',
    as: 'productos'
});

Producto.belongsTo(Categoria, { 
    foreignKey: 'categoria_id',
    as: 'categoria'
});


Marca.hasMany(Producto, { 
    foreignKey: 'marca_id',
    as: 'productos'
});

Producto.belongsTo(Marca, { 
    foreignKey: 'marca_id',
    as: 'marca'
});


Rol.hasMany(Usuario, {
    foreignKey: 'rol_id',
    as: 'usuarios'
});

Usuario.belongsTo(Rol, {
    foreignKey: 'rol_id',
    as: 'rol'
});


Sucursal.hasMany(Usuario, {
    foreignKey: 'sucursal_id',
    as: 'usuarios'
});

Usuario.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});


Producto.hasMany(ProductoPresentacion, {
    foreignKey: 'producto_id',
    as: 'presentaciones'
});

ProductoPresentacion.belongsTo(Producto, {
    foreignKey: 'producto_id',
    as: 'producto'
});


Presentacion.hasMany(ProductoPresentacion, {
    foreignKey: 'presentacion_id',
    as: 'productos'
});

ProductoPresentacion.belongsTo(Presentacion, {
    foreignKey: 'presentacion_id',
    as: 'presentacion'
});


ProductoPresentacion.hasMany(Precio, {
    foreignKey: 'producto_presentacion_id',
    as: 'precios'
});

Precio.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});


Sucursal.hasMany(Precio, {
    foreignKey: 'sucursal_id',
    as: 'precios'
});

Precio.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});


Sucursal.hasMany(InventarioSucursal, {
    foreignKey: 'sucursal_id',
    as: 'inventarios'
});

InventarioSucursal.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});


ProductoPresentacion.hasMany(InventarioSucursal, {
    foreignKey: 'producto_presentacion_id',
    as: 'inventarios'
});

InventarioSucursal.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});


Sucursal.hasMany(MovimientoInventario, {
    foreignKey: 'sucursal_id',
    as: 'movimientos'
});

MovimientoInventario.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});


ProductoPresentacion.hasMany(MovimientoInventario, {
    foreignKey: 'producto_presentacion_id',
    as: 'movimientos'
});

MovimientoInventario.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});




Cliente.hasMany(Factura, {
    foreignKey: 'cliente_id',
    as: 'facturas'
});

Factura.belongsTo(Cliente, {
    foreignKey: 'cliente_id',
    as: 'cliente'
});


Usuario.hasMany(Factura, {
    foreignKey: 'usuario_id',
    as: 'facturas'
});

Factura.belongsTo(Usuario, {
    foreignKey: 'usuario_id',
    as: 'usuario'
});


Usuario.hasMany(Factura, {
    foreignKey: 'anulada_por',
    as: 'facturas_anuladas'
});

Factura.belongsTo(Usuario, {
    foreignKey: 'anulada_por',
    as: 'anulador'
});


Sucursal.hasMany(Factura, {
    foreignKey: 'sucursal_id',
    as: 'facturas'
});

Factura.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});


Factura.hasMany(DetalleFactura, {
    foreignKey: 'factura_id',
    as: 'detalles'
});

DetalleFactura.belongsTo(Factura, {
    foreignKey: 'factura_id',
    as: 'factura'
});


ProductoPresentacion.hasMany(DetalleFactura, {
    foreignKey: 'producto_presentacion_id',
    as: 'detalles_factura'
});

DetalleFactura.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});


Factura.hasMany(Pago, {
    foreignKey: 'factura_id',
    as: 'pagos'
});

Pago.belongsTo(Factura, {
    foreignKey: 'factura_id',
    as: 'factura'
});




Cliente.hasMany(Pedido, {
    foreignKey: 'cliente_id',
    as: 'pedidos'
});

Pedido.belongsTo(Cliente, {
    foreignKey: 'cliente_id',
    as: 'cliente'
});


Sucursal.hasMany(Pedido, {
    foreignKey: 'sucursal_id',
    as: 'pedidos'
});

Pedido.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});


Factura.hasOne(Pedido, {
    foreignKey: 'factura_id',
    as: 'pedido'
});

Pedido.belongsTo(Factura, {
    foreignKey: 'factura_id',
    as: 'factura'
});


Pedido.hasMany(DetallePedido, {
    foreignKey: 'pedido_id',
    as: 'detalles'
});

DetallePedido.belongsTo(Pedido, {
    foreignKey: 'pedido_id',
    as: 'pedido'
});


ProductoPresentacion.hasMany(DetallePedido, {
    foreignKey: 'producto_presentacion_id',
    as: 'detalles_pedido'
});

DetallePedido.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});


Pedido.hasMany(Pago, {
    foreignKey: 'pedido_id',
    as: 'pagos'
});

Pago.belongsTo(Pedido, {
    foreignKey: 'pedido_id',
    as: 'pedido'
});




Proveedor.hasMany(OrdenCompra, {
    foreignKey: 'proveedor_id',
    as: 'ordenes'
});

OrdenCompra.belongsTo(Proveedor, {
    foreignKey: 'proveedor_id',
    as: 'proveedor'
});


Sucursal.hasMany(OrdenCompra, {
    foreignKey: 'sucursal_id',
    as: 'ordenes_compra'
});

OrdenCompra.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});


Usuario.hasMany(OrdenCompra, {
    foreignKey: 'usuario_id',
    as: 'ordenes_compra'
});

OrdenCompra.belongsTo(Usuario, {
    foreignKey: 'usuario_id',
    as: 'usuario'
});


OrdenCompra.hasMany(DetalleOrdenCompra, {
    foreignKey: 'orden_compra_id',
    as: 'detalles'
});

DetalleOrdenCompra.belongsTo(OrdenCompra, {
    foreignKey: 'orden_compra_id',
    as: 'ordenCompra'
});


ProductoPresentacion.hasMany(DetalleOrdenCompra, {
    foreignKey: 'producto_presentacion_id',
    as: 'detalles_orden_compra'
});

DetalleOrdenCompra.belongsTo(ProductoPresentacion, {
    foreignKey: 'producto_presentacion_id',
    as: 'productoPresentacion'
});


OrdenCompra.hasMany(Recepcion, {
    foreignKey: 'orden_compra_id',
    as: 'recepciones'
});

Recepcion.belongsTo(OrdenCompra, {
    foreignKey: 'orden_compra_id',
    as: 'ordenCompra'
});


Sucursal.hasMany(Recepcion, {
    foreignKey: 'sucursal_id',
    as: 'recepciones'
});

Recepcion.belongsTo(Sucursal, {
    foreignKey: 'sucursal_id',
    as: 'sucursal'
});


Usuario.hasMany(Recepcion, {
    foreignKey: 'usuario_id',
    as: 'recepciones'
});

Recepcion.belongsTo(Usuario, {
    foreignKey: 'usuario_id',
    as: 'usuario'
});


Recepcion.hasMany(DetalleRecepcion, {
    foreignKey: 'recepcion_id',
    as: 'detalles'
});

DetalleRecepcion.belongsTo(Recepcion, {
    foreignKey: 'recepcion_id',
    as: 'recepcion'
});


DetalleOrdenCompra.hasMany(DetalleRecepcion, {
    foreignKey: 'detalle_orden_id',
    as: 'recepciones'
});

DetalleRecepcion.belongsTo(DetalleOrdenCompra, {
    foreignKey: 'detalle_orden_id',
    as: 'detalleOrden'
});


module.exports = {
    
    Categoria,
    Marca,
    Presentacion,
    Rol,
    Sucursal,
    
    Producto,
    ProductoPresentacion,
    
    Precio,
    InventarioSucursal,
    MovimientoInventario,
    
    Usuario,
    Cliente,
    
    Factura,
    DetalleFactura,
    Pago,
    Pedido,
    DetallePedido,
    
    Proveedor,
    OrdenCompra,
    DetalleOrdenCompra,
    Recepcion,
    DetalleRecepcion,
    
    sequelize: db
};
