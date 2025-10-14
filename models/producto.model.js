// producto.model.js

const { DataTypes } = require('sequelize');
const db = require('../db/db'); // Archivo de conexión a la base de datos

/**
 * Definimos el modelo de Producto, con los campos necesarios para gestionar los productos en el inventario.
 */
const Producto = db.define('producto', {
    nombre: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    descripcion: {
        type: DataTypes.TEXT,
        allowNull: true
    },
    precio: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    stock: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0
    },
    categoria: {
        type: DataTypes.STRING(50),
        allowNull: false
    },
    // Otros campos que puedan ser relevantes, como imágenes, fechas, etc.
}, {
    tableName: 'productos',
    timestamps: true
});

module.exports = Producto;
