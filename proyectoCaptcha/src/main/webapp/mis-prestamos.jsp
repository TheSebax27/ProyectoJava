<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.prestamoDTO"%>
<%@page import="DTO.usuarioDTO"%>
<%@page import="java.util.Date"%>
<%
    // Verificar que el usuario esté logueado
    usuarioDTO usuarioLogueado = (usuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Obtener datos
    List<prestamoDTO> prestamos = (List<prestamoDTO>) request.getAttribute("prestamos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Préstamos - Sistema de Biblioteca ADSO</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
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
        
        .loans-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .loan-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 4px solid #007bff;
        }
        
        .loan-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .loan-card.active {
            border-left-color: #28a745;
        }
        
        .loan-card.returned {
            border-left-color: #6c757d;
            opacity: 0.8;
        }
        
        .loan-card.overdue {
            border-left-color: #dc3545;
        }
        
        .loan-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .loan-author {
            color: #6c757d;
            font-size: 1rem;
            margin-bottom: 15px;
        }
        
        .loan-details {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .loan-actions {
            margin-top: 15px;
        }
        
        .status-badge {
            font-size: 0.8rem;
            padding: 5px 12px;
            border-radius: 15px;
            font-weight: bold;
        }
        
        .badge-active {
            background-color: #28a745;
            color: white;
        }
        
        .badge-returned {
            background-color: #6c757d;
            color: white;
        }
        
        .badge-overdue {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-group-sm .btn {
            font-size: 0.8rem;
            padding: 5px 10px;
        }
        
        .stats-row {
            background: linear-gradient(45deg, #007bff, #0056b3);
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
        
        .filter-tabs {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .filter-btn {
            border: none;
            background: transparent;
            padding: 10px 20px;
            border-radius: 20px;
            margin-right: 10px;
            transition: all 0.3s ease;
        }
        
        .filter-btn.active {
            background: #007bff;
            color: white;
        }
        
        .date-info {
            font-size: 0.85rem;
        }
        
        .overdue-days {
            background: #dc3545;
            color: white;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        
        .days-remaining {
            background: #ffc107;
            color: #000;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        
        .user-welcome {
            background: linear-gradient(45deg, #20c997, #17a2b8);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 1.5rem;
        }
        
        @media (max-width: 768px) {
            .loan-card {
                padding: 15px;
            }
            
            .btn-group-sm .btn {
                font-size: 0.7rem;
                padding: 4px 8px;
                margin: 2px;
            }
            
            .loan-actions {
                text-align: center;
            }
            
            .filter-btn {
                font-size: 0.8rem;
                padding: 8px 15px;
                margin-bottom: 5px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/user-dashboard">
                <i class="fas fa-book-open me-2"></i>
                Sistema de Biblioteca ADSO
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user-dashboard">
                            <i class="fas fa-home me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/libros-buscar">
                            <i class="fas fa-search me-1"></i>Buscar Libros
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/mis-prestamos">
                            <i class="fas fa-book-reader me-1"></i>Mis Préstamos
                        </a>
                    </li>
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
                <div class="col-md-8">
                    <h1 class="mb-2">
                        <i class="fas fa-book-reader me-3"></i>
                        Mis Préstamos
                    </h1>
                    <p class="mb-0">Gestiona tus libros prestados</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="${pageContext.request.contextPath}/prestamo-nuevo" class="btn btn-light btn-lg">
                        <i class="fas fa-plus me-2"></i>
                        Solicitar Préstamo
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Bienvenida del Usuario -->
        <div class="user-welcome">
            <div class="user-avatar">
                <i class="fas fa-user"></i>
            </div>
            <h4>¡Hola, <%= usuarioLogueado.getNombre() %>!</h4>
            <p class="mb-0">Aquí puedes ver el estado de todos tus préstamos de libros</p>
        </div>
        
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
        
        <!-- Estadísticas del Usuario -->
        <% if (prestamos != null) { %>
            <div class="stats-row">
                <div class="row text-center">
                    <div class="col-md-3">
                        <h3><i class="fas fa-list me-2"></i><%= prestamos.size() %></h3>
                        <p class="mb-0">Total Préstamos</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-clock me-2"></i>
                            <% 
                                int activos = 0;
                                Date today = new Date();
                                for (prestamoDTO p : prestamos) {
                                    if (!p.isDevuelto() && !p.getFechaDevolucion().before(today)) activos++;
                                }
                            %>
                            <%= activos %>
                        </h3>
                        <p class="mb-0">Activos</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-check-circle me-2"></i>
                            <% 
                                int devueltos = 0;
                                for (prestamoDTO p : prestamos) {
                                    if (p.isDevuelto()) devueltos++;
                                }
                            %>
                            <%= devueltos %>
                        </h3>
                        <p class="mb-0">Devueltos</p>
                    </div>
                    <div class="col-md-3">
                        <h3><i class="fas fa-exclamation-triangle me-2"></i>
                            <% 
                                int vencidos = 0;
                                for (prestamoDTO p : prestamos) {
                                    if (!p.isDevuelto() && p.getFechaDevolucion().before(today)) vencidos++;
                                }
                            %>
                            <%= vencidos %>
                        </h3>
                        <p class="mb-0">Vencidos</p>
                    </div>
                </div>
            </div>
        <% } %>
        
        <!-- Filtros -->
        <div class="filter-tabs">
            <div class="d-flex flex-wrap align-items-center justify-content-between">
                <div class="filter-buttons">
                    <button class="filter-btn active" data-filter="all">
                        <i class="fas fa-list me-1"></i>Todos
                    </button>
                    <button class="filter-btn" data-filter="active">
                        <i class="fas fa-clock me-1"></i>Activos
                    </button>
                    <button class="filter-btn" data-filter="returned">
                        <i class="fas fa-check-circle me-1"></i>Devueltos
                    </button>
                    <button class="filter-btn" data-filter="overdue">
                        <i class="fas fa-exclamation-triangle me-1"></i>Vencidos
                    </button>
                </div>
                
                <div class="search-box">
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-search"></i>
                        </span>
                        <input type="text" 
                               class="form-control" 
                               id="searchLoans" 
                               placeholder="Buscar por título...">
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Lista de Préstamos -->
        <div class="loans-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="mb-0">
                    <i class="fas fa-book-reader me-2"></i>
                    Mis Libros Prestados
                </h5>
                
                <a href="${pageContext.request.contextPath}/prestamo-nuevo" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>
                    Nuevo Préstamo
                </a>
            </div>
            
            <% if (prestamos == null || prestamos.isEmpty()) { %>
                <!-- Estado vacío -->
                <div class="empty-state">
                    <i class="fas fa-book-reader"></i>
                    <h4>No tienes préstamos</h4>
                    <p class="text-muted">Aún no has solicitado ningún libro en préstamo</p>
                    <a href="${pageContext.request.contextPath}/libros-buscar" class="btn btn-primary me-2">
                        <i class="fas fa-search me-2"></i>
                        Buscar Libros
                    </a>
                    <a href="${pageContext.request.contextPath}/prestamo-nuevo" class="btn btn-success">
                        <i class="fas fa-plus me-2"></i>
                        Solicitar Préstamo
                    </a>
                </div>
            <% } else { %>
                <!-- Lista de préstamos -->
                <div class="row" id="loansContainer">
                    <% 
                        for (prestamoDTO prestamo : prestamos) {
                            boolean isOverdue = !prestamo.isDevuelto() && prestamo.getFechaDevolucion().before(today);
                            boolean isActive = !prestamo.isDevuelto() && !isOverdue;
                            boolean isReturned = prestamo.isDevuelto();
                            
                            String cardClass = "";
                            String statusClass = "";
                            String statusText = "";
                            
                            if (isReturned) {
                                cardClass = "returned";
                                statusClass = "badge-returned";
                                statusText = "Devuelto";
                            } else if (isOverdue) {
                                cardClass = "overdue";
                                statusClass = "badge-overdue";
                                statusText = "Vencido";
                            } else {
                                cardClass = "active";
                                statusClass = "badge-active";
                                statusText = "Activo";
                            }
                    %>
                        <div class="col-lg-6 col-xl-4 mb-4 loan-item" 
                             data-status="<%= cardClass %>"
                             data-book="<%= prestamo.getTituloLibro() != null ? prestamo.getTituloLibro().toLowerCase() : "" %>">
                            <div class="loan-card <%= cardClass %>">
                                <!-- Encabezado del préstamo -->
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="flex-grow-1">
                                        <div class="loan-title">
                                            <i class="fas fa-book me-1"></i>
                                            <%= prestamo.getTituloLibro() != null ? prestamo.getTituloLibro() : "Libro no encontrado" %>
                                        </div>
                                        <div class="loan-author">
                                            <i class="fas fa-user-edit me-1"></i>
                                            <%= prestamo.getAutorLibro() != null ? prestamo.getAutorLibro() : "Autor no disponible" %>
                                        </div>
                                    </div>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= statusText %>
                                    </span>
                                </div>
                                
                                <!-- Detalles del préstamo -->
                                <div class="loan-details">
                                    <div class="mb-2 date-info">
                                        <i class="fas fa-calendar-plus me-1"></i>
                                        <strong>Fecha préstamo:</strong> <%= prestamo.getFechaPrestamo() %>
                                    </div>
                                    
                                    <div class="mb-2 date-info">
                                        <i class="fas fa-calendar-check me-1"></i>
                                        <strong>Fecha límite:</strong> <%= prestamo.getFechaDevolucion() %>
                                        <% if (isOverdue) { %>
                                            <%
                                                long diffInMillies = today.getTime() - prestamo.getFechaDevolucion().getTime();
                                                long diffInDays = diffInMillies / (1000 * 60 * 60 * 24);
                                            %>
                                            <span class="overdue-days ms-2">Vencido hace <%= diffInDays %> días</span>
                                        <% } else if (isActive) { %>
                                            <%
                                                long diffInMillies = prestamo.getFechaDevolucion().getTime() - today.getTime();
                                                long diffInDays = diffInMillies / (1000 * 60 * 60 * 24);
                                            %>
                                            <span class="days-remaining ms-2"><%= diffInDays %> días restantes</span>
                                        <% } %>
                                    </div>
                                    
                                    <div class="mb-2">
                                        <i class="fas fa-hashtag me-1"></i>
                                        <strong>ID Préstamo:</strong> #<%= prestamo.getId() %>
                                    </div>
                                </div>
                                
                                <!-- Acciones -->
                                <div class="loan-actions">
                                    <% if (!prestamo.isDevuelto()) { %>
                                        <div class="d-grid gap-2">
                                            <button type="button" 
                                                    class="btn btn-success btn-sm"
                                                    onclick="confirmarDevolucion(<%= prestamo.getId() %>, '<%= prestamo.getTituloLibro() != null ? prestamo.getTituloLibro().replace("'", "\\'") : "Libro" %>')"
                                                    title="Marcar como devuelto">
                                                <i class="fas fa-undo me-2"></i>
                                                He Devuelto Este Libro
                                            </button>
                                            
                                            <a href="${pageContext.request.contextPath}/generar-pdf?id=<%= prestamo.getId() %>" 
                                               class="btn btn-outline-info btn-sm"
                                               target="_blank"
                                               title="Descargar comprobante">
                                                <i class="fas fa-file-pdf me-2"></i>
                                                Descargar Comprobante
                                            </a>
                                        </div>
                                    <% } else { %>
                                        <div class="d-grid">
                                            <a href="${pageContext.request.contextPath}/generar-pdf?id=<%= prestamo.getId() %>" 
                                               class="btn btn-outline-secondary btn-sm"
                                               target="_blank"
                                               title="Descargar comprobante">
                                                <i class="fas fa-file-pdf me-2"></i>
                                                Ver Comprobante
                                            </a>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                <!-- Mensaje cuando no hay resultados -->
                <div id="noResults" class="empty-state" style="display: none;">
                    <i class="fas fa-search"></i>
                    <h4>No se encontraron préstamos</h4>
                    <p class="text-muted">No hay préstamos que coincidan con tu búsqueda o filtro</p>
                    <button class="btn btn-primary" onclick="clearFilters()">
                        <i class="fas fa-refresh me-2"></i>
                        Limpiar Filtros
                    </button>
                </div>
            <% } %>
        </div>
        
        <!-- Consejos y Recordatorios -->
        <% if (prestamos != null && !prestamos.isEmpty()) { %>
            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body">
                            <h6 class="card-title text-primary">
                                <i class="fas fa-lightbulb me-2"></i>
                                Consejos Útiles
                            </h6>
                            <div class="small text-muted">
                                <div class="mb-2">
                                    <i class="fas fa-check text-success me-1"></i>
                                    Devuelve tus libros a tiempo para evitar restricciones
                                </div>
                                <div class="mb-2">
                                    <i class="fas fa-check text-success me-1"></i>
                                    Puedes solicitar hasta 3 libros simultáneamente
                                </div>
                                <div class="mb-0">
                                    <i class="fas fa-check text-success me-1"></i>
                                    Descarga los comprobantes para tus registros
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body">
                            <h6 class="card-title text-info">
                                <i class="fas fa-info-circle me-2"></i>
                                Información de Contacto
                            </h6>
                            <div class="small text-muted">
                                <div class="mb-2">
                                    <i class="fas fa-envelope me-1"></i>
                                    Email: biblioteca@adso.edu.co
                                </div>
                                <div class="mb-2">
                                    <i class="fas fa-phone me-1"></i>
                                    Teléfono: (123) 456-7890
                                </div>
                                <div class="mb-0">
                                    <i class="fas fa-clock me-1"></i>
                                    Horario: Lunes a Viernes 8:00 AM - 6:00 PM
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
    
    <!-- Modal de Confirmación de Devolución -->
    <div class="modal fade" id="confirmReturnModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-undo text-success me-2"></i>
                        Confirmar Devolución
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>¿Confirmas que ya has devuelto este libro a la biblioteca?</p>
                    <p class="fw-bold text-primary" id="bookToReturn"></p>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Importante:</strong> Solo marca como devuelto si ya entregaste físicamente el libro en la biblioteca.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Cancelar
                    </button>
                    <a href="#" id="confirmReturnBtn" class="btn btn-success">
                        <i class="fas fa-undo me-2"></i>Sí, Ya lo Devolví
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Función de confirmación de devolución
        function confirmarDevolucion(id, titulo) {
            document.getElementById('bookToReturn').textContent = titulo;
            document.getElementById('confirmReturnBtn').href = '${pageContext.request.contextPath}/prestamo-devolver?id=' + id;
            
            const modal = new bootstrap.Modal(document.getElementById('confirmReturnModal'));
            modal.show();
        }
        
        // Funciones de filtrado y búsqueda
        const searchInput = document.getElementById('searchLoans');
        const filterButtons = document.querySelectorAll('.filter-btn');
        const loansContainer = document.getElementById('loansContainer');
        const noResults = document.getElementById('noResults');
        
        let currentFilter = 'all';
        
        function filterLoans() {
            const searchTerm = searchInput.value.toLowerCase();
            const loanItems = document.querySelectorAll('.loan-item');
            let visibleCount = 0;
            
            loanItems.forEach(item => {
                const status = item.dataset.status;
                const book = item.dataset.book;
                
                const matchesSearch = !searchTerm || book.includes(searchTerm);
                const matchesFilter = currentFilter === 'all' || status === currentFilter;
                
                if (matchesSearch && matchesFilter) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });
            
            // Mostrar/ocultar mensaje de "no hay resultados"
            if (visibleCount === 0 && loanItems.length > 0) {
                noResults.style.display = 'block';
                loansContainer.style.display = 'none';
            } else {
                noResults.style.display = 'none';
                loansContainer.style.display = 'flex';
            }
        }
        
        function clearFilters() {
            searchInput.value = '';
            currentFilter = 'all';
            
            // Actualizar botones
            filterButtons.forEach(btn => {
                btn.classList.remove('active');
                if (btn.dataset.filter === 'all') {
                    btn.classList.add('active');
                }
            });
            
            filterLoans();
        }
        
        // Event listeners
        if (searchInput) {
            searchInput.addEventListener('input', filterLoans);
        }
        
        filterButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                // Actualizar filtro actual
                currentFilter = this.dataset.filter;
                
                // Actualizar botones activos
                filterButtons.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                // Aplicar filtro
                filterLoans();
            });
        });
        
        // Animaciones de entrada
        document.addEventListener('DOMContentLoaded', function() {
            const loanCards = document.querySelectorAll('.loan-card');
            loanCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
        
        // Tooltip para botones
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
        const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        // Función para mostrar notificaciones de préstamos próximos a vencer
        function checkUpcomingDues() {
            const loanItems = document.querySelectorAll('[data-status="active"]');
            let soonDueCount = 0;
            
            loanItems.forEach(item => {
                const daysRemaining = item.querySelector('.days-remaining');
                if (daysRemaining) {
                    const days = parseInt(daysRemaining.textContent);
                    if (days <= 3) {
                        soonDueCount++;
                    }
                }
            });
            
            if (soonDueCount > 0) {
                // Mostrar notificación discreta
                setTimeout(() => {
                    const toast = document.createElement('div');
                    toast.className = 'toast position-fixed top-0 end-0 m-3';
                    toast.innerHTML = `
                        <div class="toast-header">
                            <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                            <strong class="me-auto">Recordatorio</strong>
                            <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                        </div>
                        <div class="toast-body">
                            Tienes ${soonDueCount} libro(s) que vencen pronto. ¡No olvides devolverlos!
                        </div>
                    `;
                    document.body.appendChild(toast);
                    
                    const bootstrapToast = new bootstrap.Toast(toast);
                    bootstrapToast.show();
                    
                    // Remover el toast del DOM después de que se oculte
                    toast.addEventListener('hidden.bs.toast', () => {
                        toast.remove();
                    });
                }, 2000);
            }
        }
        
        // Ejecutar verificación de vencimientos al cargar la página
        document.addEventListener('DOMContentLoaded', checkUpcomingDues);
    </script>
</body>
</html>