<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="userLang" value="${not empty sessionScope.LANG ? sessionScope.LANG : 'vi'}" scope="session" />
<fmt:setLocale value="${userLang}" />
<fmt:setBundle basename="messages" />

<!-- Lấy URI hiện tại để kiểm tra trang -->
<c:set var="currentUri" value="${pageContext.request.requestURI}" />
<c:set var="isAuthPage" value="${currentUri.endsWith('/login') || currentUri.endsWith('/register') || currentUri.contains('/login.jsp') || currentUri.contains('/register.jsp')}" />

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container">
        <!-- Logo thương hiệu -->
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-box-seam-fill text-primary me-2"></i> <fmt:message key="nav.brand"/>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">

            <!-- CHỈ HIỂN THỊ Ô TÌM KIẾM NẾU KHÔNG PHẢI TRANG LOGIN / REGISTER -->
            <c:if test="${not isAuthPage}">
                <form class="d-flex mx-auto col-lg-5 my-2 my-lg-0" action="${pageContext.request.contextPath}/home" method="get">
                    <div class="input-group">
                        <fmt:message key="nav.search_placeholder" var="searchPlaceholder"/>
                        <input class="form-control border-0" type="search" name="keyword"
                               value="${param.keyword}" placeholder="${searchPlaceholder}">
                        <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                    </div>
                </form>
            </c:if>

            <ul class="navbar-nav align-items-center ms-auto">

                <!-- CHỈ HIỂN THỊ GIỎ HÀNG & NÚT LOGIN/REGISTER NẾU KHÔNG PHẢI TRANG AUTH -->
                <c:if test="${not isAuthPage}">
                    <li class="nav-item me-3">
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light position-relative">
                            <i class="bi bi-cart3"></i>
                            <c:if test="${not empty sessionScope.cart}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        ${sessionScope.cart.size()}
                                </span>
                            </c:if>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm me-2" href="${pageContext.request.contextPath}/login"><fmt:message key="nav.login"/></a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/register"><fmt:message key="nav.register"/></a>
                    </li>
                </c:if>

                <!-- DROPDOWN CHUYỂN NGÔN NGỮ (LUÔN HIỂN THỊ) -->
                <li class="nav-item dropdown ms-2">
                    <button class="btn btn-sm btn-outline-secondary text-white border-0 dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-globe me-1"></i> ${userLang eq 'en' ? 'EN' : 'VI'}
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                        <li>
                            <a class="dropdown-item ${userLang eq 'vi' ? 'active' : ''}" href="${pageContext.request.contextPath}/change-language?lang=vi">
                                🇻🇳 Tiếng Việt
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item ${userLang eq 'en' ? 'active' : ''}" href="${pageContext.request.contextPath}/change-language?lang=en">
                                🇺🇸 English
                            </a>
                        </li>
                    </ul>
                </li>

            </ul>
        </div>
    </div>
</nav>