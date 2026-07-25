<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Sửa Sản Phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">
<h2>Chỉnh Sửa Sản Phẩm</h2>

<form action="${pageContext.request.contextPath}/admin/product/edit" method="post">
    <!-- Input ẩn lưu ID sản phẩm -->
    <input type="hidden" name="id" value="${product.productID}">

    <div class="mb-3">
        <label class="form-label">Tên sản phẩm:</label>
        <input type="text" name="name" class="form-control" value="${product.productName}" required>
    </div>

    <div class="mb-3">
        <label class="form-label">Danh mục:</label>
        <select name="categoryId" class="form-select" required>
            <c:forEach var="c" items="${categories}">
                <option value="${c.categoryId}" ${c.categoryId == product.category.categoryId ? 'selected' : ''}>
                        ${c.categoryName}
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label class="form-label">Giá bán:</label>
        <input type="number" step="0.01" name="price" class="form-control" value="${product.price}" required>
    </div>

    <div class="mb-3">
        <label class="form-label">Số lượng tồn kho:</label>
        <input type="number" name="quantity" class="form-control" value="${product.stockQuantity}" required>
    </div>

    <div class="mb-3">
        <label class="form-label">Đường dẫn hình ảnh (URL):</label>
        <input type="text" name="image" class="form-control" value="${product.image}">
    </div>

    <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">Hủy</a>
</form>
</body>
</html>