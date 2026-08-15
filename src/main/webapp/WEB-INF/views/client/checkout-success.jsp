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
    <title><fmt:message key="chk_success.title"/> - <fmt:message key="cart.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light d-flex flex-column min-vh-100">

<!-- NAVBAR (Đồng bộ hệ thống) -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-box-seam-fill text-primary me-2"></i><fmt:message key="cart.brand_title"/>
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-seam me-1"></i> Đơn hàng của tôi
            </a>
        </div>
    </div>
</nav>

<!-- MAIN CONTENT -->
<div class="container my-5 text-center flex-grow-1 d-flex align-items-center justify-content-center">
    <div class="card border-0 shadow-sm p-5 mx-auto w-100" style="max-width: 600px;">
        <i class="bi bi-check-circle-fill text-success display-1 mb-3"></i>
        <h2 class="fw-bold text-dark mb-2"><fmt:message key="chk_success.heading"/></h2>
        <p class="text-muted mb-4"><fmt:message key="chk_success.message"/></p>

        <div class="d-flex justify-content-center gap-2 flex-wrap">
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-primary btn-lg px-4">
                <i class="bi bi-list-check me-1"></i> Xem đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg px-4">
                <i class="bi bi-house me-1"></i> <fmt:message key="chk_success.btn_home"/>
            </a>
        </div>
    </div>
</div>

<!-- FOOTER (Đồng bộ hệ thống) -->
<footer class="bg-dark text-white text-center py-4 mt-auto">
    <div class="container">
        <p class="mb-0 small">&copy; 2026 Gia Dụng Store. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>