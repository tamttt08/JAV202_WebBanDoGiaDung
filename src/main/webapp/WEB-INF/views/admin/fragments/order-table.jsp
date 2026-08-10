<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-primary mb-0">
        <i class="bi bi-receipt me-2"></i><fmt:message key="order.manage_title"/>
    </h3>
</div>

<!-- THÔNG BÁO THÀNH CÔNG / LỖI -->
<c:if test="${not empty sessionScope.message}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle me-1"></i> ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="message" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle me-1"></i> ${sessionScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="error" scope="session"/>
</c:if>

<div class="card border-0 shadow-sm rounded-3">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="text-center" style="width: 80px;"><fmt:message key="order.col_id"/></th>
                    <th><fmt:message key="order.col_customer"/></th>
                    <th><fmt:message key="order.col_date"/></th>
                    <th><fmt:message key="order.col_total"/></th>
                    <th class="text-center"><fmt:message key="order.col_status"/></th>
                    <th class="text-center" style="width: 150px;"><fmt:message key="order.col_actions"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td class="text-center fw-bold">#${o.orderID}</td>
                                <td>
                                    <div class="fw-semibold text-dark">
                                        <c:choose>
                                            <c:when test="${not empty o.receiverName}">
                                                <c:out value="${o.receiverName}" />
                                            </c:when>
                                            <c:when test="${not empty o.customer && not empty o.customer.fullName}">
                                                <c:out value="${o.customer.fullName}" />
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message key="order.default_guest"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <small class="text-muted">
                                        <i class="bi bi-telephone me-1"></i>
                                        <c:choose>
                                            <c:when test="${not empty o.receiverPhone}">
                                                <c:out value="${o.receiverPhone}" />
                                            </c:when>
                                            <c:when test="${not empty o.customer && not empty o.customer.phone}">
                                                <c:out value="${o.customer.phone}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="fst-italic text-secondary"><fmt:message key="order.no_phone"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </td>

                                <td class="text-muted">
                                        ${o.formattedOrderDate}
                                </td>

                                <td class="fw-bold text-danger">
                                    <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ
                                </td>

                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${o.status == 'Pending'}">
                                            <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split me-1"></i><fmt:message key="order.status_pending"/></span>
                                        </c:when>
                                        <c:when test="${o.status == 'Paid'}">
                                            <span class="badge bg-success"><i class="bi bi-credit-card me-1"></i><fmt:message key="order.status_paid"/></span>
                                        </c:when>
                                        <c:when test="${o.status == 'Shipping'}">
                                            <span class="badge bg-info text-dark"><i class="bi bi-truck me-1"></i><fmt:message key="order.status_shipping_alt"/></span>
                                        </c:when>
                                        <c:when test="${o.status == 'Delivered'}">
                                            <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i><fmt:message key="order.status_delivered"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i><fmt:message key="order.status_cancelled"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-center">
                                    <!-- Nút gọi hàm viewOrderDetail nằm bên dashboard.jsp -->
                                    <fmt:message key="order.tooltip_view" var="viewTitle"/>
                                    <button class="btn btn-sm btn-outline-primary me-1" onclick="viewOrderDetail('${o.orderID}')" title="${viewTitle}">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <!-- Nút gọi hàm openUpdateStatusModal nằm bên dashboard.jsp -->
                                    <fmt:message key="order.tooltip_update_status" var="updateTitle"/>
                                    <button class="btn btn-sm btn-outline-success"
                                            onclick="openUpdateStatusModal('${o.orderID}', '${o.status}')"
                                            title="${updateTitle}">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                <fmt:message key="order.empty_list"/>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>