
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const DetalleRecepcion = db.define('DetalleRecepcion', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    recepcion_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'recepciones',
            key: 'id'
        }
    },
    detalle_orden_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'detalle_orden_compra',
            key: 'id'
        }
    },
    cantidad_recibida: {
        type: DataTypes.INTEGER,
        allowNull: false,
        validate: {
            min: 1
        }
    },
    observaciones: {
        type: DataTypes.STRING(255),
        allowNull: true
    }
}, {
    tableName: 'detalle_recepciones',
    timestamps: false
});

module.exports = DetalleRecepcion;