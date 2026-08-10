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
    <title><fmt:message key="checkout.title"/> - <fmt:message key="cart.brand_title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
</head>
<body class="bg-light">

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-shop me-2"></i><fmt:message key="cart.brand_title"/>
        </a>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light btn-sm">
            <i class="bi bi-arrow-left me-1"></i> <fmt:message key="checkout.btn_back_cart"/>
        </a>
    </div>
</nav>

<div class="container my-4">
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
                            <!-- Nút định vị GPS -->
                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="getCurrentLocation()">
                                <i class="bi bi-geo-alt-fill me-1"></i><fmt:message key="checkout.btn_get_location"/>
                            </button>
                        </div>

                        <!-- Ô nhập địa chỉ -->
                        <fmt:message key="checkout.ph_address" var="phAddress"/>
                        <textarea class="form-control mb-2" id="address" name="address" rows="2"
                                  placeholder="${phAddress}" required>${customer != null ? customer.address : ''}</textarea>

                        <!-- Khung hiển thị bản đồ -->
                        <div id="map" style="height: 280px; width: 100%; border-radius: 8px;" class="border"></div>
                        <small class="text-muted"><i class="bi bi-info-circle me-1"></i><fmt:message key="checkout.map_note"/></small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold"><fmt:message key="checkout.lbl_note"/></label>
                        <fmt:message key="checkout.ph_note" var="phNote"/>
                        <textarea name="note" class="form-control" rows="2" placeholder="${phNote}"></textarea>
                    </div>

                    <h5 class="fw-bold mt-4 mb-3"><i class="bi bi-wallet2 me-2 text-primary"></i><fmt:message key="checkout.sec_payment_method"/></h5>
                    <div class="form-check border rounded p-3 mb-2">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="COD" checked>
                        <label class="form-check-label fw-semibold" for="cod">
                            <i class="bi bi-cash-stack me-2 text-success"></i><fmt:message key="checkout.pm_cod"/>
                        </label>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<fmt:message key="checkout.js_getting_address" var="jsGettingAddress"/>
<fmt:message key="checkout.js_getting_location" var="jsGettingLocation"/>
<fmt:message key="checkout.js_coords_prefix" var="jsCoordsPrefix"/>
<fmt:message key="checkout.js_err_perm_denied" var="jsErrPermDenied"/>
<fmt:message key="checkout.js_err_unavailable" var="jsErrUnavailable"/>
<fmt:message key="checkout.js_err_no_support" var="jsErrNoSupport"/>

<script>
    // 1. Tọa độ mặc định (TP.HCM)
    var defaultLat = 10.7769;
    var defaultLng = 106.7009;

    // 2. Khởi tạo bản đồ Leaflet
    var map = L.map('map').setView([defaultLat, defaultLng], 15);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    var marker = L.marker([defaultLat, defaultLng], { draggable: true }).addTo(map);

    // Fix lỗi hiển thị map khi nằm trong khung
    setTimeout(function() { map.invalidateSize(); }, 400);

    // 3. Hàm lấy địa chỉ từ Tọa độ
    function reverseGeocode(lat, lng) {
        var addressInput = document.getElementById('address');
        addressInput.placeholder = "${jsGettingAddress}";

        var url = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}&accept-language=${'${userLang}'}`;

        fetch(url)
            .then(response => response.json())
            .then(data => {
                if (data && data.display_name) {
                    addressInput.value = data.display_name;
                } else {
                    addressInput.value = `${jsCoordsPrefix} ${lat.toFixed(5)}, ${lng.toFixed(5)}`;
                }
            })
            .catch(err => {
                console.error("Lỗi reverseGeocode:", err);
                addressInput.value = `${jsCoordsPrefix} ${lat.toFixed(5)}, ${lng.toFixed(5)}`;
            });
    }

    // 4. Kéo thả ghim
    marker.on('dragend', function (e) {
        var position = marker.getLatLng();
        reverseGeocode(position.lat, position.lng);
    });

    // 5. Click lên map
    map.on('click', function (e) {
        var lat = e.latlng.lat;
        var lng = e.latlng.lng;
        marker.setLatLng([lat, lng]);
        reverseGeocode(lat, lng);
    });

    // 6. Định vị GPS người dùng
    function getCurrentLocation() {
        if (navigator.geolocation) {
            var addressInput = document.getElementById('address');
            addressInput.placeholder = "${jsGettingLocation}";

            navigator.geolocation.getCurrentPosition(
                function (position) {
                    var lat = position.coords.latitude;
                    var lng = position.coords.longitude;

                    map.setView([lat, lng], 16);
                    marker.setLatLng([lat, lng]);

                    reverseGeocode(lat, lng);
                },
                function (error) {
                    console.warn("Lỗi vị trí:", error.message);
                    let msg = "";
                    switch(error.code) {
                        case error.PERMISSION_DENIED:
                            msg = "${jsErrPermDenied}";
                            break;
                        case error.POSITION_UNAVAILABLE:
                        case error.TIMEOUT:
                        default:
                            msg = "${jsErrUnavailable}";
                    }
                    alert(msg);
                    addressInput.placeholder = "${phAddress}";
                },
                {
                    enableHighAccuracy: false,
                    timeout: 10000,
                    maximumAge: 60000
                }
            );
        } else {
            alert("${jsErrNoSupport}");
        }
    }
</script>
</body>
</html>