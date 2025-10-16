// models/ventas/detalleFactura.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const DetalleFactura = db.define('DetalleFactura', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    factura_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'facturas',
            key: 'id'
        }
    },
    producto_presentacion_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'productopresentacion',
            key: 'id'
        }
    },
    cantidad: {
        type: DataTypes.INTEGER,
        allowNull: false,
        validate: {
            min: 1
        }
    },
    precio_unitario: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        validate: {
            min: 0
        }
    },
    descuento_pct_aplicado: {
        type: DataTypes.DECIMAL(5, 2),
        defaultValue: 0,
        validate: {
            min: 0,
            max: 100
        }
    },
    subtotal: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        validate: {
            min: 0
        }
    }
}, {
    tableName: 'detallefactura',
    timestamps: false
});

module.exports = DetalleFactura;