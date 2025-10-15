// models/core/sucursal.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Sucursal = db.define('Sucursal', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(120),
        unique: true,
        allowNull: false
    },
    direccion: {
        type: DataTypes.STRING(255),
        allowNull: true
    },
    gps_lat: {
        type: DataTypes.DECIMAL(10, 6),
        allowNull: true
    },
    gps_lng: {
        type: DataTypes.DECIMAL(10, 6),
        allowNull: true
    },
    telefono: {
        type: DataTypes.STRING(30),
        allowNull: true
    },
    activa: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
    tableName: 'sucursales',
    timestamps: false
});

module.exports = Sucursal;