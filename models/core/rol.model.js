// models/core/rol.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Rol = db.define('Rol', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(30),
        unique: true,
        allowNull: false
    }
}, {
    tableName: 'roles',
    timestamps: false
});

module.exports = Rol;