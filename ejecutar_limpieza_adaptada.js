// Script de limpieza adaptado a las tablas existentes
require('dotenv').config();
const db = require('./db/db');

async function tablaExiste(nombreTabla) {
    try {
        await db.query(`SELECT 1 FROM ${nombreTabla} LIMIT 1`);
        return true;
    } catch (error) {
        return false;
    }
}

async function limpiarTabla(nombreTabla) {
    try {
        const existe = await tablaExiste(nombreTabla);
        if (!existe) {
            console.log(`   ⊘ ${nombreTabla}: no existe, omitiendo`);
            return { limpiada: false, registrosAntes: 0 };
        }

        // Contar registros antes
        const [countBefore] = await db.query(`SELECT COUNT(*) as total FROM ${nombreTabla}`);
        const registrosAntes = countBefore[0].total;

        // Limpiar
        await db.query(`SET FOREIGN_KEY_CHECKS = 0`);
        await db.query(`TRUNCATE TABLE ${nombreTabla}`);
        await db.query(`SET FOREIGN_KEY_CHECKS = 1`);

        console.log(`   ✅ ${nombreTabla}: ${registrosAntes} registros eliminados`);
        return { limpiada: true, registrosAntes };

    } catch (error) {
        console.log(`   ❌ ${nombreTabla}: error - ${error.message}`);
        return { limpiada: false, registrosAntes: 0, error: error.message };
    }
}

async function main() {
    try {
        console.log('🔄 Conectando a la base de datos...\n');
        await db.authenticate();
        console.log('✅ Conexión establecida\n');

        console.log('═══════════════════════════════════════════════════════');
        console.log('  VERIFICANDO BACKUP EXISTENTE');
        console.log('═══════════════════════════════════════════════════════\n');

        const [backupTables] = await db.query("SHOW TABLES LIKE 'backup_%'");
        if (backupTables.length > 0) {
            console.log(`✅ ${backupTables.length} tablas de backup encontradas:`);
            for (const row of backupTables) {
                const tableName = Object.values(row)[0];
                const [count] = await db.query(`SELECT COUNT(*) as total FROM ${tableName}`);
                console.log(`   📦 ${tableName}: ${count[0].total} registros respaldados`);
            }
        } else {
            console.log('⚠️  No se encontraron tablas de backup');
            console.log('   Se recomienda hacer backup primero, pero continuaremos...\n');
        }

        console.log('\n═══════════════════════════════════════════════════════');
        console.log('  LIMPIANDO TABLAS (en orden correcto)');
        console.log('═══════════════════════════════════════════════════════\n');

        // Orden correcto para evitar problemas de llaves foráneas
        const tablasParaLimpiar = [
            // Primero las tablas dependientes
            'detalle_recepciones',
            'detallerecepcion',
            'recepciones',
            'detalleordencompra',
            'ordenescompra',
            'ordenes_compra',
            'movimientosinventario',
            'movimientos_inventario',
            'inventariosucursal',
            'inventario_sucursal',
            'precios',
            'productopresentacion',
            'producto_presentacion',
            // Finalmente los productos
            'productos'
        ];

        let totalLimpiadas = 0;
        let totalRegistrosEliminados = 0;

        await db.query(`SET FOREIGN_KEY_CHECKS = 0`);

        for (const tabla of tablasParaLimpiar) {
            const resultado = await limpiarTabla(tabla);
            if (resultado.limpiada) {
                totalLimpiadas++;
                totalRegistrosEliminados += resultado.registrosAntes;
            }
        }

        await db.query(`SET FOREIGN_KEY_CHECKS = 1`);

        console.log('\n═══════════════════════════════════════════════════════');
        console.log('  VERIFICACIÓN FINAL');
        console.log('═══════════════════════════════════════════════════════\n');

        // Verificar tablas principales
        const tablasVerificar = [
            'productos',
            'productopresentacion',
            'producto_presentacion',
            'precios',
            'inventariosucursal',
            'inventario_sucursal'
        ];

        console.log('📊 Estado de tablas principales:\n');
        for (const tabla of tablasVerificar) {
            if (await tablaExiste(tabla)) {
                const [count] = await db.query(`SELECT COUNT(*) as total FROM ${tabla}`);
                const total = count[0].total;
                const icon = total === 0 ? '✅' : '⚠️';
                console.log(`   ${icon} ${tabla}: ${total} registros`);
            }
        }

        console.log('\n📊 Datos conservados (NO eliminados):\n');
        const tablasConservadas = [
            'categorias',
            'marcas',
            'presentaciones',
            'sucursales',
            'proveedores',
            'usuarios',
            'clientes'
        ];

        for (const tabla of tablasConservadas) {
            if (await tablaExiste(tabla)) {
                const [count] = await db.query(`SELECT COUNT(*) as total FROM ${tabla}`);
                console.log(`   ✅ ${tabla}: ${count[0].total} registros`);
            }
        }

        console.log('\n═══════════════════════════════════════════════════════');
        console.log('  ✅ LIMPIEZA COMPLETADA EXITOSAMENTE');
        console.log('═══════════════════════════════════════════════════════\n');

        console.log('📊 Resumen:');
        console.log(`   ✅ ${totalLimpiadas} tablas limpiadas`);
        console.log(`   ✅ ${totalRegistrosEliminados} registros eliminados en total`);
        if (backupTables.length > 0) {
            console.log(`   ✅ Backup disponible en ${backupTables.length} tablas backup_*`);
        }
        console.log('   ✅ Categorías, marcas y sucursales conservadas\n');

        console.log('🚀 Próximos pasos:');
        console.log('   1. Reinicia el backend (si está corriendo)');
        console.log('   2. Recarga el frontend (Ctrl+F5)');
        console.log('   3. Crea tus nuevos productos\n');

        process.exit(0);

    } catch (error) {
        console.error('\n❌ ERROR CRÍTICO:', error.message);
        console.error(error);
        if (backupTables && backupTables.length > 0) {
            console.log('\n🔄 Tienes backup disponible en las tablas backup_*');
        }
        process.exit(1);
    }
}

main();
