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
    <title><fmt:message key="reset_pwd.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light d-flex align-items-center min-vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card border-0 shadow-lg rounded-4 p-4">
                <div class="card-body">
                    <div class="text-center mb-4">
                        <div class="bg-warning text-dark rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                            <i class="bi bi-lock-fill fs-3"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1"><fmt:message key="reset_pwd.heading"/></h4>
                        <p class="text-muted small"><fmt:message key="reset_pwd.sub_heading"/></p>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger small" role="alert">${errorMessage}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/forgot-password?action=reset-password" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-secondary"><fmt:message key="reset_pwd.lbl_new_pwd"/></label>
                            <input type="password" name="newPassword" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-secondary"><fmt:message key="reset_pwd.lbl_confirm_pwd"/></label>
                            <input type="password" name="confirmPassword" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm rounded-3"><fmt:message key="reset_pwd.btn_submit"/></button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>