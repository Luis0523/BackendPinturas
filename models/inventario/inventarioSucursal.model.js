// models/inventario/inventarioSucursal.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const InventarioSucursal = db.define('InventarioSucursal', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    sucursal_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'sucursales',
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
    existencia: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
        validate: {
            min: 0
        }
    },
    minimo: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
        validate: {
            min: 0
        }
    }
}, {
    tableName: 'inventariosucursal',
    timestamps: false,
    indexes: [
        {
            unique: true,
            fields: ['sucursal_id', 'producto_presentacion_id'],
            name: 'unique_sucursal_producto'
        }
    ]
});

module.exports = InventarioSucursal;