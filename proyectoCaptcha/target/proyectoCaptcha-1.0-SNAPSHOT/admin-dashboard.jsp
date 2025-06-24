<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DTO.usuarioDTO"%>
<%
    // Verificar que el usuario esté logueado y sea admin
    usuarioDTO usuario = (usuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuario == null || !"admin".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Sistema de Biblioteca ADSO</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .hero-section {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 60px 0;
            margin-bottom: 40px;
        }
        
        .hero-title {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 20px;
        }
        
        .hero-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            border-left: 5px solid;
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        
        .stat-card.books {
            border-left-color: #28a745;
        }
        
        .stat-card.users {
            border-left-color: #17a2b8;
        }
        
        .stat-card.loans {
            border-left-color: #ffc107;
        }
        
        .stat-card.returned {
            border-left-color: #6f42c1;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .stat-label {
            font-size: 1.1rem;
            color: #6c757d;
            margin-bottom: 15px;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }
        
        .action-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            height: 100%;
            border: 2px solid transparent;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            border-color: #007bff;
            box-shadow: 0 10px 25px rgba(0,123,255,0.1);
        }
        
        .action-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        
        .action-title {
            font-size: 1.3rem;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        .action-description {
            color: #6c757d;
            margin-bottom: 25px;
        }
        
        .btn-action {
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
        }
        
        .quick-stats {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 30px;
            color: #333;
        }
        
        .welcome-message {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .alert-custom {
            border: none;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .footer-info {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-top: 40px;
            text-align: center;
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }
            
            .stat-number {
                font-size: 2.5rem;
            }
            
            .action-icon {
                font-size: 2.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-book-open me-2"></i>
                Sistema de Biblioteca ADSO
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
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
    
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container text-center">
            <div class="hero-title">
                <i class="fas fa-tachometer-alt me-3"></i>
                Panel de Administración
            </div>
            <p class="hero-subtitle">Bienvenido, <%= session.getAttribute("nombreUsuario") %></p>
            <p class="mb-0">Gestiona tu biblioteca de manera eficiente y profesional</p>
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
        
        <!-- Estadísticas Principales -->
        <div class="row mb-5">
            <div class="col-md-3 mb-4">
                <div class="stat-card books">
                    <div class="stat-icon text-success">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-number text-success">
                        <%= request.getAttribute("totalLibros") != null ? request.getAttribute("totalLibros") : "0" %>
                    </div>
                    <div class="stat-label">Total de Libros</div>
                    <a href="${pageContext.request.contextPath}/libros" class="btn btn-outline-success btn-sm">
                        <i class="fas fa-eye me-1"></i>Ver Todos
                    </a>
                </div>
            </div>
            
            <div class="col-md-3 mb-4">
                <div class="stat-card users">
                    <div class="stat-icon text-info">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-number text-info">
                        <%= request.getAttribute("totalUsuarios") != null ? request.getAttribute("totalUsuarios") : "0" %>
                    </div>
                    <div class="stat-label">Usuarios Registrados</div>
                    <a href="${pageContext.request.contextPath}/usuarios" class="btn btn-outline-info btn-sm">
                        <i class="fas fa-eye me-1"></i>Ver Todos
                    </a>
                </div>
            </div>
            
            <div class="col-md-3 mb-4">
                <div class="stat-card loans">
                    <div class="stat-icon text-warning">
                        <i class="fas fa-exchange-alt"></i>
                    </div>
                    <div class="stat-number text-warning">
                        <%= request.getAttribute("prestamosActivos") != null ? request.getAttribute("prestamosActivos") : "0" %>
                    </div>
                    <div class="stat-label">Préstamos Activos</div>
                    <a href="${pageContext.request.contextPath}/prestamos" class="btn btn-outline-warning btn-sm">
                        <i class="fas fa-eye me-1"></i>Ver Todos
                    </a>
                </div>
            </div>
            
            <div class="col-md-3 mb-4">
                <div class="stat-card returned">
                    <div class="stat-icon text-purple">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-number" style="color: #6f42c1;">
                        <%= request.getAttribute("prestamosDevueltos") != null ? request.getAttribute("prestamosDevueltos") : "0" %>
                    </div>
                    <div class="stat-label">Libros Devueltos</div>
                    <a href="${pageContext.request.contextPath}/prestamos" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-eye me-1"></i>Ver Historial
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Acciones Rápidas -->
        <div class="section-title">
            <i class="fas fa-bolt me-2"></i>
            Acciones Rápidas
        </div>
        
        <div class="row mb-5">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-primary">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <div class="action-title">Agregar Libro</div>
                    <div class="action-description">Añade un nuevo libro al catálogo de la biblioteca</div>
                    <a href="${pageContext.request.contextPath}/libro-nuevo" class="btn btn-primary btn-action">
                        <i class="fas fa-plus me-1"></i>Crear
                    </a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-success">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div class="action-title">Nuevo Usuario</div>
                    <div class="action-description">Registra un nuevo usuario en el sistema</div>
                    <a href="${pageContext.request.contextPath}/usuario-nuevo" class="btn btn-success btn-action">
                        <i class="fas fa-plus me-1"></i>Crear
                    </a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-warning">
                        <i class="fas fa-handshake"></i>
                    </div>
                    <div class="action-title">Nuevo Préstamo</div>
                    <div class="action-description">Registra un nuevo préstamo de libro</div>
                    <a href="${pageContext.request.contextPath}/prestamo-nuevo" class="btn btn-warning btn-action">
                        <i class="fas fa-plus me-1"></i>Crear
                    </a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-danger">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="action-title">Préstamos Vencidos</div>
                    <div class="action-description">Revisa los préstamos que están vencidos</div>
                    <a href="${pageContext.request.contextPath}/prestamos-vencidos" class="btn btn-danger btn-action">
                        <i class="fas fa-eye me-1"></i>Ver
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Gestión del Sistema -->
        <div class="section-title">
            <i class="fas fa-cogs me-2"></i>
            Gestión del Sistema
        </div>
        
        <div class="row mb-5">
            <div class="col-lg-4 mb-4">
                <div class="action-card">
                    <div class="action-icon text-info">
                        <i class="fas fa-books"></i>
                    </div>
                    <div class="action-title">Gestionar Libros</div>
                    <div class="action-description">Administra el catálogo completo de libros</div>
                    <a href="${pageContext.request.contextPath}/libros" class="btn btn-info btn-action">
                        <i class="fas fa-cog me-1"></i>Gestionar
                    </a>
                </div>
            </div>
            
            <div class="col-lg-4 mb-4">
                <div class="action-card">
                    <div class="action-icon text-secondary">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <div class="action-title">Gestionar Usuarios</div>
                    <div class="action-description">Administra los usuarios del sistema</div>
                    <a href="${pageContext.request.contextPath}/usuarios" class="btn btn-secondary btn-action">
                        <i class="fas fa-cog me-1"></i>Gestionar
                    </a>
                </div>
            </div>
            
            <div class="col-lg-4 mb-4">
                <div class="action-card">
                    <div class="action-icon text-dark">
                        <i class="fas fa-exchange-alt"></i>
                    </div>
                    <div class="action-title">Gestionar Préstamos</div>
                    <div class="action-description">Administra todos los préstamos del sistema</div>
                    <a href="${pageContext.request.contextPath}/prestamos" class="btn btn-dark btn-action">
                        <i class="fas fa-cog me-1"></i>Gestionar
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Reportes -->
        <div class="section-title">
            <i class="fas fa-chart-bar me-2"></i>
            Reportes y Documentos
        </div>
        
        <div class="row mb-5">
            <div class="col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-success">
                        <i class="fas fa-file-excel"></i>
                    </div>
                    <div class="action-title">Reporte de Inventario</div>
                    <div class="action-description">Genera un reporte completo en Excel</div>
                    <a href="${pageContext.request.contextPath}/generar-excel" class="btn btn-success btn-action">
                        <i class="fas fa-download me-1"></i>Generar Excel
                    </a>
                </div>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-primary">
                        <i class="fas fa-globe"></i>
                    </div>
                    <div class="action-title">Catálogo Público</div>
                    <div class="action-description">Accede al catálogo público de la biblioteca</div>
                    <a href="${pageContext.request.contextPath}/consulta-publica" class="btn btn-primary btn-action">
                        <i class="fas fa-eye me-1"></i>Ver Catálogo
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Información del Sistema -->
        <div class="footer-info">
            <h5><i class="fas fa-info-circle me-2"></i>Información del Sistema</h5>
            <div class="row mt-3">
                <div class="col-md-4">
                    <p class="mb-1"><strong>Sistema:</strong> Biblioteca ADSO</p>
                    <p class="mb-1"><strong>Versión:</strong> 1.0.0</p>
                </div>
                <div class="col-md-4">
                    <p class="mb-1"><strong>Usuario:</strong> <%= session.getAttribute("nombreUsuario") %></p>
                    <p class="mb-1"><strong>Rol:</strong> Administrador</p>
                </div>
                <div class="col-md-4">
                    <p class="mb-1"><strong>Fecha:</strong> <span id="currentDate"></span></p>
                    <p class="mb-1"><strong>Hora:</strong> <span id="currentTime"></span></p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Actualizar fecha y hora
        function updateDateTime() {
            const now = new Date();
            const dateOptions = { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                weekday: 'long'
            };
            const timeOptions = { 
                hour: '2-digit', 
                minute: '2-digit', 
                second: '2-digit'
            };
            
            document.getElementById('currentDate').textContent = 
                now.toLocaleDateString('es-ES', dateOptions);
            document.getElementById('currentTime').textContent = 
                now.toLocaleTimeString('es-ES', timeOptions);
        }
        
        // Actualizar cada segundo
        setInterval(updateDateTime, 1000);
        updateDateTime(); // Llamada inicial
        
        // Efectos de animación
        document.addEventListener('DOMContentLoaded', function() {
            // Animación de entrada para las tarjetas
            const cards = document.querySelectorAll('.stat-card, .action-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>