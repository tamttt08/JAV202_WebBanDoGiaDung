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
    <title><fmt:message key="cat_edit.title"/> - <fmt:message key="admin.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5" style="max-width: 600px;">
    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-header bg-warning text-dark py-3">
            <h5 class="card-title mb-0 fw-bold">
                <i class="bi bi-pencil-square me-2"></i><fmt:message key="cat_edit.title"/>
            </h5>
        </div>
        <div class="card-body p-4">

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/category/edit" method="post">

                <!-- ID Ẩn để phục vụ Update -->
                <input type="hidden" name="categoryId" value="${category.categoryId}">

                <!-- Mã Danh Mục (Chỉ hiển thị, không cho sửa) -->
                <div class="mb-3">
                    <label class="form-label fw-semibold"><fmt:message key="cat_edit.lbl_code"/></label>
                    <input type="text" class="form-control bg-light" value="${category.categoryCode}" readonly>
                </div>

                <!-- Tên danh mục -->
                <div class="mb-3">
                    <label for="categoryName" class="form-label fw-semibold">
                        <fmt:message key="cat_edit.lbl_name"/> <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="categoryName" name="categoryName" value="${category.categoryName}" required>
                </div>

                <!-- Mô tả -->
                <div class="mb-4">
                    <label for="description" class="form-label fw-semibold"><fmt:message key="cat_edit.lbl_desc"/></label>
                    <textarea class="form-control" id="description" name="description" rows="3">${category.description}</textarea>
                </div>

                <!-- Nút thao tác -->
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/admin/dashboard?tab=category" class="btn btn-outline-secondary">
                        <fmt:message key="cat_edit.btn_cancel"/>
                    </a>
                    <button type="submit" class="btn btn-warning fw-semibold">
                        <i class="bi bi-check-lg me-1"></i> <fmt:message key="cat_edit.btn_update"/>
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>