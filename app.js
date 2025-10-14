const express = require('express');
require('dotenv').config();  
const sequelize = require('./db/db');  
const productoRoutes = require('./routes/producto.routes');  

const app = express();


app.use(express.json());


app.use('/', productoRoutes);  
 


sequelize.sync()
  .then(() => {
    // Iniciar el servidor cuando la base de datos esté conectada
    app.listen(5000, () => {
      console.log('Servidor corriendo en http://localhost:5000');
      console.log('Base de datos conectada');
    });
  })
  .catch((err) => {
    console.error('Error al conectar la base de datos', err);
  });

