<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Sản Phẩm Mới - Gia Dụng Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container my-5" style="max-width: 800px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary mb-0">
            <i class="bi bi-plus-square-fill me-2"></i>Thêm Sản Phẩm Mới
        </h3>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <!-- BÁO LỖI NẾU CÓ -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/admin/product/add" method="post">

                <!-- TÊN SẢN PHẨM -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Tên Sản Phẩm <span class="text-danger">*</span></label>
                    <input type="text" name="productName" class="form-control" placeholder="Ví dụ: Nồi chiên không dầu Philips 4.1L" required>
                </div>

                <div class="row">
                    <!-- GIÁ BÁN -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Giá Bán (VNĐ) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="number" name="price" step="1000" min="0" class="form-control" placeholder="2500000" required>
                            <span class="input-group-text">đ</span>
                        </div>
                    </div>

                    <!-- SỐ LƯỢNG TỒN KHO -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Số Lượng Tồn Kho <span class="text-danger">*</span></label>
                        <input type="number" name="stockQuantity" min="0" value="10" class="form-control" required>
                    </div>
                </div>

                <div class="row">
                    <!-- DANH MỤC -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Danh Mục <span class="text-danger">*</span></label>
                        <select name="categoryId" class="form-select" required>
                            <option value="" selected disabled>-- Chọn danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}">${c.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- URL HÌNH ẢNH -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Link Hình Ảnh (URL)</label>
                        <input type="text" name="image" class="form-control" placeholder="https://example.com/hinh-anh.jpg">
                    </div>
                </div>

                <!-- MÔ TẢ SẢN PHẨM -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">Mô Tả Sản Phẩm</label>
                    <textarea name="description" class="form-control" rows="4" placeholder="Nhập chi tiết thông số, đặc điểm nổi bật..."></textarea>
                </div>

                <!-- NÚT XỬ LÝ -->
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-light border px-4">Hủy</a>
                    <button type="submit" class="btn btn-primary fw-bold px-4">
                        <i class="bi bi-check-lg me-1"></i> Lưu Sản Phẩm
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>