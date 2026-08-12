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
    <title>Đơn Hàng Của Tôi - GIA DỤNG STORE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-shop me-2"></i>GIA DỤNG STORE
        </a>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light btn-sm">
            <i class="bi bi-cart3 me-1"></i> Giỏ hàng của tôi
        </a>
    </div>
</nav>

<div class="container my-4">
    <h3 class="fw-bold mb-4"><i class="bi bi-box-seam me-2"></i>Đơn Hàng Của Tôi</h3>

    <!-- THANH TAB TRẠNG THÁI -->
    <ul class="nav nav-tabs mb-4 bg-white rounded shadow-sm px-3 pt-2 border-0">
        <li class="nav-item">
            <a class="nav-link ${empty activeTab || activeTab == 'all' ? 'active fw-bold text-primary border-bottom border-primary border-3' : 'text-dark'}"
               href="${pageContext.request.contextPath}/orders?tab=all">Tất cả</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'pending_payment' ? 'active fw-bold text-primary border-bottom border-primary border-3' : 'text-dark'}"
               href="${pageContext.request.contextPath}/orders?tab=pending_payment">Chờ thanh toán</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'pending_ship' ? 'active fw-bold text-primary border-bottom border-primary border-3' : 'text-dark'}"
               href="${pageContext.request.contextPath}/orders?tab=pending_ship">Chờ vận chuyển</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'shipping' ? 'active fw-bold text-primary border-bottom border-primary border-3' : 'text-dark'}"
               href="${pageContext.request.contextPath}/orders?tab=shipping">Chờ nhận</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'completed' ? 'active fw-bold text-primary border-bottom border-primary border-3' : 'text-dark'}"
               href="${pageContext.request.contextPath}/orders?tab=completed">Gửi đánh giá</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'returned' ? 'active fw-bold text-primary border-bottom border-primary border-3' : 'text-dark'}"
               href="${pageContext.request.contextPath}/orders?tab=returned">Trả hàng</a>
        </li>
    </ul>

    <!-- DANH SÁCH ĐƠN HÀNG THEO TAB -->
    <div class="row">
        <div class="col-12">
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="card border-0 shadow-sm p-5 text-center bg-white rounded-3">
                        <i class="bi bi-receipt text-muted display-1 mb-3"></i>
                        <h5 class="text-secondary">Không có đơn hàng nào</h5>
                        <p class="text-muted">Bạn chưa có đơn hàng nào trong trạng thái này.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4 mt-2">
                                Mua sắm ngay
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="order" items="${orders}">
                        <div class="card border-0 shadow-sm rounded-3 mb-3 p-4 bg-white">
                            <!-- Header đơn hàng (Sử dụng orderID thay vì orderCode để tránh lỗi nếu entity không có) -->
                            <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                                <span class="fw-bold text-secondary">Mã đơn hàng: #${order.orderID}</span>
                                <span class="badge bg-warning text-dark px-3 py-2">${order.status}</span>
                            </div>

                            <!-- Danh sách sản phẩm trong đơn -->
                            <c:forEach var="detail" items="${order.orderDetails}">
                                <div class="d-flex align-items-center mb-3">
                                    <img src="${detail.product.mainImage}" alt="${detail.product.productName}"
                                         style="width: 65px; height: 65px; object-fit: contain;" class="rounded border me-3">
                                    <div class="flex-grow-1">
                                        <div class="fw-bold text-dark">${detail.product.productName}</div>
                                        <div class="text-muted small">Phân loại / Số lượng: x${detail.quantity}</div>
                                    </div>
                                    <div class="fw-bold text-end">
                                        <fmt:formatNumber value="${detail.unitPrice}" type="number" groupingUsed="true"/> đ
                                    </div>
                                </div>
                            </c:forEach>

                            <hr>
                            <!-- Tổng tiền và nút hành động tương ứng với từng trạng thái -->
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-muted">Thành tiền: </span>
                                    <span class="fw-bold fs-4 text-danger">
                                        <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> đ
                                    </span>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${order.status.name() == 'PENDING_PAYMENT'}">
                                            <a href="${pageContext.request.contextPath}/checkout?orderId=${order.orderID}" class="btn btn-primary btn-sm fw-bold px-3">Thanh toán ngay</a>
                                        </c:when>
                                        <c:when test="${order.status.name() == 'SHIPPING'}">
                                            <button class="btn btn-success btn-sm fw-bold px-3">Đã nhận được hàng</button>
                                        </c:when>
                                        <c:when test="${order.status.name() == 'COMPLETED'}">
                                            <button class="btn btn-outline-primary btn-sm fw-bold px-3">Gửi đánh giá</button>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>