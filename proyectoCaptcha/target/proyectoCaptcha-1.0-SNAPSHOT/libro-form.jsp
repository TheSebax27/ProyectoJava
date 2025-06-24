<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.libroDTO"%>
<%@page import="DTO.usuarioDTO"%>
<%
    // Verificar que el usuario esté logueado y sea admin
    usuarioDTO usuario = (usuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuario == null || !"admin".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Obtener datos
    libroDTO libro = (libroDTO) request.getAttribute("libro");
    List<String> categorias = (List<String>) request.getAttribute("categorias");
    String accion = (String) request.getAttribute("accion");
    boolean esEdicion = "editar".equals(accion);
    String titulo = esEdicion ? "Editar Libro" : "Nuevo Libro";
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
            background: linear-gradient(135deg, #28a745, #20c997);
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
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
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
        
        .custom-switch {
            margin-top: 10px;
        }
        
        .switch-label {
            font-weight: 600;
            color: #495057;
        }
        
        .category-input-group {
            position: relative;
        }
        
        .category-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #dee2e6;
            border-top: none;
            border-radius: 0 0 10px 10px;
            max-height: 200px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
        }
        
        .category-suggestion {
            padding: 10px 15px;
            cursor: pointer;
            border-bottom: 1px solid #f8f9fa;
        }
        
        .category-suggestion:hover {
            background-color: #f8f9fa;
        }
        
        .category-suggestion:last-child {
            border-bottom: none;
        }
        
        .preview-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid #28a745;
        }
        
        .preview-title {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .preview-detail {
            margin-bottom: 5px;
            color: #6c757d;
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
                <div class="col-md-8">
                    <h1 class="mb-2">
                        <i class="fas fa-<%= esEdicion ? "edit" : "plus-circle" %> me-3"></i>
                        <%= titulo %>
                    </h1>
                    <p class="mb-0">
                        <%= esEdicion ? "Modifica la información del libro" : "Añade un nuevo libro al catálogo" %>
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="${pageContext.request.contextPath}/libros" class="btn btn-light">
                        <i class="fas fa-arrow-left me-2"></i>
                        Volver a Libros
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
                    <form method="post" action="${pageContext.request.contextPath}/<%= esEdicion ? "libro-editar" : "libro-nuevo" %>" id="bookForm">
                        <% if (esEdicion && libro != null) { %>
                            <input type="hidden" name="id" value="<%= libro.getId() %>">
                        <% } %>
                        
                        <!-- Información Básica -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="fas fa-info-circle me-2"></i>
                                Información Básica
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label for="titulo" class="form-label">
                                        Título del Libro <span class="required">*</span>
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="titulo" 
                                           name="titulo" 
                                           placeholder="Ej: Cien Años de Soledad"
                                           value="<%= libro != null ? libro.getTitulo() : "" %>"
                                           required
                                           maxlength="200">
                                    <div class="form-text">Ingresa el título completo del libro</div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="autor" class="form-label">
                                        Autor <span class="required">*</span>
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="autor" 
                                           name="autor" 
                                           placeholder="Ej: Gabriel García Márquez"
                                           value="<%= libro != null ? libro.getAutor() : "" %>"
                                           required
                                           maxlength="100">
                                    <div class="form-text">Nombre completo del autor</div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="editorial" class="form-label">Editorial</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="editorial" 
                                           name="editorial" 
                                           placeholder="Ej: Editorial Sudamericana"
                                           value="<%= libro != null && libro.getEditorial() != null ? libro.getEditorial() : "" %>"
                                           maxlength="100">
                                    <div class="form-text">Casa editorial que publicó el libro</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Detalles Adicionales -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="fas fa-tags me-2"></i>
                                Detalles Adicionales
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="anio" class="form-label">Año de Publicación</label>
                                    <input type="number" 
                                           class="form-control" 
                                           id="anio" 
                                           name="anio" 
                                           placeholder="2024"
                                           value="<%= libro != null && libro.getAnio() > 0 ? libro.getAnio() : "" %>"
                                           min="1000" 
                                           max="2030">
                                    <div class="form-text">Año entre 1000 y 2030</div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="categoria" class="form-label">Categoría</label>
                                    <div class="category-input-group">
                                        <select class="form-select" id="categoria" name="categoria">
                                            <option value="">Selecciona una categoría</option>
                                            <% if (categorias != null) { %>
                                                <% for (String cat : categorias) { %>
                                                    <option value="<%= cat %>" 
                                                            <%= libro != null && cat.equals(libro.getCategoria()) ? "selected" : "" %>>
                                                        <%= cat %>
                                                    </option>
                                                <% } %>
                                            <% } %>
                                            <option value="Otro">Otra categoría...</option>
                                        </select>
                                    </div>
                                    <div class="form-text">Selecciona o crea una nueva categoría</div>
                                </div>
                            </div>
                            
                            <!-- Campo para categoría personalizada -->
                            <div class="row" id="customCategoryRow" style="display: none;">
                                <div class="col-md-6 mb-3">
                                    <label for="categoriaPersonalizada" class="form-label">Nueva Categoría</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="categoriaPersonalizada" 
                                           name="categoriaPersonalizada" 
                                           placeholder="Ej: Ciencia Ficción"
                                           maxlength="100">
                                    <div class="form-text">Ingresa el nombre de la nueva categoría</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Estado del Libro -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="fas fa-toggle-on me-2"></i>
                                Estado del Libro
                            </h5>
                            
                            <div class="form-check form-switch custom-switch">
                                <input class="form-check-input" 
                                       type="checkbox" 
                                       id="disponible" 
                                       name="disponible"
                                       <%= libro == null || libro.isDisponible() ? "checked" : "" %>>
                                <label class="form-check-label switch-label" for="disponible">
                                    <span id="availabilityText">
                                        <%= libro == null || libro.isDisponible() ? "Libro Disponible" : "Libro No Disponible" %>
                                    </span>
                                </label>
                                <div class="form-text">
                                    Marca si el libro está disponible para préstamo
                                </div>
                            </div>
                        </div>
                        
                        <!-- Botones de Acción -->
                        <div class="form-section">
                            <div class="row">
                                <div class="col-md-6">
                                    <button type="submit" class="btn btn-success btn-submit w-100">
                                        <i class="fas fa-<%= esEdicion ? "save" : "plus" %> me-2"></i>
                                        <%= esEdicion ? "Actualizar Libro" : "Crear Libro" %>
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/libros" class="btn btn-secondary btn-cancel w-100">
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
                <!-- Vista Previa -->
                <div class="form-card">
                    <h5 class="section-title">
                        <i class="fas fa-eye me-2"></i>
                        Vista Previa
                    </h5>
                    
                    <div class="preview-card" id="bookPreview">
                        <div class="preview-title" id="previewTitle">
                            <%= libro != null ? libro.getTitulo() : "Título del libro" %>
                        </div>
                        <div class="preview-detail">
                            <i class="fas fa-user me-1"></i>
                            <strong>Autor:</strong> 
                            <span id="previewAutor"><%= libro != null ? libro.getAutor() : "Autor del libro" %></span>
                        </div>
                        <div class="preview-detail" id="previewEditorialRow" <%= libro == null || libro.getEditorial() == null || libro.getEditorial().trim().isEmpty() ? "style='display:none'" : "" %>>
                            <i class="fas fa-building me-1"></i>
                            <strong>Editorial:</strong> 
                            <span id="previewEditorial"><%= libro != null && libro.getEditorial() != null ? libro.getEditorial() : "" %></span>
                        </div>
                        <div class="preview-detail" id="previewAnioRow" <%= libro == null || libro.getAnio() <= 0 ? "style='display:none'" : "" %>>
                            <i class="fas fa-calendar me-1"></i>
                            <strong>Año:</strong> 
                            <span id="previewAnio"><%= libro != null && libro.getAnio() > 0 ? libro.getAnio() : "" %></span>
                        </div>
                        <div class="preview-detail" id="previewCategoriaRow" <%= libro == null || libro.getCategoria() == null || libro.getCategoria().trim().isEmpty() ? "style='display:none'" : "" %>>
                            <i class="fas fa-tag me-1"></i>
                            <strong>Categoría:</strong> 
                            <span class="badge bg-secondary" id="previewCategoria"><%= libro != null && libro.getCategoria() != null ? libro.getCategoria() : "" %></span>
                        </div>
                        <div class="preview-detail">
                            <i class="fas fa-toggle-on me-1"></i>
                            <strong>Estado:</strong> 
                            <span class="badge" id="previewEstado">
                                <%= libro == null || libro.isDisponible() ? "Disponible" : "No Disponible" %>
                            </span>
                        </div>
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
                        <small>Usa títulos completos y precisos</small>
                    </div>
                    
                    <div class="tip-item mb-3">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Incluye el nombre completo del autor</small>
                    </div>
                    
                    <div class="tip-item mb-3">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Las categorías ayudan a organizar el catálogo</small>
                    </div>
                    
                    <div class="tip-item mb-0">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Marca como "No disponible" solo si es necesario</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Referencias a elementos
        const tituloInput = document.getElementById('titulo');
        const autorInput = document.getElementById('autor');
        const editorialInput = document.getElementById('editorial');
        const anioInput = document.getElementById('anio');
        const categoriaSelect = document.getElementById('categoria');
        const categoriaPersonalizadaInput = document.getElementById('categoriaPersonalizada');
        const disponibleSwitch = document.getElementById('disponible');
        const customCategoryRow = document.getElementById('customCategoryRow');
        
        // Referencias a vista previa
        const previewTitle = document.getElementById('previewTitle');
        const previewAutor = document.getElementById('previewAutor');
        const previewEditorial = document.getElementById('previewEditorial');
        const previewEditorialRow = document.getElementById('previewEditorialRow');
        const previewAnio = document.getElementById('previewAnio');
        const previewAnioRow = document.getElementById('previewAnioRow');
        const previewCategoria = document.getElementById('previewCategoria');
        const previewCategoriaRow = document.getElementById('previewCategoriaRow');
        const previewEstado = document.getElementById('previewEstado');
        const availabilityText = document.getElementById('availabilityText');
        
        // Actualizar vista previa en tiempo real
        function updatePreview() {
            // Título
            const titulo = tituloInput.value.trim() || 'Título del libro';
            previewTitle.textContent = titulo;
            
            // Autor
            const autor = autorInput.value.trim() || 'Autor del libro';
            previewAutor.textContent = autor;
            
            // Editorial
            const editorial = editorialInput.value.trim();
            if (editorial) {
                previewEditorial.textContent = editorial;
                previewEditorialRow.style.display = 'block';
            } else {
                previewEditorialRow.style.display = 'none';
            }
            
            // Año
            const anio = anioInput.value.trim();
            if (anio) {
                previewAnio.textContent = anio;
                previewAnioRow.style.display = 'block';
            } else {
                previewAnioRow.style.display = 'none';
            }
            
            // Categoría
            let categoria = '';
            if (categoriaSelect.value === 'Otro') {
                categoria = categoriaPersonalizadaInput.value.trim();
            } else {
                categoria = categoriaSelect.value.trim();
            }
            
            if (categoria) {
                previewCategoria.textContent = categoria;
                previewCategoriaRow.style.display = 'block';
            } else {
                previewCategoriaRow.style.display = 'none';
            }
            
            // Estado
            const disponible = disponibleSwitch.checked;
            previewEstado.textContent = disponible ? 'Disponible' : 'No Disponible';
            previewEstado.className = 'badge ' + (disponible ? 'bg-success' : 'bg-danger');
            availabilityText.textContent = disponible ? 'Libro Disponible' : 'Libro No Disponible';
        }
        
        // Event listeners para actualizar vista previa
        tituloInput.addEventListener('input', updatePreview);
        autorInput.addEventListener('input', updatePreview);
        editorialInput.addEventListener('input', updatePreview);
        anioInput.addEventListener('input', updatePreview);
        categoriaSelect.addEventListener('change', updatePreview);
        categoriaPersonalizadaInput.addEventListener('input', updatePreview);
        disponibleSwitch.addEventListener('change', updatePreview);
        
        // Mostrar/ocultar campo de categoría personalizada
        categoriaSelect.addEventListener('change', function() {
            if (this.value === 'Otro') {
                customCategoryRow.style.display = 'block';
                categoriaPersonalizadaInput.focus();
            } else {
                customCategoryRow.style.display = 'none';
                categoriaPersonalizadaInput.value = '';
            }
            updatePreview();
        });
        
        // Validación del formulario
        document.getElementById('bookForm').addEventListener('submit', function(e) {
            const titulo = tituloInput.value.trim();
            const autor = autorInput.value.trim();
            
            if (!titulo) {
                e.preventDefault();
                alert('El título del libro es obligatorio');
                tituloInput.focus();
                return false;
            }
            
            if (!autor) {
                e.preventDefault();
                alert('El autor del libro es obligatorio');
                autorInput.focus();
                return false;
            }
            
            // Validar año si se proporciona
            const anio = anioInput.value;
            if (anio && (anio < 1000 || anio > 2030)) {
                e.preventDefault();
                alert('El año debe estar entre 1000 y 2030');
                anioInput.focus();
                return false;
            }
            
            // Validar categoría personalizada
            if (categoriaSelect.value === 'Otro') {
                const categoriaPers = categoriaPersonalizadaInput.value.trim();
                if (!categoriaPers) {
                    e.preventDefault();
                    alert('Debes ingresar el nombre de la nueva categoría');
                    categoriaPersonalizadaInput.focus();
                    return false;
                }
            }
            
            return true;
        });
        
        // Inicializar vista previa
        document.addEventListener('DOMContentLoaded', function() {
            updatePreview();
            
            // Verificar si hay categoría "Otro" seleccionada
            if (categoriaSelect.value === 'Otro') {
                customCategoryRow.style.display = 'block';
            }
            
            // Si es edición y la categoría no está en la lista, mostrar como "Otro"
            <% if (esEdicion && libro != null && libro.getCategoria() != null) { %>
                const currentCategory = '<%= libro.getCategoria() %>';
                let categoryExists = false;
                
                for (let option of categoriaSelect.options) {
                    if (option.value === currentCategory) {
                        categoryExists = true;
                        break;
                    }
                }
                
                if (!categoryExists && currentCategory.trim() !== '') {
                    categoriaSelect.value = 'Otro';
                    categoriaPersonalizadaInput.value = currentCategory;
                    customCategoryRow.style.display = 'block';
                    updatePreview();
                }
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
        
        // Capitalizar primera letra automáticamente
        function capitalizeFirst(input) {
            input.addEventListener('blur', function() {
                if (this.value) {
                    this.value = this.value.charAt(0).toUpperCase() + this.value.slice(1);
                    updatePreview();
                }
            });
        }
        
        capitalizeFirst(tituloInput);
        capitalizeFirst(autorInput);
        capitalizeFirst(editorialInput);
        capitalizeFirst(categoriaPersonalizadaInput);
    </script>
</body>
</html>