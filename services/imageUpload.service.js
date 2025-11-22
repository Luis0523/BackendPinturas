const { bucket } = require('../config/firebase.config');
const multer = require('multer');
const path = require('path');

// Configuración de Multer para almacenamiento en memoria
const storage = multer.memoryStorage();

// Filtro para aceptar solo imágenes
const fileFilter = (req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];

  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Tipo de archivo no permitido. Solo se permiten imágenes (JPEG, PNG, GIF, WEBP)'), false);
  }
};

// Configuración de Multer
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024 // Límite de 5MB
  }
});

/**
 * Sube una imagen a Firebase Storage
 * @param {Object} file - Archivo de Multer (req.file)
 * @param {string} folder - Carpeta en Firebase Storage (ejemplo: 'productos')
 * @returns {Promise<string>} - URL pública de la imagen subida
 */
const uploadImageToFirebase = async (file, folder = 'productos') => {
  try {
    if (!file) {
      throw new Error('No se proporcionó ningún archivo');
    }

    // Generar nombre único para el archivo
    const timestamp = Date.now();
    const extension = path.extname(file.originalname);
    const filename = `${folder}/${timestamp}${extension}`;

    // Crear referencia al archivo en Firebase Storage
    const fileUpload = bucket.file(filename);

    // Crear stream de escritura
    const stream = fileUpload.createWriteStream({
      metadata: {
        contentType: file.mimetype,
        metadata: {
          firebaseStorageDownloadTokens: timestamp
        }
      },
      resumable: false
    });

    // Promesa para manejar la subida
    return new Promise((resolve, reject) => {
      stream.on('error', (error) => {
        reject(new Error(`Error al subir imagen: ${error.message}`));
      });

      stream.on('finish', async () => {
        try {
          // Hacer el archivo público
          await fileUpload.makePublic();

          // Obtener la URL pública
          const publicUrl = `https://storage.googleapis.com/${bucket.name}/${filename}`;

          resolve(publicUrl);
        } catch (error) {
          reject(new Error(`Error al generar URL pública: ${error.message}`));
        }
      });

      // Escribir el buffer del archivo al stream
      stream.end(file.buffer);
    });
  } catch (error) {
    throw new Error(`Error en uploadImageToFirebase: ${error.message}`);
  }
};

/**
 * Elimina una imagen de Firebase Storage
 * @param {string} imageUrl - URL de la imagen a eliminar
 * @returns {Promise<boolean>} - true si se eliminó correctamente
 */
const deleteImageFromFirebase = async (imageUrl) => {
  try {
    if (!imageUrl) {
      return false;
    }

    // Extraer el nombre del archivo de la URL
    // URL formato: https://storage.googleapis.com/bucket-name/folder/filename.ext
    const urlParts = imageUrl.split(`https://storage.googleapis.com/${bucket.name}/`);

    if (urlParts.length < 2) {
      throw new Error('URL de imagen inválida');
    }

    const filename = urlParts[1];

    // Eliminar el archivo
    await bucket.file(filename).delete();

    return true;
  } catch (error) {
    console.error('Error al eliminar imagen:', error.message);
    // No lanzamos error para no bloquear otras operaciones
    return false;
  }
};

module.exports = {
  upload,
  uploadImageToFirebase,
  deleteImageFromFirebase
};
