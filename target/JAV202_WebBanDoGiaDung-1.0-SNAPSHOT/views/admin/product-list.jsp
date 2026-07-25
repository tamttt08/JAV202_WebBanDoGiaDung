<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm - Admin</title>
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
    </style>
</head>
<body>

<div class="d-flex">
    <!-- SIDEBAR MENU BÊN TRÁI -->
    <div class="sidebar d-flex flex-column p-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center mb-4 me-md-auto text-white text-decoration-none px-2">
            <i class="bi bi-box-seam-fill fs-4 me-2 text-primary"></i>
            <span class="fs-5 fw-bold">GIA DỤNG ADMIN</span>
        </a>
        <hr class="text-secondary mt-0">
        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                    <i class="bi bi-speedometer2 me-2"></i>Tổng quan
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/product" class="nav-link active">
                    <i class="bi bi-box-seam me-2"></i>Sản phẩm
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/category" class="nav-link">
                    <i class="bi bi-grid me-2"></i>Danh mục
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/order" class="nav-link">
                    <i class="bi bi-receipt me-2"></i>Đơn hàng
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/account" class="nav-link">
                    <i class="bi bi-people me-2"></i>Tài khoản
                </a>
            </li>
        </ul>
        <hr class="text-secondary">
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light w-100 btn-sm text-start">
                <i class="bi bi-house me-2"></i>Xem Cửa Hàng
            </a>
        </div>
    </div>

    <!-- NỘI DUNG CHÍNH BÊN PHẢI -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-primary mb-0">
                <i class="bi bi-box-seam me-2"></i>Quản Lý Sản Phẩm
            </h3>
            <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-primary fw-semibold">
                <i class="bi bi-plus-lg me-1"></i> Thêm Sản Phẩm Mới
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-3">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 80px;">Mã</th>
                            <th style="width: 80px;">Hình ảnh</th>
                            <th>Tên Sản Phẩm</th>
                            <th>Danh Mục</th>
                            <th>Giá Bán</th>
                            <th class="text-center">Tồn Kho</th>
                            <th class="text-center" style="width: 120px;">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty products}">
                                <c:forEach var="p" items="${products}">
                                    <tr>
                                        <!-- Bỏ dấu # dư thừa khi dùng Mã ProductCode custom -->
                                        <td class="text-center fw-bold text-secondary">${p.productCode}</td>
                                        <td>
                                            <img src="${p.image}" alt="${p.productName}" class="rounded border" style="width: 50px; height: 50px; object-fit: cover;">
                                        </td>
                                        <td class="fw-semibold text-primary">${p.productName}</td>
                                        <td>
                                            <span class="badge bg-info text-dark">${p.category.categoryName}</span>
                                        </td>
                                        <td class="fw-bold text-danger">
                                            <fmt:formatNumber value="${p.price}" pattern="#,##0"/> đ
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${p.stockQuantity > 0 ? 'bg-success' : 'bg-secondary'}">
                                                    ${p.stockQuantity}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/admin/product/edit?id=${p.productID}" class="btn btn-sm btn-outline-warning me-1" title="Sửa">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/product/delete?id=${p.productID}"
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Cậu có chắc chắn muốn xóa sản phẩm này không?');" title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
                                        Chưa có sản phẩm nào. Hãy bấm nút "Thêm Sản Phẩm Mới" ở trên nhé!
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