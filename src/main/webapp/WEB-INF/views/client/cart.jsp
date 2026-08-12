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
    <title><fmt:message key="cart.title"/> - <fmt:message key="cart.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-shop me-2"></i><fmt:message key="cart.brand_title"/>
        </a>
        <div class="d-flex align-items-center gap-2">
            <!-- Nút xem danh sách đơn hàng theo trạng thái -->
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-warning btn-sm">
                <i class="bi bi-box-seam me-1"></i> Đơn hàng của tôi
            </a>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm">
                <i class="bi bi-arrow-left me-1"></i> <fmt:message key="cart.btn_continue_shopping"/>
            </a>
        </div>
    </div>
</nav>

<div class="container my-4">
    <h3 class="fw-bold mb-4"><i class="bi bi-cart3 me-2"></i><fmt:message key="cart.page_heading"/></h3>

    <c:choose>
        <c:when test="${empty cart}">
            <div class="card border-0 shadow-sm p-5 text-center">
                <i class="bi bi-cart-x text-muted display-1 mb-3"></i>
                <h5 class="text-secondary"><fmt:message key="cart.empty_title"/></h5>
                <p class="text-muted"><fmt:message key="cart.empty_desc"/></p>
                <div>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4 mt-2">
                        <fmt:message key="cart.btn_explore"/>
                    </a>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <!-- FORM CHÍNH: GỬI SẢN PHẨM ĐƯỢC CHỌN SANG CHECKOUT -->
            <form action="${pageContext.request.contextPath}/checkout" method="post" id="cartForm">
                <div class="row g-4">

                    <!-- BẢNG DANH SÁCH SẢN PHẨM -->
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="table-responsive">
                                <table class="table align-middle mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <!-- Ô tích chọn tất cả -->
                                        <th class="text-center" style="width: 40px;">
                                            <input class="form-check-input" type="checkbox" id="selectAll" checked onchange="toggleSelectAll(this)">
                                        </th>
                                        <th><fmt:message key="cart.th_product"/></th>
                                        <th><fmt:message key="cart.th_price"/></th>
                                        <th style="width: 130px;"><fmt:message key="cart.th_quantity"/></th>
                                        <th><fmt:message key="cart.th_subtotal"/></th>
                                        <th class="text-center"><fmt:message key="cart.th_action"/></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="entry" items="${cart}">
                                        <c:set var="item" value="${entry.value}" />
                                        <tr class="cart-item-row">
                                            <!-- Checkbox cho từng sản phẩm -->
                                            <td class="text-center">
                                                <input class="form-check-input item-checkbox" type="checkbox"
                                                       name="selectedProductIds" value="${item.product.productID}"
                                                       data-price="${item.totalPrice}" checked onchange="calculateTotal()">
                                            </td>

                                            <!-- Ảnh & Tên -->
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${item.product.mainImage}" alt="${item.product.productName}"
                                                         style="width: 60px; height: 60px; object-fit: contain;" class="rounded border me-3">
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/product/detail?id=${item.product.productID}"
                                                           class="fw-bold text-dark text-decoration-none">
                                                                ${item.product.productName}
                                                        </a>
                                                        <div class="text-muted small"><fmt:message key="cart.code_prefix"/> ${item.product.productCode}</div>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Đơn giá -->
                                            <td class="fw-semibold">
                                                <fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true"/> đ
                                            </td>

                                            <!-- Cập nhật Số lượng -->
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <input type="number" value="${item.quantity}"
                                                           min="1" max="${item.product.stockQuantity}"
                                                           class="form-control form-control-sm text-center"
                                                           onchange="updateQuantity('${item.product.productID}', this.value)">
                                                </div>
                                            </td>

                                            <!-- Thành tiền -->
                                            <td class="fw-bold text-danger">
                                                <fmt:formatNumber value="${item.totalPrice}" type="number" groupingUsed="true"/> đ
                                            </td>

                                            <!-- Nút Xóa -->
                                            <td class="text-center">
                                                <fmt:message key="cart.confirm_remove" var="confirmRemoveMsg"/>
                                                <a href="${pageContext.request.contextPath}/cart/remove?id=${item.product.productID}"
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('${confirmRemoveMsg}');">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- TỔNG TIỀN VÀ NÚT THANH TOÁN -->
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-3 p-3">
                            <h5 class="fw-bold mb-3"><fmt:message key="cart.summary_title"/></h5>

                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted"><fmt:message key="cart.lbl_selected"/></span>
                                <span class="fw-semibold" id="selectedCount">0</span>
                            </div>

                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted"><fmt:message key="cart.lbl_subtotal"/></span>
                                <span class="fw-semibold" id="subTotal">0 đ</span>
                            </div>

                            <div class="d-flex justify-content-between mb-3">
                                <span class="text-muted"><fmt:message key="cart.lbl_shipping"/></span>
                                <span class="text-success fw-semibold"><fmt:message key="cart.free_shipping"/></span>
                            </div>

                            <hr>

                            <div class="d-flex justify-content-between mb-4">
                                <span class="fw-bold fs-5"><fmt:message key="cart.lbl_total"/></span>
                                <span class="fw-bold fs-5 text-danger" id="grandTotal">0 đ</span>
                            </div>

                            <button type="submit" id="btnCheckout" class="btn btn-success btn-lg w-100 fw-bold">
                                <fmt:message key="cart.btn_checkout"/> <i class="bi bi-arrow-right ms-1"></i>
                            </button>
                        </div>
                    </div>

                </div>
            </form>
        </c:otherwise>
    </c:choose>
