<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.prestamoDTO"%>
<%@page import="DTO.libroDTO"%>
<%@page import="DTO.usuarioDTO"%>
<%@page import="java.time.LocalDate"%>
<%
    // Verificar que el usuario esté logueado
    usuarioDTO usuarioLogueado = (usuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Obtener datos
    prestamoDTO prestamo = (prestamoDTO) request.getAttribute("prestamo");
    List<libroDTO> librosDisponibles = (List<libroDTO>) request.getAttribute("librosDisponibles");
    List<usuarioDTO> usuarios = (List<usuarioDTO>) request.getAttribute("usuarios");
    String accion = (String) request.getAttribute("accion");
    boolean esEdicion = "editar".equals(accion);
    boolean esAdmin = "admin".equals(usuarioLogueado.getRol());
    String titulo = esEdicion ? "Editar Préstamo" : "Nuevo Préstamo";
    
    // Obtener libro preseleccionado si viene de parámetro
    String libroPreseleccionado = request.getParameter("libro");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= titulo %> - Sistema de Biblioteca ADSO</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .page-header {
            background: linear-gradient(135deg, #20c997, #17a2b8);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            color: #333;
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #20c997;
            box-shadow: 0 0 0 0.2rem rgba(32, 201, 151, 0.25);
        }
        
        .form-text {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .btn-submit {
            border-radius: 25px;
            padding: 12px 40px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
        }
        
        .btn-cancel {
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: bold;
        }
        
        .alert-custom {
            border: none;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .required {
            color: #dc3545;
        }
        
        .preview-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid #20c997;
        }
        
        .preview-title {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .preview-detail {
            margin-bottom: 8px;
            color: #6c757d;
        }
        
        .book-card {
            background: #e8f5e8;
            border: 1px solid #c3e6c3;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }
        
        .book-title {
            font-weight: bold;
            color: #155724;
        }
        
        .book-author {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .date-picker {
            position: relative;
        }
        
        .date-suggestions {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
        }
        
        .date-option {
            display: inline-block;
            background: #20c997;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            margin: 2px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .date-option:hover {
            background: #17a2b8;
            transform: scale(1.05);
        }
        
        .loan-summary {
            background: linear-gradient(45deg, #20c997, #17a2b8);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .days-counter {
            text-align: center;
            padding: 15px;
            background: #e3f2fd;
            border-radius: 8px;
            margin: 15px 0;
        }
        
        .days-number {
            font-size: 2rem;
            font-weight: bold;
            color: #1976d2;
        }
        
        @media (max-width: 768px) {
            .form-card {
                padding: 20px;
                margin: 15px;
            }
            
            .btn-submit, .btn-cancel {
                width: 100%;
                margin-bottom: 10px;
            }
            
            .date-option {
                display: block;
                margin: 5px 0;
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/prestamos">
                                <i class="fas fa-exchange-alt me-1"></i>Préstamos
                            </a>
                        </li>
                    <% } else { %>
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
                <div class="col-md-8">
                    <h1 class="mb-2">
                        <i class="fas fa-<%= esEdicion ? "edit" : "plus-circle" %> me-3"></i>
                        <%= titulo %>
                    </h1>
                    <p class="mb-0">
                        <%= esEdicion ? "Modifica los detalles del préstamo" : "Registra un nuevo préstamo de libro" %>
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="${pageContext.request.contextPath}/<%= esAdmin ? "prestamos" : "mis-prestamos" %>" class="btn btn-light">
                        <i class="fas fa-arrow-left me-2"></i>
                        Volver
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Mensajes de error -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-custom" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <div class="row">
            <div class="col-lg-8">
                <!-- Formulario Principal -->
                <div class="form-card">
                    <form method="post" action="${pageContext.request.contextPath}/<%= esEdicion ? "prestamo-editar" : "prestamo-nuevo" %>" id="loanForm">
                        <% if (esEdicion && prestamo != null) { %>
                            <input type="hidden" name="id" value="<%= prestamo.getId() %>">
                        <% } %>
                        
                        <!-- Selección de Libro -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="fas fa-book me-2"></i>
                                Selección de Libro
                            </h5>
                            
                            <% if (esEdicion) { %>
                                <!-- En edición, mostrar el libro actual -->
                                <div class="book-card">
                                    <div class="book-title">
                                        <i class="fas fa-book me-2"></i>
                                        <%= prestamo.getTituloLibro() != null ? prestamo.getTituloLibro() : "Libro no encontrado" %>
                                    </div>
                                    <div class="book-author">
                                        <i class="fas fa-user me-1"></i>
                                        <%= prestamo.getAutorLibro() != null ? prestamo.getAutorLibro() : "Autor no disponible" %>
                                    </div>
                                </div>
                                <div class="form-text">
                                    <i class="fas fa-info-circle me-1"></i>
                                    No puedes cambiar el libro en un préstamo existente
                                </div>
                            <% } else { %>
                                <!-- En creación, permitir seleccionar libro -->
                                <div class="mb-3">
                                    <label for="idLibro" class="form-label">
                                        Libro a Prestar <span class="required">*</span>
                                    </label>
                                    <select class="form-select" id="idLibro" name="idLibro" required>
                                        <option value="">Selecciona un libro</option>
                                        <% if (librosDisponibles != null) { %>
                                            <% for (libroDTO libro : librosDisponibles) { %>
                                                <option value="<%= libro.getId() %>" 
                                                        data-author="<%= libro.getAutor() %>"
                                                        data-category="<%= libro.getCategoria() != null ? libro.getCategoria() : "" %>"
                                                        <%= libroPreseleccionado != null && libroPreseleccionado.equals(String.valueOf(libro.getId())) ? "selected" : "" %>>
                                                    <%= libro.getTitulo() %> - <%= libro.getAutor() %>
                                                </option>
                                            <% } %>
                                        <% } %>
                                    </select>
                                    <div class="form-text">Selecciona el libro que se va a prestar</div>
                                </div>
                                
                                <!-- Información del libro seleccionado -->
                                <div id="selectedBookInfo" style="display: none;">
                                    <div class="book-card">
                                        <div class="book-title" id="selectedBookTitle"></div>
                                        <div class="book-author" id="selectedBookAuthor"></div>
                                        <div class="book-author" id="selectedBookCategory"></div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                        
                        <!-- Selección de Usuario (solo para admin) -->
                        <% if (esAdmin) { %>
                            <div class="form-section">
                                <h5 class="section-title">
                                    <i class="fas fa-user me-2"></i>
                                    Selección de Usuario
                                </h5>
                                
                                <% if (esEdicion) { %>
                                    <!-- En edición, mostrar el usuario actual -->
                                    <div class="alert alert-info">
                                        <i class="fas fa-user me-2"></i>
                                        <strong>Usuario:</strong> <%= prestamo.getNombreUsuario() != null ? prestamo.getNombreUsuario() : "Usuario no encontrado" %>
                                    </div>
                                    <div class="form-text">
                                        <i class="fas fa-info-circle me-1"></i>
                                        No puedes cambiar el usuario en un préstamo existente
                                    </div>
                                <% } else { %>
                                    <!-- En creación, permitir seleccionar usuario -->
                                    <div class="mb-3">
                                        <label for="idUsuario" class="form-label">
                                            Usuario <span class="required">*</span>
                                        </label>
                                        <select class="form-select" id="idUsuario" name="idUsuario" required>
                                            <option value="">Selecciona un usuario</option>
                                            <% if (usuarios != null) { %>
                                                <% for (usuarioDTO user : usuarios) { %>
                                                    <option value="<%= user.getId() %>" 
                                                            data-email="<%= user.getCorreo() %>"
                                                            data-document="<%= user.getDocumento() %>">
                                                        <%= user.getNombre() %> - <%= user.getCorreo() %>
                                                    </option>
                                                <% } %>
                                            <% } %>
                                        </select>
                                        <div class="form-text">Selecciona el usuario que recibirá el préstamo</div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <!-- Para usuarios normales, mostrar su información -->
                            <div class="form-section">
                                <h5 class="section-title">
                                    <i class="fas fa-user me-2"></i>
                                    Usuario del Préstamo
                                </h5>
                                
                                <div class="alert alert-success">
                                    <i class="fas fa-user me-2"></i>
                                    <strong>Préstamo para:</strong> <%= usuarioLogueado.getNombre() %>
                                </div>
                            </div>
                        <% } %>
                        
                        <!-- Configuración de Fechas -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="fas fa-calendar me-2"></i>
                                Configuración de Fechas
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fechaPrestamo" class="form-label">Fecha de Préstamo</label>
                                    <input type="date" 
                                           class="form-control" 
                                           id="fechaPrestamo" 
                                           value="<%= LocalDate.now() %>"
                                           readonly>
                                    <div class="form-text">El préstamo se registra para hoy</div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="fechaDevolucion" class="form-label">
                                        Fecha de Devolución <span class="required">*</span>
                                    </label>
                                    <input type="date" 
                                           class="form-control" 
                                           id="fechaDevolucion" 
                                           name="fechaDevolucion" 
                                           required
                                           min="<%= LocalDate.now().plusDays(1) %>"
                                           max="<%= LocalDate.now().plusDays(30) %>"
                                           value="<%= prestamo != null ? prestamo.getFechaDevolucion() : LocalDate.now().plusDays(7) %>">
                                    <div class="form-text">Máximo 30 días desde hoy</div>
                                </div>
                            </div>
                            
                            <!-- Sugerencias de fecha -->
                            <div class="date-suggestions">
                                <label class="form-label">Sugerencias rápidas:</label>
                                <div>
                                    <span class="date-option" onclick="setReturnDate(7)">7 días</span>
                                    <span class="date-option" onclick="setReturnDate(15)">15 días</span>
                                    <span class="date-option" onclick="setReturnDate(21)">21 días</span>
                                    <span class="date-option" onclick="setReturnDate(30)">30 días</span>
                                </div>
                            </div>
                            
                            <!-- Contador de días -->
                            <div class="days-counter">
                                <div class="days-number" id="daysCount">7</div>
                                <div class="text-muted">días de préstamo</div>
                            </div>
                        </div>
                        
                        <!-- Botones de Acción -->
                        <div class="form-section">
                            <div class="row">
                                <div class="col-md-6">
                                    <button type="submit" class="btn btn-success btn-submit w-100">
                                        <i class="fas fa-<%= esEdicion ? "save" : "plus" %> me-2"></i>
                                        <%= esEdicion ? "Actualizar Préstamo" : "Crear Préstamo" %>
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/<%= esAdmin ? "prestamos" : "mis-prestamos" %>" 
                                       class="btn btn-secondary btn-cancel w-100">
                                        <i class="fas fa-times me-2"></i>
                                        Cancelar
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="col-lg-4">
                <!-- Resumen del Préstamo -->
                <div class="form-card">
                    <h5 class="section-title">
                        <i class="fas fa-eye me-2"></i>
                        Resumen del Préstamo
                    </h5>
                    
                    <div class="loan-summary">
                        <div class="text-center mb-3">
                            <i class="fas fa-handshake fa-2x mb-2"></i>
                            <h6>Nuevo Préstamo</h6>
                        </div>
                        
                        <div class="preview-detail">
                            <i class="fas fa-book me-1"></i>
                            <strong>Libro:</strong> 
                            <span id="summaryBook">
                                <%= prestamo != null && prestamo.getTituloLibro() != null ? prestamo.getTituloLibro() : "Seleccionar libro" %>
                            </span>
                        </div>
                        
                        <div class="preview-detail">
                            <i class="fas fa-user me-1"></i>
                            <strong>Usuario:</strong> 
                            <span id="summaryUser">
                                <% if (esAdmin) { %>
                                    <%= prestamo != null && prestamo.getNombreUsuario() != null ? prestamo.getNombreUsuario() : "Seleccionar usuario" %>
                                <% } else { %>
                                    <%= usuarioLogueado.getNombre() %>
                                <% } %>
                            </span>
                        </div>
                        
                        <div class="preview-detail">
                            <i class="fas fa-calendar-plus me-1"></i>
                            <strong>Fecha préstamo:</strong> 
                            <span id="summaryStartDate"><%= LocalDate.now() %></span>
                        </div>
                        
                        <div class="preview-detail">
                            <i class="fas fa-calendar-check me-1"></i>
                            <strong>Fecha devolución:</strong> 
                            <span id="summaryEndDate">
                                <%= prestamo != null ? prestamo.getFechaDevolucion() : LocalDate.now().plusDays(7) %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- Información Importante -->
                <div class="form-card">
                    <h5 class="section-title">
                        <i class="fas fa-info-circle me-2"></i>
                        Información Importante
                    </h5>
                    
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Políticas de Préstamo</strong>
                    </div>
                    
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-2">
                            <i class="fas fa-clock text-primary me-2"></i>
                            <strong>Duración máxima:</strong>
                        </div>
                        <small class="text-muted">
                            Los préstamos pueden tener una duración máxima de 30 días
                        </small>
                    </div>
                    
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-2">
                            <i class="fas fa-undo text-success me-2"></i>
                            <strong>Devolución:</strong>
                        </div>
                        <small class="text-muted">
                            El libro debe devolverse en la fecha acordada o antes
                        </small>
                    </div>
                    
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-2">
                            <i class="fas fa-exclamation-circle text-danger me-2"></i>
                            <strong>Préstamos vencidos:</strong>
                        </div>
                        <small class="text-muted">
                            Los préstamos vencidos pueden tener restricciones para futuros préstamos
                        </small>
                    </div>
                </div>
                
                <!-- Consejos -->
                <div class="form-card">
                    <h5 class="section-title">
                        <i class="fas fa-lightbulb me-2"></i>
                        Consejos
                    </h5>
                    
                    <div class="tip-item mb-3">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Verifica la disponibilidad del libro antes de crear el préstamo</small>
                    </div>
                    
                    <div class="tip-item mb-3">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Confirma la información del usuario antes de proceder</small>
                    </div>
                    
                    <div class="tip-item mb-0">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Establece fechas de devolución realistas según el tipo de libro</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Referencias a elementos
        const bookSelect = document.getElementById('idLibro');
        const userSelect = document.getElementById('idUsuario');
        const returnDateInput = document.getElementById('fechaDevolucion');
        const selectedBookInfo = document.getElementById('selectedBookInfo');
        const selectedBookTitle = document.getElementById('selectedBookTitle');
        const selectedBookAuthor = document.getElementById('selectedBookAuthor');
        const selectedBookCategory = document.getElementById('selectedBookCategory');
        const daysCount = document.getElementById('daysCount');
        
        // Referencias a resumen
        const summaryBook = document.getElementById('summaryBook');
        const summaryUser = document.getElementById('summaryUser');
        const summaryEndDate = document.getElementById('summaryEndDate');
        
        // Función para actualizar información del libro seleccionado
        function updateBookInfo() {
            if (bookSelect && bookSelect.value) {
                const selectedOption = bookSelect.options[bookSelect.selectedIndex];
                const title = selectedOption.text.split(' - ')[0];
                const author = selectedOption.dataset.author;
                const category = selectedOption.dataset.category;
                
                selectedBookTitle.innerHTML = '<i class="fas fa-book me-2"></i>' + title;
                selectedBookAuthor.innerHTML = '<i class="fas fa-user me-1"></i>Autor: ' + author;
                selectedBookCategory.innerHTML = '<i class="fas fa-tag me-1"></i>Categoría: ' + (category || 'Sin categoría');
                
                selectedBookInfo.style.display = 'block';
                summaryBook.textContent = title;
            } else {
                selectedBookInfo.style.display = 'none';
                summaryBook.textContent = 'Seleccionar libro';
            }
        }
        
        // Función para actualizar información del usuario seleccionado
        function updateUserInfo() {
            if (userSelect && userSelect.value) {
                const selectedOption = userSelect.options[userSelect.selectedIndex];
                const userName = selectedOption.text.split(' - ')[0];
                summaryUser.textContent = userName;
            } else if (userSelect) {
                summaryUser.textContent = 'Seleccionar usuario';
            }
        }
        
        // Función para establecer fecha de devolución
        function setReturnDate(days) {
            const today = new Date();
            const returnDate = new Date(today);
            returnDate.setDate(today.getDate() + days);
            
            const formattedDate = returnDate.toISOString().split('T')[0];
            returnDateInput.value = formattedDate;
            
            updateDaysCount();
            updateSummary();
        }
        
        // Función para actualizar contador de días
        function updateDaysCount() {
            const today = new Date();
            const returnDate = new Date(returnDateInput.value);
            
            if (returnDate > today) {
                const timeDiff = returnDate.getTime() - today.getTime();
                const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
                daysCount.textContent = daysDiff;
            } else {
                daysCount.textContent = '0';
            }
        }
        
        // Función para actualizar resumen
        function updateSummary() {
            summaryEndDate.textContent = returnDateInput.value;
        }
        
        // Event listeners
        if (bookSelect) {
            bookSelect.addEventListener('change', updateBookInfo);
        }
        
        if (userSelect) {
            userSelect.addEventListener('change', updateUserInfo);
        }
        
        returnDateInput.addEventListener('change', function() {
            updateDaysCount();
            updateSummary();
        });
        
        // Validación del formulario
        document.getElementById('loanForm').addEventListener('submit', function(e) {
            const today = new Date();
            const returnDate = new Date(returnDateInput.value);
            
            <% if (!esEdicion) { %>
                if (bookSelect && !bookSelect.value) {
                    e.preventDefault();
                    alert('Debes seleccionar un libro');
                    bookSelect.focus();
                    return false;
                }
                
                <% if (esAdmin) { %>
                    if (userSelect && !userSelect.value) {
                        e.preventDefault();
                        alert('Debes seleccionar un usuario');
                        userSelect.focus();
                        return false;
                    }
                <% } %>
            <% } %>
            
            if (!returnDateInput.value) {
                e.preventDefault();
                alert('Debes establecer una fecha de devolución');
                returnDateInput.focus();
                return false;
            }
            
            if (returnDate <= today) {
                e.preventDefault();
                alert('La fecha de devolución debe ser posterior a hoy');
                returnDateInput.focus();
                return false;
            }
            
            const timeDiff = returnDate.getTime() - today.getTime();
            const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
            
            if (daysDiff > 30) {
                e.preventDefault();
                alert('El período de préstamo no puede exceder 30 días');
                returnDateInput.focus();
                return false;
            }
            
            return true;
        });
        
        // Inicialización
        document.addEventListener('DOMContentLoaded', function() {
            updateBookInfo();
            updateUserInfo();
            updateDaysCount();
            updateSummary();
            
            // Si hay un libro preseleccionado, mostrar información
            <% if (libroPreseleccionado != null) { %>
                updateBookInfo();
            <% } %>
        });
        
        // Animación de entrada
        document.addEventListener('DOMContentLoaded', function() {
            const formCard = document.querySelector('.form-card');
            formCard.style.opacity = '0';
            formCard.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                formCard.style.transition = 'all 0.5s ease';
                formCard.style.opacity = '1';
                formCard.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html>