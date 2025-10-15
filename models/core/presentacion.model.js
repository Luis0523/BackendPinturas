// models/core/presentacion.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Presentacion = db.define('Presentacion', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(40),
        unique: true,
        allowNull: false
    },
    unidad_base: {
        type: DataTypes.STRING(20),
        allowNull: true
    },
    factor_galon: {
        type: DataTypes.DECIMAL(10, 5),
        allowNull: true,
        comment: 'Factor de conversión a galones'
    },
    activo: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
    tableName: 'presentaciones',
    timestamps: false
});

module.exports = Presentacion;