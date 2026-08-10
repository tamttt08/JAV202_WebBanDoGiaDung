<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="${userLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="login.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        .login-header {
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            color: white;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
    </style>
</head>
<body class="d-flex align-items-center min-vh-100 py-5">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">

            <!-- NÚT CHUYỂN NGÔN NGỮ (GÓC TRÊN CỦA FORM) -->
            <div class="d-flex justify-content-end mb-2">
                <div class="dropdown">
                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle fw-semibold bg-white shadow-sm" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-globe me-1"></i> ${userLang eq 'en' ? 'English' : 'Tiếng Việt'}
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                        <li>
                            <a class="dropdown-item ${userLang eq 'vi' ? 'active' : ''}" href="${pageContext.request.contextPath}/change-language?lang=vi">
                                🇻🇳 Tiếng Việt
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item ${userLang eq 'en' ? 'active' : ''}" href="${pageContext.request.contextPath}/change-language?lang=en">
                                🇺🇸 English
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="card login-card">
                <!-- Card Header -->
                <div class="card-header login-header text-center py-4">
                    <h4 class="mb-1 fw-bold"><i class="bi bi-shop me-2"></i><fmt:message key="login.store_name"/></h4>
                    <p class="mb-0 text-white-50"><fmt:message key="login.sub_title"/></p>
                </div>

                <!-- Card Body -->
                <div class="card-body p-4 p-sm-5">

                    <!-- Thông báo Lỗi từ Servlet (Nếu có) -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                            <div>${error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <!-- Thông báo Thành công từ Đăng ký chuyển sang (Nếu có) -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                            <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                            <div>${success}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty sessionScope.authMessage}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.authMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <!-- Xóa message sau khi đã hiển thị xong -->
                        <c:remove var="authMessage" scope="session"/>
                    </c:if>

                    <!-- Form Đăng nhập -->
                    <form action="${pageContext.request.contextPath}/login" method="post">

                        <!-- Username Input -->
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold"><fmt:message key="login.username"/></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-secondary"><i class="bi bi-person-fill"></i></span>
                                <fmt:message key="login.username_placeholder" var="userPlaceholder"/>
                                <input type="text" class="form-control" id="username" name="username"
                                       placeholder="${userPlaceholder}" required>
                            </div>
                        </div>

                        <!-- Password Input -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label for="password" class="form-label fw-semibold mb-0"><fmt:message key="login.password"/></label>
                                <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none small text-muted"><fmt:message key="login.forgot_password"/></a>
                            </div>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-secondary"><i class="bi bi-lock-fill"></i></span>
                                <fmt:message key="login.password_placeholder" var="passPlaceholder"/>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="${passPlaceholder}" required>
                            </div>
                        </div>

                        <!-- Remember Me Checkbox -->
                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="rememberMe">
                            <label class="form-check-label text-secondary small" for="rememberMe">
                                <fmt:message key="login.remember_me"/>
                            </label>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-box-arrow-in-right me-1"></i> <fmt:message key="login.btn_login"/>
                        </button>

                    </form>

                </div>

                <!-- Card Footer -->
                <div class="card-footer bg-light text-center py-3 border-0 rounded-bottom">
                    <span class="text-muted small"><fmt:message key="login.no_account"/> </span>
                    <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-primary text-decoration-none"><fmt:message key="login.register_now"/></a>
                </div>
            </div>

            <!-- Back to Home Link -->
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/home" class="text-secondary text-decoration-none small">
                    <i class="bi bi-arrow-left me-1"></i> <fmt:message key="login.back_home"/>
                </a>
            </div>

        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>