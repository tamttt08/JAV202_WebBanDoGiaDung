<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<div class="modal-header bg-light">
    <h5 class="modal-title fw-bold text-primary">
        <i class="bi bi-receipt-cutoff me-2"></i>
        <fmt:message key="order.detail_title">
            <fmt:param value="${order.orderID}"/>
        </fmt:message>
    </h5>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>

<div class="modal-body p-4">
    <div class="row g-3 mb-4">
        <div class="col-md-6">
            <div class="p-3 border rounded bg-light-subtle">
                <h6 class="fw-bold text-secondary mb-2"><i class="bi bi-person me-1"></i><fmt:message key="order.customer_info"/></h6>

                <fmt:message key="order.default_guest" var="defaultGuest"/>
                <p class="mb-1"><strong><fmt:message key="order.receiver_name"/></strong> <c:out value="${order.receiverName}" default="${defaultGuest}"/></p>

                <fmt:message key="order.no_phone" var="noPhone"/>
                <p class="mb-0"><strong><fmt:message key="order.receiver_phone"/></strong> <c:out value="${order.receiverPhone}" default="${noPhone}"/></p>

                <fmt:message key="order.no_address" var="noAddress"/>
                <p class="mb-0"><strong><fmt:message key="order.shipping_address"/></strong> <c:out value="${order.shippingAddress}" default="${noAddress}"/></p>
            </div>
        </div>
        <div class="col-md-6">
            <div class="p-3 border rounded bg-light-subtle">
                <h6 class="fw-bold text-secondary mb-2"><i class="bi bi-info-circle me-1"></i><fmt:message key="order.info"/></h6>
                <p class="mb-1"><strong><fmt:message key="order.date"/></strong> ${order.formattedOrderDate}</p>
                <p class="mb-0"><strong><fmt:message key="order.status"/></strong>
                    <c:choose>
                        <c:when test="${order.status == 'Pending'}"><span class="badge bg-warning text-dark"><fmt:message key="order.status_pending"/></span></c:when>
                        <c:when test="${order.status == 'Paid'}"><span class="badge bg-success"><fmt:message key="order.status_paid"/></span></c:when>
                        <c:when test="${order.status == 'Shipping'}"><span class="badge bg-info"><fmt:message key="order.status_shipping"/></span></c:when>
                        <c:when test="${order.status == 'Cancelled'}"><span class="badge bg-danger"><fmt:message key="order.status_cancelled"/></span></c:when>
                        <c:otherwise><span class="badge bg-primary">${order.statusDisplayName}</span></c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
    </div>

    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-box-seam me-1"></i><fmt:message key="order.product_list"/></h6>
    <!-- FORM THÊM SẢN PHẨM MỚI VÀO ĐƠN -->
    <c:if test="${order.status == 'Pending'}">
        <div class="row g-2 mb-3 align-items-center">
            <div class="col">
                <select id="addProductId" class="form-select form-select-sm">
                    <option value=""><fmt:message key="order.select_product"/></option>
                    <c:forEach var="p" items="${products}">
                        <option value="${p.productID}">
                                ${p.productName} - <fmt:formatNumber value="${p.price}" pattern="#,##0"/>đ
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-auto">
                <input type="number" id="addQuantity" class="form-control form-control-sm" value="1" min="1" style="width: 70px;">
            </div>
            <div class="col-auto">
                <button type="button" class="btn btn-sm btn-primary" onclick="addOrderDetail('${order.orderID}')">
                    <i class="bi bi-plus-lg me-1"></i><fmt:message key="order.btn_add_item"/>
                </button>
            </div>
        </div>
    </c:if>
    <div class="table-responsive">
        <table class="table table-bordered align-middle text-center mb-0">
            <thead class="table-light">
            <tr>
                <th class="text-start"><fmt:message key="order.col_product"/></th>
                <th><fmt:message key="order.col_price"/></th>
                <th style="width: 100px;"><fmt:message key="order.col_quantity"/></th>
                <th><fmt:message key="order.col_subtotal"/></th>
                <c:if test="${order.status == 'Pending'}">
                    <th style="width: 60px;"><fmt:message key="order.col_delete"/></th>
                </c:if>
            </tr>
            </thead>
            <tbody class="align-middle">
            <c:forEach var="detail" items="${order.orderDetails}">
                <tr>
                    <td class="text-start">${detail.product.productName}</td>

                    <!-- 🟢 1. ĐƠN GIÁ: Format có dấu chấm phân cách -->
                    <td>
                        <fmt:formatNumber value="${detail.unitPrice}" pattern="#,##0"/> đ
                    </td>

                    <td>
                        <c:choose>
                            <%-- Trạng thái Chờ xử lý: Cho phép sửa số lượng --%>
                            <c:when test="${order.status == 'Pending'}">
                                <input type="number" class="form-control form-control-sm text-center"
                                       value="${detail.quantity}" min="1"
                                       onchange="updateOrderDetailQuantity('${detail.orderDetailID}', this.value, '${order.orderID}')">
                            </c:when>
                            <%-- Các trạng thái còn lại: Read-only --%>
                            <c:otherwise>
                                <span class="fw-bold">${detail.quantity}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- 🟢 2. THÀNH TIỀN: Format có dấu chấm phân cách -->
                    <td class="text-danger fw-bold">
                        <fmt:formatNumber value="${detail.unitPrice * detail.quantity}" pattern="#,##0"/> đ
                    </td>

                        <%-- Trạng thái Chờ xử lý: Hiện nút xóa --%>
                    <c:if test="${order.status == 'Pending'}">
                        <td>
                            <button type="button" class="btn btn-outline-danger btn-sm"
                                    onclick="deleteOrderDetail('${detail.orderDetailID}', '${order.orderID}')">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </c:if>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="modal-footer d-flex justify-content-between align-items-center">
    <div class="text-start">
        <span class="me-3"><fmt:message key="order.total_amount"/> <strong class="text-danger fs-5"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> đ</strong></span>
    </div>
    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><fmt:message key="order.btn_close"/></button>
</div>