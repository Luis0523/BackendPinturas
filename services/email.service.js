

const nodemailer = require('nodemailer');


const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD
    }
});


const enviarEmailConfirmacionPedido = async (pedido) => {
    try {
        
        if (!process.env.EMAIL_USER || !process.env.EMAIL_PASSWORD) {
            console.warn('⚠️ Credenciales de email no configuradas. Email no enviado.');
            return { success: false, message: 'Credenciales de email no configuradas' };
        }

        
        let productosHTML = '';
        if (pedido.detalles && pedido.detalles.length > 0) {
            pedido.detalles.forEach(detalle => {
                const nombreProducto = detalle.productoPresentacion?.producto?.nombre || 'Producto';
                const presentacion = detalle.productoPresentacion?.presentacion?.nombre || '';
                productosHTML += `
                    <tr>
                        <td style="padding: 10px; border-bottom: 1px solid #eee;">
                            <strong>${nombreProducto}</strong><br>
                            <small style="color: #666;">${presentacion}</small>
                        </td>
                        <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: center;">
                            ${detalle.cantidad}
                        </td>
                        <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: right;">
                            Q. ${parseFloat(detalle.precio_unitario).toFixed(2)}
                        </td>
                        <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: right;">
                            <strong>Q. ${parseFloat(detalle.subtotal).toFixed(2)}</strong>
                        </td>
                    </tr>
                `;
            });
        }

        
        const htmlTemplate = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Confirmación de Pedido</title>
        </head>
        <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
            <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f4f4f4; padding: 20px;">
                <tr>
                    <td align="center">
                        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">

                            <!-- HEADER -->
                            <tr>
                                <td style="background: linear-gradient(135deg, #EF4444 0%, #DC2626 100%); padding: 30px; text-align: center;">
                                    <h1 style="color: #ffffff; margin: 0; font-size: 28px;">
                                        🎨 Pinturas Premium
                                    </h1>
                                    <p style="color: #ffffff; margin: 10px 0 0 0; font-size: 16px;">
                                        ¡Gracias por tu pedido!
                                    </p>
                                </td>
                            </tr>

                            <!-- CONTENIDO -->
                            <tr>
                                <td style="padding: 30px;">

                                    <!-- CONFIRMACIÓN -->
                                    <div style="background-color: #10B981; color: #ffffff; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 30px;">
                                        <h2 style="margin: 0; font-size: 24px;">✓ Pedido Confirmado</h2>
                                        <p style="margin: 10px 0 0 0; font-size: 18px;">
                                            Pedido #${pedido.numero}
                                        </p>
                                    </div>

                                    <!-- SALUDO -->
                                    <p style="color: #333; font-size: 16px; line-height: 1.5;">
                                        Hola <strong>${pedido.nombre_cliente}</strong>,
                                    </p>
                                    <p style="color: #333; font-size: 16px; line-height: 1.5;">
                                        Hemos recibido tu pedido correctamente y lo estamos procesando.
                                        A continuación encontrarás los detalles:
                                    </p>

                                    <!-- DETALLES DEL PEDIDO -->
                                    <h3 style="color: #EF4444; border-bottom: 2px solid #EF4444; padding-bottom: 10px; margin-top: 30px;">
                                        📦 Detalles del Pedido
                                    </h3>

                                    <table width="100%" cellpadding="0" cellspacing="0" style="margin: 20px 0;">
                                        <thead>
                                            <tr style="background-color: #f8f9fa;">
                                                <th style="padding: 10px; text-align: left; color: #666; font-size: 14px;">Producto</th>
                                                <th style="padding: 10px; text-align: center; color: #666; font-size: 14px;">Cant.</th>
                                                <th style="padding: 10px; text-align: right; color: #666; font-size: 14px;">Precio</th>
                                                <th style="padding: 10px; text-align: right; color: #666; font-size: 14px;">Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            ${productosHTML}
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <td colspan="3" style="padding: 15px 10px 5px 10px; text-align: right; color: #666;">
                                                    Subtotal:
                                                </td>
                                                <td style="padding: 15px 10px 5px 10px; text-align: right;">
                                                    Q. ${parseFloat(pedido.subtotal).toFixed(2)}
                                                </td>
                                            </tr>
                                            ${pedido.descuento_total > 0 ? `
                                            <tr>
                                                <td colspan="3" style="padding: 5px 10px; text-align: right; color: #10B981;">
                                                    Descuento:
                                                </td>
                                                <td style="padding: 5px 10px; text-align: right; color: #10B981;">
                                                    -Q. ${parseFloat(pedido.descuento_total).toFixed(2)}
                                                </td>
                                            </tr>
                                            ` : ''}
                                            <tr>
                                                <td colspan="3" style="padding: 10px; text-align: right; font-size: 18px; font-weight: bold; color: #EF4444; border-top: 2px solid #eee;">
                                                    TOTAL:
                                                </td>
                                                <td style="padding: 10px; text-align: right; font-size: 18px; font-weight: bold; color: #EF4444; border-top: 2px solid #eee;">
                                                    Q. ${parseFloat(pedido.total).toFixed(2)}
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>

                                    <!-- DIRECCIÓN DE ENVÍO -->
                                    <h3 style="color: #EF4444; border-bottom: 2px solid #EF4444; padding-bottom: 10px; margin-top: 30px;">
                                        🚚 Dirección de Envío
                                    </h3>
                                    <div style="background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin: 15px 0;">
                                        <p style="margin: 5px 0; color: #333;">
                                            <strong>${pedido.direccion_envio}</strong>
                                        </p>
                                        <p style="margin: 5px 0; color: #666;">
                                            ${pedido.ciudad_envio}, ${pedido.departamento_envio}
                                        </p>
                                        ${pedido.codigo_postal ? `
                                        <p style="margin: 5px 0; color: #666;">
                                            Código postal: ${pedido.codigo_postal}
                                        </p>
                                        ` : ''}
                                        ${pedido.referencias_direccion ? `
                                        <p style="margin: 5px 0; color: #666;">
                                            <em>Referencias: ${pedido.referencias_direccion}</em>
                                        </p>
                                        ` : ''}
                                    </div>

                                    <!-- SIGUIENTES PASOS -->
                                    <h3 style="color: #EF4444; border-bottom: 2px solid #EF4444; padding-bottom: 10px; margin-top: 30px;">
                                        📋 Siguientes Pasos
                                    </h3>
                                    <ol style="color: #333; line-height: 1.8;">
                                        <li>Nuestro equipo te contactará para confirmar la dirección de envío</li>
                                        <li>Te enviaremos la información bancaria para realizar el pago</li>
                                        <li>Una vez confirmado el pago, prepararemos tu pedido</li>
                                        <li>Te notificaremos cuando tu pedido esté en camino</li>
                                    </ol>

                                    <!-- CONTACTO -->
                                    <div style="background-color: #EFF6FF; border-left: 4px solid #3B82F6; padding: 15px; margin: 30px 0; border-radius: 4px;">
                                        <p style="margin: 0; color: #333; font-size: 14px;">
                                            <strong>¿Tienes alguna pregunta?</strong><br>
                                            Contáctanos por WhatsApp: <a href="https://wa.me/50232013122" style="color: #10B981;">+502 3201-3122</a><br>
                                            O escríbenos a: <a href="mailto:info@pinturaspremium.com" style="color: #3B82F6;">info@pinturaspremium.com</a>
                                        </p>
                                    </div>

                                    <p style="color: #666; font-size: 14px; line-height: 1.5; margin-top: 30px;">
                                        Gracias por confiar en nosotros,<br>
                                        <strong style="color: #EF4444;">Equipo de Pinturas Premium</strong>
                                    </p>

                                </td>
                            </tr>

                            <!-- FOOTER -->
                            <tr>
                                <td style="background-color: #f8f9fa; padding: 20px; text-align: center; border-top: 1px solid #eee;">
                                    <p style="margin: 0; color: #999; font-size: 12px;">
                                        © 2025 Pinturas Premium. Todos los derechos reservados.<br>
                                        Este es un correo automático, por favor no respondas a este mensaje.
                                    </p>
                                </td>
                            </tr>

                        </table>
                    </td>
                </tr>
            </table>
        </body>
        </html>
        `;

        
        const mailOptions = {
            from: `"Pinturas Premium" <${process.env.EMAIL_USER}>`,
            to: pedido.email_cliente,
            subject: `✓ Pedido Confirmado #${pedido.numero} - Pinturas Premium`,
            html: htmlTemplate
        };

        
        const info = await transporter.sendMail(mailOptions);

        console.log('✅ Email enviado:', info.messageId);
        return {
            success: true,
            messageId: info.messageId,
            message: 'Email enviado correctamente'
        };

    } catch (error) {
        console.error('❌ Error al enviar email:', error);
        return {
            success: false,
            message: error.message
        };
    }
};


