/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Connection;
import java.sql.*;

/**
 *
 * @author DELL
 */
public class conexion {

    private static final String URL = "jdbc:mysql://localhost:3306/adso_biblioteca";
    private static final String USUARIO = "root";
    private static final String CONTRASENA = "";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private static Connection conexion = null;

    public static Connection getConexion() {
        try {
            Class.forName(DRIVER);

            conexion = DriverManager.getConnection(URL, USUARIO, CONTRASENA);
            System.out.println("conexion establecida correctamente");
        } catch (ClassNotFoundException e) {
            System.err.println("error no se encontro el dirver");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("error no se encontro el dirver");
            e.printStackTrace();
        }
        return conexion;
    }

    public static void cerrarConexion() {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
                System.out.println("Conexión cerrada exitosamente");
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar la conexión");
            e.printStackTrace();
        }
    }

    public static boolean isConectado() {
        try {
            return conexion != null && !conexion.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }

    public static Connection getNuevaConexion() {
        try {
            Class.forName(DRIVER);
            return DriverManager.getConnection(URL, USUARIO, CONTRASENA);
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error al crear nueva conexión");
            e.printStackTrace();
            return null;
        }
    }

    public static void probarConexion() {
        Connection con = getConexion();
        if (con != null) {
            System.out.println("¡Conexión exitosa a la base de datos adso_biblioteca!");
            cerrarConexion();
        } else {
            System.out.println("Error: No se pudo conectar a la base de datos");
        }
    }
}
