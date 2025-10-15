##ORGANIZACION DE ARCHIVOS##

models/
├── index.js (centraliza TODAS las relaciones)
├── core/                    # Modelos base/maestros
│   ├── categoria.model.js
│   ├── marca.model.js
│   ├── presentacion.model.js
│   ├── rol.model.js
│   └── sucursal.model.js
├── productos/               # Catálogo
│   ├── producto.model.js
│   └── productoPresentacion.model.js
├── inventario/              # Stock y precios
│   ├── inventarioSucursal.model.js
│   ├── movimientoInventario.model.js
│   └── precio.model.js
├── usuarios/                # Acceso al sistema
│   ├── usuario.model.js
│   └── cliente.model.js
└── ventas/                  # Proceso de venta
    ├── carrito.model.js
    ├── carritoItem.model.js
    ├── cotizacion.model.js
    ├── detalleCotizacion.model.js
    ├── factura.model.js
    ├── detalleFactura.model.js
    ├── pago.model.js
    └── medioPago.model.js

controllers/
├── core/
│   ├── categoria.controller.js
│   ├── marca.controller.js
│   └── presentacion.controller.js
├── productos/
│   └── producto.controller.js
├── inventario/
│   └── inventario.controller.js
├── usuarios/
│   ├── usuario.controller.js
│   └── auth.controller.js
└── ventas/
    ├── carrito.controller.js
    ├── cotizacion.controller.js
    └── factura.controller.js

routes/
├── index.js (centraliza todas las rutas)
├── core.routes.js
├── productos.routes.js
├── inventario.routes.js
├── usuarios.routes.js
└── ventas.routes.js