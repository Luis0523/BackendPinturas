const express = require('express');
require('dotenv').config();
const { sequelize } = require('./models/index');  // Las relaciones ya se ejecutan automáticamente


//const sucursalRoutes = require('./routes/sucursal.route');

const rutasindex = require('./routes/index');
const app = express();

app.use(express.json());

// Rutas
app.use('', rutasindex);
//app.use('/api', presentacionRoutes);
//app.use('/api', rolesRoutes);
//app.use('/api', sucursalRoutes);

// Sincronización de la base de datos
sequelize.sync({ alter: false })
    .then(() => {
        app.listen(5000, () => {
            console.log('🚀 Servidor corriendo en http://localhost:5000');
            console.log('✅ Base de datos conectada');
        });
    })
    .catch((err) => {
        console.error('❌ Error al conectar la base de datos:', err);
    });

// Middleware de manejo de errores
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ 
        success: false, 
        message: 'Error en el servidor',
        error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
});