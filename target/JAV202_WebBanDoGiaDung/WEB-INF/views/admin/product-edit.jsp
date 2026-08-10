<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Sản Phẩm - Gia Dụng Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .sub-img-card {
            position: relative;
            transition: transform 0.2s;
        }
        .sub-img-card:hover {
            transform: scale(1.03);
        }
        .delete-checkbox-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 5px;
            padding: 2px 6px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container my-5" style="max-width: 850px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary mb-0">
            <i class="bi bi-pencil-square me-2"></i>Chỉnh Sửa Sản Phẩm #${product.productCode}
        </h3>
        <a href="${pageContext.request.contextPath}/admin/dashboard?tab=product" class="btn btn-outline-secondary btn-sm">
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
            <form action="${pageContext.request.contextPath}/admin/product/edit" method="post" enctype="multipart/form-data">

                <input type="hidden" name="productId" value="${product.productID}">
                <input type="hidden" name="productCode" value="${product.productCode}">

                <!-- TÊN SẢN PHẨM -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Tên Sản Phẩm <span class="text-danger">*</span></label>
                    <input type="text" name="productName" class="form-control" value="${product.productName}" required>
                </div>

                <div class="row">
                    <!-- GIÁ BÁN -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Giá Bán (VNĐ) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="number" step="1000" min="0" name="price" class="form-control" value="${product.price}" required>
                            <span class="input-group-text">đ</span>
                        </div>
                    </div>

                    <!-- SỐ LƯỢNG TỒN KHO -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Số Lượng Tồn Kho <span class="text-danger">*</span></label>
                        <input type="number" min="0" name="stockQuantity" class="form-control" value="${product.stockQuantity}" required>
                    </div>
                </div>

                <!-- DANH MỤC -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Danh Mục <span class="text-danger">*</span></label>
                    <select name="categoryId" class="form-select" required>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${c.categoryId == product.category.categoryId ? 'selected' : ''}>
                                    ${c.categoryName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <hr class="my-4 text-secondary">

                <!-- 1. CẬP NHẬT ẢNH CHÍNH (MAIN IMAGE) -->
                <div class="mb-4">
                    <label class="form-label fw-bold text-primary">
                        <i class="bi bi-image me-1"></i>Ảnh Đại Diện Chính Hiện Tại
                    </label>

                    <div class="d-flex align-items-center gap-3 mb-3 p-2 border rounded bg-white" style="width: fit-content;">
                        <img src="${product.mainImage}" alt="Main Image" class="rounded border" style="width: 90px; height: 90px; object-fit: cover;"
                             onerror="this.src='https://via.placeholder.com/90'">
                        <div>
                            <span class="badge bg-success mb-1">Ảnh Chính</span>
                            <div class="small text-muted text-break" style="max-width: 300px;">${product.mainImage}</div>
                        </div>
                    </div>

                    <!-- Options Đổi Ảnh Chính -->
                    <label class="form-label fw-semibold small text-secondary">Thay đổi ảnh chính (nếu muốn):</label>
                    <ul class="nav nav-pills mb-2" id="imageTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active btn-sm" id="file-tab" data-bs-toggle="pill" data-bs-target="#tab-file" type="button" role="tab">
                                <i class="bi bi-upload"></i> Tải File từ máy
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link btn-sm" id="url-tab" data-bs-toggle="pill" data-bs-target="#tab-url" type="button" role="tab">
                                <i class="bi bi-link-45deg"></i> Dùng Link URL
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="imageTabContent">
                        <div class="tab-pane fade show active" id="tab-file" role="tabpanel">
                            <input type="file" class="form-control" name="imageFile" accept="image/*">
                        </div>
                        <div class="tab-pane fade" id="tab-url" role="tabpanel">
                            <input type="text" class="form-control" name="imageUrl" value="${product.mainImage}" placeholder="Dán đường dẫn ảnh mới (https://...)">
                        </div>
                    </div>
                </div>

                <!-- 2. QUẢN LÝ ALBUM ẢNH PHỤ (SUB IMAGES) -->
                <div class="mb-4 p-3 bg-white border rounded-3">
                    <label class="form-label fw-bold text-secondary mb-3">
                        <i class="bi bi-images me-1"></i>Album Ảnh Chi Tiết Hiện Tại
                    </label>

                    <!-- Danh sách ảnh phụ hiện có -->
                    <c:choose>
                        <c:when test="${not empty product.images}">
                            <div class="row g-3 mb-3">
                                <c:forEach var="img" items="${product.images}">
                                    <div class="col-6 col-sm-4 col-md-3">
                                        <div class="card h-100 sub-img-card border shadow-sm">
                                            <img src="${img.imageURL}"
                                                 class="card-img-top p-1 rounded"
                                                 style="height: 100px; object-fit: cover;"
                                                 onerror="this.src='https://via.placeholder.com/100?text=Loi+Anh'">
                                            <div class="card-body p-2 text-center bg-light">
                                                <div class="form-check d-inline-block text-danger small">
                                                    <input class="form-check-input" type="checkbox" name="deleteSubImageIds" value="${img.imageID}" id="delImg_${img.imageID}">
                                                    <label class="form-check-label fw-bold" for="delImg_${img.imageID}">
                                                        Xóa ảnh này
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted small fst-italic mb-3">Sản phẩm này chưa có ảnh phụ nào.</p>
                        </c:otherwise>
                    </c:choose>

                    <!-- Thêm ảnh phụ mới -->
                    <label class="form-label fw-semibold small text-primary">Tải thêm ảnh phụ mới vào album:</label>
                    <input type="file" class="form-control" name="subImages" accept="image/*" multiple>
                    <div class="form-text text-muted">Giữ phím <strong>Ctrl</strong> (hoặc <strong>Cmd</strong>) để chọn thêm nhiều ảnh phụ cùng lúc.</div>
                </div>

                <!-- MÔ TẢ SẢN PHẨM -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">Mô Tả Sản Phẩm</label>
                    <textarea name="description" class="form-control" rows="4">${product.description}</textarea>
                </div>

                <!-- NÚT XỬ LÝ -->
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/admin/dashboard?tab=product" class="btn btn-light border px-4">Hủy</a>
                    <button type="submit" class="btn btn-primary fw-bold px-4">
                        <i class="bi bi-check-lg me-1"></i> Lưu Thay Đổi
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>