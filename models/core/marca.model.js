// models/marca.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Marca = db.define('Marca', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(80),
        unique: true,
        allowNull: false
    }, 
    activa: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
    tableName: 'marcas',
    timestamps: false
});

module.exports = Marca;