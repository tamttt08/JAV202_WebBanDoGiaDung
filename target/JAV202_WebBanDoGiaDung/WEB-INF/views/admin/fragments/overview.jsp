<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-primary mb-0">
        <i class="bi bi-speedometer2 me-2"></i><fmt:message key="overview.title"/>
    </h3>
</div>

<!-- CÁC THẺ THỐNG KÊ ĐỘNG -->
<div class="row g-3 mb-4">
    <!-- 1. TỔNG SẢN PHẨM -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm rounded-3 bg-primary text-white">
            <div class="card-body p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-white-50 small mb-1"><fmt:message key="overview.total_products"/></h6>
                        <h3 class="fw-bold mb-0">${totalProducts}</h3>
                    </div>
                    <i class="bi bi-box-seam fs-1 text-white-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- 2. ĐƠN HÀNG MỚI (CHỜ XỬ LÝ) -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm rounded-3 bg-success text-white">
            <div class="card-body p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-white-50 small mb-1"><fmt:message key="overview.pending_orders"/></h6>
                        <h3 class="fw-bold mb-0">${pendingOrders}</h3>
                    </div>
                    <i class="bi bi-cart-check fs-1 text-white-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. TỔNG KHÁCH HÀNG -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm rounded-3 bg-warning text-dark">
            <div class="card-body p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-dark-50 small mb-1"><fmt:message key="overview.total_customers"/></h6>
                        <h3 class="fw-bold mb-0">${totalCustomers}</h3>
                    </div>
                    <i class="bi bi-people fs-1 text-dark-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- 4. DOANH THU -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm rounded-3 bg-danger text-white">
            <div class="card-body p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-white-50 small mb-1"><fmt:message key="overview.revenue"/></h6>
                        <h3 class="fw-bold mb-0">
                            <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> đ
                        </h3>
                    </div>
                    <i class="bi bi-cash-stack fs-1 text-white-50"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm rounded-3 p-4">
    <h5 class="fw-bold text-secondary mb-3">
        <i class="bi bi-info-circle me-2"></i><fmt:message key="overview.welcome_title"/>
    </h5>
    <p class="text-muted mb-0"><fmt:message key="overview.welcome_desc"/></p>
</div>