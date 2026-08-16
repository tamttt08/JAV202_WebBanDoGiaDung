<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="${userLang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="add_acc.title_page"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <div class="card-body">

                    <div class="d-flex align-items-center mb-4">
                        <a href="${pageContext.request.contextPath}/admin/dashboard?tab=account" class="btn btn-outline-secondary me-3">
                            <i class="bi bi-arrow-left"></i>
                        </a>
                        <h4 class="fw-bold mb-0 text-primary"><fmt:message key="add_acc.heading"/></h4>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/account/add" method="post">

                        <h6 class="fw-bold text-secondary mb-3"><i class="bi bi-shield-lock me-2"></i><fmt:message key="add_acc.sec_login"/></h6>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold"><fmt:message key="add_acc.username"/> (<span class="text-danger">*</span>)</label>
                                <fmt:message key="add_acc.ph_username" var="phUsername"/>
                                <input type="text" name="username" class="form-control" placeholder="${phUsername}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold"><fmt:message key="add_acc.password"/> (<span class="text-danger">*</span>)</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label small fw-semibold"><fmt:message key="add_acc.role"/></label>
                                <select name="role" class="form-select">
                                    <option value="Customer" selected><fmt:message key="add_acc.role_customer"/></option>
                                    <option value="Staff"><fmt:message key="add_acc.role_staff"/></option>
                                    <option value="Admin"><fmt:message key="add_acc.role_admin"/></option>
                                </select>
                            </div>
                        </div>

                        <hr class="my-4">

                        <h6 class="fw-bold text-secondary mb-3"><i class="bi bi-person-badge me-2"></i><fmt:message key="add_acc.sec_personal"/></h6>
                        <div class="row g-3 mb-4">
                            <div class="col-md-12">
                                <label class="form-label small fw-semibold"><fmt:message key="add_acc.fullname"/></label>
                                <fmt:message key="add_acc.ph_fullname" var="phFullname"/>
                                <input type="text" name="fullName" class="form-control" placeholder="${phFullname}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold"><fmt:message key="add_acc.email"/> (<span class="text-danger">*</span>)</label>
                                <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold"><fmt:message key="add_acc.phone"/></label>
                                <input type="tel" name="phone" class="form-control" placeholder="0901234567">
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary fw-bold py-2">
                                <i class="bi bi-plus-circle me-1"></i> <fmt:message key="add_acc.btn_create"/>
                            </button>
                        </div>

                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>