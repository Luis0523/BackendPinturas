// models/usuarios/usuario.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Usuario = db.define('Usuario', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(120),
        allowNull: false
    },
    dpi: {
        type: DataTypes.STRING(20),
        unique: true,
        allowNull: false
    },
    email: {
        type: DataTypes.STRING(150),
        unique: true,
        allowNull: false,
        validate: {
            isEmail: true
        }
    },
    password_hash: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    rol_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    sucursal_id: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    activo: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
    tableName: 'usuarios',
    timestamps: true,
    createdAt: 'creado_en',
    updatedAt: false
});

module.exports = Usuario;