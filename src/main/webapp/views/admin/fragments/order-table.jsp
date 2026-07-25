<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-primary mb-0">
        <i class="bi bi-receipt me-2"></i>Quản Lý Đơn Hàng
    </h3>
</div>

<div class="card border-0 shadow-sm rounded-3">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="text-center" style="width: 80px;">Mã Đơn</th>
                    <th>Khách Hàng</th>
                    <th>Ngày Đặt</th>
                    <th>Tổng Tiền</th>
                    <th class="text-center">Trạng Thái</th>
                    <th class="text-center" style="width: 150px;">Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td class="text-center fw-bold">#${o.orderID}</td>
                                <td>
                                    <div class="fw-semibold text-dark">${o.account.fullname}</div>
                                    <small class="text-muted"><i class="bi bi-telephone me-1"></i>${o.phone}</small>
                                </td>
                                <td class="text-muted">
                                    <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td class="fw-bold text-danger">
                                    <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${o.status eq 'Pending' or o.status eq 'Chờ xử lý'}">
                                            <span class="badge bg-warning text-dark"><i class="bi bi-clock me-1"></i>Chờ xử lý</span>
                                        </c:when>
                                        <c:when test="${o.status eq 'Shipping' or o.status eq 'Đang giao'}">
                                            <span class="badge bg-info text-dark"><i class="bi bi-truck me-1"></i>Đang giao</span>
                                        </c:when>
                                        <c:when test="${o.status eq 'Completed' or o.status eq 'Đã giao'}">
                                            <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Đã giao</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i>Đã hủy</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-primary me-1" title="Xem chi tiết đơn">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-success" title="Duyệt / Đổi trạng thái">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                Chưa có đơn hàng nào trong hệ thống.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>