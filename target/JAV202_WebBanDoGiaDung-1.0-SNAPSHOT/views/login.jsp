<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Đồ Gia Dụng Cao Cấp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        .login-header {
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            color: white;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
    </style>
</head>
<body class="d-flex align-items-center min-vh-100 py-5">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">

            <div class="card login-card">
                <!-- Card Header -->
                <div class="card-header login-header text-center py-4">
                    <h4 class="mb-1 fw-bold"><i class="bi bi-shop me-2"></i>CỬA HÀNG ĐỒ GIA DỤNG</h4>
                    <p class="mb-0 text-white-50">Đăng nhập tài khoản để tiếp tục</p>
                </div>

                <!-- Card Body -->
                <div class="card-body p-4 p-sm-5">

                    <!-- Thông báo Lỗi từ Servlet (Nếu có) -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                            <div>${error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Thông báo Thành công từ Đăng ký chuyển sang (Nếu có) -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                            <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                            <div>${success}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Form Đăng nhập -->
                    <form action="${pageContext.request.contextPath}/login" method="post">

                        <!-- Username Input -->
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">Tên đăng nhập</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-secondary"><i class="bi bi-person-fill"></i></span>
                                <input type="text" class="form-control" id="username" name="username"
                                       placeholder="Nhập username..." required>
                            </div>
                        </div>

                        <!-- Password Input -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label for="password" class="form-label fw-semibold mb-0">Mật khẩu</label>
                                <a href="#" class="text-decoration-none small text-muted">Quên mật khẩu?</a>
                            </div>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-secondary"><i class="bi bi-lock-fill"></i></span>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="Nhập mật khẩu..." required>
                            </div>
                        </div>

                        <!-- Remember Me Checkbox -->
                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="rememberMe">
                            <label class="form-check-label text-secondary small" for="rememberMe">
                                Ghi nhớ đăng nhập
                            </label>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
                        </button>

                    </form>

                </div>

                <!-- Card Footer -->
                <div class="card-footer bg-light text-center py-3 border-0 rounded-bottom">
                    <span class="text-muted small">Chưa có tài khoản? </span>
                    <a href="${pageContext.request.contextPath}/dang-ky" class="fw-semibold text-primary text-decoration-none">Đăng ký ngay</a>
                </div>
            </div>

            <!-- Back to Home Link -->
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none small">
                    <i class="bi bi-arrow-left me-1"></i> Trở về Trang chủ
                </a>
            </div>

        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>