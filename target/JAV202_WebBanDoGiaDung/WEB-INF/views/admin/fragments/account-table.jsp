<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<div class="container-fluid px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary mb-0"><i class="bi bi-people-fill me-2"></i><fmt:message key="account.title"/></h3>
        <a href="${pageContext.request.contextPath}/admin/account/add" class="btn btn-primary btn-sm fw-semibold">
            <i class="bi bi-person-plus-fill me-1"></i> <fmt:message key="account.btn_add"/>
        </a>
    </div>

    <!-- KHUNG TÌM KIẾM TÀI KHOẢN -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form id="searchAccountForm" class="row g-3" onsubmit="return searchAccounts(event)">
                <div class="col-md-4">
                    <label class="form-label small fw-semibold text-muted"><fmt:message key="account.lbl_keyword"/></label>
                    <fmt:message key="account.ph_keyword" var="phKeyword"/>
                    <input type="text" class="form-control form-control-sm" id="searchKeyword" value="${param.keyword}" placeholder="${phKeyword}">
                </div>

                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted"><fmt:message key="account.lbl_role"/></label>
                    <select id="searchRole" class="form-select form-select-sm">
                        <option value=""><fmt:message key="account.all_roles"/></option>
                        <option value="Staff" ${param.role eq 'Staff' ? 'selected' : ''}><fmt:message key="account.role_staff"/></option>
                        <option value="Manager" ${param.role eq 'Manager' ? 'selected' : ''}><fmt:message key="account.role_manager"/></option>
                        <option value="Customer" ${param.role eq 'Customer' ? 'selected' : ''}><fmt:message key="account.role_customer"/></option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted"><fmt:message key="account.lbl_status"/></label>
                    <select id="searchStatus" class="form-select form-select-sm">
                        <option value=""><fmt:message key="account.all_statuses"/></option>
                        <option value="true" ${param.status eq 'true' ? 'selected' : ''}><fmt:message key="account.status_active"/></option>
                        <option value="false" ${param.status eq 'false' ? 'selected' : ''}><fmt:message key="account.status_locked"/></option>
                    </select>
                </div>

                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary btn-sm w-100 fw-semibold">
                        <i class="bi bi-search me-1"></i> <fmt:message key="account.btn_search"/>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- BẢNG HIỂN THỊ KẾT QUẢ -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th class="ps-3"><fmt:message key="account.col_id"/></th>
                        <th><fmt:message key="account.col_username"/></th>
                        <th><fmt:message key="account.col_role"/></th>
                        <th><fmt:message key="account.col_status"/></th>
                        <th class="text-end pe-3"><fmt:message key="account.col_actions"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="acc" items="${accounts}">
                        <tr>
                            <td class="ps-3 fw-semibold">#${acc.accountID}</td>
                            <td>
                                <div class="fw-bold text-dark"><i class="bi bi-person-circle me-1 text-secondary"></i>${acc.username}</div>
                            </td>
                            <td>
                                    <span class="badge ${acc.role eq 'Manager' ? 'bg-danger' : (acc.role eq 'Staff' ? 'bg-primary' : 'bg-secondary')}">
                                            ${acc.role}
                                    </span>
                            </td>
                            <td>
                                    <span class="badge ${acc.active ? 'bg-success' : 'bg-warning text-dark'}">
                                            ${acc.active ? '<fmt:message key="account.status_active"/>' : '<fmt:message key="account.status_locked"/>'}
                                    </span>
                            </td>
                            <td class="text-end pe-3">
                                <fmt:message key="account.title_reset_pw" var="titleResetPw"/>
                                <button type="button" class="btn btn-outline-warning btn-sm me-1"
                                        onclick="resetAccountPassword(${acc.accountID})" title="${titleResetPw}">
                                    <i class="bi bi-key-fill"></i>
                                </button>

                                <fmt:message key="account.title_lock" var="titleLock"/>
                                <fmt:message key="account.title_unlock" var="titleUnlock"/>
                                <a href="${pageContext.request.contextPath}/admin/account?action=toggle-status&id=${acc.accountID}&status=${!acc.active}"
                                   class="btn btn-outline-${acc.active ? 'danger' : 'success'} btn-sm"
                                   title="${acc.active ? titleLock : titleUnlock}">
                                    <i class="bi bi-shield-${acc.active ? 'lock' : 'check'}"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty accounts}">
                        <tr>
                            <td colspan="5" class="text-center py-4 text-muted"><fmt:message key="account.no_data"/></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<fmt:message key="account.confirm_reset" var="jsConfirmReset"/>
<fmt:message key="account.err_network" var="jsErrNetwork"/>

<script>
    function searchAccounts(e) {
        if (e) {
            e.preventDefault();
            e.stopPropagation();
        }

        try {
            const appPath = "${pageContext.request.contextPath}";
            const keyword = document.getElementById('searchKeyword').value;
            const role = document.getElementById('searchRole').value;
            const status = document.getElementById('searchStatus').value;

            const url = appPath + "/admin/account?action=search&keyword="
                + encodeURIComponent(keyword) + "&role=" + encodeURIComponent(role) + "&status=" + encodeURIComponent(status);

            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error("Lỗi mạng/server: " + response.status);
                    return response.text();
                })
                .then(html => {
                    document.getElementById('main-content').innerHTML = html;

                    const newUrl = appPath + "/admin/dashboard?tab=account&action=search&keyword="
                        + encodeURIComponent(keyword) + "&role=" + encodeURIComponent(role) + "&status=" + encodeURIComponent(status);
                    history.pushState(null, '', newUrl);
                })
                .catch(err => console.error("Lỗi tìm kiếm:", err));
        } catch (err) {
            console.error("Lỗi thực thi JavaScript:", err);
        }

        return false;
    }

    function resetAccountPassword(accountId) {
        const msgConfirm = "${jsConfirmReset}" + accountId + "?";
        if (confirm(msgConfirm)) {
            fetch('${pageContext.request.contextPath}/admin/account?action=reset-password&id=' + accountId, {
                method: 'POST'
            })
                .then(response => response.text())
                .then(result => {
                    alert(result);
                })
                .catch(err => {
                    console.error(err);
                    alert("${jsErrNetwork}");
                });
        }
    }
</script>