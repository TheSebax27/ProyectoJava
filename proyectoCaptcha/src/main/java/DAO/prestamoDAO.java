/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import DTO.prestamoDTO;
import Model.conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author DELL
 */
public class prestamoDAO {
     public boolean crearPrestamo(prestamoDTO prestamo) {
        String sql = "INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_devolucion, devuelto) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, prestamo.getIdUsuario());
            ps.setInt(2, prestamo.getIdLibro());
            ps.setDate(3, prestamo.getFechaPrestamo());
            ps.setDate(4, prestamo.getFechaDevolucion());
            ps.setBoolean(5, prestamo.isDevuelto());
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al crear préstamo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Obtener todos los préstamos con información detallada
     * @return List<PrestamoDTO> lista de préstamos
     */
    public List<prestamoDTO> obtenerTodosPrestamos() {
        List<prestamoDTO> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre as nombre_usuario, l.titulo as titulo_libro, l.autor as autor_libro " +
                     "FROM prestamos p " +
                     "INNER JOIN usuarios u ON p.id_usuario = u.id " +
                     "INNER JOIN libros l ON p.id_libro = l.id " +
                     "ORDER BY p.fecha_prestamo DESC";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                prestamoDTO prestamo = mapearResultSetAPrestamo(rs);
                prestamos.add(prestamo);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener préstamos: " + e.getMessage());
            e.printStackTrace();
        }
        
        return prestamos;
    }
    
    /**
     * Obtener préstamo por ID
     * @param id ID del préstamo
     * @return PrestamoDTO préstamo encontrado o null
     */
    public prestamoDTO obtenerPrestamoPorId(int id) {
        String sql = "SELECT p.*, u.nombre as nombre_usuario, l.titulo as titulo_libro, l.autor as autor_libro " +
                     "FROM prestamos p " +
                     "INNER JOIN usuarios u ON p.id_usuario = u.id " +
                     "INNER JOIN libros l ON p.id_libro = l.id " +
                     "WHERE p.id = ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearResultSetAPrestamo(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener préstamo por ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
  
    public List<prestamoDTO> obtenerPrestamosPorUsuario(int idUsuario) {
        List<prestamoDTO> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre as nombre_usuario, l.titulo as titulo_libro, l.autor as autor_libro " +
                     "FROM prestamos p " +
                     "INNER JOIN usuarios u ON p.id_usuario = u.id " +
                     "INNER JOIN libros l ON p.id_libro = l.id " +
                     "WHERE p.id_usuario = ? " +
                     "ORDER BY p.fecha_prestamo DESC";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    prestamoDTO prestamo = mapearResultSetAPrestamo(rs);
                    prestamos.add(prestamo);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener préstamos por usuario: " + e.getMessage());
            e.printStackTrace();
        }
        
        return prestamos;
    }
  
    public List<prestamoDTO> obtenerPrestamosActivos() {
        List<prestamoDTO> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre as nombre_usuario, l.titulo as titulo_libro, l.autor as autor_libro " +
                     "FROM prestamos p " +
                     "INNER JOIN usuarios u ON p.id_usuario = u.id " +
                     "INNER JOIN libros l ON p.id_libro = l.id " +
                     "WHERE p.devuelto = 0 " +
                     "ORDER BY p.fecha_prestamo DESC";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                prestamoDTO prestamo = mapearResultSetAPrestamo(rs);
                prestamos.add(prestamo);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener préstamos activos: " + e.getMessage());
            e.printStackTrace();
        }
        
