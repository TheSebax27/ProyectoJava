<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DTO.usuarioDTO"%>
<%
    // Verificar que el usuario esté logueado y sea admin
    usuarioDTO usuarioLogueado = (usuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !"admin".equals(usuarioLogueado.getRol())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Obtener datos
    usuarioDTO usuario = (usuarioDTO) request.getAttribute("usuario");
    String accion = (String) request.getAttribute("accion");
    boolean esEdicion = "editar".equals(accion);
    String titulo = esEdicion ? "Editar Usuario" : "Nuevo Usuario";
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
            background: linear-gradient(135deg, #6f42c1, #563d7c);
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
            border-color: #6f42c1;
            box-shadow: 0 0 0 0.2rem rgba(111, 66, 193, 0.25);
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
            border-left: 4px solid #6f42c1;
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
        
        .avatar-preview {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(45deg, #6f42c1, #563d7c);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            font-weight: bold;
            margin: 0 auto 15px;
        }
        
        .avatar-preview.admin {
            background: linear-gradient(45deg, #dc3545, #c82333);
        }
        
        .avatar-preview.lector {
            background: linear-gradient(45deg, #28a745, #218838);
        }
        
        .password-toggle {
            position: relative;
        }
        
        .password-toggle .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: none;
            color: #6c757d;
            cursor: pointer;
        }
        
        .password-strength {
            margin-top: 10px;
        }
        
        .strength-bar {
            height: 4px;
            border-radius: 2px;
            background: #e9ecef;
            overflow: hidden;
        }
        
        .strength-fill {
            height: 100%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }
        
        .strength-weak { background: #dc3545; width: 25%; }
        .strength-fair { background: #ffc107; width: 50%; }
        .strength-good { background: #28a745; width: 75%; }
        .strength-strong { background: #17a2b8; width: 100%; }
        
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/usuarios">
                            <i class="fas fa-users me-1"></i>Usuarios
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
                        <i class="fas fa-<%= esEdicion ? "user-edit" : "user-plus" %> me-3"></i>
                        <%= titulo %>
                    </h1>
                    <p class="mb-0">
                        <%= esEdicion ? "Modifica la información del usuario" : "Registra un nuevo usuario en el sistema" %>
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="${pageContext.request.contextPath}/usuarios" class="btn btn-light">
                        <i class="fas fa-arrow-left me-2"></i>
                        Volver a Usuarios
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
                    <form method="post" action="${pageContext.request.contextPath}/<%= esEdicion ? "usuario-editar" : "usuario-nuevo" %>" id="userForm">
                        <% if (esEdicion && usuario != null) { %>
                            <input type="hidden" name="id" value="<%= usuario.getId() %>">
                        <% } %>
                        
                        <!-- Información Personal -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="fas fa-user me-2"></i>
                                Información Personal
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nombre" class="form-label">
                                        Nombre Completo <span class="required">*</span>
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="nombre" 
                                           name="nombre" 
                                           placeholder="Ej: Juan Pérez"
                                           value="<%= usuario != null ? usuario.getNombre() : "" %>"
                                           required
                                           maxlength="100">
                                    <div class="form-text">Ingresa el nombre completo del usuario</div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="documento" class="form-label">
                                        Documento de Identidad <span class="required">*</span>
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="documento" 
                                           name="documento" 
                                           placeholder="Ej: 12345678"
                                           value="<%= usuario != null ? usuario.getDocumento() : "" %>"
                                           required
                                           maxlength="20"
                                           pattern="[0-9]+">
                                    <div class="form-text">Solo números, sin espacios ni guiones</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Información de Contacto -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="fas fa-address-book me-2"></i>
                                Información de Contacto
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="correo" class="form-label">
                                        Correo Electrónico <span class="required">*</span>
                                    </label>
                                    <input type="email" 
                                           class="form-control" 
                                           id="correo" 
                                           name="correo" 
                                           placeholder="usuario@email.com"
                                           value="<%= usuario != null ? usuario.getCorreo() : "" %>"
                                           required
                                           maxlength="100">
                                    <div class="form-text">Será usado para iniciar sesión</div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="telefono" class="form-label">Teléfono</label>
                                    <input type="tel" 
                                           class="form-control" 
                                           id="telefono" 
                                           name="telefono" 
                                           placeholder="Ej: 3001234567"
                                           value="<%= usuario != null && usuario.getTelefono() != null ? usuario.getTelefono() : "" %>"
                                           maxlength="20">
                                    <div class="form-text">Número de contacto (opcional)</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Configuración de Cuenta -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="fas fa-cog me-2"></i>
                                Configuración de Cuenta
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="rol" class="form-label">
                                        Rol del Usuario <span class="required">*</span>
                                    </label>
                                    <select class="form-select" id="rol" name="rol" required>
                                        <option value="">Selecciona un rol</option>
                                        <option value="lector" <%= usuario != null && "lector".equals(usuario.getRol()) ? "selected" : "" %>>
                                            Lector
                                        </option>
                                        <option value="admin" <%= usuario != null && "admin".equals(usuario.getRol()) ? "selected" : "" %>>
                                            Administrador
                                        </option>
                                    </select>
                                    <div class="form-text">Define los permisos del usuario</div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="contrasena" class="form-label">
                                        <%= esEdicion ? "Nueva Contraseña" : "Contraseña" %>
                                        <% if (!esEdicion) { %><span class="required">*</span><% } %>
                                    </label>
                                    <div class="password-toggle">
                                        <input type="password" 
                                               class="form-control" 
                                               id="contrasena" 
                                               name="<%= esEdicion ? "nuevaContrasena" : "contrasena" %>" 
                                               placeholder="Mínimo 6 caracteres"
                                               <%= esEdicion ? "" : "required" %>
                                               minlength="6">
                                        <button type="button" class="toggle-password" onclick="togglePassword('contrasena')">
                                            <i class="fas fa-eye" id="eyeIcon"></i>
                                        </button>
                                    </div>
                                    <div class="form-text">
                                        <%= esEdicion ? "Deja en blanco para mantener la actual" : "Mínimo 6 caracteres" %>
                                    </div>
                                    <div class="password-strength">
                                        <div class="strength-bar">
                                            <div class="strength-fill" id="strengthFill"></div>
                                        </div>
                                        <small class="text-muted" id="strengthText">Ingresa una contraseña</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Botones de Acción -->
                        <div class="form-section">
                            <div class="row">
                                <div class="col-md-6">
                                    <button type="submit" class="btn btn-success btn-submit w-100">
                                        <i class="fas fa-<%= esEdicion ? "save" : "user-plus" %> me-2"></i>
                                        <%= esEdicion ? "Actualizar Usuario" : "Crear Usuario" %>
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/usuarios" class="btn btn-secondary btn-cancel w-100">
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
                    
                    <div class="preview-card" id="userPreview">
                        <div class="text-center">
                            <div class="avatar-preview" id="avatarPreview">
                                <%= usuario != null ? usuario.getNombre().substring(0, 1).toUpperCase() : "U" %>
                            </div>
                        </div>
                        
                        <div class="preview-title text-center" id="previewNombre">
                            <%= usuario != null ? usuario.getNombre() : "Nombre del usuario" %>
                        </div>
                        
                        <div class="preview-detail">
                            <i class="fas fa-envelope me-1"></i>
                            <strong>Email:</strong> 
                            <span id="previewCorreo"><%= usuario != null ? usuario.getCorreo() : "usuario@email.com" %></span>
                        </div>
                        
                        <div class="preview-detail">
                            <i class="fas fa-id-card me-1"></i>
                            <strong>Documento:</strong> 
                            <span id="previewDocumento"><%= usuario != null ? usuario.getDocumento() : "12345678" %></span>
                        </div>
                        
                        <div class="preview-detail" id="previewTelefonoRow">
                            <i class="fas fa-phone me-1"></i>
                            <strong>Teléfono:</strong> 
                            <span id="previewTelefono"><%= usuario != null && usuario.getTelefono() != null ? usuario.getTelefono() : "" %></span>
                        </div>
                        
                        <div class="preview-detail">
                            <i class="fas fa-user-tag me-1"></i>
                            <strong>Rol:</strong> 
                            <span class="badge" id="previewRol">
                                <%= usuario != null ? ("admin".equals(usuario.getRol()) ? "Administrador" : "Lector") : "Seleccionar rol" %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- Información de Roles -->
                <div class="form-card">
                    <h5 class="section-title">
                        <i class="fas fa-info-circle me-2"></i>
                        Información de Roles
                    </h5>
                    
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-2">
                            <i class="fas fa-user-shield text-danger me-2"></i>
                            <strong>Administrador</strong>
                        </div>
                        <small class="text-muted">
                            Puede gestionar usuarios, libros, préstamos y generar reportes
                        </small>
                    </div>
                    
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-2">
                            <i class="fas fa-user text-success me-2"></i>
                            <strong>Lector</strong>
                        </div>
                        <small class="text-muted">
                            Puede buscar libros, solicitar préstamos y gestionar su perfil
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
                        <small>Usa emails únicos para cada usuario</small>
                    </div>
                    
                    <div class="tip-item mb-3">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Los documentos deben ser únicos</small>
                    </div>
                    
                    <div class="tip-item mb-3">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Contraseñas seguras con al menos 6 caracteres</small>
                    </div>
                    
                    <div class="tip-item mb-0">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <small>Asigna roles según las responsabilidades</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Referencias a elementos
        const nombreInput = document.getElementById('nombre');
        const correoInput = document.getElementById('correo');
        const documentoInput = document.getElementById('documento');
        const telefonoInput = document.getElementById('telefono');
        const rolSelect = document.getElementById('rol');
        const contrasenaInput = document.getElementById('contrasena');
        
        // Referencias a vista previa
        const previewNombre = document.getElementById('previewNombre');
        const previewCorreo = document.getElementById('previewCorreo');
        const previewDocumento = document.getElementById('previewDocumento');
        const previewTelefono = document.getElementById('previewTelefono');
        const previewTelefonoRow = document.getElementById('previewTelefonoRow');
        const previewRol = document.getElementById('previewRol');
        const avatarPreview = document.getElementById('avatarPreview');
        
        // Actualizar vista previa en tiempo real
        function updatePreview() {
            // Nombre
            const nombre = nombreInput.value.trim() || 'Nombre del usuario';
            previewNombre.textContent = nombre;
            avatarPreview.textContent = nombre.substring(0, 1).toUpperCase();
            
            // Correo
            const correo = correoInput.value.trim() || 'usuario@email.com';
            previewCorreo.textContent = correo;
            
            // Documento
            const documento = documentoInput.value.trim() || '12345678';
            previewDocumento.textContent = documento;
            
            // Teléfono
            const telefono = telefonoInput.value.trim();
            if (telefono) {
                previewTelefono.textContent = telefono;
                previewTelefonoRow.style.display = 'block';
            } else {
                previewTelefonoRow.style.display = 'none';
            }
            
            // Rol
            const rol = rolSelect.value;
            let rolText = 'Seleccionar rol';
            let rolClass = 'bg-secondary';
            let avatarClass = '';
            
            if (rol === 'admin') {
                rolText = 'Administrador';
                rolClass = 'bg-danger';
                avatarClass = 'admin';
            } else if (rol === 'lector') {
                rolText = 'Lector';
                rolClass = 'bg-success';
                avatarClass = 'lector';
            }
            
            previewRol.textContent = rolText;
            previewRol.className = 'badge ' + rolClass;
            avatarPreview.className = 'avatar-preview ' + avatarClass;
        }
        
        // Event listeners para actualizar vista previa
        nombreInput.addEventListener('input', updatePreview);
        correoInput.addEventListener('input', updatePreview);
        documentoInput.addEventListener('input', updatePreview);
        telefonoInput.addEventListener('input', updatePreview);
        rolSelect.addEventListener('change', updatePreview);
        
        // Función para mostrar/ocultar contraseña
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById('eyeIcon');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'fas fa-eye';
            }
        }
        
        // Validación de fortaleza de contraseña
        function checkPasswordStrength(password) {
            const strengthFill = document.getElementById('strengthFill');
            const strengthText = document.getElementById('strengthText');
            
            if (password.length === 0) {
                strengthFill.className = 'strength-fill';
                strengthText.textContent = 'Ingresa una contraseña';
                return;
            }
            
            let strength = 0;
            let strengthClass = '';
            let strengthLabel = '';
            
            // Criterios de fortaleza
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            if (strength <= 2) {
                strengthClass = 'strength-weak';
                strengthLabel = 'Débil';
            } else if (strength <= 3) {
                strengthClass = 'strength-fair';
                strengthLabel = 'Regular';
            } else if (strength <= 4) {
                strengthClass = 'strength-good';
                strengthLabel = 'Buena';
            } else {
                strengthClass = 'strength-strong';
                strengthLabel = 'Muy fuerte';
            }
            
            strengthFill.className = 'strength-fill ' + strengthClass;
            strengthText.textContent = 'Fortaleza: ' + strengthLabel;
        }
        
        // Event listener para validación de contraseña
        contrasenaInput.addEventListener('input', function() {
            checkPasswordStrength(this.value);
        });
        
        // Validación del formulario
        document.getElementById('userForm').addEventListener('submit', function(e) {
            const nombre = nombreInput.value.trim();
            const correo = correoInput.value.trim();
            const documento = documentoInput.value.trim();
            const rol = rolSelect.value;
            const contrasena = contrasenaInput.value;
            
            if (!nombre) {
                e.preventDefault();
                alert('El nombre del usuario es obligatorio');
                nombreInput.focus();
                return false;
            }
            
            if (!correo) {
                e.preventDefault();
                alert('El correo electrónico es obligatorio');
                correoInput.focus();
                return false;
            }
            
            if (!documento) {
                e.preventDefault();
                alert('El documento es obligatorio');
                documentoInput.focus();
                return false;
            }
            
            if (!/^\d+$/.test(documento)) {
                e.preventDefault();
                alert('El documento debe contener solo números');
                documentoInput.focus();
                return false;
            }
            
            if (!rol) {
                e.preventDefault();
                alert('Debes seleccionar un rol para el usuario');
                rolSelect.focus();
                return false;
            }
            
            <% if (!esEdicion) { %>
                if (!contrasena || contrasena.length < 6) {
                    e.preventDefault();
                    alert('La contraseña debe tener al menos 6 caracteres');
                    contrasenaInput.focus();
                    return false;
                }
            <% } else { %>
                if (contrasena && contrasena.length < 6) {
                    e.preventDefault();
                    alert('Si proporcionas una nueva contraseña, debe tener al menos 6 caracteres');
                    contrasenaInput.focus();
                    return false;
                }
            <% } %>
            
            return true;
        });
        
        // Inicializar vista previa
        document.addEventListener('DOMContentLoaded', function() {
            updatePreview();
            
            // Validar contraseña inicial si existe
            if (contrasenaInput.value) {
                checkPasswordStrength(contrasenaInput.value);
            }
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
        
        capitalizeFirst(nombreInput);
        
        // Formatear documento (solo números)
        documentoInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
            updatePreview();
        });
        
        // Formatear teléfono (solo números)
        telefonoInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
            updatePreview();
        });
        
        // Validación de email en tiempo real
        correoInput.addEventListener('blur', function() {
            const email = this.value.trim();
            if (email && !email.includes('@')) {
                this.setCustomValidity('Ingresa un email válido');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>