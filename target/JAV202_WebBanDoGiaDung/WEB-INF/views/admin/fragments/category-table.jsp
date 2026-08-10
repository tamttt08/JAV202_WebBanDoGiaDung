<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-primary mb-0">
        <i class="bi bi-grid me-2"></i><fmt:message key="cat.title_manage"/>
    </h3>
</div>

<div class="row g-4">
    <!-- FORM THÊM / SỬA DANH MỤC (BÊN TRÁI) -->
    <div class="col-md-5">
        <div class="card border-0 shadow-sm rounded-3">
            <div class="card-header bg-white py-3 border-0">
                <h6 class="fw-bold m-0 text-primary">
                    <i class="bi bi-pencil-square me-2"></i><fmt:message key="cat.form_title"/>
                </h6>
            </div>
            <div class="card-body pt-0">
                <form action="${pageContext.request.contextPath}/admin/category/add" method="post">
                    <!-- ID ẩn dùng cho trường hợp Edit -->
                    <input type="hidden" name="categoryId" value="${category != null ? category.categoryId : ''}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold"><fmt:message key="cat.name_label"/> <span class="text-danger">*</span></label>
                        <fmt:message key="cat.name_placeholder" var="namePlaceholder"/>
                        <input type="text" name="categoryName" class="form-control"
                               placeholder="${namePlaceholder}"
                               value="${category != null ? category.categoryName : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold"><fmt:message key="cat.desc_label"/></label>
                        <fmt:message key="cat.desc_placeholder" var="descPlaceholder"/>
                        <textarea name="description" class="form-control" rows="3"
                                  placeholder="${descPlaceholder}">${category != null ? category.description : ''}</textarea>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary fw-semibold">
                            <i class="bi bi-download me-1"></i> <fmt:message key="cat.btn_save"/>
                        </button>
                        <c:if test="${category != null}">
                            <a href="${pageContext.request.contextPath}/admin/category" class="btn btn-light border"><fmt:message key="cat.btn_cancel"/></a>
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
                    <i class="bi bi-list-task me-2"></i><fmt:message key="cat.list_title"/>
                </h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 70px;"><fmt:message key="cat.col_code"/></th>
                            <th><fmt:message key="cat.col_name"/></th>
                            <th><fmt:message key="cat.col_desc"/></th>
                            <th class="text-center" style="width: 100px;"><fmt:message key="cat.col_actions"/></th>
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
                                            <fmt:message key="cat.tooltip_edit" var="editTitle"/>
                                            <a href="${pageContext.request.contextPath}/admin/category/edit?id=${c.categoryId}"
                                               class="btn btn-sm btn-outline-warning me-1" title="${editTitle}">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <fmt:message key="cat.tooltip_delete" var="deleteTitle"/>
                                            <fmt:message key="cat.confirm_delete" var="confirmDeleteMsg"/>
                                            <a href="${pageContext.request.contextPath}/admin/category/delete?id=${c.categoryId}"
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
                                    <td colspan="4" class="text-center py-4 text-muted">
                                        <fmt:message key="cat.empty"/>
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