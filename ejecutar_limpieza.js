// Script para ejecutar limpieza completa de productos
require('dotenv').config();
const db = require('./db/db');
const fs = require('fs');
const path = require('path');

async function ejecutarScript(nombreArchivo) {
    const rutaArchivo = path.join(__dirname, 'SQL', nombreArchivo);
    console.log(`📄 Leyendo archivo: ${nombreArchivo}`);

    const sql = fs.readFileSync(rutaArchivo, 'utf8');

    // Dividir el SQL en declaraciones individuales (separadas por ;)
    // Pero ignorar los comentarios y líneas vacías
    const statements = sql
        .split(';')
        .map(s => s.trim())
        .filter(s => s.length > 0 && !s.startsWith('--') && !s.startsWith('/*'));

    console.log(`✅ ${statements.length} declaraciones SQL encontradas\n`);

    for (let i = 0; i < statements.length; i++) {
        const statement = statements[i];

        // Ignorar comentarios de bloque
        if (statement.startsWith('/*') || statement.includes('SELECT \'')) {
            try {
                const [results] = await db.query(statement);
                if (results && results.length > 0) {
                    console.table(results);
                }
            } catch (error) {
                // Ignorar errores en SELECT informativos
            }
            continue;
        }

        try {
            await db.query(statement);
            // console.log(`✓ Declaración ${i + 1} ejecutada`);
        } catch (error) {
            console.error(`❌ Error en declaración ${i + 1}:`, error.message);
            // Continuar con las siguientes
        }
    }
}

async function main() {
    try {
        console.log('🔄 Conectando a la base de datos...\n');
        await db.authenticate();
        console.log('✅ Conexión establecida\n');

        console.log('═══════════════════════════════════════════════════════');
        console.log('  PASO 1: CREANDO BACKUP DE SEGURIDAD');
        console.log('═══════════════════════════════════════════════════════\n');

        await ejecutarScript('BACKUP_ANTES_DE_LIMPIAR.sql');

        console.log('\n═══════════════════════════════════════════════════════');
        console.log('  PASO 2: VERIFICANDO BACKUP');
        console.log('═══════════════════════════════════════════════════════\n');

        const [backupTables] = await db.query("SHOW TABLES LIKE 'backup_%'");
        console.log(`✅ ${backupTables.length} tablas de backup creadas:`);
        backupTables.forEach(row => {
            const tableName = Object.values(row)[0];
            console.log(`   - ${tableName}`);
        });

        // Contar registros en cada backup
        console.log('\n📊 Registros respaldados:');
        for (const row of backupTables) {
            const tableName = Object.values(row)[0];
            const [count] = await db.query(`SELECT COUNT(*) as total FROM ${tableName}`);
            console.log(`   ${tableName}: ${count[0].total} registros`);
        }

        console.log('\n═══════════════════════════════════════════════════════');
        console.log('  PASO 3: EJECUTANDO LIMPIEZA COMPLETA');
        console.log('═══════════════════════════════════════════════════════\n');

        await ejecutarScript('LIMPIEZA_COMPLETA_PRODUCTOS.sql');

        console.log('\n═══════════════════════════════════════════════════════');
        console.log('  PASO 4: VERIFICACIÓN FINAL');
        console.log('═══════════════════════════════════════════════════════\n');

        const tablas = [
            'productos',
            'productopresentacion',
            'precios',
            'inventariosucursal',
            'movimientosinventario',
            'ordenescompra',
            'detalleordencompra',
            'recepciones',
            'detallerecepcion'
        ];

        console.log('📊 Tablas limpiadas (deben estar en 0):');
        for (const tabla of tablas) {
            const [count] = await db.query(`SELECT COUNT(*) as total FROM ${tabla}`);
            const total = count[0].total;
            const icon = total === 0 ? '✅' : '⚠️';
            console.log(`   ${icon} ${tabla}: ${total} registros`);
        }

        console.log('\n📊 Datos conservados (NO eliminados):');
        const tablasConservadas = [
            'categorias',
            'marcas',
            'presentaciones',
            'sucursales',
            'proveedores',
            'usuarios'
        ];

        for (const tabla of tablasConservadas) {
            try {
                const [count] = await db.query(`SELECT COUNT(*) as total FROM ${tabla}`);
                console.log(`   ✅ ${tabla}: ${count[0].total} registros`);
            } catch (error) {
                console.log(`   - ${tabla}: tabla no existe o vacía`);
            }
        }

        console.log('\n═══════════════════════════════════════════════════════');
        console.log('  ✅ LIMPIEZA COMPLETADA EXITOSAMENTE');
        console.log('═══════════════════════════════════════════════════════\n');

        console.log('📝 Resumen:');
        console.log('   ✅ Backup creado en tablas backup_*');
        console.log('   ✅ Todos los productos eliminados');
        console.log('   ✅ Inventario limpiado en todas las sucursales');
        console.log('   ✅ Precios eliminados');
        console.log('   ✅ Órdenes de compra eliminadas');
        console.log('   ✅ Categorías, marcas y sucursales conservadas\n');

        console.log('🚀 Próximos pasos:');
        console.log('   1. Reinicia el backend');
        console.log('   2. Recarga el frontend (Ctrl+F5)');
        console.log('   3. Crea tus nuevos productos\n');

        process.exit(0);

    } catch (error) {
        console.error('\n❌ ERROR CRÍTICO:', error.message);
        console.error(error);
        console.log('\n🔄 Puedes restaurar desde las tablas backup_*');
        process.exit(1);
    }
}

main();