        return prestamos;
    }
 
    public boolean marcarComoDevuelto(int idPrestamo, Date fechaDevolucion) {
        String sql = "UPDATE prestamos SET devuelto = 1, fecha_devolucion = ? WHERE id = ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setDate(1, fechaDevolucion);
            ps.setInt(2, idPrestamo);
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al marcar como devuelto: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
  
    public boolean libroEstaPrestado(int idLibro) {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE id_libro = ? AND devuelto = 0";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idLibro);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al verificar si libro está prestado: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
 
    public List<prestamoDTO> obtenerPrestamosVencidos() {
        List<prestamoDTO> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre as nombre_usuario, l.titulo as titulo_libro, l.autor as autor_libro " +
                     "FROM prestamos p " +
                     "INNER JOIN usuarios u ON p.id_usuario = u.id " +
                     "INNER JOIN libros l ON p.id_libro = l.id " +
                     "WHERE p.devuelto = 0 AND p.fecha_devolucion < CURDATE() " +
                     "ORDER BY p.fecha_devolucion ASC";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                prestamoDTO prestamo = mapearResultSetAPrestamo(rs);
                prestamos.add(prestamo);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener préstamos vencidos: " + e.getMessage());
            e.printStackTrace();
        }
        
        return prestamos;
    }
    
  
    public boolean eliminarPrestamo(int id) {
        String sql = "DELETE FROM prestamos WHERE id = ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar préstamo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
 
    public String[] obtenerEstadisticasPrestamos() {
        String[] estadisticas = new String[4];
        
        try (Connection con = conexion.getNuevaConexion()) {
            
            // Total de préstamos
            String sqlTotal = "SELECT COUNT(*) FROM prestamos";
            try (PreparedStatement ps = con.prepareStatement(sqlTotal);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    estadisticas[0] = String.valueOf(rs.getInt(1));
                }
            }
            
            
            String sqlActivos = "SELECT COUNT(*) FROM prestamos WHERE devuelto = 0";
            try (PreparedStatement ps = con.prepareStatement(sqlActivos);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    estadisticas[1] = String.valueOf(rs.getInt(1));
                }
            }
            
            
            String sqlDevueltos = "SELECT COUNT(*) FROM prestamos WHERE devuelto = 1";
            try (PreparedStatement ps = con.prepareStatement(sqlDevueltos);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    estadisticas[2] = String.valueOf(rs.getInt(1));
                }
            }
            
            
            String sqlVencidos = "SELECT COUNT(*) FROM prestamos WHERE devuelto = 0 AND fecha_devolucion < CURDATE()";
            try (PreparedStatement ps = con.prepareStatement(sqlVencidos);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    estadisticas[3] = String.valueOf(rs.getInt(1));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener estadísticas: " + e.getMessage());
            e.printStackTrace();
        }
        
        return estadisticas;
    }
    
  
    public List<prestamoDTO> obtenerPrestamosPorFecha(Date fechaInicio, Date fechaFin) {
        List<prestamoDTO> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre as nombre_usuario, l.titulo as titulo_libro, l.autor as autor_libro " +
                     "FROM prestamos p " +
                     "INNER JOIN usuarios u ON p.id_usuario = u.id " +
                     "INNER JOIN libros l ON p.id_libro = l.id " +
                     "WHERE p.fecha_prestamo BETWEEN ? AND ? " +
                     "ORDER BY p.fecha_prestamo DESC";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setDate(1, fechaInicio);
            ps.setDate(2, fechaFin);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    prestamoDTO prestamo = mapearResultSetAPrestamo(rs);
                    prestamos.add(prestamo);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener préstamos por fecha: " + e.getMessage());
            e.printStackTrace();
        }
        
        return prestamos;
    }
    
  
    public int contarPrestamosPorUsuario(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE id_usuario = ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al contar préstamos por usuario: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
   
    public List<Object[]> obtenerLibrosMasPrestados(int limite) {
        List<Object[]> resultado = new ArrayList<>();
        String sql = "SELECT l.id, l.titulo, COUNT(p.id) as total_prestamos " +
                     "FROM libros l " +
                     "LEFT JOIN prestamos p ON l.id = p.id_libro " +
                     "GROUP BY l.id, l.titulo " +
                     "ORDER BY total_prestamos DESC " +
                     "LIMIT ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, limite);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Object[] fila = {
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getInt("total_prestamos")
                    };
                    resultado.add(fila);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener libros más prestados: " + e.getMessage());
            e.printStackTrace();
        }
        
        return resultado;
    }
    
  
    public boolean usuarioTienePrestamosActivos(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE id_usuario = ? AND devuelto = 0";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al verificar préstamos activos: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
  
    public boolean actualizarFechaDevolucion(int idPrestamo, Date nuevaFecha) {
        String sql = "UPDATE prestamos SET fecha_devolucion = ? WHERE id = ? AND devuelto = 0";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setDate(1, nuevaFecha);
            ps.setInt(2, idPrestamo);
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar fecha de devolución: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Método auxiliar para mapear ResultSet a PrestamoDTO
     * @param rs ResultSet de la consulta
     * @return PrestamoDTO objeto préstamo
     * @throws SQLException si hay error en el mapeo
     */
    private prestamoDTO mapearResultSetAPrestamo(ResultSet rs) throws SQLException {
        prestamoDTO prestamo = new prestamoDTO();
        prestamo.setId(rs.getInt("id"));
        prestamo.setIdUsuario(rs.getInt("id_usuario"));
        prestamo.setIdLibro(rs.getInt("id_libro"));
        prestamo.setFechaPrestamo(rs.getDate("fecha_prestamo"));
        prestamo.setFechaDevolucion(rs.getDate("fecha_devolucion"));
        prestamo.setDevuelto(rs.getBoolean("devuelto"));
        
        // Información adicional si está disponible
        try {
            prestamo.setNombreUsuario(rs.getString("nombre_usuario"));
            prestamo.setTituloLibro(rs.getString("titulo_libro"));
            prestamo.setAutorLibro(rs.getString("autor_libro"));
        } catch (SQLException e) {
            // Los campos adicionales no están presentes en esta consulta
        }
        
        return prestamo;
    }
}
