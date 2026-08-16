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

<!-- THỐNG KÊ TOP 5 SẢN PHẨM BÁN CHẠY -->
<div class="card border-0 shadow-sm rounded-3">
    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
        <h5 class="fw-bold text-secondary mb-0">
            <i class="bi bi-trophy-fill text-warning me-2"></i><fmt:message key="overview.top5_title"/>
        </h5>

        <!-- Bộ Lọc Thời Gian -->
        <div class="d-flex align-items-center gap-2">
            <select id="filterRange" class="form-select form-select-sm shadow-sm" style="width: auto;" onchange="filterTopSelling(this.value)">
                <option value="all" ${param.filterRange eq 'all' ? 'selected' : ''}><fmt:message key="overview.filter_all"/></option>
                <option value="today" ${param.filterRange eq 'today' ? 'selected' : ''}><fmt:message key="overview.filter_today"/></option>
                <option value="this_month" ${param.filterRange eq 'this_month' ? 'selected' : ''}><fmt:message key="overview.filter_month"/></option>
                <option value="this_year" ${param.filterRange eq 'this_year' ? 'selected' : ''}><fmt:message key="overview.filter_year"/></option>
            </select>
            <span class="badge bg-primary-subtle text-primary rounded-pill px-3 py-2"><fmt:message key="overview.top5_badge"/></span>
        </div>
    </div>

    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-3" style="width: 10%;"><fmt:message key="overview.col_rank"/></th>
                    <th style="width: 40%;"><fmt:message key="overview.col_product"/></th>
                    <th style="width: 20%;"><fmt:message key="overview.col_price"/></th>
                    <th class="text-center" style="width: 15%;"><fmt:message key="overview.col_sold"/></th>
                    <th class="text-end pe-3" style="width: 15%;"><fmt:message key="overview.col_est_revenue"/></th>
                </tr>
                </thead>
                <tbody id="top5TableBody">
                <c:forEach var="p" items="${top5Products}" varStatus="loop">
                    <tr>
                        <!-- Thứ hạng kèm Huy chương cho Top 3 -->
                        <td class="ps-3 fw-bold">
                            <c:choose>
                                <c:when test="${loop.index == 0}">
                                    <span class="badge bg-warning text-dark"><i class="bi bi-award-fill me-1"></i>#1</span>
                                </c:when>
                                <c:when test="${loop.index == 1}">
                                    <span class="badge bg-secondary"><i class="bi bi-award-fill me-1"></i>#2</span>
                                </c:when>
                                <c:when test="${loop.index == 2}">
                                    <span class="badge bg-danger-subtle text-danger"><i class="bi bi-award-fill me-1"></i>#3</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="ms-2">#${loop.index + 1}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Tên & Hình ảnh sản phẩm -->
                        <td>
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/assets/images/${not empty p.mainImage ? p.mainImage : p.image}"
                                     alt="${not empty p.productName ? p.productName : p.name}"
                                     class="rounded border me-3"
                                     style="width: 48px; height: 48px; object-fit: cover;"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/default.png'">
                                <span class="fw-semibold text-dark">
                                        ${not empty p.productName ? p.productName : p.name}
                                </span>
                            </div>
                        </td>

                        <!-- Giá bán -->
                        <td>
                            <fmt:formatNumber value="${p.price}" pattern="#,##0"/> đ
                        </td>

                        <!-- Số lượng bán -->
                        <td class="text-center">
                                <span class="badge bg-success-subtle text-success fw-bold fs-6 px-3 py-1 rounded-pill">
                                        ${not empty p.totalSold ? p.totalSold : 0}
                                </span>
                        </td>

                        <!-- Doanh thu tạm tính -->
                        <td class="text-end pe-3 fw-bold text-primary">
                            <fmt:formatNumber value="${p.price * (not empty p.totalSold ? p.totalSold : 0)}" pattern="#,##0"/> đ
                        </td>
                    </tr>
                </c:forEach>

                <!-- Khối thông báo nếu trống dữ liệu -->
                <c:if test="${empty top5Products}">
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted">
                            <i class="bi bi-inbox fs-3 d-block mb-2"></i> <fmt:message key="overview.no_data"/>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<fmt:message key="overview.loading" var="jsLoading"/>
<fmt:message key="overview.err_loading" var="jsErrLoading"/>

<!-- SCRIPT LỌC AJAX DÀNH CHO TRANG SINGLE PAGE -->
<script>
    function filterTopSelling(range) {
        const tableBody = document.getElementById('top5TableBody');

        // Spinner trạng thái đang tải
        tableBody.innerHTML = `
            <tr>
                <td colspan="5" class="text-center py-4">
                    <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>
                    <span class="text-muted">${jsLoading}</span>
                </td>
            </tr>
        `;

        // Gọi ngầm tới Servlet
        fetch(`${pageContext.request.contextPath}/admin/overview?filterRange=` + range, {
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newBody = doc.getElementById('top5TableBody');

                if (newBody) {
                    tableBody.innerHTML = newBody.innerHTML;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                tableBody.innerHTML = `
                <tr>
                    <td colspan="5" class="text-center py-4 text-danger">
                        <i class="bi bi-exclamation-triangle me-1"></i> ${jsErrLoading}
                    </td>
                </tr>
            `;
            });
    }
</script>