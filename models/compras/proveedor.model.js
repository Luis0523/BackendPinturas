
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Proveedor = db.define('Proveedor', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombre: {
        type: DataTypes.STRING(150),
        allowNull: false,
        validate: {
            notEmpty: {
                msg: 'El nombre es obligatorio'
            },
            len: {
                args: [3, 150],
                msg: 'El nombre debe tener entre 3 y 150 caracteres'
            }
        }
    },
    razon_social: {
        type: DataTypes.STRING(200),
        allowNull: true
    },
    nit: {
        type: DataTypes.STRING(20),
        allowNull: true
    },
    telefono: {
        type: DataTypes.STRING(20),
        allowNull: true
    },
    email: {
        type: DataTypes.STRING(100),
        allowNull: true,
        validate: {
            isEmail: {
                msg: 'Debe ser un email válido'
            }
        }
    },
    direccion: {
        type: DataTypes.STRING(255),
        allowNull: true
    },
    contacto_principal: {
        type: DataTypes.STRING(100),
        allowNull: true
    },
    activo: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
    tableName: 'proveedores',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at'
});

module.exports = Proveedor;