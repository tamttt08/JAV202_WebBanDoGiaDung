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

<!-- THỐNG KÊ TOP 5 SẢN PHẨM BÁN CHẠY & BỘ LỌC THỜI GIAN -->
<div class="card border-0 shadow-sm rounded-3">
    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
        <h5 class="fw-bold text-secondary mb-0">
            <i class="bi bi-trophy-fill text-warning me-2"></i><fmt:message key="overview.top5_title"/>
        </h5>

        <div class="d-flex align-items-center gap-2">
            <!-- Ô chọn ngày cụ thể -->
            <input type="date" id="filterDate" class="form-control form-control-sm" style="width: auto;" value="${filterDate}">

            <!-- Select chọn mốc thời gian -->
            <select id="filterRange" class="form-select form-select-sm" style="width: auto;">
                <option value="all" ${filterRange eq 'all' ? 'selected' : ''}><fmt:message key="overview.filter_all"/></option>
                <option value="today" ${filterRange eq 'today' ? 'selected' : ''}><fmt:message key="overview.filter_today"/></option>
                <option value="this_month" ${filterRange eq 'this_month' ? 'selected' : ''}><fmt:message key="overview.filter_month"/></option>
                <option value="this_year" ${filterRange eq 'this_year' ? 'selected' : ''}><fmt:message key="overview.filter_year"/></option>
            </select>
        </div>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-3"><fmt:message key="overview.col_rank"/></th>
                    <th><fmt:message key="overview.col_product"/></th>
                    <th><fmt:message key="overview.col_price"/></th>
                    <th class="text-center"><fmt:message key="overview.col_sold"/></th>
                    <th class="text-end pe-3"><fmt:message key="overview.col_est_revenue"/></th>
                </tr>
                </thead>
                <tbody id="top5TableBody">
                <c:forEach var="item" items="${top5Products}" varStatus="loop">
                    <c:set var="p" value="${item[0]}" />
                    <c:set var="soldQty" value="${item[1]}" />
                    <tr>
                        <td class="ps-3 fw-bold">
                            <c:choose>
                                <c:when test="${loop.index == 0}"><span class="badge bg-warning text-dark">#1</span></c:when>
                                <c:when test="${loop.index == 1}"><span class="badge bg-secondary">#2</span></c:when>
                                <c:when test="${loop.index == 2}"><span class="badge bg-danger-subtle text-danger">#3</span></c:when>
                                <c:otherwise><span class="ms-2">#${loop.index + 1}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="d-flex align-items-center">
                                <img src="${p.mainImage}"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/default-product.jpg'"
                                     class="rounded border me-3" style="width: 48px; height: 48px; object-fit: cover;">
                                <span class="fw-semibold">${p.productName}</span>
                            </div>
                        </td>
                        <td><fmt:formatNumber value="${p.price}" pattern="#,##0"/> đ</td>
                        <td class="text-center"><span class="badge bg-success-subtle text-success">${soldQty}</span></td>
                        <td class="text-end pe-3 fw-bold text-primary">
                            <fmt:formatNumber value="${p.price * soldQty}" pattern="#,##0"/> đ
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty top5Products}">
                    <tr><td colspan="5" class="text-center py-4 text-muted"><fmt:message key="overview.no_data"/></td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>