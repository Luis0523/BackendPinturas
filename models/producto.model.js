// models/producto.model.js
const { DataTypes } = require('sequelize');
const db = require('../db/db');

const Producto = db.define('Producto', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    codigo_sku: {
        type: DataTypes.STRING(50),
        unique: true,
        allowNull: false
    },
    descripcion: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    tamano: {
        type: DataTypes.STRING(40),
        allowNull: true
    },
    duracion_anios: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    extension_m2: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    },
    color: {
        type: DataTypes.STRING(60),
        allowNull: true
    },
    activo: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    },
    categoria_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    marca_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    }
}, {
    tableName: 'productos',
    timestamps: true
});

module.exports = Producto;