const enviarEmailNotificacionAdmin = async (pedido) => {
    try {
        
        if (!process.env.EMAIL_USER || !process.env.EMAIL_PASSWORD || !process.env.EMAIL_ADMIN) {
            console.warn('⚠️ Credenciales de email no configuradas. Notificación admin no enviada.');
            return { success: false, message: 'Credenciales de email no configuradas' };
        }

        
        const htmlTemplate = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Nuevo Pedido</title>
        </head>
        <body style="font-family: Arial, sans-serif; padding: 20px;">
            <h2 style="color: #EF4444;">🔔 Nuevo Pedido Recibido</h2>

            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin: 20px 0;">
                <p><strong>Pedido:</strong> #${pedido.numero}</p>
                <p><strong>Cliente:</strong> ${pedido.nombre_cliente}</p>
                <p><strong>Email:</strong> ${pedido.email_cliente}</p>
                <p><strong>Teléfono:</strong> ${pedido.telefono_cliente}</p>
                <p><strong>Total:</strong> Q. ${parseFloat(pedido.total).toFixed(2)}</p>
                <p><strong>Dirección:</strong> ${pedido.direccion_envio}, ${pedido.ciudad_envio}, ${pedido.departamento_envio}</p>
            </div>

            <p style="color: #666;">
                <a href="http://localhost:5500/views/ventas/pedidos.html" style="background-color: #EF4444; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; display: inline-block;">
                    Ver Pedido en el Sistema
                </a>
            </p>
        </body>
        </html>
        `;

        const mailOptions = {
            from: `"Sistema Pinturas Premium" <${process.env.EMAIL_USER}>`,
            to: process.env.EMAIL_ADMIN,
            subject: `🔔 Nuevo Pedido #${pedido.numero} - Acción Requerida`,
            html: htmlTemplate
        };

        const info = await transporter.sendMail(mailOptions);

        console.log('✅ Notificación admin enviada:', info.messageId);
        return {
            success: true,
            messageId: info.messageId
        };

    } catch (error) {
        console.error('❌ Error al enviar notificación admin:', error);
        return {
            success: false,
            message: error.message
        };
    }
};

module.exports = {
    enviarEmailConfirmacionPedido,
    enviarEmailNotificacionAdmin
};
