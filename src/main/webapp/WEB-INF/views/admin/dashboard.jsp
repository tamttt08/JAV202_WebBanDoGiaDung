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
        body {
            min-height: 100vh;
            background-color: #f4f6f9;
            margin: 0;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        /* Header trên cùng cố định */
        .admin-header {
            height: 60px;
            background-color: #212529;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1030;
            display: flex;
            align-items: center;
            padding: 0 25px;
            border-bottom: 1px solid #343a40;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        /* Khu vực thân chứa sidebar và nội dung */
        .admin-body {
            display: flex;
            margin-top: 60px;
            margin-bottom: 45px;
            flex: 1;
        }
        /* Sidebar bên trái cố định chiều cao */
        .sidebar {
            width: 260px;
            background-color: #212529;
            color: white;
            position: fixed;
            top: 60px;
            bottom: 45px;
            left: 0;
            display: flex;
            flex-direction: column;
            padding: 20px 15px;
            z-index: 1025;
            overflow-y: auto;
        }
        .sidebar .nav-link {
            color: #adb5bd;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: #fff;
            background-color: #0d6efd;
        }

        /* Nội dung chính bên phải */
        .main-wrapper {
            margin-left: 260px;
            flex: 1;
            padding: 25px;
            background-color: #f4f6f9;
            min-height: calc(100vh - 105px);
        }

        /* Footer dưới cùng cố định toàn màn hình với chữ màu trắng nổi bật */
        .admin-footer {
            height: 45px;
            background-color: #1a1d20;
            color: #ffffff;
            font-weight: 400;
            text-align: center;
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            z-index: 1030;
            display: flex;
            align-items: center;
            justify-content: center;
            border-top: 1px solid #343a40;
            font-size: 13px;
        }

        /* Cụm điều khiển dưới sidebar có khoảng cách đẹp hơn */
        .sidebar-bottom {
            margin-top: auto;
            padding-top: 15px;
            border-top: 1px solid #343a40;
        }
    </style>
</head>
<body>

    <!-- 1. HEADER TRÊN CÙNG -->
    <header class="admin-header">
        <a href="${pageContext.request.contextPath}/home" class="d-flex align-items-center text-white text-decoration-none ps-1">
            <i class="bi bi-box-seam-fill fs-4 me-2 text-primary"></i>
            <span class="fs-5 fw-bold tracking-wide">GIA DỤNG STORE</span>
        </a>
    </header>

    <!-- 2. PHẦN THÂN -->
    <div class="admin-body">
        <!-- SIDEBAR BÊN TRÁI -->
        <div class="sidebar">
            <ul class="nav nav-pills flex-column mb-2" id="adminMenu">
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

            <!-- Cụm nút ngôn ngữ và xem cửa hàng -->
            <div class="sidebar-bottom">
                <div class="mb-2">
                    <div class="btn-group w-100 shadow-sm" role="group">
                        <a href="${pageContext.request.contextPath}/change-language?lang=vi" class="btn btn-sm ${userLang == 'vi' ? 'btn-primary' : 'btn-outline-secondary text-light'}">🇻🇳 Tiếng Việt</a>
                        <a href="${pageContext.request.contextPath}/change-language?lang=en" class="btn btn-sm ${userLang == 'en' ? 'btn-primary' : 'btn-outline-secondary text-light'}">🇬🇧 English</a>
                    </div>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light w-100 btn-sm text-start py-2">
                        <i class="bi bi-house-door-fill me-2 text-warning"></i><fmt:message key="admin.btn_view_store"/>
                    </a>
                </div>
            </div>
        </div>

        <!-- NỘI DUNG CHÍNH BÊN PHẢI -->
        <div class="main-wrapper">
            <div id="main-content">
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status"></div>
                    <p class="mt-2 text-muted"><fmt:message key="admin.loading"/></p>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. FOOTER DƯỚI CÙNG -->
    <footer class="admin-footer">
        <p class="mb-0">&copy; 2026 Gia Dụng Store. All rights reserved.</p>
    </footer>

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

    // --- HÀM TOÀN CỤC TÌM KIẾM TÀI KHOẢN QUA AJAX ---
    function searchAccounts(e) {
        if (e) {
            e.preventDefault();
            e.stopPropagation();
        }

        const keyword = document.getElementById('searchKeyword')?.value || '';
        const role = document.getElementById('searchRole')?.value || '';
        const status = document.getElementById('searchStatus')?.value || '';

        const url = contextPath + "/admin/account?action=search&keyword="
            + encodeURIComponent(keyword) + "&role=" + encodeURIComponent(role) + "&status=" + encodeURIComponent(status);

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error("Lỗi tải dữ liệu tìm kiếm");
                return response.text();
            })
            .then(html => {
                const mainContent = document.getElementById('main-content');
                if (mainContent) {
                    mainContent.innerHTML = html;
                }
                const newUrl = contextPath + "/admin/dashboard?tab=account&action=search&keyword="
                    + encodeURIComponent(keyword) + "&role=" + encodeURIComponent(role) + "&status=" + encodeURIComponent(status);
                history.pushState(null, '', newUrl);
            })
            .catch(err => {
                console.error("Lỗi tìm kiếm:", err);
            });

        return false;
    }

    // --- HÀM TOÀN CỤC CẬP NHẬT VAI TRÒ ---
    function updateAccountRole(accountId, newRole) {
        if (confirm("Cậu có chắc chắn muốn thay đổi vai trò của tài khoản #" + accountId + " thành " + newRole + " không?")) {
            const formData = new URLSearchParams();
            formData.append('action', 'update-role');
            formData.append('accountId', accountId);
            formData.append('role', newRole);

            fetch(contextPath + '/admin/account', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(response => {
                if (!response.ok) throw new Error("Cập nhật vai trò thất bại!");
                searchAccounts();
            })
            .catch(err => {
                console.error(err);
                alert("Đã xảy ra lỗi khi cập nhật vai trò!");
                searchAccounts();
            });
        } else {
            searchAccounts();
        }
    }

    // --- HÀM TOÀN CỤC RESET MẬT KHẨU ---
    function resetAccountPassword(accountId) {
        if (confirm("Cậu có chắc chắn muốn cấp lại mật khẩu mới và gửi về email cho tài khoản #" + accountId + " không?")) {
            const formData = new URLSearchParams();
            formData.append('action', 'reset-password');
            formData.append('id', accountId);

            fetch(contextPath + '/admin/account', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(response => response.text())
            .then(result => {
                alert(result);
                searchAccounts();
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