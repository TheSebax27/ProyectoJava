<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.usuarioDTO"%>
<%
    // Verificar que el usuario esté logueado y sea admin
    usuarioDTO usuarioLogueado = (usuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !"admin".equals(usuarioLogueado.getRol())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Obtener datos
    List<usuarioDTO> usuarios = (List<usuarioDTO>) request.getAttribute("usuarios");
    Integer totalUsuarios = (Integer) request.getAttribute("totalUsuarios");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - Sistema de Biblioteca ADSO</title>
    
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
            background: linear-gradient(135deg, #17a2b8, #138496);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        
        .users-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .user-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 4px solid #17a2b8;
        }
        
        .user-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .user-card.admin {
            border-left-color: #dc3545;
        }
        
        .user-card.reader {
            border-left-color: #28a745;
        }
        
        .user-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .user-email {
            color: #6c757d;
            font-size: 1rem;
            margin-bottom: 10px;
        }
        
        .user-details {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .user-actions {
            margin-top: 15px;
        }
        
        .role-badge {
            font-size: 0.8rem;
            padding: 5px 12px;
            border-radius: 15px;
            font-weight: bold;
        }
        
        .badge-admin {
            background-color: #dc3545;
            color: white;
        }
        
        .badge-reader {
            background-color: #28a745;
            color: white;
        }
        
        .btn-group-sm .btn {
            font-size: 0.8rem;
            padding: 5px 10px;
        }
        
        .stats-row {
            background: linear-gradient(45deg, #17a2b8, #138496);
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
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        .search-box {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(45deg, #17a2b8, #138496);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            font-weight: bold;
            margin-right: 15px;
        }
        
        .avatar.admin {
            background: linear-gradient(45deg, #dc3545, #c82333);
        }
        
        .avatar.reader {
            background: linear-gradient(45deg, #28a745, #218838);
        }
        
        @media (max-width: 768px) {
            .user-card {
                padding: 15px;
            }
            
            .btn-group-sm .btn {
                font-size: 0.7rem;
                padding: 4px 8px;
                margin: 2px;
            }
            
            .user-actions {
                text-align: center;
            }
            
            .avatar {
                width: 40px;
                height: 40px;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin-dashboard">
                <i class="fas fa-book-open me-2"></i>
                Sistema de Biblioteca ADSO
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin-dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/libros">
                            <i class="fas fa-book me-1"></i>Libros
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/usuarios">
                            <i class="fas fa-users me-1"></i>Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/prestamos">
                            <i class="fas fa-exchange-alt me-1"></i>Préstamos
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-shield me-1"></i>
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
                        <i class="fas fa-users me-3"></i>
                        Gestión de Usuarios
                    </h1>
                    <p class="mb-0">Administra los usuarios del sistema</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="${pageContext.request.contextPath}/usuario-nuevo" class="btn btn-light btn-lg">
                        <i class="fas fa-user-plus me-2"></i>
                        Agregar Usuario
                    </a>
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
        <% if (totalUsuarios != null) { %>
            <div class="stats-row">
                <div class="row text-center">
                    <div class="col-md-3">
                        <h3><i class="fas fa-users me-2"></i><%= totalUsuarios %></h3>
                        <p class="mb-0">Total de Usuarios</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-user-shield me-2"></i>
                            <% 
                                int admins = 0;
                                if (usuarios != null) {
                                    for (usuarioDTO user : usuarios) {
                                        if ("admin".equals(user.getRol())) admins++;
                                    }
                                }
                            %>
                            <%= admins %>
                        </h3>
                        <p class="mb-0">Administradores</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-user me-2"></i><%= totalUsuarios - admins %></h3>
                        <p class="mb-0">Lectores</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-clock me-2"></i><%= new java.text.SimpleDateFormat("HH:mm").format(new java.util.Date()) %></h3>
                        <p class="mb-0">Hora Actual</p>
                    </div>
                </div>
            </div>
        <% } %>
        
        <!-- Búsqueda -->
        <div class="search-box">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-search"></i>
                        </span>
                        <input type="text" 
                               class="form-control" 
                               id="searchUsers" 
                               placeholder="Buscar usuarios por nombre, email o documento...">
                    </div>
                </div>
                <div class="col-md-4">
                    <select class="form-select" id="filterRole">
                        <option value="">Todos los usuarios</option>
                        <option value="admin">Solo Administradores</option>
                        <option value="lector">Solo Lectores</option>
                    </select>
                </div>
            </div>
        </div>
        
        <!-- Lista de Usuarios -->
        <div class="users-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="mb-0">
                    <i class="fas fa-list me-2"></i>
                    Lista de Usuarios
                </h5>
                
                <a href="${pageContext.request.contextPath}/usuario-nuevo" class="btn btn-success">
                    <i class="fas fa-user-plus me-2"></i>
                    Nuevo Usuario
                </a>
            </div>
            
            <% if (usuarios == null || usuarios.isEmpty()) { %>
                <!-- Estado vacío -->
                <div class="empty-state">
                    <i class="fas fa-users"></i>
                    <h4>No hay usuarios registrados</h4>
                    <p class="text-muted">Aún no hay usuarios en el sistema</p>
                    <a href="${pageContext.request.contextPath}/usuario-nuevo" class="btn btn-primary">
                        <i class="fas fa-user-plus me-2"></i>
                        Registrar Primer Usuario
                    </a>
                </div>
            <% } else { %>
                <!-- Lista de usuarios -->
                <div class="row" id="usersContainer">
                    <% for (usuarioDTO usuario : usuarios) { %>
                        <div class="col-lg-6 col-xl-4 mb-4 user-item" 
                             data-name="<%= usuario.getNombre().toLowerCase() %>"
                             data-email="<%= usuario.getCorreo().toLowerCase() %>"
                             data-document="<%= usuario.getDocumento() %>"
                             data-role="<%= usuario.getRol() %>">
                            <div class="user-card <%= usuario.getRol() %>">
                                <!-- Encabezado del usuario -->
                                <div class="d-flex align-items-center mb-3">
                                    <div class="avatar <%= usuario.getRol() %>">
                                        <%= usuario.getNombre().substring(0, 1).toUpperCase() %>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="user-name"><%= usuario.getNombre() %></div>
                                        <div class="user-email">
                                            <i class="fas fa-envelope me-1"></i>
                                            <%= usuario.getCorreo() %>
                                        </div>
                                    </div>
                                    <span class="role-badge badge-<%= usuario.getRol() %>">
                                        <%= "admin".equals(usuario.getRol()) ? "Administrador" : "Lector" %>
                                    </span>
                                </div>
                                
                                <!-- Detalles del usuario -->
                                <div class="user-details">
                                    <div class="mb-1">
                                        <i class="fas fa-id-card me-1"></i>
                                        <strong>Documento:</strong> <%= usuario.getDocumento() %>
                                    </div>
                                    
                                    <% if (usuario.getTelefono() != null && !usuario.getTelefono().trim().isEmpty()) { %>
                                        <div class="mb-1">
                                            <i class="fas fa-phone me-1"></i>
                                            <strong>Teléfono:</strong> <%= usuario.getTelefono() %>
                                        </div>
                                    <% } %>
                                    
                                    <div class="mb-1">
                                        <i class="fas fa-user-tag me-1"></i>
                                        <strong>Rol:</strong> <%= "admin".equals(usuario.getRol()) ? "Administrador" : "Lector" %>
                                    </div>
                                    
                                    <div class="mb-1">
                                        <i class="fas fa-hashtag me-1"></i>
                                        <strong>ID:</strong> #<%= usuario.getId() %>
                                    </div>
                                </div>
                                
                                <!-- Acciones -->
                                <div class="user-actions">
                                    <div class="btn-group btn-group-sm w-100" role="group">
                                        <a href="${pageContext.request.contextPath}/usuario-editar?id=<%= usuario.getId() %>" 
                                           class="btn btn-outline-primary"
                                           title="Editar usuario">
                                            <i class="fas fa-edit"></i>
                                            <span class="d-none d-md-inline ms-1">Editar</span>
                                        </a>
                                        
                                        <a href="${pageContext.request.contextPath}/prestamos?usuario=<%= usuario.getId() %>" 
                                           class="btn btn-outline-info"
                                           title="Ver préstamos">
                                            <i class="fas fa-book-reader"></i>
                                            <span class="d-none d-md-inline ms-1">Préstamos</span>
                                        </a>
                                        
                                        <% if (usuario.getId() != usuarioLogueado.getId()) { %>
                                            <button type="button" 
                                                    class="btn btn-outline-danger"
                                                    onclick="confirmarEliminacion(<%= usuario.getId() %>, '<%= usuario.getNombre().replace("'", "\\'") %>')"
                                                    title="Eliminar usuario">
                                                <i class="fas fa-trash"></i>
                                                <span class="d-none d-md-inline ms-1">Eliminar</span>
                                            </button>
                                        <% } else { %>
                                            <button type="button" 
                                                    class="btn btn-outline-secondary"
                                                    disabled
                                                    title="No puedes eliminarte a ti mismo">
                                                <i class="fas fa-lock"></i>
                                                <span class="d-none d-md-inline ms-1">Protegido</span>
                                            </button>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                <!-- Mensaje cuando no hay resultados de búsqueda -->
                <div id="noResults" class="empty-state" style="display: none;">
                    <i class="fas fa-search"></i>
                    <h4>No se encontraron usuarios</h4>
                    <p class="text-muted">No hay usuarios que coincidan con tu búsqueda</p>
                    <button class="btn btn-primary" onclick="clearSearch()">
                        <i class="fas fa-refresh me-2"></i>
                        Limpiar Búsqueda
                    </button>
                </div>
            <% } %>
        </div>
    </div>
    
    <!-- Modal de Confirmación de Eliminación -->
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
                    <p>¿Estás seguro de que deseas eliminar al usuario:</p>
                    <p class="fw-bold text-danger" id="userToDelete"></p>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Atención:</strong> Esta acción eliminará también todos los registros asociados al usuario.
                    </div>
                    <p class="text-muted">Esta acción no se puede deshacer.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Cancelar
                    </button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Eliminar Usuario
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Función para confirmar eliminación
        function confirmarEliminacion(id, nombre) {
            document.getElementById('userToDelete').textContent = nombre;
            document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/usuario-eliminar?id=' + id;
            
            const modal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
            modal.show();
        }
        
        // Funciones de búsqueda y filtrado
        const searchInput = document.getElementById('searchUsers');
        const roleFilter = document.getElementById('filterRole');
        const usersContainer = document.getElementById('usersContainer');
        const noResults = document.getElementById('noResults');
        
        function filterUsers() {
            const searchTerm = searchInput.value.toLowerCase();
            const selectedRole = roleFilter.value;
            const userItems = document.querySelectorAll('.user-item');
            let visibleCount = 0;
            
            userItems.forEach(item => {
                const name = item.dataset.name;
                const email = item.dataset.email;
                const document = item.dataset.document;
                const role = item.dataset.role;
                
                const matchesSearch = !searchTerm || 
                    name.includes(searchTerm) || 
                    email.includes(searchTerm) || 
                    document.includes(searchTerm);
                    
                const matchesRole = !selectedRole || role === selectedRole;
                
                if (matchesSearch && matchesRole) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });
            
            // Mostrar/ocultar mensaje de "no hay resultados"
            if (visibleCount === 0 && userItems.length > 0) {
                noResults.style.display = 'block';
                usersContainer.style.display = 'none';
            } else {
                noResults.style.display = 'none';
                usersContainer.style.display = 'flex';
            }
        }
        
        function clearSearch() {
            searchInput.value = '';
            roleFilter.value = '';
            filterUsers();
        }
        
        // Event listeners para búsqueda
        if (searchInput) {
            searchInput.addEventListener('input', filterUsers);
        }
        
        if (roleFilter) {
            roleFilter.addEventListener('change', filterUsers);
        }
        
        // Animaciones de entrada
        document.addEventListener('DOMContentLoaded', function() {
            const userCards = document.querySelectorAll('.user-card');
            userCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
        
        // Tooltip para botones pequeños
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
        const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        // Actualizar hora cada minuto
        setInterval(function() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('es-ES', {
                hour: '2-digit',
                minute: '2-digit'
            });
            
            const timeElements = document.querySelectorAll('.stats-row h3:last-child');
            if (timeElements.length > 0) {
                timeElements[0].innerHTML = '<i class="fas fa-clock me-2"></i>' + timeString;
            }
        }, 60000);
    </script>
</body>
</html>