<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <title><fmt:message key="forgot_pwd.title"/> - <fmt:message key="cart.brand_title"/></title>
    <!-- CDN Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- CDN Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light d-flex align-items-center min-vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card border-0 shadow-lg rounded-4 p-4">
                <div class="card-body">

                    <div class="text-center mb-4">
                        <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                            <i class="bi bi-key-fill fs-3"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1"><fmt:message key="forgot_pwd.heading"/></h4>
                        <p class="text-muted small"><fmt:message key="forgot_pwd.sub_heading"/></p>
                    </div>

                    <!-- THÔNG BÁO LỖI NẾU CÓ -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                            <i class="bi bi-exclamation-circle-fill me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- FORM GỬI EMAIL -->
                    <form action="${pageContext.request.contextPath}/forgot-password?action=send-otp" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-secondary"><fmt:message key="forgot_pwd.lbl_email"/></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                                <fmt:message key="forgot_pwd.ph_email" var="phEmail"/>
                                <input type="email" name="email" class="form-control" placeholder="${phEmail}" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm rounded-3">
                            <i class="bi bi-send me-1"></i> <fmt:message key="forgot_pwd.btn_send_otp"/>
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none small fw-semibold text-secondary">
                            <i class="bi bi-arrow-left me-1"></i> <fmt:message key="forgot_pwd.btn_back_login"/>
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- CDN Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>