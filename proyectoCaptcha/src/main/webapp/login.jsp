<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistema de Biblioteca ADSO</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }
        
        .login-left {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 60px 40px;
            text-align: center;
        }
        
        .login-right {
            padding: 60px 40px;
        }
        
        .brand-logo {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        
        .brand-title {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .brand-subtitle {
            opacity: 0.9;
            font-size: 1.1rem;
        }
        
        .form-title {
            color: #333;
            font-weight: bold;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .form-control {
            border: none;
            border-bottom: 2px solid #e9ecef;
            border-radius: 0;
            padding: 15px 0;
            font-size: 1rem;
            background: transparent;
        }
        
        .form-control:focus {
            border-bottom-color: #667eea;
            box-shadow: none;
            background: transparent;
        }
        
        .input-group {
            margin-bottom: 25px;
        }
        
        .input-group-text {
            background: transparent;
            border: none;
            border-bottom: 2px solid #e9ecef;
            border-radius: 0;
            color: #6c757d;
        }
        
        .btn-login {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 50px;
            padding: 15px 40px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .captcha-container {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            margin-bottom: 25px;
        }
        
        .captcha-image {
            border: 2px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 15px;
            display: block;
            max-width: 100%;
        }
        
        .captcha-refresh {
            background: #6c757d;
            border: none;
            border-radius: 20px;
            color: white;
            padding: 8px 15px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .captcha-refresh:hover {
            background: #5a6268;
            transform: rotate(360deg);
        }
        
        .alert {
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
        }
        
        .alert-danger {
            background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            color: white;
        }
        
        .public-access {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .public-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .public-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .login-left {
                padding: 40px 20px;
            }
            
            .login-right {
                padding: 40px 20px;
            }
            
            .brand-logo {
                font-size: 2rem;
            }
            
            .brand-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12">
                <div class="login-container row g-0 mx-auto">
                    <!-- Left Panel -->
                    <div class="col-lg-6 login-left d-flex flex-column justify-content-center">
                        <div class="brand-logo">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h2 class="brand-title">Sistema de Biblioteca</h2>
                        <p class="brand-subtitle">ADSO - Tecnología en Análisis y Desarrollo de Software</p>
                        
                        <div class="mt-4">
                            <h5><i class="fas fa-shield-alt me-2"></i>Acceso Seguro</h5>
                            <p class="mb-1"><i class="fas fa-check me-2"></i>Autenticación con CAPTCHA</p>
                            <p class="mb-1"><i class="fas fa-check me-2"></i>Gestión completa de biblioteca</p>
                            <p class="mb-0"><i class="fas fa-check me-2"></i>Reportes y comprobantes</p>
                        </div>
                    </div>
                    
                    <!-- Right Panel -->
                    <div class="col-lg-6 login-right">
                        <h3 class="form-title">
                            <i class="fas fa-sign-in-alt me-2"></i>
                            Iniciar Sesión
                        </h3>
                        
                        <!-- Mostrar errores si existen -->
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
                            <!-- Campo Email -->
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-envelope"></i>
                                </span>
                                <input type="email" 
                                       class="form-control" 
                                       name="correo" 
                                       placeholder="Correo electrónico"
                                       value="<%= request.getAttribute("correoAnterior") != null ? request.getAttribute("correoAnterior") : "" %>"
                                       required>
                            </div>
                            
                            <!-- Campo Contraseña -->
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-lock"></i>
                                </span>
                                <input type="password" 
                                       class="form-control" 
                                       name="contrasena" 
                                       placeholder="Contraseña"
                                       required>
                            </div>
                            
                            <!-- CAPTCHA -->
                            <div class="captcha-container">
                                <h6 class="mb-3">
                                    <i class="fas fa-shield-alt me-2"></i>
                                    Verificación de Seguridad
                                </h6>
                                
                                <div class="mb-3">
                                    <img id="captchaImage" 
                                         src="<%= request.getAttribute("captchaImagen") %>" 
                                         alt="CAPTCHA" 
                                         class="captcha-image">
                                    
                                    <br>
                                    <button type="button" 
                                            class="captcha-refresh" 
                                            onclick="refreshCaptcha()"
                                            title="Generar nuevo CAPTCHA">
                                        <i class="fas fa-sync-alt me-1"></i>
                                        Nuevo código
                                    </button>
                                </div>
                                
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-key"></i>
                                    </span>
                                    <input type="text" 
                                           class="form-control" 
                                           name="captcha" 
                                           placeholder="Ingresa el código mostrado"
                                           maxlength="6"
                                           style="text-transform: uppercase;"
                                           required>
                                </div>
                            </div>
                            
                            <!-- Botón de Login -->
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-login">
                                    <i class="fas fa-sign-in-alt me-2"></i>
                                    Iniciar Sesión
                                </button>
                            </div>
                        </form>
                        
                        <!-- Acceso Público -->
                        <div class="public-access">
                            <p class="mb-2">
                                <i class="fas fa-globe me-2"></i>
                                ¿Solo quieres consultar el catálogo?
                            </p>
                            <a href="${pageContext.request.contextPath}/consulta-publica" class="public-link">
                                <i class="fas fa-search me-1"></i>
                                Acceder al Catálogo Público
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Función para refrescar el CAPTCHA
        function refreshCaptcha() {
            const button = document.querySelector('.captcha-refresh');
            const icon = button.querySelector('i');
            
            // Mostrar animación de carga
            button.disabled = true;
            icon.classList.add('fa-spin');
            
            // Hacer petición AJAX para obtener nuevo CAPTCHA
            fetch('${pageContext.request.contextPath}/captcha')
                .then(response => response.json())
                .then(data => {
                    // Actualizar la imagen del CAPTCHA
                    document.getElementById('captchaImage').src = data.imagen;
                    
                    // Limpiar el campo de texto
                    document.querySelector('input[name="captcha"]').value = '';
                    document.querySelector('input[name="captcha"]').focus();
                })
                .catch(error => {
                    console.error('Error refreshing CAPTCHA:', error);
                    alert('Error al generar nuevo CAPTCHA. Por favor, recarga la página.');
                })
                .finally(() => {
                    // Restaurar botón
                    button.disabled = false;
                    icon.classList.remove('fa-spin');
                });
        }
        
        // Convertir texto del CAPTCHA a mayúsculas automáticamente
        document.querySelector('input[name="captcha"]').addEventListener('input', function(e) {
            e.target.value = e.target.value.toUpperCase();
        });
        
        // Validación del formulario
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const email = document.querySelector('input[name="correo"]').value;
            const password = document.querySelector('input[name="contrasena"]').value;
            const captcha = document.querySelector('input[name="captcha"]').value;
            
            if (!email || !password || !captcha) {
                e.preventDefault();
                alert('Por favor, complete todos los campos.');
                return false;
            }
            
            if (captcha.length !== 6) {
                e.preventDefault();
                alert('El código CAPTCHA debe tener 6 caracteres.');
                document.querySelector('input[name="captcha"]').focus();
                return false;
            }
        });
        
        // Auto-focus en el primer campo vacío
        window.addEventListener('load', function() {
            const emailField = document.querySelector('input[name="correo"]');
            const passwordField = document.querySelector('input[name="contrasena"]');
            const captchaField = document.querySelector('input[name="captcha"]');
            
            if (!emailField.value) {
                emailField.focus();
            } else if (!passwordField.value) {
                passwordField.focus();
            } else {
                captchaField.focus();
            }
        });
    </script>
</body>
</html>