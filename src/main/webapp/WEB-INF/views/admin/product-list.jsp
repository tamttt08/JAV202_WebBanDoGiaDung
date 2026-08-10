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
    <title><fmt:message key="prod_list.title"/> - <fmt:message key="admin.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        .sidebar {
            width: 260px;
            background-color: #212529;
            min-height: 100vh;
        }
        .sidebar .nav-link {
            color: #adb5bd;
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 4px;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: #fff;
            background-color: #0d6efd;
        }
        .main-content {
            flex: 1;
            padding: 25px;
        }
        .product-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 6px;
        }
    </style>
</head>
<body>

<div class="d-flex">
    <!-- SIDEBAR MENU BÊN TRÁI -->
    <div class="sidebar d-flex flex-column p-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center mb-4 me-md-auto text-white text-decoration-none px-2">
            <i class="bi bi-box-seam-fill fs-4 me-2 text-primary"></i>
            <span class="fs-5 fw-bold"><fmt:message key="admin.brand_title"/></span>
        </a>
        <hr class="text-secondary mt-0">
        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                    <i class="bi bi-speedometer2 me-2"></i><fmt:message key="admin.nav_dashboard"/>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/product" class="nav-link active">
                    <i class="bi bi-box-seam me-2"></i><fmt:message key="admin.nav_products"/>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/category" class="nav-link">
                    <i class="bi bi-grid me-2"></i><fmt:message key="admin.nav_categories"/>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/order" class="nav-link">
                    <i class="bi bi-receipt me-2"></i><fmt:message key="admin.nav_orders"/>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/account" class="nav-link">
                    <i class="bi bi-people me-2"></i><fmt:message key="admin.nav_accounts"/>
                </a>
            </li>
        </ul>
        <hr class="text-secondary">
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light w-100 btn-sm text-start" target="_blank">
                <i class="bi bi-house me-2"></i><fmt:message key="admin.view_store"/> <i class="bi bi-box-arrow-up-right ms-auto small"></i>
            </a>
        </div>
    </div>

    <!-- NỘI DUNG CHÍNH BÊN PHẢI -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-primary mb-1">
                    <i class="bi bi-box-seam me-2"></i><fmt:message key="prod_list.title"/>
                </h3>
                <p class="text-muted small mb-0"><fmt:message key="prod_list.sub_title"/></p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-primary fw-semibold shadow-sm">
                <i class="bi bi-plus-lg me-1"></i> <fmt:message key="prod_list.btn_add"/>
            </a>
        </div>

        <!-- THÔNG BÁO THÀNH CÔNG / LỖI NẾU CÓ -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- BẢNG DANH SÁCH -->
        <div class="card border-0 shadow-sm rounded-3">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 100px;"><fmt:message key="prod_list.th_code"/></th>
                            <th style="width: 80px;"><fmt:message key="prod_list.th_image"/></th>
                            <th><fmt:message key="prod_list.th_name"/></th>
                            <th><fmt:message key="prod_list.th_category"/></th>
                            <th><fmt:message key="prod_list.th_price"/></th>
                            <th class="text-center"><fmt:message key="prod_list.th_stock"/></th>
                            <th class="text-center" style="width: 130px;"><fmt:message key="prod_list.th_action"/></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty products}">
                                <c:forEach var="p" items="${products}">
                                    <tr>
                                        <!-- Mã SP -->
                                        <td class="text-center fw-bold text-secondary">
                                            <span class="badge bg-light text-dark border">${p.productCode}</span>
                                        </td>

                                        <!-- Ảnh Đại Diện -->
                                        <td>
                                            <img src="${p.mainImage}" alt="${p.productName}" class="product-img border"
                                                 onerror="this.src='https://via.placeholder.com/50?text=No+Img'">
                                        </td>

                                        <!-- Tên SP -->
                                        <td>
                                            <div class="fw-semibold text-dark mb-0">${p.productName}</div>
                                            <c:if test="${not empty p.images}">
                                                <small class="text-muted"><i class="bi bi-images me-1"></i>${p.images.size()} <fmt:message key="prod_list.sub_images_count"/></small>
                                            </c:if>
                                        </td>

                                        <!-- Danh Mục -->
                                        <td>
                                            <span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">
                                                    ${p.category.categoryName}
                                            </span>
                                        </td>

                                        <!-- Giá Bán -->
                                        <td class="fw-bold text-danger">
                                            <fmt:formatNumber value="${p.price}" pattern="#,##0"/> đ
                                        </td>

                                        <!-- Số Lượng Tồn Kho -->
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${p.stockQuantity > 5}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                            ${p.stockQuantity}
                                                    </span>
                                                </c:when>
                                                <c:when test="${p.stockQuantity > 0}">
                                                    <fmt:message key="prod_list.low_stock_title" var="lowStockTitle"/>
                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-2 py-1" title="${lowStockTitle}">
                                                            ${p.stockQuantity}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                        <fmt:message key="prod_list.out_of_stock"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Nút Thao Tác -->
                                        <td class="text-center">
                                            <fmt:message key="prod_list.btn_edit" var="titleEdit"/>
                                            <a href="${pageContext.request.contextPath}/admin/product/edit?id=${p.productID}"
                                               class="btn btn-sm btn-outline-primary me-1" title="${titleEdit}">
                                                <i class="bi bi-pencil"></i>
                                            </a>

                                            <fmt:message key="prod_list.btn_delete" var="titleDelete"/>
                                            <fmt:message key="prod_list.confirm_delete" var="confirmDeleteMsg">
                                                <fmt:param value="${p.productName}"/>
                                            </fmt:message>
                                            <a href="${pageContext.request.contextPath}/admin/product/delete?id=${p.productID}"
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('${confirmDeleteMsg}');"
                                               title="${titleDelete}">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                        <fmt:message key="prod_list.empty_msg"/><br>
                                        <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-sm btn-primary mt-2">
                                            <i class="bi bi-plus-lg me-1"></i><fmt:message key="prod_list.btn_add_first"/>
                                        </a>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>