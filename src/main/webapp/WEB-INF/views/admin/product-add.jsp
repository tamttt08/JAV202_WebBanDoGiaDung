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
    <title><fmt:message key="prod_add.title"/> - <fmt:message key="admin.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container my-5" style="max-width: 850px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary mb-0">
            <i class="bi bi-plus-square-fill me-2"></i><fmt:message key="prod_add.title"/>
        </h3>
        <a href="${pageContext.request.contextPath}/admin/dashboard?tab=product" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> <fmt:message key="prod_add.btn_back"/>
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
            <form action="${pageContext.request.contextPath}/admin/product/add" method="post" enctype="multipart/form-data">

                <!-- TÊN SẢN PHẨM -->
                <div class="mb-3">
                    <label class="form-label fw-semibold"><fmt:message key="prod_add.lbl_name"/> <span class="text-danger">*</span></label>
                    <fmt:message key="prod_add.ph_name" var="phName"/>
                    <input type="text" name="productName" class="form-control" placeholder="${phName}" required>
                </div>

                <div class="row">
                    <!-- GIÁ BÁN -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold"><fmt:message key="prod_add.lbl_price"/> <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <fmt:message key="prod_add.ph_price" var="phPrice"/>
                            <input type="number" name="price" step="1000" min="0" class="form-control" placeholder="${phPrice}" required>
                            <span class="input-group-text">đ</span>
                        </div>
                    </div>

                    <!-- SỐ LƯỢNG TỒN KHO -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold"><fmt:message key="prod_add.lbl_stock"/> <span class="text-danger">*</span></label>
                        <input type="number" name="stockQuantity" min="0" value="10" class="form-control" required>
                    </div>
                </div>

                <!-- DANH MỤC -->
                <div class="mb-3">
                    <label class="form-label fw-semibold"><fmt:message key="prod_add.lbl_category"/> <span class="text-danger">*</span></label>
                    <select name="categoryId" class="form-select" required>
                        <option value="" selected disabled><fmt:message key="prod_add.opt_select_category"/></option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}">${c.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>

                <hr class="my-4 text-secondary">

                <!-- 1. ẢNH ĐẠI DIỆN CHÍNH (MAIN IMAGE) -->
                <div class="mb-4">
                    <label class="form-label fw-bold text-primary">
                        <i class="bi bi-image me-1"></i><fmt:message key="prod_add.sec_main_img"/> <span class="text-danger">*</span>
                    </label>

                    <!-- Tab chọn phương thức cho ảnh chính -->
                    <ul class="nav nav-pills mb-2" id="imageTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active btn-sm" id="file-tab" data-bs-toggle="pill" data-bs-target="#tab-file" type="button" role="tab">
                                <i class="bi bi-upload"></i> <fmt:message key="prod_add.tab_upload"/>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link btn-sm" id="url-tab" data-bs-toggle="pill" data-bs-target="#tab-url" type="button" role="tab">
                                <i class="bi bi-link-45deg"></i> <fmt:message key="prod_add.tab_url"/>
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="imageTabContent">
                        <!-- Option 1: Upload File -->
                        <div class="tab-pane fade show active" id="tab-file" role="tabpanel">
                            <input type="file" class="form-control" name="imageFile" accept="image/*">
                        </div>

                        <!-- Option 2: Nhập Link -->
                        <div class="tab-pane fade" id="tab-url" role="tabpanel">
                            <fmt:message key="prod_add.ph_url" var="phUrl"/>
                            <input type="text" class="form-control" name="imageUrl" placeholder="${phUrl}">
                        </div>
                    </div>
                </div>

                <!-- 2. ALBUM ẢNH PHỤ CHI TIẾT (SUB IMAGES) -->
                <div class="mb-4 p-3 bg-white border rounded-3">
                    <label class="form-label fw-bold text-secondary">
                        <i class="bi bi-images me-1"></i><fmt:message key="prod_add.sec_sub_imgs"/>
                    </label>
                    <input type="file" class="form-control" name="subImages" accept="image/*" multiple>
                    <div class="form-text text-muted">
                        <i class="bi bi-info-circle me-1"></i>
                        <fmt:message key="prod_add.sub_imgs_note"/>
                    </div>
                </div>

                <!-- MÔ TẢ SẢN PHẨM -->
                <div class="mb-4">
                    <label class="form-label fw-semibold"><fmt:message key="prod_add.lbl_desc"/></label>
                    <fmt:message key="prod_add.ph_desc" var="phDesc"/>
                    <textarea name="description" class="form-control" rows="4" placeholder="${phDesc}"></textarea>
                </div>

                <!-- NÚT XỬ LÝ -->
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/admin/dashboard?tab=product" class="btn btn-light border px-4">
                        <fmt:message key="prod_add.btn_cancel"/>
                    </a>
                    <button type="submit" class="btn btn-primary fw-bold px-4">
                        <i class="bi bi-check-lg me-1"></i> <fmt:message key="prod_add.btn_save"/>
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>