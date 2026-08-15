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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="checkout.title"/> - <fmt:message key="cart.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
</head>
<body class="bg-light d-flex flex-column min-vh-100">

<!-- NAVBAR (Đồng bộ hệ thống) -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-box-seam-fill text-primary me-2"></i><fmt:message key="cart.brand_title"/>
        </a>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light btn-sm">
            <i class="bi bi-arrow-left me-1"></i> <fmt:message key="checkout.btn_back_cart"/>
        </a>
    </div>
</nav>

<!-- MAIN CONTENT -->
<div class="container my-4 flex-grow-1">
    <h3 class="fw-bold mb-4"><i class="bi bi-credit-card me-2"></i><fmt:message key="checkout.page_heading"/></h3>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout/process" method="post">
        <div class="row g-4">

            <!-- THÔNG TIN GIAO HÀNG -->
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-geo-alt me-2 text-primary"></i><fmt:message key="checkout.sec_receiver_info"/></h5>

                    <div class="mb-3">
                        <label class="form-label fw-semibold"><fmt:message key="checkout.lbl_fullname"/> <span class="text-danger">*</span></label>
                        <fmt:message key="checkout.ph_fullname" var="phFullname"/>
                        <input type="text" name="receiverName" class="form-control"
                               value="${customer != null ? customer.fullName : ''}" placeholder="${phFullname}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold"><fmt:message key="checkout.lbl_phone"/> <span class="text-danger">*</span></label>
                        <fmt:message key="checkout.ph_phone" var="phPhone"/>
                        <input type="tel" name="receiverPhone" class="form-control"
                               value="${customer != null ? customer.phone : ''}" placeholder="${phPhone}" pattern="[0-9]{10,11}" required>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label for="address" class="form-label fw-semibold mb-0"><fmt:message key="checkout.lbl_address"/> <span class="text-danger">*</span></label>
                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="getCurrentLocation()">
                                <i class="bi bi-geo-alt-fill me-1"></i><fmt:message key="checkout.btn_get_location"/>
                            </button>
                        </div>

                        <fmt:message key="checkout.ph_address" var="phAddress"/>
                        <textarea class="form-control mb-2" id="address" name="address" rows="2"
                                  placeholder="${phAddress}" required>${customer != null ? customer.address : ''}</textarea>

                        <div id="map" style="height: 280px; width: 100%; border-radius: 8px;" class="border"></div>
                        <small class="text-muted"><i class="bi bi-info-circle me-1"></i><fmt:message key="checkout.map_note"/></small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold"><fmt:message key="checkout.lbl_note"/></label>
                        <fmt:message key="checkout.ph_note" var="phNote"/>
                        <textarea name="note" class="form-control" rows="2" placeholder="${phNote}"></textarea>
                    </div>

                    <h5 class="fw-bold mt-4 mb-3"><i class="bi bi-wallet2 me-2 text-primary"></i><fmt:message key="checkout.sec_payment_method"/></h5>

                    <!-- COD -->
                    <div class="form-check border rounded p-3 mb-2">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="COD" checked onclick="togglePaymentMethod()">
                        <label class="form-check-label fw-semibold" for="cod">
                            <i class="bi bi-cash-stack me-2 text-success"></i><fmt:message key="checkout.pm_cod"/>
                        </label>
                    </div>

                    <!-- Chuyển khoản QR Ngân hàng (Đã cấu hình STK 866602008 - DUONG THANH TUAN) -->
                    <div class="form-check border rounded p-3 mb-2">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="qrTransfer" value="QR_TRANSFER" onclick="togglePaymentMethod()">
                        <label class="form-check-label fw-semibold" for="qrTransfer">
                            <i class="bi bi-qr-code-scan me-2 text-primary"></i> Chuyển khoản quét mã QR Ngân hàng
                        </label>
                    </div>

                    <!-- Khung hiển thị QR Code -->
                    <div id="qrCodeSection" class="text-center p-3 border rounded bg-white mt-3" style="display: none;">
                        <p class="fw-bold text-danger mb-2">Quét mã QR để thanh toán nhanh chóng</p>
                        <img id="vietQrImg" src="" alt="QR Ngân hàng" class="img-fluid border rounded mb-2" style="max-width: 220px;">
                        <div class="small text-muted">
                            <p class="mb-1">Ngân hàng: <b>MB Bank (Quân Đội)</b></p>
                            <p class="mb-1">Số tài khoản: <b>866602008</b></p>
                            <p class="mb-0">Chủ tài khoản: <b>DUONG THANH TUAN</b></p>
                            <p class="text-primary mt-2 mb-0 fw-semibold">Nội dung chuyển khoản tự động sẽ theo mã đơn hàng.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TÓM TẮT SẢN PHẨM THANH TOÁN -->
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h5 class="fw-bold mb-3"><fmt:message key="checkout.sec_selected_items"/> (${checkoutItems.size()})</h5>

                    <div class="mb-3" style="max-height: 300px; overflow-y: auto;">
                        <c:forEach var="item" items="${checkoutItems}">
                            <div class="d-flex align-items-center mb-3">
                                <img src="${item.product.mainImage}" alt="${item.product.productName}"
                                     style="width: 50px; height: 50px; object-fit: contain;" class="rounded border me-3">
                                <div class="flex-grow-1">
                                    <div class="fw-bold text-dark text-truncate" style="max-width: 200px;">
                                            ${item.product.productName}
                                    </div>
                                    <div class="text-muted small"><fmt:message key="checkout.lbl_quantity"/> ${item.quantity}</div>
                                </div>
                                <div class="fw-bold text-end">
                                    <fmt:formatNumber value="${item.totalPrice}" type="number" groupingUsed="true"/> đ
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted"><fmt:message key="checkout.lbl_subtotal"/></span>
                        <span class="fw-semibold">
                            <fmt:formatNumber value="${checkoutGrandTotal}" type="number" groupingUsed="true"/> đ
                        </span>
                    </div>

                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted"><fmt:message key="checkout.lbl_shipping"/></span>
                        <span class="text-success fw-semibold"><fmt:message key="checkout.free_shipping"/></span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between mb-4">
                        <span class="fw-bold fs-5"><fmt:message key="checkout.lbl_grand_total"/></span>
                        <span class="fw-bold fs-4 text-danger">
                            <fmt:formatNumber value="${checkoutGrandTotal}" type="number" groupingUsed="true"/> đ
                        </span>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg w-100 fw-bold">
                        <i class="bi bi-check-circle me-1"></i> <fmt:message key="checkout.btn_place_order"/>
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- FOOTER (Đồng bộ hệ thống) -->
<footer class="bg-dark text-white text-center py-4 mt-auto">
    <div class="container">
        <p class="mb-0 small">&copy; 2026 Gia Dụng Store. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<fmt:message key="checkout.js_getting_address" var="jsGettingAddress"/>
