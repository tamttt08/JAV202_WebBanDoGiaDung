<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-primary mb-0">
        <i class="bi bi-grid me-2"></i>Quản Lý Danh Mục Sản Phẩm
    </h3>
</div>

<div class="row g-4">
    <!-- FORM THÊM / SỬA DANH MỤC (BÊN TRÁI) -->
    <div class="col-md-5">
        <div class="card border-0 shadow-sm rounded-3">
            <div class="card-header bg-white py-3 border-0">
                <h6 class="fw-bold m-0 text-primary">
                    <i class="bi bi-pencil-square me-2"></i>Thêm / Cập Nhật Danh Mục
                </h6>
            </div>
            <div class="card-body pt-0">
                <form action="${pageContext.request.contextPath}/admin/category/add" method="post">
                    <!-- ID ẩn dùng cho trường hợp Edit -->
                    <input type="hidden" name="categoryId" value="${category != null ? category.categoryId : ''}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" name="categoryName" class="form-control"
                               placeholder="Ví dụ: Nồi chiên không dầu"
                               value="${category != null ? category.categoryName : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Mô tả</label>
                        <textarea name="description" class="form-control" rows="3"
                                  placeholder="Mô tả ngắn về danh mục...">${category != null ? category.description : ''}</textarea>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary fw-semibold">
                            <i class="bi bi-download me-1"></i> Lưu Danh Mục
                        </button>
                        <c:if test="${category != null}">
                            <a href="${pageContext.request.contextPath}/admin/category" class="btn btn-light border">Hủy chỉnh sửa</a>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- DANH SÁCH DANH MỤC (BÊN PHẢI) -->
    <div class="col-md-7">
        <div class="card border-0 shadow-sm rounded-3">
            <div class="card-header bg-white py-3 border-0">
                <h6 class="fw-bold m-0 text-secondary">
                    <i class="bi bi-list-task me-2"></i>Danh Sách Hiện Có
                </h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 70px;">Mã</th>
                            <th>Tên Danh Mục</th>
                            <th>Mô Tả</th>
                            <th class="text-center" style="width: 100px;">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty categories}">
                                <c:forEach var="c" items="${categories}">
                                    <tr>
                                        <td class="text-center fw-bold">${c.categoryCode}</td>
                                        <td class="fw-semibold text-primary">${c.categoryName}</td>
                                        <td class="text-muted text-truncate" style="max-width: 200px;" title="${c.description}">
                                                ${c.description}
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/admin/category/edit?id=${c.categoryId}"
                                               class="btn btn-sm btn-outline-warning me-1" title="Sửa">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/category/delete?id=${c.categoryId}"
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Xóa danh mục này có thể ảnh hưởng đến các sản phẩm thuộc danh mục. Cậu chắc chắn muốn xóa chứ?');"
                                               title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="text-center py-4 text-muted">
                                        Chưa có danh mục nào được tạo.
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