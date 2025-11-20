
const { DataTypes } = require('sequelize');
const db = require('../../db/db');

const Pedido = db.define('Pedido', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    numero: {
        type: DataTypes.INTEGER,
        allowNull: false,
        comment: 'Número correlativo del pedido'
    },
    fecha_pedido: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    
    cliente_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: 'clientes',
            key: 'id'
        },
        comment: 'ID del cliente si está registrado'
    },
    
    nombre_cliente: {
        type: DataTypes.STRING(120),
        allowNull: false,
        comment: 'Nombre completo del comprador'
    },
    email_cliente: {
        type: DataTypes.STRING(80),
        allowNull: false,
        comment: 'Email para notificaciones'
    },
    telefono_cliente: {
        type: DataTypes.STRING(20),
        allowNull: false,
        comment: 'Teléfono de contacto'
    },
    nit_cliente: {
        type: DataTypes.STRING(20),
        allowNull: true,
        defaultValue: 'CF',
        comment: 'NIT del cliente para facturación'
    },
    
    direccion_envio: {
        type: DataTypes.TEXT,
        allowNull: false,
        comment: 'Dirección completa de entrega'
    },
    ciudad_envio: {
        type: DataTypes.STRING(80),
        allowNull: false
    },
    departamento_envio: {
        type: DataTypes.STRING(80),
        allowNull: false
    },
    codigo_postal: {
        type: DataTypes.STRING(10),
        allowNull: true
    },
    referencias_direccion: {
        type: DataTypes.TEXT,
        allowNull: true,
        comment: 'Referencias adicionales para encontrar la dirección'
    },
    
    sucursal_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'sucursales',
            key: 'id'
        },
        comment: 'Sucursal desde donde se enviará'
    },
    
    subtotal: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
        validate: {
            min: 0
        }
    },
    descuento_total: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
        validate: {
            min: 0
        }
    },
    total: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
        validate: {
            min: 0
        }
    },
    
    estado: {
        type: DataTypes.ENUM('PENDIENTE', 'CONFIRMADO', 'EN_PREPARACION', 'ENVIADO', 'ENTREGADO', 'CANCELADO'),
        allowNull: false,
        defaultValue: 'PENDIENTE',
        comment: 'Estado actual del pedido'
    },
    estado_pago: {
        type: DataTypes.ENUM('PENDIENTE', 'PAGADO', 'RECHAZADO', 'REEMBOLSADO'),
        allowNull: false,
        defaultValue: 'PENDIENTE'
    },
    
    factura_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: 'facturas',
            key: 'id'
        },
        comment: 'Factura generada cuando se confirma el pedido'
    },
    
    cancelado_fecha: {
        type: DataTypes.DATE,
        allowNull: true
    },
    motivo_cancelacion: {
        type: DataTypes.TEXT,
        allowNull: true
    },
    
    notas_cliente: {
        type: DataTypes.TEXT,
        allowNull: true,
        comment: 'Notas o instrucciones del cliente'
    },
    notas_internas: {
        type: DataTypes.TEXT,
        allowNull: true,
        comment: 'Notas internas del personal'
    }
}, {
    tableName: 'pedidos',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    indexes: [
        {
            unique: true,
            fields: ['numero'],
            name: 'unique_pedido_numero'
        },
        {
            fields: ['email_cliente'],
            name: 'idx_pedido_email'
        },
        {
            fields: ['estado'],
            name: 'idx_pedido_estado'
        },
        {
            fields: ['sucursal_id'],
            name: 'idx_pedido_sucursal'
        }
    ]
});

module.exports = Pedido;
