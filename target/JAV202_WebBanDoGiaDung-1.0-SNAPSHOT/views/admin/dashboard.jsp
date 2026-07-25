<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gia Dụng Admin - Quản Lý</title>
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
    <div class="sidebar d-flex flex-column p-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center mb-4 me-md-auto text-white text-decoration-none px-2">
            <i class="bi bi-box-seam-fill fs-4 me-2 text-primary"></i>
            <span class="fs-5 fw-bold">GIA DỤNG ADMIN</span>
        </a>
        <hr class="text-secondary mt-0">

        <!-- Đã thêm data-url và data-tab cho từng tab -->
        <ul class="nav nav-pills flex-column mb-auto" id="adminMenu">
            <li class="nav-item">
                <a href="#" data-tab="overview" data-url="/admin/overview" class="nav-link">
                    <i class="bi bi-speedometer2 me-2"></i>Tổng quan
                </a>
            </li>
            <li>
                <a href="#" data-tab="product" data-url="/admin/product" class="nav-link">
                    <i class="bi bi-box-seam me-2"></i>Sản phẩm
                </a>
            </li>
            <li>
                <a href="#" data-tab="category" data-url="/admin/category" class="nav-link">
                    <i class="bi bi-grid me-2"></i>Danh mục
                </a>
            </li>
            <li>
                <a href="#" data-tab="order" data-url="/admin/order" class="nav-link">
                    <i class="bi bi-receipt me-2"></i>Đơn hàng
                </a>
            </li>
            <li>
                <a href="#" data-tab="account" data-url="/admin/account" class="nav-link">
                    <i class="bi bi-people me-2"></i>Tài khoản
                </a>
            </li>
        </ul>
        <hr class="text-secondary">
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light w-100 btn-sm text-start">
                <i class="bi bi-house me-2"></i>Xem Cửa Hàng
            </a>
        </div>
    </div>

    <!-- VÙNG NỘI DUNG CHÍNH (THAY ĐỔI ĐỘNG BẰNG AJAX) -->
    <div class="main-wrapper w-100">
        <div id="main-content">
            <!-- Nội dung các tab sẽ bắn vào đây -->
            <div class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted">Đang tải dữ liệu...</p>
            </div>
        </div>
    </div>
</div>

<!-- SCRIPT XỬ LÝ CHUYỂN TAB BẰNG AJAX (FETCH) -->
<script>
    const contextPath = "${pageContext.request.contextPath}";

    function loadTab(endpoint) {
        const mainContent = document.getElementById('main-content');

        mainContent.innerHTML = `
            <div class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted">Đang tải...</p>
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
                mainContent.innerHTML = `<div class="alert alert-danger">Lỗi tải dữ liệu: \${err.message}</div>`;
            });
    }

    // Bắt sự kiện click vào các Menu Sidebar
    document.querySelectorAll('#adminMenu .nav-link').forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();

            // Lấy endpoint từ data-url
            const url = this.getAttribute('data-url');
            const tab = this.getAttribute('data-tab');

            if (url) {
                // Đổi active menu
                document.querySelectorAll('#adminMenu .nav-link').forEach(nav => nav.classList.remove('active'));
                this.classList.add('active');

                // Load AJAX nội dung tab
                loadTab(url);

                // Cập nhật lại URL trình duyệt mà không reload trang (để F5 không bị mất tab)
                history.pushState(null, '', contextPath + '/admin/dashboard?tab=' + tab);
            }
        });
    });

    // Tự động kiểm tra param 'tab' trên URL để load tab tương ứng khi vừa mở Dashboard
    document.addEventListener("DOMContentLoaded", () => {
        const urlParams = new URLSearchParams(window.location.search);
        const currentTab = urlParams.get('tab') || 'product'; // Mặc định là tab product

        // Tìm menu tương ứng với tab trên URL
        const targetMenu = document.querySelector(`#adminMenu .nav-link[data-tab="\${currentTab}"]`);

        if (targetMenu) {
            targetMenu.classList.add('active');
            const url = targetMenu.getAttribute('data-url');
            if (url) loadTab(url);
        } else {
            // Mặc định kích hoạt tab product nếu không tìm thấy tab khớp
            const defaultMenu = document.querySelector('#adminMenu .nav-link[data-tab="product"]');
            if (defaultMenu) {
                defaultMenu.classList.add('active');
                loadTab(defaultMenu.getAttribute('data-url'));
            }
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>