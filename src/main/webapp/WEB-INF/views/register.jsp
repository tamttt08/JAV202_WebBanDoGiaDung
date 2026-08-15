<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="${userLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="register.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .register-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
    </style>
</head>
<body class="bg-light d-flex flex-column min-vh-100">

<!-- NAVBAR HEADER (Đồng bộ với hệ thống) -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-box-seam-fill text-primary me-2"></i> <fmt:message key="nav.brand"/>
        </a>

        <div class="ms-auto d-flex align-items-center">
            <!-- DROPDOWN CHUYỂN NGÔN NGỮ -->
            <div class="dropdown">
                <button class="btn btn-outline-light dropdown-toggle btn-sm fw-semibold" type="button" data-bs-toggle="dropdown">
                    <i class="bi bi-globe me-1"></i> ${userLang eq 'en' ? 'English' : 'Tiếng Việt'}
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow">
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
    </div>
</nav>

<!-- MAIN CONTENT - FORM ĐĂNG KÝ -->
<div class="container my-auto py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">

            <div class="card register-card bg-white p-4 p-sm-5">
                <div class="card-body p-0">
                    <!-- LOGO & BRAND -->
                    <div class="text-center mb-4">
                        <i class="bi bi-box-seam-fill text-primary display-4"></i>
                        <h3 class="fw-bold text-dark mt-2"><fmt:message key="register.heading"/></h3>
                        <p class="text-muted small"><fmt:message key="register.sub_heading"/></p>
                    </div>

                    <!-- THÔNG BÁO LỖI NẾU CÓ -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show text-center py-2 fs-6 mb-4" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- FORM ĐĂNG KÝ -->
                    <form action="${pageContext.request.contextPath}/register" method="post">

                        <div class="row">
                            <!-- Họ và tên -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold"><fmt:message key="register.fullname"/></label>
                                <fmt:message key="register.fullname_placeholder" var="fnPlaceholder"/>
                                <input type="text" name="fullName" class="form-control" placeholder="${fnPlaceholder}" required>
                            </div>

                            <!-- Tên đăng nhập -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold"><fmt:message key="register.username"/></label>
                                <fmt:message key="register.username_placeholder" var="unPlaceholder"/>
                                <input type="text" name="username" class="form-control" placeholder="${unPlaceholder}" required>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Email -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold"><fmt:message key="register.email"/></label>
                                <fmt:message key="register.email_placeholder" var="emailPlaceholder"/>
                                <input type="email" name="email" class="form-control" placeholder="${emailPlaceholder}" required>
                            </div>

                            <!-- Số điện thoại -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Số điện thoại</label>
                                <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại" required>
                            </div>
                        </div>

                        <!-- Địa chỉ -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Địa chỉ</label>
                            <input type="text" name="address" class="form-control" placeholder="Nhập địa chỉ" required>
                        </div>

                        <div class="row">
                            <!-- Mật khẩu -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold"><fmt:message key="register.password"/></label>
                                <fmt:message key="register.password_placeholder" var="passPlaceholder"/>
                                <input type="password" name="password" class="form-control" placeholder="${passPlaceholder}" required>
                            </div>

                            <!-- Xác nhận mật khẩu -->
                            <div class="col-md-4 mb-4">
                                <label class="form-label fw-semibold"><fmt:message key="register.confirm_password"/></label>
                                <input type="password" name="confirmPassword" class="form-control" placeholder="${passPlaceholder}" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold rounded-3">
                            <i class="bi bi-person-plus-fill me-1"></i> <fmt:message key="register.btn_register"/>
                        </button>
                    </form>

                    <hr class="my-4">

                    <div class="text-center">
                        <span class="text-muted small"><fmt:message key="register.has_account"/></span>
                        <a href="${pageContext.request.contextPath}/login" class="text-primary fw-bold text-decoration-none ms-1"><fmt:message key="register.login_now"/></a>
                    </div>
                </div>
            </div>

            <!-- BACK TO HOME LINK -->
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/home" class="text-secondary text-decoration-none small">
                    <i class="bi bi-arrow-left me-1"></i> <fmt:message key="register.back_home"/>
                </a>
            </div>

        </div>
    </div>
</div>

<!-- FOOTER (Đồng bộ với toàn hệ thống) -->
<footer class="bg-dark text-white text-center py-4 mt-auto">
    <div class="container">
        <p class="mb-0 small">&copy; 2026 Gia Dụng Store. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>