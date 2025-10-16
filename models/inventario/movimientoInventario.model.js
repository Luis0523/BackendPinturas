// models/inventario/movimientoInventario.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const MovimientoInventario = db.define('MovimientoInventario', {
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
    tipo: {
        type: DataTypes.STRING(20),
        allowNull: false,
        validate: {
            isIn: [['COMPRA', 'VENTA', 'AJUSTE', 'TRASLADO_ENTRADA', 'TRASLADO_SALIDA', 'DEVOLUCION']]
        }
    },
    cantidad: {
        type: DataTypes.INTEGER,
        allowNull: false,
        comment: 'Positivo = entrada, Negativo = salida'
    },
    referencia: {
        type: DataTypes.STRING(60),
        allowNull: true
    }
}, {
    tableName: 'movimientosinventario',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false
});

module.exports = MovimientoInventario;