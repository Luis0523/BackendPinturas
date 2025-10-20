// models/compras/detalleOrdenCompra.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const DetalleOrdenCompra = db.define('DetalleOrdenCompra', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    orden_compra_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'ordenes_compra',
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
    descuento_pct: {
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
    },
    cantidad_recibida: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
        validate: {
            min: 0
        }
    }
}, {
    tableName: 'detalle_orden_compra',
    timestamps: false
});

module.exports = DetalleOrdenCompra;