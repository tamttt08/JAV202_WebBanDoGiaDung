<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Tài Khoản - Gia Dụng Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }
        .register-card {
            width: 100%;
            max-width: 480px;
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

<div class="card register-card bg-white p-4">
    <div class="card-body">
        <!-- LOGO & BRAND -->
        <div class="text-center mb-4">
            <i class="bi bi-box-seam-fill text-primary display-4"></i>
            <h3 class="fw-bold text-dark mt-2">Tạo Tài Khoản Mới</h3>
            <p class="text-muted small">Đăng ký để mua sắm thiết bị gia dụng dễ dàng hơn</p>
        </div>

        <!-- THÔNG BÁO LỖI NẾU CÓ -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show text-center py-2 fs-6" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- FORM ĐĂNG KÝ -->
        <form action="${pageContext.request.contextPath}/register" method="post">

            <!-- Họ và tên -->
            <div class="mb-3">
                <label class="form-label fw-semibold">Họ và Tên</label>
                <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required>
            </div>

            <!-- Tên đăng nhập -->
            <div class="mb-3">
                <label class="form-label fw-semibold">Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" placeholder="username123" required>
            </div>

            <!-- Email -->
            <div class="mb-3">
                <label class="form-label fw-semibold">Email</label>
                <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required>
            </div>

            <!-- Mật khẩu -->
            <div class="mb-3">
                <label class="form-label fw-semibold">Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <!-- Xác nhận mật khẩu -->
            <div class="mb-4">
                <label class="form-label fw-semibold">Xác nhận mật khẩu</label>
                <input type="password" name="confirmPassword" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold rounded-3">
                <i class="bi bi-person-plus-fill me-1"></i> Đăng Ký
            </button>
        </form>

        <hr class="my-4">

        <div class="text-center">
            <span class="text-muted small">Đã có tài khoản?</span>
            <a href="${pageContext.request.contextPath}/login" class="text-primary fw-bold text-decoration-none ms-1">Đăng nhập ngay</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>