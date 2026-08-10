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
    <title><fmt:message key="profile.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        .profile-card { border-radius: 12px; border: none; box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
        .avatar-circle { width: 80px; height: 80px; background-color: #0d6efd; color: #fff; font-size: 32px; font-weight: bold; display: flex; align-items: center; justify-content: center; border-radius: 50%; margin: 0 auto 15px; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="card profile-card p-4 bg-white">

                <!-- Header Card -->
                <div class="text-center mb-4">
                    <div class="avatar-circle">
                        ${not empty customer.fullName ? customer.fullName.substring(0,1).toUpperCase() : 'U'}
                    </div>
                    <h4 class="fw-bold mb-1">${customer.fullName}</h4>
                    <p class="text-muted mb-0"><fmt:message key="profile.sub_title"/></p>
                </div>

                <!-- Thông báo Lỗi / Thành công -->
                <c:if test="${not empty message}">
                    <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                        <i class="bi bi-info-circle me-1"></i> ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Form cập nhật -->
                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold"><fmt:message key="profile.lbl_fullname"/> <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" name="fullName" value="${customer.fullName}" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold"><fmt:message key="profile.lbl_phone"/></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <fmt:message key="profile.ph_phone" var="phPhone"/>
                                <input type="text" class="form-control" name="phone" value="${customer.phone}" placeholder="${phPhone}">
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold"><fmt:message key="profile.lbl_email"/></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <fmt:message key="profile.ph_email" var="phEmail"/>
                                <input type="email" class="form-control" name="email" value="${customer.email}" placeholder="${phEmail}">
                            </div>
                        </div>

                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label fw-semibold mb-0"><fmt:message key="profile.lbl_address"/></label>
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="getCurrentLocation()">
                                    <i class="bi bi-geo-alt-fill me-1"></i> <fmt:message key="profile.btn_get_location"/>
                                </button>
                            </div>

                            <!-- Ô nhập địa chỉ -->
                            <div class="input-group mb-2">
                                <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                                <fmt:message key="profile.ph_address" var="phAddress"/>
                                <textarea class="form-control" id="address" name="address" rows="2"
                                          placeholder="${phAddress}">${customer.address}</textarea>
                            </div>

                            <!-- Khung chứa Bản đồ -->
                            <div id="map" style="height: 250px; width: 100%; border-radius: 8px; border: 1px solid #dee2e6;"></div>
                            <small class="text-muted d-block mt-1">
                                <i class="bi bi-info-circle me-1"></i> <fmt:message key="profile.map_note"/>
                            </small>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-4 pt-2 border-top">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-arrow-left me-1"></i> <fmt:message key="profile.btn_back_store"/>
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg me-1"></i> <fmt:message key="profile.btn_save"/>
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // i18n text cho JS
    var msgLoadingAddress = "<fmt:message key='profile.js_loading_address'/>";
    var msgCoords = "<fmt:message key='profile.js_coords'/>";
    var msgGpsError = "<fmt:message key='profile.js_gps_error'/>";
    var msgNoGpsSupport = "<fmt:message key='profile.js_no_gps_support'/>";
    var userLang = "${userLang}";

    // 1. Tọa độ mặc định (TP.HCM)
    var defaultLat = 10.7769;
    var defaultLng = 106.7009;

    // 2. Khởi tạo bản đồ Leaflet
    var map = L.map('map').setView([defaultLat, defaultLng], 14);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    var marker = L.marker([defaultLat, defaultLng], { draggable: true }).addTo(map);

    // 3. Hàm lấy tên địa chỉ từ tọa độ
    function reverseGeocode(lat, lng) {
        var addressInput = document.getElementById('address') || document.querySelector('textarea[name="address"]');
        if (!addressInput) return;

        addressInput.placeholder = msgLoadingAddress;

        // Tự động thay đổi ngôn ngữ phản hồi API theo userLang
        var acceptLang = userLang === 'en' ? 'en' : 'vi';
        var url = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}&accept-language=${acceptLang}`;

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error("Network error when fetching address");
                return response.json();
            })
            .then(data => {
                if (data && data.display_name) {
                    addressInput.value = data.display_name;
                } else {
                    addressInput.value = `${msgCoords} ${lat.toFixed(5)}, ${lng.toFixed(5)}`;
                }
            })
            .catch(err => {
                console.warn("Could not retrieve street name, recording coordinates:", err);
                addressInput.value = `${msgCoords} ${lat.toFixed(5)}, ${lng.toFixed(5)}`;
            });
    }

    // 4. Kéo thả ghim trên map
    marker.on('dragend', function (e) {
        var position = marker.getLatLng();
        reverseGeocode(position.lat, position.lng);
    });

    // 5. Click trực tiếp lên map
    map.on('click', function (e) {
        var lat = e.latlng.lat;
        var lng = e.latlng.lng;
        marker.setLatLng([lat, lng]);
        reverseGeocode(lat, lng);
    });

    // 6. Định vị GPS người dùng
    function getCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function (position) {
                    var lat = position.coords.latitude;
                    var lng = position.coords.longitude;

                    if (typeof map !== 'undefined' && typeof marker !== 'undefined') {
                        map.setView([lat, lng], 16);
                        marker.setLatLng([lat, lng]);
                    }

                    reverseGeocode(lat, lng);
                },
                function (error) {
                    console.error("GPS Error:", error);
                    alert(msgGpsError);
                },
                {
                    enableHighAccuracy: false,
                    timeout: 10000,
                    maximumAge: 60000
                }
            );
        } else {
            alert(msgNoGpsSupport);
        }
    }
</script>
</body>
</html>