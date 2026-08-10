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
    <div class="sidebar d-flex flex-column p-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center mb-4 me-md-auto text-white text-decoration-none px-2">
            <i class="bi bi-box-seam-fill fs-4 me-2 text-primary"></i>
            <span class="fs-5 fw-bold"><fmt:message key="admin.brand_title"/></span>
        </a>
        <hr class="text-secondary mt-0">

        <!-- Đã thêm data-url và data-tab cho từng tab -->
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

        <!-- NÚT CHUYỂN ĐỔI NGÔN NGỮ -->
        <div class="mb-2">
            <div class="btn-group w-100" role="group">
                <a href="${pageContext.request.contextPath}/change-language?lang=vi" class="btn btn-sm ${userLang == 'vi' ? 'btn-primary' : 'btn-outline-secondary text-light'}">🇻🇳 Tiếng Việt</a>
                <a href="${pageContext.request.contextPath}/change-language?lang=en" class="btn btn-sm ${userLang == 'en' ? 'btn-primary' : 'btn-outline-secondary text-light'}">🇬🇧 English</a>
            </div>
        </div>

        <hr class="text-secondary">
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light w-100 btn-sm text-start">
                <i class="bi bi-house me-2"></i><fmt:message key="admin.btn_view_store"/>
            </a>
        </div>
    </div>

    <!-- VÙNG NỘI DUNG CHÍNH (THAY ĐỔI ĐỘNG BẰNG AJAX) -->
    <div class="main-wrapper w-100">
        <div id="main-content">
            <!-- Nội dung các tab sẽ bắn vào đây -->
            <div class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted"><fmt:message key="admin.loading"/></p>
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

<!-- Modal container chứa chi tiết đơn hàng -->
<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content" id="modalContentContainer">
            <!-- Nội dung chi tiết đơn hàng sẽ được load bằng AJAX vào đây -->
        </div>
    </div>
</div>

