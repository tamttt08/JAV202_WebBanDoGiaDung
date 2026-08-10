<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="${userLang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="chk_success.title"/> - <fmt:message key="cart.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container my-5 text-center">
    <div class="card border-0 shadow-sm p-5 mx-auto" style="max-width: 600px;">
        <i class="bi bi-check-circle-fill text-success display-1 mb-3"></i>
        <h2 class="fw-bold text-dark mb-2"><fmt:message key="chk_success.heading"/></h2>
        <p class="text-muted mb-4"><fmt:message key="chk_success.message"/></p>

        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg px-4">
                <i class="bi bi-house me-1"></i> <fmt:message key="chk_success.btn_home"/>
            </a>
        </div>
    </div>
</div>

</body>
</html>