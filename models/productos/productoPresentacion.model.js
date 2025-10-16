// models/productos/productoPresentacion.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const ProductoPresentacion = db.define('ProductoPresentacion', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    producto_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'productos',
            key: 'id'
        }
    },
    presentacion_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'presentaciones',
            key: 'id'
        }
    },
    activo: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
    tableName: 'productopresentacion',
    timestamps: false,
    indexes: [
        {
            unique: true,
            fields: ['producto_id', 'presentacion_id'],
            name: 'unique_producto_presentacion'
        }
    ]
});

module.exports = ProductoPresentacion;