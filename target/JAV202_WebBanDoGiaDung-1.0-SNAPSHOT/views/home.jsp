<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gia Dụng Store - Thiết Bị Gia Đình Hiện Đại</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .product-card {
            transition: transform 0.2s, box-shadow 0.2s;
            border: none;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
        }
        .product-img {
            height: 200px;
            object-fit: contain;
            padding: 15px;
        }
        .hero-banner {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            color: white;
            border-radius: 16px;
        }
    </style>
</head>
<body class="bg-light">

<!-- NAVBAR HEADER -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-box-seam-fill text-primary me-2"></i> GIA DỤNG STORE
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- FORM TÌM KIẾM -->
            <form class="d-flex mx-auto col-lg-5 my-2 my-lg-0" action="${pageContext.request.contextPath}/home" method="get">
                <div class="input-group">
                    <input class="form-control border-0" type="search" name="keyword" placeholder="Tìm sản phẩm gia dụng..." aria-label="Search">
                    <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                </div>
            </form>

            <!-- USER & CART -->
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item me-3">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                        <i class="bi bi-cart3 fs-5"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">0</span>
                    </a>
                </li>

                <%-- SỬA ĐOẠN NÀY: Thay sessionScope.account -> sessionScope.user --%>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle fw-semibold text-white" href="#" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle me-1"></i> ${sessionScope.user.username}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow">
                                    <%-- Kiểm tra nếu là Manager hoặc Staff --%>
                                <c:if test="${sessionScope.user.role eq 'Manager' or sessionScope.user.role eq 'Staff'}">
                                    <li>
                                        <a class="dropdown-item text-primary fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="bi bi-speedometer2 me-2"></i>Trang Quản Lý
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>

                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person me-2"></i>Thông tin cá nhân
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>

                    <%-- NẾU CHƯA ĐĂNG NHẬP --%>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm me-2" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- HERO BANNER -->
<div class="container mt-4">
    <div class="p-5 hero-banner shadow-sm">
        <div class="col-md-8">
            <h1 class="display-5 fw-bold">Thiết Bị Gia Dụng Thông Minh</h1>
            <p class="fs-5">Nâng tầm không gian sống gia đình bạn với các sản phẩm gia dụng hiện đại, chất lượng hàng đầu.</p>
            <a class="btn btn-warning btn-lg fw-bold px-4" href="#product-section">Khám Phá Ngay</a>
        </div>
    </div>
</div>

<!-- MAIN CONTAINER -->
<div class="container my-5" id="product-section">
    <div class="row g-4">

        <!-- DANH MỤC SIDEBAR -->
        <div class="col-lg-3">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header bg-white py-3">
                    <h6 class="fw-bold mb-0"><i class="bi bi-list-stars me-2 text-primary"></i>Danh Mục Sản Phẩm</h6>
                </div>
                <div class="list-group list-group-flush">
                    <a href="${pageContext.request.contextPath}/home"
                       class="list-group-item list-group-item-action ${empty selectedCategoryId ? 'active fw-bold' : ''}">
                        Tất cả sản phẩm
                    </a>
                    <c:forEach var="c" items="${categories}">
                        <a href="${pageContext.request.contextPath}/home?categoryId=${c.categoryId}"
                           class="list-group-item list-group-item-action ${selectedCategoryId eq c.categoryId ? 'active fw-bold' : ''}">
                                ${c.categoryName}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- DANH SÁCH SẢN PHẨM -->
        <div class="col-lg-9">
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <c:forEach var="p" items="${products}">
                    <div class="col">
                        <div class="card h-100 shadow-sm product-card rounded-3">
                            <img src="${empty p.image ? 'https://via.placeholder.com/200' : p.image}"
                                 class="card-img-top product-img" alt="${p.productName}">
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title fw-bold text-dark text-truncate">${p.productName}</h6>
                                <p class="text-danger fw-bold fs-5 mb-2">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </p>
                                <div class="mt-auto">
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.productID}"
                                       class="btn btn-outline-primary w-100 btn-sm fw-semibold mb-2">Xem chi tiết</a>
                                    <button class="btn btn-primary w-100 btn-sm fw-semibold">
                                        <i class="bi bi-cart-plus me-1"></i> Thêm vào giỏ
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty products}">
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <p class="text-muted mt-2">Không tìm thấy sản phẩm nào trong danh mục này.</p>
                    </div>
                </c:if>
            </div>
        </div>

    </div>
</div>

<!-- FOOTER -->
<footer class="bg-dark text-white text-center py-4 mt-auto">
    <div class="container">
        <p class="mb-0 small">&copy; 2026 Gia Dụng Store. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>