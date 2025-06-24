/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import DTO.libroDTO;
import Model.conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author DELL
 */
public class libroDAO {
     public boolean crearLibro(libroDTO libro) {
        String sql = "INSERT INTO libros (titulo, autor, editorial, anio, categoria, disponible) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, libro.getTitulo());
            ps.setString(2, libro.getAutor());
            ps.setString(3, libro.getEditorial());
            ps.setInt(4, libro.getAnio());
            ps.setString(5, libro.getCategoria());
            ps.setBoolean(6, libro.isDisponible());
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al crear libro: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Obtener todos los libros
     * @return List<LibroDTO> lista de libros
     */
    public List<libroDTO> obtenerTodosLibros() {
        List<libroDTO> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros ORDER BY titulo";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                libroDTO libro = mapearResultSetALibro(rs);
                libros.add(libro);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener libros: " + e.getMessage());
            e.printStackTrace();
        }
        
        return libros;
    }
    
  
    public libroDTO obtenerLibroPorId(int id) {
        String sql = "SELECT * FROM libros WHERE id = ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearResultSetALibro(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener libro por ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
   
    public boolean actualizarLibro(libroDTO libro) {
        String sql = "UPDATE libros SET titulo = ?, autor = ?, editorial = ?, anio = ?, categoria = ?, disponible = ? WHERE id = ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, libro.getTitulo());
            ps.setString(2, libro.getAutor());
            ps.setString(3, libro.getEditorial());
            ps.setInt(4, libro.getAnio());
            ps.setString(5, libro.getCategoria());
            ps.setBoolean(6, libro.isDisponible());
            ps.setInt(7, libro.getId());
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar libro: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
  
    public boolean eliminarLibro(int id) {
        String sql = "DELETE FROM libros WHERE id = ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar libro: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
  
    public List<libroDTO> buscarPorTitulo(String titulo) {
        List<libroDTO> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE titulo LIKE ? ORDER BY titulo";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, "%" + titulo + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    libroDTO libro = mapearResultSetALibro(rs);
                    libros.add(libro);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al buscar por título: " + e.getMessage());
            e.printStackTrace();
        }
        
        return libros;
    }
    

    public List<libroDTO> buscarPorAutor(String autor) {
        List<libroDTO> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE autor LIKE ? ORDER BY titulo";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, "%" + autor + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    libroDTO libro = mapearResultSetALibro(rs);
                    libros.add(libro);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al buscar por autor: " + e.getMessage());
            e.printStackTrace();
        }
        
        return libros;
    }
    
  
    public List<libroDTO> buscarPorCategoria(String categoria) {
        List<libroDTO> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE categoria LIKE ? ORDER BY titulo";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, "%" + categoria + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    libroDTO libro = mapearResultSetALibro(rs);
                    libros.add(libro);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al buscar por categoría: " + e.getMessage());
            e.printStackTrace();
        }
        
        return libros;
    }
    
   
    public List<libroDTO> obtenerLibrosDisponibles() {
        List<libroDTO> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE disponible = 1 ORDER BY titulo";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                libroDTO libro = mapearResultSetALibro(rs);
                libros.add(libro);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener libros disponibles: " + e.getMessage());
            e.printStackTrace();
        }
        
        return libros;
    }
    
    
    public boolean cambiarDisponibilidad(int idLibro, boolean disponible) {
        String sql = "UPDATE libros SET disponible = ? WHERE id = ?";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setBoolean(1, disponible);
            ps.setInt(2, idLibro);
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al cambiar disponibilidad: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
 
    public List<libroDTO> busquedaGeneral(String termino) {
        List<libroDTO> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE titulo LIKE ? OR autor LIKE ? OR categoria LIKE ? ORDER BY titulo";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String patron = "%" + termino + "%";
            ps.setString(1, patron);
            ps.setString(2, patron);
            ps.setString(3, patron);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    libroDTO libro = mapearResultSetALibro(rs);
                    libros.add(libro);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error en búsqueda general: " + e.getMessage());
            e.printStackTrace();
        }
        
        return libros;
    }
    

    public List<String> obtenerCategorias() {
        List<String> categorias = new ArrayList<>();
        String sql = "SELECT DISTINCT categoria FROM libros WHERE categoria IS NOT NULL ORDER BY categoria";
        
        try (Connection con = conexion.getNuevaConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categorias.add(rs.getString("categoria"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener categorías: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categorias;
    }
    

    private libroDTO mapearResultSetALibro(ResultSet rs) throws SQLException {
        libroDTO libro = new libroDTO();
        libro.setId(rs.getInt("id"));
        libro.setTitulo(rs.getString("titulo"));
        libro.setAutor(rs.getString("autor"));
        libro.setEditorial(rs.getString("editorial"));
        libro.setAnio(rs.getInt("anio"));
        libro.setCategoria(rs.getString("categoria"));
        libro.setDisponible(rs.getBoolean("disponible"));
        
        return libro;
    }
}
