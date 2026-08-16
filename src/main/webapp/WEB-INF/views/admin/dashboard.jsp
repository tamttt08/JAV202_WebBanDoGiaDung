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
    <title><fmt:message key="admin.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { min-height: 100vh; background-color: #f8f9fa; }
        .sidebar { width: 260px; background-color: #212529; min-height: 100vh; position: fixed; top: 0; left: 0; bottom: 0; z-index: 100; }
        .sidebar .nav-link { color: #adb5bd; padding: 12px 20px; border-radius: 6px; margin-bottom: 4px; cursor: pointer; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { color: #fff; background-color: #0d6efd; }
        .main-wrapper { margin-left: 260px; padding: 25px; }
    </style>
</head>
<body>

<div class="d-flex">
    <!-- SIDEBAR MENU BÊN TRÁI -->
    <div class="sidebar d-flex flex-column p-3 text-white">
        <a href="${pageContext.request.contextPath}/home" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none px-2">
            <i class="bi bi-box-seam-fill fs-4 me-2 text-primary"></i>
            <span class="fs-5 fw-bold">GIA DỤNG STORE</span>
        </a>
        <hr class="text-secondary">

        <ul class="nav nav-pills flex-column mb-auto" id="adminMenu">
            <li class="nav-item">
                <a href="#" data-tab="overview" data-url="/admin/overview" class="nav-link">
                    <i class="bi bi-speedometer2 me-2"></i><fmt:message key="admin.menu_overview"/>
                </a>
            </li>
            <li>
                <a href="#" data-tab="product" data-url="/admin/product" class="nav-link">
                    <i class="bi bi-box-seam me-2"></i><fmt:message key="admin.menu_product"/>
                </a>
            </li>
            <li>
                <a href="#" data-tab="category" data-url="/admin/category" class="nav-link">
                    <i class="bi bi-grid me-2"></i><fmt:message key="admin.menu_category"/>
                </a>
            </li>
            <li>
                <a href="#" data-tab="order" data-url="/admin/order" class="nav-link">
                    <i class="bi bi-receipt me-2"></i><fmt:message key="admin.menu_order"/>
                </a>
            </li>
            <li>
                <a href="#" data-tab="account" data-url="/admin/account" class="nav-link">
                    <i class="bi bi-people me-2"></i><fmt:message key="admin.menu_account"/>
                </a>
            </li>
        </ul>

        <hr class="text-secondary">
        <div class="mb-3">
            <div class="btn-group w-100" role="group">
                <a href="${pageContext.request.contextPath}/change-language?lang=vi" class="btn btn-sm ${userLang == 'vi' ? 'btn-primary' : 'btn-outline-secondary text-light'}">🇻🇳 Tiếng Việt</a>
                <a href="${pageContext.request.contextPath}/change-language?lang=en" class="btn btn-sm ${userLang == 'en' ? 'btn-primary' : 'btn-outline-secondary text-light'}">🇬🇧 English</a>
            </div>
        </div>
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light w-100 btn-sm text-start py-2">
                <i class="bi bi-house-door-fill me-2 text-warning"></i><fmt:message key="admin.btn_view_store"/>
            </a>
        </div>
        <div class="text-center text-muted small mt-auto pt-2 border-top border-secondary">
            &copy; 2026 Gia Dụng Store.<br>All rights reserved.
        </div>
    </div>

    <div class="main-wrapper w-100">
        <div id="main-content">
            <div class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted"><fmt:message key="admin.loading"/></p>
            </div>
        </div>
    </div>
</div>

<script>
    const contextPath = "${pageContext.request.contextPath}";

    function loadTab(endpoint) {
        const mainContent = document.getElementById('main-content');
        mainContent.innerHTML = `
            <div class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted"><fmt:message key="admin.loading_short"/></p>
            </div>`;

        fetch(contextPath + endpoint)
            .then(response => {
                if (!response.ok) throw new Error("Không thể tải trang");
                return response.text();
            })
            .then(html => {
                mainContent.innerHTML = html;
            })
            .catch(err => {
                mainContent.innerHTML = `<div class="alert alert-danger"><fmt:message key="admin.load_error"/> \${err.message}</div>`;
            });
    }

    document.querySelectorAll('#adminMenu .nav-link').forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            const url = this.getAttribute('data-url');
            const tab = this.getAttribute('data-tab');

            if (url) {
                document.querySelectorAll('#adminMenu .nav-link').forEach(nav => nav.classList.remove('active'));
                this.classList.add('active');
                loadTab(url);
                history.pushState(null, '', contextPath + '/admin/dashboard?tab=' + tab);
            }
        });
    });

    // FIX LỖI: Load đúng tab khi có tham số trên URL
    document.addEventListener("DOMContentLoaded", () => {
        const urlParams = new URLSearchParams(window.location.search);
        const currentTab = urlParams.get('tab') || 'product';

        const targetMenu = document.querySelector(`#adminMenu .nav-link[data-tab="\${currentTab}"]`);

        if (targetMenu) {
            document.querySelectorAll('#adminMenu .nav-link').forEach(nav => nav.classList.remove('active'));
            targetMenu.classList.add('active');

            let url = targetMenu.getAttribute('data-url');
            const fullSearch = window.location.search;
            if (fullSearch.includes('?')) {
                const queryString = fullSearch.substring(fullSearch.indexOf('?'));
                url += queryString;
            }

            if (url) loadTab(url);
        } else {
            const defaultMenu = document.querySelector('#adminMenu .nav-link[data-tab="product"]');
            if (defaultMenu) {
                defaultMenu.classList.add('active');
                loadTab(defaultMenu.getAttribute('data-url'));
            }
        }
    });

    // --- HÀM TOÀN CỤC XỬ LÝ CẬP NHẬT VAI TRÒ TÀI KHOẢN ---
    function updateAccountRole(accountId, newRole) {
        if (confirm("Cậu có chắc chắn muốn thay đổi vai trò của tài khoản #" + accountId + " thành " + newRole + " không?")) {
            const formData = new URLSearchParams();
            formData.append('action', 'update-role');
            formData.append('accountId', accountId);
            formData.append('role', newRole);

            fetch(contextPath + '/admin/account', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData.toString()
            })
            .then(response => {
                if (!response.ok) throw new Error("Cập nhật vai trò thất bại!");
                if (typeof searchAccounts === 'function') {
                    searchAccounts();
                } else {
                    loadTab('/admin/account');
                }
            })
            .catch(err => {
                console.error(err);
                alert("Đã xảy ra lỗi khi cập nhật vai trò!");
                location.reload();
            });
        } else {
            if (typeof searchAccounts === 'function') {
                searchAccounts();
            } else {
                loadTab('/admin/account');
            }
        }
    }

    // --- HÀM TOÀN CỤC XỬ LÝ RESET MẬT KHẨU VÀ GỬI EMAIL ---
    function resetAccountPassword(accountId) {
        if (confirm("Cậu có chắc chắn muốn cấp lại mật khẩu mới và gửi về email cho tài khoản #" + accountId + " không?")) {
            const formData = new URLSearchParams();
            formData.append('action', 'reset-password');
            formData.append('id', accountId);

            fetch(contextPath + '/admin/account', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData.toString()
            })
            .then(response => response.text())
            .then(result => {
                alert(result);
                if (typeof searchAccounts === 'function') {
                    searchAccounts();
                } else {
                    loadTab('/admin/account');
                }
            })
            .catch(err => {
                console.error(err);
                alert("Đã xảy ra lỗi khi kết nối đến server!");
            });
        }
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>