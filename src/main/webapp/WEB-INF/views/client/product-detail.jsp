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
    <title>${product.productName} - <fmt:message key="prod_detail.title_suffix"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .product-img {
            height: 400px;
            object-fit: contain;
            width: 100%;
            border-radius: 8px;
        }
        .price-text {
            color: #dc3545;
            font-size: 1.8rem;
            font-weight: bold;
        }
        .thumb-img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.2s ease;
            border-radius: 6px;
        }
        .thumb-img:hover, .thumb-img.active-thumb {
            border-color: #0d6efd !important;
            opacity: 0.9;
        }
        .carousel-control-prev-icon,
        .carousel-control-next-icon {
            background-color: rgba(0, 0, 0, 0.4);
            border-radius: 50%;
            padding: 15px;
        }
    </style>
</head>
<body class="bg-light">

<!-- NAVBAR ĐƠN GIẢN -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-shop me-2 text-primary"></i><fmt:message key="prod_detail.title_suffix"/>
        </a>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm">
            <i class="bi bi-arrow-left me-1"></i> <fmt:message key="prod_detail.btn_back_home"/>
        </a>
    </div>
</nav>

<div class="container my-5">
    <div class="card border-0 shadow-sm rounded-3 p-4 bg-white">
        <div class="row g-4">

            <!-- CỘT BÊN TRÁI: CAROUSEL SLIDER VÀ THUMBNAIL -->
            <div class="col-md-5">
                <div class="border rounded-3 p-2 bg-light shadow-sm">
                    <!-- CAROUSEL BANNER LƯỚT ẢNH -->
                    <div id="productCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3000">
                        <div class="carousel-inner">

                            <!-- 1. Ảnh chính (Main Image) luôn nằm ở vị trí đầu tiên -->
                            <div class="carousel-item active">
                                <img src="${product.mainImage}" class="product-img d-block w-100" alt="${product.productName}"
                                     onerror="this.src='https://via.placeholder.com/400?text=No+Image';">
                            </div>

                            <!-- 2. Danh sách các ảnh phụ (Sub Images) -->
                            <c:if test="${not empty product.images}">
                                <c:forEach var="img" items="${product.images}">
                                    <div class="carousel-item">
                                        <img src="${img.imageURL}" class="product-img d-block w-100" alt="${product.productName}"
                                             onerror="this.src='https://via.placeholder.com/400?text=No+Image';">
                                    </div>
                                </c:forEach>
                            </c:if>

                        </div>

                        <!-- NÚT LƯỚT QUA LẠI (Chỉ hiển thị khi có từ 2 ảnh trở lên) -->
                        <c:if test="${not empty product.images}">
                            <button class="carousel-control-prev" type="button" data-bs-target="#productCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#productCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </c:if>
                    </div>
                </div>

                <!-- ALBUM THUMBNAILS BÊN DƯỚI DÙNG ĐỂ CLICK XEM NHANH -->
                <c:if test="${not empty product.images}">
                    <div class="d-flex gap-2 mt-3 overflow-x-auto pb-2 justify-content-center">
                        <!-- Thumb Ảnh Chính -->
                        <img src="${product.mainImage}"
                             class="thumb-img border active-thumb"
                             data-bs-target="#productCarousel"
                             data-bs-slide-to="0"
                             onerror="this.src='https://via.placeholder.com/70';">

                        <!-- Thumb Ảnh Phụ -->
                        <c:forEach var="img" items="${product.images}" varStatus="loop">
                            <img src="${img.imageURL}"
                                 class="thumb-img border"
                                 data-bs-target="#productCarousel"
                                 data-bs-slide-to="${loop.index + 1}"
                                 onerror="this.src='https://via.placeholder.com/70';">
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <!-- CỘT BÊN PHẢI: THÔNG TIN CHI TIẾT SẢN PHẨM -->
            <div class="col-md-7 d-flex flex-column justify-content-between">
                <div>
                    <!-- Danh mục badge -->
                    <span class="badge bg-info text-dark mb-2">${product.category.categoryName}</span>

                    <!-- Tên sản phẩm -->
                    <h2 class="fw-bold text-dark mb-2">${product.productName}</h2>
                    <p class="text-muted small mb-3"><fmt:message key="prod_detail.lbl_code"/> <strong>${product.productCode}</strong></p>

                    <hr>

                    <!-- Giá tiền -->
                    <div class="mb-3">
                        <span class="price-text">
                            <fmt:formatNumber value="${product.price}" pattern="#,##0"/> đ
                        </span>
                    </div>

                    <!-- Tình trạng kho -->
                    <div class="mb-4">
                        <strong><fmt:message key="prod_detail.lbl_status"/> </strong>
                        <c:choose>
                            <c:when test="${product.stockQuantity > 0}">
                                <span class="badge bg-success">
                                    <i class="bi bi-check-circle me-1"></i><fmt:message key="prod_detail.in_stock"/> (${product.stockQuantity} <fmt:message key="prod_detail.items_unit"/>)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">
                                    <i class="bi bi-x-circle me-1"></i><fmt:message key="prod_detail.out_of_stock"/>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Mô tả sản phẩm -->
                    <div class="mb-4">
                        <h6 class="fw-bold"><fmt:message key="prod_detail.lbl_desc"/></h6>
                        <fmt:message key="prod_detail.no_desc" var="noDescMsg"/>
                        <p class="text-secondary" style="white-space: pre-line;">
                            ${empty product.description ? noDescMsg : product.description}
                        </p>
                    </div>
                </div>

                <!-- FORM CHỌN SỐ LƯỢNG VÀ THÊM VÀO GIỎ HÀNG -->
                <form action="${pageContext.request.contextPath}/cart/add" method="post" class="mt-3">
                    <input type="hidden" name="productId" value="${product.productID}">

                    <div class="row align-items-center g-3">
                        <div class="col-auto">
                            <label for="quantity" class="col-form-label fw-bold"><fmt:message key="prod_detail.lbl_quantity"/></label>
                        </div>
                        <div class="col-auto">
                            <input type="number" id="quantity" name="quantity" class="form-control text-center fw-bold"
                                   value="1" min="1" max="${product.stockQuantity}" style="width: 80px;"
                            ${product.stockQuantity <= 0 ? 'disabled' : ''}>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary btn-lg px-4 fw-bold" ${product.stockQuantity <= 0 ? 'disabled' : ''}>
                                <i class="bi bi-cart-plus me-2"></i><fmt:message key="prod_detail.btn_add_to_cart"/>
                            </button>
                        </div>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- SCRIPT ĐỒNG BỘ NÚT THUMBNAIL KHI CAROUSEL TỰ ĐỘNG CHUYỂN ẢNH -->
<script>
    const productCarousel = document.getElementById('productCarousel');
    const thumbnails = document.querySelectorAll('.thumb-img');

    if (productCarousel && thumbnails.length > 0) {
        productCarousel.addEventListener('slide.bs.carousel', function (event) {
            // Xóa viền active của tất cả thumb
            thumbnails.forEach(thumb => thumb.classList.remove('active-thumb'));
            // Thêm viền active cho thumb ứng với slide hiện tại
            thumbnails[event.to].classList.add('active-thumb');
        });
    }
</script>

</body>
</html>