<!-- Modal Cập Nhật Trạng Thái Đơn Hàng -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fs-6"><i class="bi bi-pencil-square me-2"></i><fmt:message key="admin.modal_update_status_title"/></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-4">
                <input type="hidden" id="statusOrderId">
                <div class="mb-3">
                    <label class="form-label fw-semibold"><fmt:message key="admin.modal_select_status_label"/></label>
                    <select id="selectOrderStatus" class="form-select">
                        <option value="Pending"><fmt:message key="admin.status_pending_opt"/></option>
                        <option value="Paid"><fmt:message key="admin.status_paid_opt"/></option>
                        <option value="Shipping"><fmt:message key="admin.status_shipping_opt"/></option>
                        <option value="Delivered"><fmt:message key="admin.status_delivered_opt"/></option>
                        <option value="Cancelled"><fmt:message key="admin.status_cancelled_opt"/></option>
                    </select>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal"><fmt:message key="admin.btn_cancel"/></button>
                <button type="button" class="btn btn-primary btn-sm" onclick="saveOrderStatus()">
                    <i class="bi bi-save me-1"></i><fmt:message key="admin.btn_save_changes"/>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // 🔴 KHAI BÁO THẲNG VÀO WINDOW ĐỂ TRÁNH LỖI SCOPE KHI LOAD AJAX
    window.viewOrderDetail = function(orderId) {
        var url = '${pageContext.request.contextPath}/admin/order?action=detail&id=' + orderId;

        fetch(url)
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Lỗi HTTP: ' + response.status);
                }
                return response.text();
            })
            .then(function(html) {
                document.getElementById('modalContentContainer').innerHTML = html;

                var modalElement = document.getElementById('orderDetailModal');
                var myModal = bootstrap.Modal.getInstance(modalElement);
                if (!myModal) {
                    myModal = new bootstrap.Modal(modalElement);
                }
                myModal.show();
            })
            .catch(function(error) {
                console.error('Lỗi khi tải chi tiết đơn hàng:', error);
                alert('Không thể tải chi tiết đơn hàng. Kiểm tra Console (F12)!');
            });
    };
    // Cập nhật số lượng
    window.updateOrderDetailQuantity = window.updateDetailQuantity = function(detailId, quantity, orderId) {
        if (quantity < 1) {
            alert("Số lượng phải lớn hơn 0!");
            return;
        }
        var url = contextPath + '/admin/order?action=updateDetail&detailId=' + detailId + '&quantity=' + quantity + '&orderId=' + orderId;

        fetch(url)
            .then(response => response.text())
            .then(html => {
                document.getElementById('modalContentContainer').innerHTML = html;
            })
            .catch(err => console.error(err));
    };

    // Xóa món
    window.deleteOrderDetail = function(detailId, orderId) {
        if (confirm("Cậu có chắc muốn xóa sản phẩm này không?")) {
            var url = contextPath + '/admin/order?action=deleteDetail&detailId=' + detailId + '&orderId=' + orderId;

            fetch(url)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('modalContentContainer').innerHTML = html;
                })
                .catch(err => console.error(err));
        }
    };

    // Thêm món
    window.addOrderDetail = window.addDetailToOrder = function(orderId) {
        var productSelect = document.getElementById('addProductId');
        var quantityInput = document.getElementById('addQuantity');

        if (!productSelect || !quantityInput) return;

        var productId = productSelect.value;
        var quantity = quantityInput.value;

        if (!productId || productId === "undefined") {
            alert("Vui lòng chọn một sản phẩm!");
            return;
        }

        var url = contextPath + '/admin/order?action=addDetail&orderId=' + orderId + '&productId=' + productId + '&quantity=' + quantity;

        fetch(url)
            .then(response => response.text())
            .then(html => {
                document.getElementById('modalContentContainer').innerHTML = html;
            })
            .catch(err => console.error(err));
    };

    // Cập nhật trạng thái đơn hàng từ Bảng Order
    window.changeOrderStatus = function(orderId, newStatus) {
        if (confirm("Cậu có chắc chắn muốn thay đổi trạng thái đơn hàng #" + orderId + " không?")) {
            var url = '${pageContext.request.contextPath}/admin/order?action=updateStatus&id=' + orderId + '&status=' + newStatus;

            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error("Lỗi khi cập nhật trạng thái");
                    return response.text();
                })
                .then(html => {
                    // Tải lại bảng order-table với trạng thái mới
                    document.getElementById('main-content').innerHTML = html;
                })
                .catch(err => {
                    console.error(err);
                    alert("Không thể cập nhật trạng thái đơn hàng!");
                });
        } else {
            // Nếu hủy chọn thì reload lại tab để reset về trạng thái cũ trên select
            loadTab('/admin/order');
        }
    };

    // Hàm mở Modal và gán thông tin đơn hàng hiện tại
    window.openUpdateStatusModal = function(orderId, currentStatus) {
        document.getElementById('statusOrderId').value = orderId;
        document.getElementById('selectOrderStatus').value = currentStatus;

        var statusModal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
        statusModal.show();
    };

    // Hàm gửi request cập nhật trạng thái khi nhấn Lưu
    window.saveOrderStatus = function() {
        var orderId = document.getElementById('statusOrderId').value;
        var newStatus = document.getElementById('selectOrderStatus').value;

        var url = '${pageContext.request.contextPath}/admin/order?action=updateStatus&id=' + orderId + '&status=' + newStatus;

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error("Lỗi khi cập nhật");
                return response.text();
            })
            .then(html => {
                // Ẩn Modal đi
                var modalElement = document.getElementById('updateStatusModal');
                var modalInstance = bootstrap.Modal.getInstance(modalElement);
                if (modalInstance) modalInstance.hide();

                // Reload lại bảng Order với trạng thái vừa cập nhật
                document.getElementById('main-content').innerHTML = html;
            })
            .catch(err => {
                console.error(err);
                alert("Không thể cập nhật trạng thái!");
            });
    };
</script>
</body>
</html>