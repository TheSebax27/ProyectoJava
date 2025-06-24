/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import org.mindrot.jbcrypt.BCrypt;

import DTO.usuarioDTO;
import Model.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL
 */
public class usuarioDAO {

    public boolean crearUsuario(usuarioDTO usuario) {
        String sql = "INSERT INTO usuarios (nombre, documento, correo, telefono, contrasena, rol) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getDocumento());
            ps.setString(3, usuario.getCorreo());
            ps.setString(4, usuario.getTelefono());
            ps.setString(5, BCrypt.hashpw(usuario.getContrasena(), BCrypt.gensalt()));
            ps.setString(6, usuario.getRol());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.err.println("Error al crear usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }

    }

    public List<usuarioDTO> obtenerTodosUsuarios() {
        List<usuarioDTO> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY nombre";

        try (Connection con = conexion.getNuevaConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                usuarioDTO usuario = new usuarioDTO();
                usuario.setId(rs.getInt("id"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setDocumento(rs.getString("documento"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setRol(rs.getString("rol"));

                usuarios.add(usuario);
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener usuarios: " + e.getMessage());
            e.printStackTrace();
        }

        return usuarios;
    }

    public usuarioDTO obtenerUsuarioPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id = ?";

        try (Connection con = conexion.getNuevaConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuarioDTO usuario = new usuarioDTO();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setDocumento(rs.getString("documento"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setRol(rs.getString("rol"));

                    return usuario;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener usuario por ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    
    public boolean actualizarUsuario(usuarioDTO usuario) {
        String sql = "UPDATE usuarios SET nombre = ?, documento = ?, correo = ?, telefono = ?, rol = ? WHERE id = ?";

        try (Connection con = conexion.getNuevaConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getDocumento());
            ps.setString(3, usuario.getCorreo());
            ps.setString(4, usuario.getTelefono());
            ps.setString(5, usuario.getRol());
            ps.setInt(6, usuario.getId());

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarUsuario(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";

        try (Connection con = conexion.getNuevaConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

 
    public usuarioDTO validarCredenciales(String correo, String contrasena) {
        String sql = "SELECT * FROM usuarios WHERE correo = ?";

        try (Connection con = conexion.getNuevaConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            System.out.println("🔍 Consultando base de datos para: " + correo);
            ps.setString(1, correo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String contrasenaEncriptada = rs.getString("contrasena");
                    System.out.println("🔍 Usuario encontrado en BD, verificando contraseña");

                    if (BCrypt.checkpw(contrasena, contrasenaEncriptada)) {
                        System.out.println("✅ Contraseña válida");
                        usuarioDTO usuario = new usuarioDTO();
                        usuario.setId(rs.getInt("id"));
                        usuario.setNombre(rs.getString("nombre"));
                        usuario.setDocumento(rs.getString("documento"));
                        usuario.setCorreo(rs.getString("correo"));
                        usuario.setTelefono(rs.getString("telefono"));
                        usuario.setRol(rs.getString("rol"));

                        return usuario;
                    } else {
                        System.out.println("❌ Contraseña incorrecta");
                    }
                } else {
                    System.out.println("❌ Usuario no encontrado en BD");
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Error al validar credenciales en BD: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ Error general al validar credenciales: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("❌ Credenciales no válidas para: " + correo);
        return null;
    }

    /**
     * Verificar si existe un usuario con el correo dado
     *
     * @param correo Correo a verificar
     * @return boolean true si existe
     */
    public boolean existeCorreo(String correo) {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE correo = ?";

        try (Connection con = conexion.getNuevaConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al verificar correo: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Verificar si existe un usuario con el documento dado
     *
     * @param documento Documento a verificar
     * @return boolean true si existe
     */
    public boolean existeDocumento(String documento) {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE documento = ?";

        try (Connection con = conexion.getNuevaConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, documento);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al verificar documento: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Cambiar contraseña de usuario
     *
     * @param idUsuario ID del usuario
     * @param nuevaContrasena Nueva contraseña
     * @return boolean true si se cambió exitosamente
     */
    public boolean cambiarContrasena(int idUsuario, String nuevaContrasena) {
        String sql = "UPDATE usuarios SET contrasena = ? WHERE id = ?";

        try (Connection con = conexion.getNuevaConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, BCrypt.hashpw(nuevaContrasena, BCrypt.gensalt()));
            ps.setInt(2, idUsuario);

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al cambiar contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
