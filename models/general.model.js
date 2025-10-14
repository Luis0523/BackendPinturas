const { DataTypes } = require('sequelize');
const db = require('../db/db');

// ===== DEFINICIÓN DE MODELOS =====
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

// ===== RELACIONES (SE EJECUTAN INMEDIATAMENTE) =====
Categoria.hasMany(Producto, { 
    foreignKey: 'categoria_id',
    as: 'productos'
});

Producto.belongsTo(Categoria, { 
    foreignKey: 'categoria_id',
    as: 'categoria'
});

Marca.hasMany(Producto, { 
    foreignKey: 'marca_id',
    as: 'productos'
});

Producto.belongsTo(Marca, { 
    foreignKey: 'marca_id',
    as: 'marca'
});

// ===== EXPORTACIÓN =====
module.exports = { 
    Producto, 
    Categoria, 
    Marca,
    sequelize: db 
};