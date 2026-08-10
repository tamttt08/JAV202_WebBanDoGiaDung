<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold text-primary mb-0">
        <i class="bi bi-people me-2"></i><fmt:message key="acc.title"/>
    </h3>
    <a href="${pageContext.request.contextPath}/admin/account/add" class="btn btn-primary fw-semibold">
        <i class="bi bi-person-plus me-1"></i> <fmt:message key="acc.btn_add"/>
    </a>
</div>

<!-- THÔNG BÁO (Nếu có từ Servlet truyền về) -->
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
                    <th class="text-center" style="width: 80px;"><fmt:message key="acc.col_id"/></th>
                    <th><fmt:message key="acc.col_username"/></th>
                    <th class="text-center"><fmt:message key="acc.col_role"/></th>
                    <th class="text-center"><fmt:message key="acc.col_created_at"/></th>
                    <th class="text-center"><fmt:message key="acc.col_status"/></th>
                    <th class="text-center" style="width: 120px;"><fmt:message key="acc.col_actions"/></th>
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

                                <!-- HIỂN THỊ VAI TRÒ -->
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${acc.role eq 'Manager'}">
                                            <span class="badge bg-danger"><fmt:message key="acc.role_manager"/></span>
                                        </c:when>
                                        <c:when test="${acc.role eq 'Staff'}">
                                            <span class="badge bg-primary"><fmt:message key="acc.role_staff"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary"><fmt:message key="acc.role_customer"/></span>
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
                                            <span class="badge bg-success-subtle text-success border border-success-subtle"><fmt:message key="acc.status_active"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle"><fmt:message key="acc.status_locked"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- HÀNH ĐỘNG -->
                                <td class="text-center">
                                    <fmt:message key="acc.tooltip_edit_role" var="editRoleTitle"/>
                                    <!-- Nút Sửa Quyền (Mở Modal) -->
                                    <button class="btn btn-sm btn-outline-primary me-1 btn-edit-role"
                                            title="${editRoleTitle}"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editRoleModal"
                                            data-id="${acc.accountID}"
                                            data-username="${acc.username}"
                                            data-role="${acc.role}">
                                        <i class="bi bi-shield-lock"></i>
                                    </button>

                                    <!-- Nút Khóa / Mở khóa -->
                                    <c:choose>
                                        <c:when test="${acc.active}">
                                            <fmt:message key="acc.tooltip_lock" var="lockTitle"/>
                                            <fmt:message key="acc.confirm_lock" var="confirmLockMsg">
                                                <fmt:param value="${acc.username}"/>
                                            </fmt:message>
                                            <a href="${pageContext.request.contextPath}/admin/account?action=toggle-status&id=${acc.accountID}&status=false"
                                               class="btn btn-sm btn-outline-danger"
                                               title="${lockTitle}"
                                               onclick="return confirm('${confirmLockMsg}');">
                                                <i class="bi bi-lock-fill"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:message key="acc.tooltip_unlock" var="unlockTitle"/>
                                            <fmt:message key="acc.confirm_unlock" var="confirmUnlockMsg">
                                                <fmt:param value="${acc.username}"/>
                                            </fmt:message>
                                            <a href="${pageContext.request.contextPath}/admin/account?action=toggle-status&id=${acc.accountID}&status=true"
                                               class="btn btn-sm btn-outline-success"
                                               title="${unlockTitle}"
                                               onclick="return confirm('${confirmUnlockMsg}');">
                                                <i class="bi bi-unlock-fill"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                <fmt:message key="acc.empty"/>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- ================= MODAL SỬA QUYỀN ================= -->
<div class="modal fade" id="editRoleModal" tabindex="-1" aria-labelledby="editRoleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/account" method="post">
                <input type="hidden" name="action" value="update-role">
                <input type="hidden" name="accountId" id="modalAccountId">

                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold" id="editRoleModalLabel">
                        <i class="bi bi-shield-lock me-2"></i><fmt:message key="acc.modal_title"/>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary"><fmt:message key="acc.modal_username"/></label>
                        <input type="text" class="form-control bg-light fw-bold text-dark" id="modalUsername" readonly>
                    </div>

                    <div class="mb-3">
                        <label for="modalRole" class="form-label fw-semibold"><fmt:message key="acc.modal_select_role"/></label>
                        <select class="form-select" id="modalRole" name="role" required>
                            <option value="Customer"><fmt:message key="acc.role_customer"/> (Customer)</option>
                            <option value="Staff"><fmt:message key="acc.role_staff"/> (Staff)</option>
                            <option value="Manager"><fmt:message key="acc.role_manager"/> (Manager)</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><fmt:message key="acc.btn_cancel"/></button>
                    <button type="submit" class="btn btn-primary fw-semibold px-4"><fmt:message key="acc.btn_save"/></button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- SCRIPT ĐỔ DỮ LIỆU VÀO MODAL SỬA QUYỀN (ĐÃ TỐI ƯU CHO AJAX) -->
<script>
    (function() {
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.btn-edit-role');
            if (btn) {
                const id = btn.getAttribute('data-id');
                const username = btn.getAttribute('data-username');
                const role = btn.getAttribute('data-role');

                const inputId = document.getElementById('modalAccountId');
                const inputUsername = document.getElementById('modalUsername');
                const selectRole = document.getElementById('modalRole');

                if (inputId) inputId.value = id || '';
                if (inputUsername) inputUsername.value = username || '';
                if (selectRole) selectRole.value = role || 'Customer';
            }
        });
    })();
</script>