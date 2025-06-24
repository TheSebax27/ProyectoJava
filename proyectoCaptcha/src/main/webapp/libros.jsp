<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.libroDTO"%>
<%@page import="DTO.usuarioDTO"%>
<%
    // Verificar que el usuario esté logueado
    usuarioDTO usuario = (usuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Obtener datos
    List<libroDTO> libros = (List<libroDTO>) request.getAttribute("libros");
    List<String> categorias = (List<String>) request.getAttribute("categorias");
    String terminoBusqueda = (String) request.getAttribute("terminoBusqueda");
    String tipoBusqueda = (String) request.getAttribute("tipoBusqueda");
    Integer totalLibros = (Integer) request.getAttribute("totalLibros");
    boolean esAdmin = "admin".equals(usuario.getRol());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Libros - Sistema de Biblioteca ADSO</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .page-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        
        .search-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .books-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .book-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 4px solid #007bff;
        }
        
        .book-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .book-card.available {
            border-left-color: #28a745;
        }
        
        .book-card.unavailable {
            border-left-color: #dc3545;
            opacity: 0.8;
        }
        
        .book-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .book-author {
            color: #6c757d;
            font-size: 1rem;
            margin-bottom: 10px;
        }
        
        .book-details {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .book-actions {
            margin-top: 15px;
        }
        
        .status-badge {
            font-size: 0.8rem;
            padding: 5px 10px;
            border-radius: 15px;
        }
        
        .btn-group-sm .btn {
            font-size: 0.8rem;
            padding: 5px 10px;
        }
        
        .stats-row {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .alert-custom {
            border: none;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
        }
        
        .btn-search {
            border-radius: 10px;
            padding: 12px 25px;
            font-weight: bold;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .book-card {
                padding: 15px;
            }
            
            .btn-group-sm .btn {
                font-size: 0.7rem;
                padding: 4px 8px;
                margin: 2px;
            }
            
            .book-actions {
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/<%= esAdmin ? "admin-dashboard" : "user-dashboard" %>">
                <i class="fas fa-book-open me-2"></i>
                Sistema de Biblioteca ADSO
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/<%= esAdmin ? "admin-dashboard" : "user-dashboard" %>">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <% if (esAdmin) { %>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/libros">
                                <i class="fas fa-book me-1"></i>Libros
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/usuarios">
                                <i class="fas fa-users me-1"></i>Usuarios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/prestamos">
                                <i class="fas fa-exchange-alt me-1"></i>Préstamos
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/libros-buscar">
                                <i class="fas fa-search me-1"></i>Buscar Libros
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/mis-prestamos">
                                <i class="fas fa-book-reader me-1"></i>Mis Préstamos
                            </a>
                        </li>
                    <% } %>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>
                            <%= session.getAttribute("nombreUsuario") %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil">
                                <i class="fas fa-user me-2"></i>Mi Perfil
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1 class="mb-2">
                        <i class="fas fa-books me-3"></i>
                        Gestión de Libros
                    </h1>
                    <p class="mb-0">Administra el catálogo de la biblioteca</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <% if (esAdmin) { %>
                        <a href="${pageContext.request.contextPath}/libro-nuevo" class="btn btn-light btn-lg">
                            <i class="fas fa-plus me-2"></i>
                            Agregar Libro
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Mensajes de éxito/error -->
        <% if (session.getAttribute("mensaje") != null) { %>
            <div class="alert alert-success alert-custom" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <%= session.getAttribute("mensaje") %>
                <% session.removeAttribute("mensaje"); %>
            </div>
        <% } %>
        
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-custom" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= session.getAttribute("error") %>
                <% session.removeAttribute("error"); %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-custom" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <!-- Estadísticas -->
        <% if (totalLibros != null) { %>
            <div class="stats-row">
                <div class="row text-center">
                    <div class="col-md-3">
                        <h3><i class="fas fa-book me-2"></i><%= totalLibros %></h3>
                        <p class="mb-0">Total de Libros</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-check-circle me-2"></i>
                            <% 
                                int disponibles = 0;
                                if (libros != null) {
                                    for (libroDTO libro : libros) {
                                        if (libro.isDisponible()) disponibles++;
                                    }
                                }
                            %>
                            <%= disponibles %>
                        </h3>
                        <p class="mb-0">Disponibles</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-times-circle me-2"></i><%= totalLibros - disponibles %></h3>
                        <p class="mb-0">No Disponibles</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-tags me-2"></i><%= categorias != null ? categorias.size() : 0 %></h3>
                        <p class="mb-0">Categorías</p>
                    </div>
                </div>
            </div>
        <% } %>
        
        <!-- Formulario de Búsqueda -->
        <div class="search-card">
            <h5 class="mb-4">
                <i class="fas fa-search me-2"></i>
                Buscar Libros
            </h5>
            
            <form method="post" action="${pageContext.request.contextPath}/libros-buscar">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="termino" class="form-label">Término de búsqueda</label>
                        <input type="text" 
                               class="form-control" 
                               id="termino" 
                               name="termino" 
                               placeholder="Ingresa título, autor o categoría..."
                               value="<%= terminoBusqueda != null ? terminoBusqueda : "" %>">
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <label for="tipo" class="form-label">Buscar por</label>
                        <select class="form-select" id="tipo" name="tipo">
                            <option value="general" <%= "general".equals(tipoBusqueda) ? "selected" : "" %>>Todo</option>
                            <option value="titulo" <%= "titulo".equals(tipoBusqueda) ? "selected" : "" %>>Título</option>
                            <option value="autor" <%= "autor".equals(tipoBusqueda) ? "selected" : "" %>>Autor</option>
                            <option value="categoria" <%= "categoria".equals(tipoBusqueda) ? "selected" : "" %>>Categoría</option>
                        </select>
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-search">
                                <i class="fas fa-search me-2"></i>
                                Buscar
                            </button>
                        </div>
                    </div>
                    
                    <div class="col-md-2 mb-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <a href="${pageContext.request.contextPath}/libros" class="btn btn-outline-secondary">
                                <i class="fas fa-refresh me-1"></i>
                                Limpiar
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Lista de Libros -->
        <div class="books-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="mb-0">
                    <i class="fas fa-list me-2"></i>
                    Catálogo de Libros
                    <% if (terminoBusqueda != null && !terminoBusqueda.trim().isEmpty()) { %>
                        <small class="text-muted">- Resultados para: "<%= terminoBusqueda %>"</small>
                    <% } %>
                </h5>
                
                <% if (esAdmin) { %>
                    <a href="${pageContext.request.contextPath}/libro-nuevo" class="btn btn-success">
                        <i class="fas fa-plus me-2"></i>
                        Nuevo Libro
                    </a>
                <% } %>
            </div>
            
            <% if (libros == null || libros.isEmpty()) { %>
                <!-- Estado vacío -->
                <div class="empty-state">
                    <i class="fas fa-book-open"></i>
                    <h4>No se encontraron libros</h4>
                    <% if (terminoBusqueda != null && !terminoBusqueda.trim().isEmpty()) { %>
                        <p class="text-muted">No hay libros que coincidan con tu búsqueda "<%= terminoBusqueda %>"</p>
                        <a href="${pageContext.request.contextPath}/libros" class="btn btn-primary">
                            <i class="fas fa-list me-2"></i>
                            Ver Todos los Libros
                        </a>
                    <% } else { %>
                        <p class="text-muted">Aún no hay libros registrados en el sistema</p>
                        <% if (esAdmin) { %>
                            <a href="${pageContext.request.contextPath}/libro-nuevo" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>
                                Agregar Primer Libro
                            </a>
                        <% } %>
                    <% } %>
                </div>
            <% } else { %>
                <!-- Lista de libros -->
                <div class="row">
                    <% for (libroDTO libro : libros) { %>
                        <div class="col-lg-6 col-xl-4 mb-4">
                            <div class="book-card <%= libro.isDisponible() ? "available" : "unavailable" %>">
                                <!-- Encabezado del libro -->
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="flex-grow-1">
                                        <div class="book-title"><%= libro.getTitulo() %></div>
                                        <div class="book-author">
                                            <i class="fas fa-user me-1"></i>
                                            <%= libro.getAutor() %>
                                        </div>
                                    </div>
                                    <span class="status-badge badge <%= libro.isDisponible() ? "bg-success" : "bg-danger" %>">
                                        <%= libro.isDisponible() ? "Disponible" : "No Disponible" %>
                                    </span>
                                </div>
                                
                                <!-- Detalles del libro -->
                                <div class="book-details">
                                    <% if (libro.getEditorial() != null && !libro.getEditorial().trim().isEmpty()) { %>
                                        <div class="mb-1">
                                            <i class="fas fa-building me-1"></i>
                                            <strong>Editorial:</strong> <%= libro.getEditorial() %>
                                        </div>
                                    <% } %>
                                    
                                    <% if (libro.getAnio() > 0) { %>
                                        <div class="mb-1">
                                            <i class="fas fa-calendar me-1"></i>
                                            <strong>Año:</strong> <%= libro.getAnio() %>
                                        </div>
                                    <% } %>
                                    
                                    <% if (libro.getCategoria() != null && !libro.getCategoria().trim().isEmpty()) { %>
                                        <div class="mb-1">
                                            <i class="fas fa-tag me-1"></i>
                                            <strong>Categoría:</strong> 
                                            <span class="badge bg-secondary"><%= libro.getCategoria() %></span>
                                        </div>
                                    <% } %>
                                    
                                    <div class="mb-1">
                                        <i class="fas fa-barcode me-1"></i>
                                        <strong>ID:</strong> #<%= libro.getId() %>
                                    </div>
                                </div>
                                
                                <!-- Acciones -->
                                <div class="book-actions">
                                    <% if (esAdmin) { %>
                                        <!-- Acciones de administrador -->
                                        <div class="btn-group btn-group-sm w-100" role="group">
                                            <a href="${pageContext.request.contextPath}/libro-editar?id=<%= libro.getId() %>" 
                                               class="btn btn-outline-primary"
                                               title="Editar libro">
                                                <i class="fas fa-edit"></i>
                                                <span class="d-none d-md-inline ms-1">Editar</span>
                                            </a>
                                            
                                            <% if (libro.isDisponible()) { %>
                                                <a href="${pageContext.request.contextPath}/prestamo-nuevo?libro=<%= libro.getId() %>" 
                                                   class="btn btn-outline-success"
                                                   title="Crear préstamo">
                                                    <i class="fas fa-handshake"></i>
                                                    <span class="d-none d-md-inline ms-1">Prestar</span>
                                                </a>
                                            <% } %>
                                            
                                            <button type="button" 
                                                    class="btn btn-outline-danger"
                                                    onclick="confirmarEliminacion(<%= libro.getId() %>, '<%= libro.getTitulo().replace("'", "\\'") %>')"
                                                    title="Eliminar libro">
                                                <i class="fas fa-trash"></i>
                                                <span class="d-none d-md-inline ms-1">Eliminar</span>
                                            </button>
                                        </div>
                                    <% } else { %>
                                        <!-- Acciones de usuario normal -->
                                        <% if (libro.isDisponible()) { %>
                                            <a href="${pageContext.request.contextPath}/prestamo-nuevo?libro=<%= libro.getId() %>" 
                                               class="btn btn-success btn-sm w-100">
                                                <i class="fas fa-plus me-2"></i>
                                                Solicitar Préstamo
                                            </a>
                                        <% } else { %>
                                            <button class="btn btn-secondary btn-sm w-100" disabled>
                                                <i class="fas fa-times me-2"></i>
                                                No Disponible
                                            </button>
                                        <% } %>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
    
    <!-- Modal de Confirmación de Eliminación -->
    <% if (esAdmin) { %>
        <div class="modal fade" id="confirmDeleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle text-danger me-2"></i>
                            Confirmar Eliminación
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>¿Estás seguro de que deseas eliminar el libro:</p>
                        <p class="fw-bold text-danger" id="bookToDelete"></p>
                        <p class="text-muted">Esta acción no se puede deshacer.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Cancelar
                        </button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                            <i class="fas fa-trash me-2"></i>Eliminar
                        </a>
                    </div>
                </div>
            </div>
        </div>
    <% } %>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        <% if (esAdmin) { %>
        // Función para confirmar eliminación
        function confirmarEliminacion(id, titulo) {
            document.getElementById('bookToDelete').textContent = titulo;
            document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/libro-eliminar?id=' + id;
            
            const modal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
            modal.show();
        }
        <% } %>
        
        // Animaciones de entrada
        document.addEventListener('DOMContentLoaded', function() {
            const bookCards = document.querySelectorAll('.book-card');
            bookCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
        
        // Funcionalidad de búsqueda en tiempo real
        const searchInput = document.getElementById('termino');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    this.closest('form').submit();
                }
            });
        }
        
        // Tooltip para botones pequeños
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
        const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    </script>
</body>
</html>