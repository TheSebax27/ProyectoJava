<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DTO.usuarioDTO"%>
<%
    // Verificar que el usuario esté logueado
    usuarioDTO usuario = (usuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Dashboard - Sistema de Biblioteca ADSO</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .hero-section {
            background: linear-gradient(135deg, #28a745, #20c997);
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
        
        .welcome-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 40px;
        }
        
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(45deg, #007bff, #0056b3);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2.5rem;
            color: white;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            height: 100%;
            border: 2px solid transparent;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            border-color: #28a745;
        }
        
        .stat-card.my-loans {
            border-left: 5px solid #007bff;
        }
        
        .stat-card.available-books {
            border-left: 5px solid #28a745;
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
            border-color: #28a745;
            box-shadow: 0 15px 35px rgba(40, 167, 69, 0.1);
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
        
        .section-title {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 30px;
            color: #333;
        }
        
        .tips-card {
            background: linear-gradient(45deg, #17a2b8, #138496);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .tips-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 20px;
        }
        
        .tip-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
        }
        
        .tip-icon {
            font-size: 1.5rem;
            margin-right: 15px;
            width: 40px;
            text-align: center;
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
            
            .avatar {
                width: 80px;
                height: 80px;
                font-size: 2rem;
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
                            <i class="fas fa-user me-1"></i>
                            <%= session.getAttribute("nombreUsuario") %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil">
                                <i class="fas fa-user me-2"></i>Mi Perfil
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/mis-prestamos">
                                <i class="fas fa-book-reader me-2"></i>Mis Préstamos
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
                <i class="fas fa-user-circle me-3"></i>
                ¡Bienvenido, <%= session.getAttribute("nombreUsuario") %>!
            </div>
            <p class="hero-subtitle">Explora, aprende y disfruta de nuestra biblioteca digital</p>
            <p class="mb-0">Tu espacio personal para gestionar tus préstamos y descubrir nuevos libros</p>
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
        
        <!-- Tarjeta de Bienvenida -->
        <div class="welcome-card">
            <div class="avatar">
                <i class="fas fa-user"></i>
            </div>
            <h3>¡Hola, <%= session.getAttribute("nombreUsuario") %>!</h3>
            <p class="text-muted mb-3">Es genial tenerte de vuelta en la biblioteca</p>
            <div class="row">
                <div class="col-md-6">
                    <p class="mb-1"><strong>Rol:</strong> Lector</p>
                    <p class="mb-1"><strong>Estado:</strong> <span class="badge bg-success">Activo</span></p>
                </div>
                <div class="col-md-6">
                    <p class="mb-1"><strong>Última visita:</strong> Hoy</p>
                    <p class="mb-1"><strong>Miembro desde:</strong> 2024</p>
                </div>
            </div>
        </div>
        
        <!-- Estadísticas del Usuario -->
        <div class="row mb-5">
            <div class="col-md-6 mb-4">
                <div class="stat-card my-loans">
                    <div class="stat-icon text-primary">
                        <i class="fas fa-book-reader"></i>
                    </div>
                    <div class="stat-number text-primary">
                        <%= request.getAttribute("misPrestamosActivos") != null ? request.getAttribute("misPrestamosActivos") : "0" %>
                    </div>
                    <div class="stat-label">Mis Préstamos Activos</div>
                    <a href="${pageContext.request.contextPath}/mis-prestamos" class="btn btn-outline-primary btn-sm">
                        <i class="fas fa-eye me-1"></i>Ver Mis Préstamos
                    </a>
                </div>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="stat-card available-books">
                    <div class="stat-icon text-success">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="stat-number text-success">
                        <%= request.getAttribute("librosDisponibles") != null ? request.getAttribute("librosDisponibles") : "0" %>
                    </div>
                    <div class="stat-label">Libros Disponibles</div>
                    <a href="${pageContext.request.contextPath}/libros-buscar" class="btn btn-outline-success btn-sm">
                        <i class="fas fa-search me-1"></i>Explorar Catálogo
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Acciones Principales -->
        <div class="section-title">
            <i class="fas fa-rocket me-2"></i>
            ¿Qué quieres hacer hoy?
        </div>
        
        <div class="row mb-5">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-primary">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="action-title">Buscar Libros</div>
                    <div class="action-description">Encuentra tu próximo libro favorito en nuestro catálogo</div>
                    <a href="${pageContext.request.contextPath}/libros-buscar" class="btn btn-primary btn-action">
                        <i class="fas fa-search me-1"></i>Buscar
                    </a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-success">
                        <i class="fas fa-book-reader"></i>
                    </div>
                    <div class="action-title">Mis Préstamos</div>
                    <div class="action-description">Revisa el estado de tus libros prestados</div>
                    <a href="${pageContext.request.contextPath}/mis-prestamos" class="btn btn-success btn-action">
                        <i class="fas fa-list me-1"></i>Ver Mis Libros
                    </a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-warning">
                        <i class="fas fa-plus"></i>
                    </div>
                    <div class="action-title">Solicitar Préstamo</div>
                    <div class="action-description">Pide prestado un libro de nuestra colección</div>
                    <a href="${pageContext.request.contextPath}/prestamo-nuevo" class="btn btn-warning btn-action">
                        <i class="fas fa-plus me-1"></i>Solicitar
                    </a>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="action-card">
                    <div class="action-icon text-info">
                        <i class="fas fa-globe"></i>
                    </div>
                    <div class="action-title">Catálogo Público</div>
                    <div class="action-description">Explora todos los libros disponibles</div>
                    <a href="${pageContext.request.contextPath}/consulta-publica" class="btn btn-info btn-action">
                        <i class="fas fa-eye me-1"></i>Ver Catálogo
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Consejos y Tips -->
        <div class="tips-card">
            <div class="tips-title">
                <i class="fas fa-lightbulb me-2"></i>
                Consejos para aprovechar mejor la biblioteca
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="tip-item">
                        <div class="tip-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div>
                            <strong>Devuelve a tiempo:</strong> Evita multas devolviendo tus libros antes de la fecha límite
                        </div>
                    </div>
                    
                    <div class="tip-item">
                        <div class="tip-icon">
                            <i class="fas fa-bookmark"></i>
                        </div>
                        <div>
                            <strong>Marca tus favoritos:</strong> Anota los libros que más te gusten para futuras lecturas
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="tip-item">
                        <div class="tip-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <div>
                            <strong>Usa los filtros:</strong> Busca por categoría, autor o año para encontrar exactamente lo que necesitas
                        </div>
                    </div>
                    
                    <div class="tip-item">
                        <div class="tip-icon">
                            <i class="fas fa-bell"></i>
                        </div>
                        <div>
                            <strong>Revisa regularmente:</strong> Mantente al día con tus préstamos y fechas de devolución
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Acceso Rápido -->
        <div class="section-title">
            <i class="fas fa-tachometer-alt me-2"></i>
            Acceso Rápido
        </div>
        
        <div class="row mb-5">
            <div class="col-md-4 mb-3">
                <div class="action-card">
                    <div class="action-icon text-secondary">
                        <i class="fas fa-user-cog"></i>
                    </div>
                    <div class="action-title">Mi Perfil</div>
                    <div class="action-description">Actualiza tu información personal</div>
                    <a href="${pageContext.request.contextPath}/perfil" class="btn btn-secondary btn-action">
                        <i class="fas fa-edit me-1"></i>Editar Perfil
                    </a>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="action-card">
                    <div class="action-icon text-primary">
                        <i class="fas fa-history"></i>
                    </div>
                    <div class="action-title">Historial</div>
                    <div class="action-description">Ve todo tu historial de préstamos</div>
                    <a href="${pageContext.request.contextPath}/mis-prestamos" class="btn btn-primary btn-action">
                        <i class="fas fa-eye me-1"></i>Ver Historial
                    </a>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="action-card">
                    <div class="action-icon text-danger">
                        <i class="fas fa-question-circle"></i>
                    </div>
                    <div class="action-title">Ayuda</div>
                    <div class="action-description">¿Necesitas ayuda? Contáctanos</div>
                    <a href="mailto:biblioteca@adso.edu.co" class="btn btn-danger btn-action">
                        <i class="fas fa-envelope me-1"></i>Contactar
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Información del Usuario -->
        <div class="footer-info">
            <h5><i class="fas fa-info-circle me-2"></i>Tu Información</h5>
            <div class="row mt-3">
                <div class="col-md-4">
                    <p class="mb-1"><strong>Usuario:</strong> <%= session.getAttribute("nombreUsuario") %></p>
                    <p class="mb-1"><strong>Rol:</strong> Lector</p>
                </div>
                <div class="col-md-4">
                    <p class="mb-1"><strong>Estado:</strong> <span class="badge bg-success">Activo</span></p>
                    <p class="mb-1"><strong>Préstamos:</strong> <%= request.getAttribute("misPrestamosActivos") != null ? request.getAttribute("misPrestamosActivos") : "0" %> activos</p>
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
            const cards = document.querySelectorAll('.stat-card, .action-card, .welcome-card');
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
        
        // Efectos hover adicionales
        document.querySelectorAll('.action-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    </script>
</body>
</html>