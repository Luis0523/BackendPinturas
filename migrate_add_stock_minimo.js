// Script de migración: Agregar campo stock_minimo a tabla precios
require('dotenv').config();
const db = require('./db/db');

async function runMigration() {
    try {
        console.log('🔄 Iniciando migración: Agregar stock_minimo a precios...');

        // Verificar conexión
        await db.authenticate();
        console.log('✅ Conexión a la base de datos establecida');

        // Verificar si la columna ya existe
        const [results] = await db.query(`
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'precios'
              AND COLUMN_NAME = 'stock_minimo'
        `);

        if (results.length > 0) {
            console.log('⚠️  La columna stock_minimo ya existe en la tabla precios');
            process.exit(0);
        }

        // Agregar la columna
        console.log('📝 Agregando columna stock_minimo...');
        await db.query(`
            ALTER TABLE precios
            ADD COLUMN stock_minimo INT DEFAULT 0
            COMMENT 'Stock mínimo configurado para esta presentación en esta sucursal'
        `);
        console.log('✅ Columna stock_minimo agregada exitosamente');

        // Intentar agregar constraint (puede fallar en versiones antiguas de MySQL)
        try {
            await db.query(`
                ALTER TABLE precios
                ADD CONSTRAINT chk_stock_minimo CHECK (stock_minimo >= 0)
            `);
            console.log('✅ Constraint de validación agregado');
        } catch (error) {
            console.log('⚠️  No se pudo agregar constraint (versión de MySQL antigua)');
        }

        // Verificar resultado
        const [verification] = await db.query(`
            SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'precios'
              AND COLUMN_NAME = 'stock_minimo'
        `);

        console.log('\n📊 Resultado de la migración:');
        console.table(verification);

        console.log('\n✅ Migración completada exitosamente');
        process.exit(0);

    } catch (error) {
        console.error('❌ Error en la migración:', error.message);
        console.error(error);
        process.exit(1);
    }
}

runMigration();
