// models/compras/ordenCompra.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const OrdenCompra = db.define('OrdenCompra', {
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
        defaultValue: 'OC'
    },
    proveedor_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'proveedores',
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
    fecha_orden: {
        type: DataTypes.DATEONLY,
        allowNull: false
    },
    fecha_entrega_estimada: {
        type: DataTypes.DATEONLY,
        allowNull: true
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
        type: DataTypes.ENUM('PENDIENTE', 'PARCIAL', 'RECIBIDA', 'CANCELADA'),
        allowNull: false,
        defaultValue: 'PENDIENTE'
    },
    observaciones: {
        type: DataTypes.TEXT,
        allowNull: true
    }
}, {
    tableName: 'ordenes_compra',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
        {
            unique: true,
            fields: ['numero', 'serie'],
            name: 'unique_orden'
        }
    ]
});

module.exports = OrdenCompra;