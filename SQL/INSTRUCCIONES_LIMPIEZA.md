# 📋 Instrucciones para Limpieza de Productos e Inventario

## ⚠️ IMPORTANTE - Lee antes de ejecutar

Esta limpieza eliminará datos de forma permanente. Sigue estos pasos **EN ORDEN**.

---

## 🎯 Opciones Disponibles

### Opción 1: Limpieza Completa (Recomendada para empezar de cero)
**Archivo:** `LIMPIEZA_COMPLETA_PRODUCTOS.sql`

**Elimina:**
- ✅ Productos
- ✅ Presentaciones de productos
- ✅ Precios
- ✅ Inventario de todas las sucursales
- ✅ Movimientos de inventario
- ✅ Órdenes de compra
- ✅ Recepciones de compras

**Conserva:**
- ✅ Sucursales
- ✅ Categorías
- ✅ Marcas
- ✅ Presentaciones (Galón, Cuarto, etc.)
- ✅ Proveedores
- ✅ Usuarios
- ✅ Clientes

---

### Opción 2: Limpieza Solo Productos (Conservador)
**Archivo:** `LIMPIEZA_SOLO_PRODUCTOS.sql`

**Elimina:**
- ✅ Productos
- ✅ Presentaciones de productos
- ✅ Precios actuales
- ✅ Inventario actual

**Conserva:**
- ✅ Todo lo de la Opción 1
- ✅ **Historial de órdenes de compra** (para auditoría)
- ✅ **Historial de recepciones** (para auditoría)
- ✅ **Movimientos de inventario** (para trazabilidad)

---

## 📝 Pasos para Ejecutar la Limpieza

### PASO 1: Hacer Backup (OBLIGATORIO)

```bash
# En tu terminal de MySQL o cliente de BD:
mysql -u root -p pinturas < /ruta/completa/BACKUP_ANTES_DE_LIMPIAR.sql
```

**Esto crea tablas temporales con todos tus datos actuales.**

---

### PASO 2: Verificar el Backup

```sql
-- Ejecuta esto para verificar que el backup se creó:
SHOW TABLES LIKE 'backup_%';

-- Deberías ver tablas como:
-- backup_productos
-- backup_inventariosucursal
-- backup_precios
-- etc.
```

---

### PASO 3: Ejecutar la Limpieza

**Opción A - Limpieza Completa:**
```bash
mysql -u root -p pinturas < /ruta/completa/LIMPIEZA_COMPLETA_PRODUCTOS.sql
```

**Opción B - Limpieza Conservadora:**
```bash
mysql -u root -p pinturas < /ruta/completa/LIMPIEZA_SOLO_PRODUCTOS.sql
```

---

### PASO 4: Verificar la Limpieza

El script mostrará automáticamente:
- ✅ Cantidad de registros eliminados (debe ser 0)
- ✅ Datos conservados (categorías, marcas, etc.)

---

## 🔄 Si Necesitas Restaurar

**Solo si algo salió mal y necesitas volver atrás:**

```sql
-- Descomenta y ejecuta el bloque de restauración
-- que está al final de BACKUP_ANTES_DE_LIMPIAR.sql
```

---

## 🚀 Después de la Limpieza

1. **Reinicia el servidor backend:**
   ```bash
   cd /home/lufi/Programacion/PlataformaPinturas/backend
   npm start
   ```

2. **Recarga el frontend** (Ctrl+F5)

3. **Crea tus nuevos productos** - Ahora con todas las propiedades actualizadas

---

## 💡 Recomendación

**Usa la Opción 1 (LIMPIEZA_COMPLETA_PRODUCTOS.sql)** si:
- ✅ Estás en fase de pruebas
- ✅ No necesitas el historial de órdenes antiguas
- ✅ Quieres empezar completamente de cero

**Usa la Opción 2 (LIMPIEZA_SOLO_PRODUCTOS.sql)** si:
- ✅ Quieres conservar el historial para auditorías
- ✅ Solo necesitas limpiar productos actuales
- ✅ Tienes órdenes de compra que no quieres perder

---

## ⚠️ Checklist Final

Antes de ejecutar, verifica:
- [ ] Hice backup con BACKUP_ANTES_DE_LIMPIAR.sql
- [ ] Verifiqué que las tablas backup_* existen
- [ ] Sé qué script quiero ejecutar (Opción 1 o 2)
- [ ] Tengo acceso a MySQL con permisos suficientes
- [ ] El backend está detenido (opcional pero recomendado)

---

## 🆘 Soporte

Si algo sale mal:
1. NO entres en pánico
2. Tienes backup en las tablas backup_*
3. Ejecuta el bloque de restauración
4. Contacta al desarrollador si necesitas ayuda
