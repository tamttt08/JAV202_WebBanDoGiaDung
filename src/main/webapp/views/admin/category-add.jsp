<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Danh Mục Mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5" style="max-width: 600px;">
    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-header bg-primary text-white py-3">
            <h5 class="card-title mb-0 fw-bold">
                <i class="bi bi-folder-plus me-2"></i>Thêm Danh Mục Mới
            </h5>
        </div>
        <div class="card-body p-4">

            <!-- Thông báo lỗi nếu có -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/category/add" method="post">

                <!-- Tên danh mục -->
                <div class="mb-3">
                    <label for="categoryName" class="form-label fw-semibold">Tên Danh Mục <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="categoryName" name="categoryName" placeholder="Nhập tên danh mục (Ví dụ: Đồ dùng nhà bếp)" required>
                </div>

                <!-- Mô tả -->
                <div class="mb-4">
                    <label for="description" class="form-label fw-semibold">Mô Tả</label>
                    <textarea class="form-control" id="description" name="description" rows="3" placeholder="Nhập mô tả ngắn về danh mục này..."></textarea>
                </div>

                <!-- Nút thao tác -->
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary">
                        Hủy Bỏ
                    </a>
                    <button type="submit" class="btn btn-primary fw-semibold">
                        <i class="bi bi-save me-1"></i> Lưu Danh Mục
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>