<fmt:message key="checkout.js_getting_location" var="jsGettingLocation"/>
<fmt:message key="checkout.js_coords_prefix" var="jsCoordsPrefix"/>
<fmt:message key="checkout.js_err_perm_denied" var="jsErrPermDenied"/>
<fmt:message key="checkout.js_err_unavailable" var="jsErrUnavailable"/>
<fmt:message key="checkout.js_err_no_support" var="jsErrNoSupport"/>

<script>
    function togglePaymentMethod() {
        var qrSection = document.getElementById('qrCodeSection');
        var isQrSelected = document.getElementById('qrTransfer').checked;

        if (isQrSelected) {
            qrSection.style.display = 'block';

            var amountStr = "${checkoutGrandTotal}";
            var amount = parseFloat(amountStr) || 0;

            var bankId = "MB";
            var accountNo = "866602008";
            var template = "compact2";
            var addInfo = "Thanh toan don hang";

            var qrUrl = "https://img.vietqr.io/image/" + bankId + "-" + accountNo + "-" + template + ".png?amount=" + amount + "&addInfo=" + encodeURIComponent(addInfo);
            document.getElementById('vietQrImg').src = qrUrl;
        } else {
            qrSection.style.display = 'none';
        }
    }

    var defaultLat = 10.7769;
    var defaultLng = 106.7009;

    var map = L.map('map').setView([defaultLat, defaultLng], 15);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    var marker = L.marker([defaultLat, defaultLng], { draggable: true }).addTo(map);

    // Tránh lỗi hiển thị xám bản đồ khi load tab ẩn
    setTimeout(function() { map.invalidateSize(); }, 400);

    // Sửa lỗi hàm reverseGeocode để chắc chắn luôn điền được dữ liệu vào ô input
    function reverseGeocode(lat, lng) {
        var addressInput = document.getElementById('address');
        addressInput.value = "Đang lấy địa chỉ...";

        var url = "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=" + lat + "&lon=" + lng;

        fetch(url, {
            headers: {
                'Accept-Language': 'vi'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Network response was not ok");
            }
            return response.json();
        })
        .then(data => {
            if (data && data.display_name) {
                addressInput.value = data.display_name;
            } else {
                addressInput.value = "Tọa độ: " + lat.toFixed(5) + ", " + lng.toFixed(5);
            }
        })
        .catch(err => {
            console.error("Lỗi lấy địa chỉ từ Nominatim:", err);
            addressInput.value = "Tọa độ vị trí: " + lat.toFixed(5) + ", " + lng.toFixed(5);
        });
    }

    // Tự động lấy địa chỉ mặc định ngay khi vừa load trang lên ghim ở giữa
    reverseGeocode(defaultLat, defaultLng);

    marker.on('dragend', function (e) {
        var position = marker.getLatLng();
        reverseGeocode(position.lat, position.lng);
    });

    map.on('click', function (e) {
        var lat = e.latlng.lat;
        var lng = e.latlng.lng;
        marker.setLatLng([lat, lng]);
        reverseGeocode(lat, lng);
    });

    function getCurrentLocation() {
        if (navigator.geolocation) {
            var addressInput = document.getElementById('address');
            addressInput.value = "Đang lấy vị trí hiện tại của bạn...";

            navigator.geolocation.getCurrentPosition(
                function (position) {
                    var lat = position.coords.latitude;
                    var lng = position.coords.longitude;

                    map.setView([lat, lng], 16);
                    marker.setLatLng([lat, lng]);

                    reverseGeocode(lat, lng);
                },
                function (error) {
                    console.warn("Lỗi định vị GPS:", error.message);
                    alert("Không thể lấy vị trí hiện tại của bạn. Vui lòng cấp quyền vị trí hoặc chọn trực tiếp trên bản đồ!");
                    addressInput.value = "";
                },
                {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 0
                }
            );
        } else {
            alert("Trình duyệt của bạn không hỗ trợ định vị GPS.");
        }
    }
</script>
</body>
</html>