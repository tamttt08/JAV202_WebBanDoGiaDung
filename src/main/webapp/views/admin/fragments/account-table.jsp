<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-primary mb-0">
        <i class="bi bi-people me-2"></i>Quản Lý Tài Khoản
    </h3>
    <button class="btn btn-primary fw-semibold">
        <i class="bi bi-person-plus me-1"></i> Thêm Tài Khoản
    </button>
</div>

<div class="card border-0 shadow-sm rounded-3">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="text-center" style="width: 80px;">Mã</th>
                    <th>Tên Đăng Nhập</th>
                    <th class="text-center">Vai Trò</th>
                    <th class="text-center">Ngày Tạo</th>
                    <th class="text-center">Trạng Thái</th>
                    <th class="text-center" style="width: 120px;">Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty accounts}">
                        <c:forEach var="acc" items="${accounts}">
                            <tr>
                                <td class="text-center fw-bold">#${acc.accountID}</td>
                                <td class="fw-semibold text-dark">
                                    <i class="bi bi-person-circle text-secondary me-2"></i>${acc.username}
                                </td>

                                <!-- HIỂN THỊ VAI TRÒ (Enum: Customer, Staff, Manager) -->
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${acc.role eq 'Manager'}">
                                            <span class="badge bg-danger">Quản lý</span>
                                        </c:when>
                                        <c:when test="${acc.role eq 'Staff'}">
                                            <span class="badge bg-primary">Nhân viên</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Khách hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- NGÀY TẠO -->
                                <td class="text-center text-muted">
                                    ${acc.createdAt != null ? acc.createdAt.toString().substring(0, 16).replace('T', ' ') : ''}
                                </td>

                                <!-- TRẠNG THÁI -->
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${acc.active}">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Bị khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- HÀNH ĐỘNG -->
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-primary me-1" title="Sửa quyền">
                                        <i class="bi bi-shield-lock"></i>
                                    </button>
                                    <c:choose>
                                        <c:when test="${acc.active}">
                                            <button class="btn btn-sm btn-outline-danger" title="Khóa tài khoản">
                                                <i class="bi bi-lock-fill"></i>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-sm btn-outline-success" title="Mở khóa">
                                                <i class="bi bi-unlock-fill"></i>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                Chưa có dữ liệu tài khoản.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>