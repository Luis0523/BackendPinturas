// models/ventas/pago.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Pago = db.define('Pago', {
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
    tipo: {
        type: DataTypes.ENUM('EFECTIVO', 'TARJETA_DEBITO', 'TARJETA_CREDITO', 'CHEQUE', 'TRANSFERENCIA', 'DEPOSITO'),
        allowNull: false
    },
    monto: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        validate: {
            min: 0.01
        }
    },
    referencia: {
        type: DataTypes.STRING(80),
        allowNull: true,
        comment: 'Número de cheque, voucher, etc.'
    },
    entidad: {
        type: DataTypes.STRING(80),
        allowNull: true,
        comment: 'Banco o procesador de pago'
    },
    transaccion_gateway_id: {
        type: DataTypes.STRING(80),
        allowNull: true,
        comment: 'ID de transacción del gateway'
    },
    autorizado_por: {
        type: DataTypes.STRING(120),
        allowNull: true,
        comment: 'Persona que autorizó el pago'
    }
}, {
    tableName: 'pagos',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false
});

module.exports = Pago;