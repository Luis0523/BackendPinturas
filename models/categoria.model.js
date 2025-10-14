// models/categoria.model.js
const { DataTypes } = require('sequelize');
const db = require('../db/db');

const Categoria = db.define('Categoria', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(60),
        unique: true,
        allowNull: false
    },
    descripcion: {
        type: DataTypes.STRING(255),
        allowNull: true
    }
}, {
    tableName: 'categorias',
    timestamps: false
});

module.exports = Categoria;