// models/ventas/factura.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Factura = db.define('Factura', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    numero: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    serie: {
        type: DataTypes.STRING(10),
        allowNull: false,
        defaultValue: 'A'
    },
    fecha_emision: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    cliente_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'clientes',
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
    sucursal_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'sucursales',
            key: 'id'
        }
    },
    subtotal: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
        validate: {
            min: 0
        }
    },
    descuento_total: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
        validate: {
            min: 0
        }
    },
    total: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
        validate: {
            min: 0
        }
    },
    estado: {
        type: DataTypes.ENUM('EMITIDA', 'ANULADA'),
        allowNull: false,
        defaultValue: 'EMITIDA'
    },
    anulada_por: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: 'usuarios',
            key: 'id'
        }
    },
    anulada_fecha: {
        type: DataTypes.DATE,
        allowNull: true
    },
    motivo_anulacion: {
        type: DataTypes.STRING(255),
        allowNull: true
    }
}, {
    tableName: 'facturas',
    timestamps: false,
    indexes: [
        {
            unique: true,
            fields: ['numero', 'serie'],
            name: 'unique_factura'
        }
    ]
});

module.exports = Factura;