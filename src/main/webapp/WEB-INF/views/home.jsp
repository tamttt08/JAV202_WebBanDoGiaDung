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
<body class="bg-light d-flex flex-column min-vh-100">

<!-- NAVBAR HEADER -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-box-seam-fill text-primary me-2"></i> <fmt:message key="nav.brand"/>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- FORM TÌM KIẾM -->
            <form class="d-flex mx-auto col-lg-5 my-2 my-lg-0" action="${pageContext.request.contextPath}/home" method="get">
                <div class="input-group">
                    <fmt:message key="nav.search_placeholder" var="searchPlaceholder"/>
                    <input class="form-control border-0" type="search" name="keyword"
                           value="${param.keyword}" placeholder="${searchPlaceholder}" aria-label="Search">
                    <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                </div>
            </form>

            <!-- DROPDOWN CHUYỂN NGÔN NGỮ -->
            <div class="dropdown me-3">
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

            <!-- USER & CART -->
            <ul class="navbar-nav align-items-center">
                <li class="nav-item me-3">
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light position-relative">
                        <i class="bi bi-cart3"></i>
                        <c:if test="${not empty sessionScope.cart}">
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    ${sessionScope.cart.size()}
                            </span>
                        </c:if>
                    </a>
                </li>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle fw-semibold text-white" href="#" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle me-1"></i> ${sessionScope.user.username}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow">
                                <c:if test="${sessionScope.user.role eq 'Manager' or sessionScope.user.role eq 'Staff'}">
                                    <li>
                                        <a class="dropdown-item text-primary fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="bi bi-speedometer2 me-2"></i><fmt:message key="nav.admin"/>
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>

                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person me-2"></i><fmt:message key="nav.profile"/>
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i><fmt:message key="nav.logout"/>
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>

                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm me-2" href="${pageContext.request.contextPath}/login"><fmt:message key="nav.login"/></a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/register"><fmt:message key="nav.register"/></a>
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
            <h1 class="display-5 fw-bold"><fmt:message key="hero.title"/></h1>
            <p class="fs-5"><fmt:message key="hero.subtitle"/></p>
            <a class="btn btn-warning btn-lg fw-bold px-4" href="#product-section"><fmt:message key="hero.btn"/></a>
        </div>
    </div>
</div>

<!-- MAIN CONTAINER -->
<div class="container my-5" id="product-section">
    <div class="row g-4">

        <!-- DANH MỤC SIDEBAR -->
        <div class="col-lg-3">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header bg-white py-3 border-0">
                    <h6 class="fw-bold mb-0"><i class="bi bi-list-stars me-2 text-primary"></i><fmt:message key="cat.title"/></h6>
                </div>
                <div class="list-group list-group-flush">
                    <a href="${pageContext.request.contextPath}/home"
                       class="list-group-item list-group-item-action ${empty param.categoryId ? 'active' : ''}">
                        <i class="bi bi-grid-fill me-2"></i><fmt:message key="cat.all"/>
                    </a>

                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/home?categoryId=${cat.categoryId}"
                           class="list-group-item list-group-item-action ${param.categoryId == cat.categoryId ? 'active' : ''}">
                            <i class="bi bi-chevron-right small me-2"></i>${cat.categoryName}
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
                            <img src="${p.mainImage}"
                                 class="card-img-top product-img" alt="${p.productName}"
                                 onerror="this.src='https://via.placeholder.com/200?text=Gia+Dung+Store'">
                            <div class="card-body d-flex flex-column">
                                <span class="badge bg-light text-secondary border w-auto mb-2 align-self-start small">
                                        ${p.category.categoryName}
                                </span>
                                <h6 class="card-title fw-bold text-dark text-truncate" title="${p.productName}">
                                        ${p.productName}
                                </h6>
                                <p class="text-danger fw-bold fs-5 mb-3">
                                    <fmt:formatNumber value="${p.price}" pattern="#,##0"/> đ
                                </p>
                                <div class="mt-auto">
                                    <a href="${pageContext.request.contextPath}/product/detail?id=${p.productID}"
                                       class="btn btn-outline-primary w-100 btn-sm fw-semibold mb-2"><fmt:message key="product.detail"/></a>
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" class="m-0">
                                        <input type="hidden" name="productId" value="${p.productID}">
                                        <input type="hidden" name="quantity" value="1">

                                        <button type="submit"
                                                class="btn btn-primary btn-sm w-100 fw-semibold"
                                            ${p.stockQuantity <= 0 ? 'disabled' : ''}>
                                            <i class="bi bi-cart-plus me-1"></i>
                                            <c:choose>
                                                <c:when test="${p.stockQuantity > 0}">
                                                    <fmt:message key="product.add_cart"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:message key="product.out_of_stock"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty products}">
                    <div class="col-12 text-center py-5 bg-white rounded-3 shadow-sm">
                        <i class="bi bi-inbox fs-1 text-muted d-block mb-2"></i>
                        <p class="text-muted mb-0"><fmt:message key="product.empty"/></p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-outline-primary mt-3">
                            <fmt:message key="product.view_all"/>
                        </a>
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