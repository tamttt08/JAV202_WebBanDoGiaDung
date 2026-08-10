<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-primary mb-0">
        <i class="bi bi-box-seam me-2"></i><fmt:message key="product.manage_title"/>
    </h3>
    <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-primary fw-semibold">
        <i class="bi bi-plus-lg me-1"></i> <fmt:message key="product.btn_add"/>
    </a>
</div>

<div class="card border-0 shadow-sm rounded-3">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="text-center" style="width: 60px;"><fmt:message key="product.col_code"/></th>
                    <th style="width: 80px;"><fmt:message key="product.col_image"/></th>
                    <th><fmt:message key="product.col_name"/></th>
                    <th><fmt:message key="product.col_category"/></th>
                    <th><fmt:message key="product.col_price"/></th>
                    <th class="text-center"><fmt:message key="product.col_stock"/></th>
                    <th class="text-center" style="width: 120px;"><fmt:message key="product.col_actions"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty products}">
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td class="text-center fw-bold">${p.productCode}</td>
                                <td>
                                    <img src="${p.mainImage}" alt="${p.productName}" class="rounded border" style="width: 50px; height: 50px; object-fit: cover;">
                                </td>
                                <td class="fw-semibold text-primary">${p.productName}</td>
                                <td>
                                    <span class="badge bg-info text-dark">${p.category.categoryName}</span>
                                </td>
                                <td class="fw-bold text-danger">
                                    <fmt:formatNumber value="${p.price}" pattern="#,##0"/> đ
                                </td>
                                <td class="text-center">
                                        <span class="badge ${p.stockQuantity > 0 ? 'bg-success' : 'bg-secondary'}">
                                                ${p.stockQuantity}
                                        </span>
                                </td>
                                <td class="text-center">
                                    <fmt:message key="cat.tooltip_edit" var="editTitle"/>
                                    <a href="${pageContext.request.contextPath}/admin/product/edit?id=${p.productID}"
                                       class="btn btn-sm btn-outline-warning me-1" title="${editTitle}">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <fmt:message key="cat.tooltip_delete" var="deleteTitle"/>
                                    <fmt:message key="product.confirm_delete" var="confirmDeleteMsg"/>
                                    <a href="${pageContext.request.contextPath}/admin/product/delete?id=${p.productID}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('${confirmDeleteMsg}');"
                                       title="${deleteTitle}">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center py-4 text-muted">
                                <fmt:message key="product.empty_list"/>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>