<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<footer class="bg-dark text-light pt-5 pb-4 mt-auto border-top border-secondary">
    <div class="container">
        <div class="row g-4">
            <!-- Cột 1: Thương hiệu -->
            <div class="col-md-4">
                <h5 class="fw-bold text-primary mb-3">
                    <i class="bi bi-shop me-2"></i>GIA DỤNG STORE
                </h5>
                <p class="small text-white-50">
                    Chuyên cung cấp các sản phẩm đồ gia dụng chất lượng cao, hiện đại và tiện ích cho mọi gia đình.
                </p>
            </div>

            <!-- Cột 2: Liên kết nhanh -->
            <div class="col-md-4">
                <h6 class="fw-bold text-white mb-3">Liên kết nhanh</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/home" class="text-white-50 text-decoration-none hover-white">
                            <i class="bi bi-chevron-right small me-1"></i>Trang chủ
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="#" class="text-white-50 text-decoration-none hover-white">
                            <i class="bi bi-chevron-right small me-1"></i>Sản phẩm khuyến mãi
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="#" class="text-white-50 text-decoration-none hover-white">
                            <i class="bi bi-chevron-right small me-1"></i>Chính sách bảo hành
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Cột 3: Thông tin liên hệ -->
            <div class="col-md-4">
                <h6 class="fw-bold text-white mb-3">Thông tin liên hệ</h6>
                <p class="small text-white-50 mb-2">
                    <i class="bi bi-geo-alt-fill text-primary me-2"></i>TP. Hồ Chí Minh, Việt Nam
                </p>
                <p class="small text-white-50 mb-2">
                    <i class="bi bi-telephone-fill text-primary me-2"></i>Hotline: 1900 9090
                </p>
                <p class="small text-white-50 mb-0">
                    <i class="bi bi-envelope-fill text-primary me-2"></i>Email: support@giadung.com
                </p>
            </div>
        </div>

        <hr class="border-secondary my-4">

        <div class="text-center small text-white-50">
            &copy; 2026 Gia Dụng Store. All rights reserved.
        </div>
    </div>
</footer>