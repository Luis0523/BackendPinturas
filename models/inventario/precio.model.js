// models/inventario/precio.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Precio = db.define('Precio', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    producto_presentacion_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'productopresentacion',
            key: 'id'
        }
    },
    sucursal_id: {
        type: DataTypes.INTEGER,
        allowNull: true,  // NULL = precio global
        references: {
            model: 'sucursales',
            key: 'id'
        }
    },
    precio_venta: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        validate: {
            min: 0,
            isDecimal: true
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
    vigente_desde: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    vigente_hasta: {
        type: DataTypes.DATE,
        allowNull: true
    },
    activo: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
    tableName: 'precios',
    timestamps: false
});

module.exports = Precio;