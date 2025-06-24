/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.Random;
import javax.imageio.ImageIO;

/**
 *
 * @author DELL
 */
public class captchaGenerator {
    private static final String Caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
    private static final int LongitudCaptcha = 6;
    private static final int anchoImagen = 200;
    private static final int altoImagen = 80;
    private static final Random random = new Random();
    
    
      public static String generarTextoCaptcha() {
        StringBuilder texto = new StringBuilder();
        
        for (int i = 0; i < LongitudCaptcha; i++) {
            int indice = random.nextInt(Caracteres.length());
            texto.append(Caracteres.charAt(indice));
        }
        
        return texto.toString();
    }
       public static String generarImagenCaptcha(String texto) {
        try {
            // Crear imagen con fondo blanco
            BufferedImage imagen = new BufferedImage(anchoImagen, altoImagen, BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = imagen.createGraphics();
            
            // Configurar renderizado
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            
            // Fondo blanco
            g2d.setColor(Color.WHITE);
            g2d.fillRect(0, 0, anchoImagen,altoImagen);
            
            // Agregar líneas aleatorias de ruido
            agregarLineasRuido(g2d);
            
            // Dibujar el texto con caracteres aleatorios
            dibujarTexto(g2d, texto);
            
            g2d.dispose();
            
            // Convertir imagen a Base64
            return imagenABase64(imagen);
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
       private static void agregarLineasRuido(Graphics2D g2d) {
        // Dibujar entre 3 y 7 líneas aleatorias
        int numeroLineas = 3 + random.nextInt(5);
        
        for (int i = 0; i < numeroLineas; i++) {
            // Color aleatorio
            g2d.setColor(new Color(
                random.nextInt(100) + 100,  // R
                random.nextInt(100) + 100,  // G
                random.nextInt(100) + 100   // B
            ));
            
            // Coordenadas aleatorias
            int x1 = random.nextInt(anchoImagen);
            int y1 = random.nextInt(altoImagen);
            int x2 = random.nextInt(anchoImagen);
            int y2 = random.nextInt(altoImagen);
            
            g2d.drawLine(x1, y1, x2, y2);
        }
    }
    
    /**
     * Dibuja el texto del CAPTCHA con efectos aleatorios
     * @param g2d Graphics2D para dibujar
     * @param texto Texto a dibujar
     */
    private static void dibujarTexto(Graphics2D g2d, String texto) {
        // Configurar fuente
        Font fuente = new Font("Arial", Font.BOLD, 32);
        g2d.setFont(fuente);
        
        // Calcular espaciado entre caracteres
        int espaciado = anchoImagen / (texto.length() + 1);
        
        for (int i = 0; i < texto.length(); i++) {
            char caracter = texto.charAt(i);
            
            // Color aleatorio para cada caracter
            g2d.setColor(new Color(
                random.nextInt(100),        // R (más oscuro)
                random.nextInt(100),        // G
                random.nextInt(100)         // B
            ));
            
            // Posición con pequeña variación aleatoria
            int x = espaciado * (i + 1) + random.nextInt(10) - 5;
            int y = altoImagen / 2 + random.nextInt(10) - 5;
            
            // Rotar el caracter ligeramente
            double angulo = Math.toRadians(random.nextInt(30) - 15);
            g2d.rotate(angulo, x, y);
            
            // Dibujar el caracter
            g2d.drawString(String.valueOf(caracter), x, y);
            
            // Restaurar rotación
            g2d.rotate(-angulo, x, y);
        }
    }
    
    /**
     * Convierte una imagen a formato Base64
     * @param imagen BufferedImage a convertir
     * @return String imagen en Base64
     * @throws IOException si hay error en la conversión
     */
    private static String imagenABase64(BufferedImage imagen) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(imagen, "png", baos);
        byte[] datosImagen = baos.toByteArray();
        return "data:image/png;base64," + Base64.getEncoder().encodeToString(datosImagen);
    }
    
    /**
     * Valida si el texto ingresado coincide con el CAPTCHA real
     * @param textoIngresado Texto que ingresó el usuario
     * @param textoReal Texto real del CAPTCHA
     * @return boolean true si coinciden (ignorando mayúsculas/minúsculas)
     */
    public static boolean validarCaptcha(String textoIngresado, String textoReal) {
        if (textoIngresado == null || textoReal == null) {
            return false;
        }
        
        return textoIngresado.trim().equalsIgnoreCase(textoReal.trim());
    }
    
    /**
     * Método para generar un CAPTCHA completo (texto e imagen)
     * @return String[] array con [0] = texto, [1] = imagen en Base64
     */
    public static String[] generarCaptchaCompleto() {
        String texto = generarTextoCaptcha();
        String imagen = generarImagenCaptcha(texto);
        return new String[]{texto, imagen};
    }
}
