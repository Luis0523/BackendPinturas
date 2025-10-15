// models/usuarios/cliente.model.js
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Cliente = db.define('Cliente', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(150),
        allowNull: false
    },
    nit: {
        type: DataTypes.STRING(25),
        unique: true,
        allowNull: true
    },
    email: {
        type: DataTypes.STRING(150),
        unique: true,
        allowNull: true,
        validate: {
            isEmail: true
        }
    },
    password_hash: {
        type: DataTypes.STRING(255),
        allowNull: true
    },
    opt_in_promos: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
    },
    verificado: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
    },
    telefono: {
        type: DataTypes.STRING(30),
        allowNull: true
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
    }
}, {
    tableName: 'clientes',
    timestamps: true,
    createdAt: 'creado_en',
    updatedAt: false
});

module.exports = Cliente;