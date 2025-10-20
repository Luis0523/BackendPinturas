// models/compras/recepcion.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Recepcion = db.define('Recepcion', {
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
    sucursal_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'sucursales',
            key: 'id'
        }
    },
    usuario_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'usuarios',
            key: 'id'
        }
    },
    fecha_recepcion: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    observaciones: {
        type: DataTypes.TEXT,
        allowNull: true
    }
}, {
    tableName: 'recepciones',
    timestamps: false
});

module.exports = Recepcion;