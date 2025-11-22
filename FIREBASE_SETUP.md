# Configuración de Firebase Storage para Imágenes de Productos

## Pasos para configurar Firebase

### 1. Obtener las credenciales de Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a **Project Settings** (Configuración del proyecto) > **Service Accounts** (Cuentas de servicio)
4. Haz clic en **Generate New Private Key** (Generar nueva clave privada)
5. Se descargará un archivo JSON con tus credenciales

### 2. Configurar las variables de entorno

Abre el archivo `.env` en la raíz del backend y completa las siguientes variables con los datos del archivo JSON descargado:

```env
FIREBASE_PROJECT_ID=tu-project-id
FIREBASE_PRIVATE_KEY_ID=tu-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nTU_PRIVATE_KEY_AQUI\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=tu-service-account@tu-proyecto.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=tu-client-id
FIREBASE_CLIENT_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/tu-service-account%40tu-proyecto.iam.gserviceaccount.com
FIREBASE_STORAGE_BUCKET=tu-bucket-name.appspot.com
```

**Importante:** La `FIREBASE_PRIVATE_KEY` debe estar entre comillas dobles y mantener los saltos de línea como `\n`.

### 3. Ejecutar la migración de base de datos

Para agregar el campo `imagen_url` a la tabla de productos, ejecuta:

```bash
mysql -u root -p pinturas < SQL/add_imagen_url_to_productos.sql
```

O copia y pega el contenido del archivo en tu cliente MySQL.

## Uso de los endpoints

### Subir imagen a un producto

**Endpoint:** `POST /api/productos/:id/imagen`

**Headers:**
- `Content-Type: multipart/form-data`

**Body (form-data):**
- `imagen`: Archivo de imagen (JPEG, PNG, GIF, WEBP)

**Restricciones:**
- Tamaño máximo: 5MB
- Tipos permitidos: image/jpeg, image/jpg, image/png, image/gif, image/webp

**Ejemplo con cURL:**
```bash
curl -X POST http://localhost:5000/api/productos/1/imagen \
  -F "imagen=@/ruta/a/tu/imagen.jpg"
```

**Ejemplo con JavaScript (fetch):**
```javascript
const formData = new FormData();
formData.append('imagen', archivoImagen); // archivoImagen es un File object

const response = await fetch('http://localhost:5000/api/productos/1/imagen', {
  method: 'POST',
  body: formData
});

const data = await response.json();
console.log(data);
```

**Respuesta exitosa:**
```json
{
  "success": true,
  "message": "Imagen subida exitosamente",
  "data": {
    "id": 1,
    "codigo_sku": "ABC-123",
    "descripcion": "Pintura Blanca",
    "imagen_url": "https://storage.googleapis.com/tu-bucket/productos/1637012345678.jpg",
    ...
  }
}
```

### Eliminar imagen de un producto

**Endpoint:** `DELETE /api/productos/:id/imagen`

**Ejemplo con cURL:**
```bash
curl -X DELETE http://localhost:5000/api/productos/1/imagen
```

**Respuesta exitosa:**
```json
{
  "success": true,
  "message": "Imagen eliminada exitosamente",
  "data": {
    "id": 1,
    "codigo_sku": "ABC-123",
    "descripcion": "Pintura Blanca",
    "imagen_url": null,
    ...
  }
}
```

## Estructura de archivos creados

```
backend/
├── config/
│   └── firebase.config.js          # Configuración de Firebase Admin SDK
├── services/
│   └── imageUpload.service.js      # Servicio para subir/eliminar imágenes
├── controllers/
│   └── producto.controller.js      # Métodos: uploadProductoImagen, deleteProductoImagen
├── routes/
│   └── productos.routes.js         # Rutas: POST /:id/imagen, DELETE /:id/imagen
├── models/
│   └── productos/
│       └── producto.model.js       # Modelo actualizado con campo imagen_url
├── SQL/
│   └── add_imagen_url_to_productos.sql  # Migración de base de datos
└── .env                            # Variables de entorno de Firebase
```

## Notas importantes

1. **Seguridad:** Las credenciales de Firebase están en el archivo `.env`. Asegúrate de que este archivo esté en `.gitignore` y nunca lo subas a un repositorio público.

2. **Permisos del bucket:** El bucket de Firebase Storage debe tener permisos públicos de lectura configurados, o bien puedes generar URLs firmadas (esto requeriría modificar el código).

3. **Reemplazo de imágenes:** Si subes una nueva imagen a un producto que ya tiene una, la imagen anterior se eliminará automáticamente de Firebase Storage.

4. **Manejo de errores:** Todos los endpoints manejan errores de forma adecuada. Si hay un problema con Firebase, el servidor devolverá un error 500 con detalles del problema.

5. **Validación:** El servicio valida que solo se suban imágenes (no otros tipos de archivo) y que no excedan el tamaño máximo de 5MB.

## Troubleshooting

### Error: "Firebase Admin SDK not initialized"
- Verifica que todas las variables de entorno en `.env` estén correctamente configuradas
- Asegúrate de que `FIREBASE_PRIVATE_KEY` tenga el formato correcto con `\n` para los saltos de línea

### Error: "Permission denied"
- Verifica que el bucket de Storage tenga los permisos correctos configurados en Firebase Console
- Asegúrate de que la cuenta de servicio tenga los roles necesarios (Storage Admin)

### Error: "File too large"
- El tamaño máximo permitido es 5MB. Puedes modificar este límite en `services/imageUpload.service.js`