</div>

<!-- FORM ẨN ĐỂ UPDATE SỐ LƯỢNG MÀ KHÔNG BỊ TRÙNG VỚI FORM CHECKOUT -->
<form id="updateQtyForm" action="${pageContext.request.contextPath}/cart/update" method="post" style="display:none;">
    <input type="hidden" name="productId" id="updateProductId">
    <input type="hidden" name="quantity" id="updateQuantity">
</form>

<script>
    <fmt:message key="cart.js_items_suffix" var="jsItemsSuffix"/>
    <fmt:message key="cart.js_currency_unit" var="jsCurrencyUnit"/>

    const itemsSuffix = "${jsItemsSuffix}";
    const currencyUnit = "${jsCurrencyUnit}";

    // Hàm format số thành định dạng tiền tệ
    function formatCurrency(amount) {
        return new Intl.NumberFormat('${userLang == "en" ? "en-US" : "vi-VN"}').format(amount) + ' ' + currencyUnit;
    }

    // Tính tổng tiền dựa vào các checkbox đang được chọn
    function calculateTotal() {
        let total = 0;
        let count = 0;
        const checkboxes = document.querySelectorAll('.item-checkbox');
        const selectAllCb = document.getElementById('selectAll');

        checkboxes.forEach(cb => {
            if (cb.checked) {
                total += parseFloat(cb.getAttribute('data-price'));
                count++;
            }
        });

        // Cập nhật giao diện
        document.getElementById('selectedCount').innerText = count + ' ' + itemsSuffix;
        document.getElementById('subTotal').innerText = formatCurrency(total);
        document.getElementById('grandTotal').innerText = formatCurrency(total);

        // Nút checkout bị disable nếu không chọn sản phẩm nào
        const btnCheckout = document.getElementById('btnCheckout');
        if (count === 0) {
            btnCheckout.disabled = true;
            if (selectAllCb) selectAllCb.checked = false;
        } else {
            btnCheckout.disabled = false;
            if (selectAllCb) {
                if (count === checkboxes.length) {
                    selectAllCb.checked = true;
                } else {
                    selectAllCb.checked = false;
                }
            }
        }
    }

    // Tích / Bỏ tích tất cả
    function toggleSelectAll(master) {
        const checkboxes = document.querySelectorAll('.item-checkbox');
        checkboxes.forEach(cb => {
            cb.checked = master.checked;
        });
        calculateTotal();
    }

    // Submit thay đổi số lượng
    function updateQuantity(productId, newQty) {
        document.getElementById('updateProductId').value = productId;
        document.getElementById('updateQuantity').value = newQty;
        document.getElementById('updateQtyForm').submit();
    }

    // Tự động tính tổng tiền ngay khi tải trang xong
    document.addEventListener("DOMContentLoaded", function() {
        if (document.querySelectorAll('.item-checkbox').length > 0) {
            calculateTotal();
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>