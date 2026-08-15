<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary mb-0"><i class="bi bi-people-fill me-2"></i>Quản Lý Tài Khoản</h3>
        <button class="btn btn-primary btn-sm fw-semibold" data-bs-toggle="modal" data-bs-target="#addAccountModal">
            <i class="bi bi-person-plus-fill me-1"></i> Thêm Tài Khoản
        </button>
    </div>

    <!-- KHUNG TÌM KIẾM TÀI KHOẢN -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form id="searchAccountForm" class="row g-3" onsubmit="return searchAccounts(event)">
                <div class="col-md-4">
                    <label class="form-label small fw-semibold text-muted">Từ khóa (Tên đăng nhập)</label>
                    <input type="text" class="form-control form-control-sm" id="searchKeyword" value="${param.keyword}" placeholder="Nhập tên đăng nhập...">
                </div>

                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted">Vai trò</label>
                    <select id="searchRole" class="form-select form-select-sm">
                        <option value="">Tất cả vai trò</option>
                        <option value="Staff" ${param.role eq 'Staff' ? 'selected' : ''}>Nhân viên</option>
                        <option value="Manager" ${param.role eq 'Manager' ? 'selected' : ''}>Quản lý</option>
                        <option value="Customer" ${param.role eq 'Customer' ? 'selected' : ''}>Khách hàng</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted">Trạng thái</label>
                    <select id="searchStatus" class="form-select form-select-sm">
                        <option value="">Tất cả trạng thái</option>
                        <option value="true" ${param.status eq 'true' ? 'selected' : ''}>Hoạt động</option>
                        <option value="false" ${param.status eq 'false' ? 'selected' : ''}>Đã khóa</option>
                    </select>
                </div>

                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary btn-sm w-100 fw-semibold">
                        <i class="bi bi-search me-1"></i> Tìm kiếm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- BẢNG HIỂN THỊ KẾT QUẢ -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">Mã</th>
                            <th>Tên Đăng Nhập</th>
                            <th>Vai Trò</th>
                            <th>Trạng Thái</th>
                            <th class="text-end pe-3">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="acc" items="${accounts}">
                            <tr>
                                <td class="ps-3 fw-semibold">#${acc.accountID}</td>
                                <td>
                                    <div class="fw-bold text-dark"><i class="bi bi-person-circle me-1 text-secondary"></i>${acc.username}</div>
                                </td>
                                <td>
                                    <span class="badge ${acc.role eq 'Manager' ? 'bg-danger' : (acc.role eq 'Staff' ? 'bg-primary' : 'bg-secondary')}">
                                        ${acc.role}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge ${acc.active ? 'bg-success' : 'bg-warning text-dark'}">
                                        ${acc.active ? 'Hoạt động' : 'Đã khóa'}
                                    </span>
                                </td>
                                <td class="text-end pe-3">
                                    <button type="button" class="btn btn-outline-warning btn-sm me-1"
                                            onclick="resetAccountPassword(${acc.accountID})" title="Random mật khẩu mới & Gửi Email">
                                        <i class="bi bi-key-fill"></i>
                                    </button>

                                    <a href="${pageContext.request.contextPath}/admin/account?action=toggle-status&id=${acc.accountID}&status=${!acc.active}"
                                       class="btn btn-outline-${acc.active ? 'danger' : 'success'} btn-sm"
                                       title="${acc.active ? 'Khóa' : 'Mở khóa'}">
                                        <i class="bi bi-shield-${acc.active ? 'lock' : 'check'}"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty accounts}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">Không tìm thấy tài khoản phù hợp.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    function searchAccounts(e) {
        if (e) {
            e.preventDefault();
            e.stopPropagation();
        }

        try {
            const appPath = "${pageContext.request.contextPath}";
            const keyword = document.getElementById('searchKeyword').value;
            const role = document.getElementById('searchRole').value;
            const status = document.getElementById('searchStatus').value;

            // Gọi đúng servlet với action search
            const url = appPath + "/admin/account?action=search&keyword="
                + encodeURIComponent(keyword) + "&role=" + encodeURIComponent(role) + "&status=" + encodeURIComponent(status);

            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error("Lỗi mạng/server: " + response.status);
                    return response.text();
                })
                .then(html => {
                    // Đổ dữ liệu vào vùng hiển thị
                    document.getElementById('main-content').innerHTML = html;

                    // Cập nhật lại URL trình duyệt giữ nguyên tab=account kèm theo các tham số tìm kiếm
                    const newUrl = appPath + "/admin/dashboard?tab=account&action=search&keyword="
                        + encodeURIComponent(keyword) + "&role=" + encodeURIComponent(role) + "&status=" + encodeURIComponent(status);
                    history.pushState(null, '', newUrl);
                })
                .catch(err => console.error("Lỗi tìm kiếm:", err));
        } catch (err) {
            console.error("Lỗi thực thi JavaScript:", err);
        }

        return false;
    }

    function resetAccountPassword(accountId) {
        if (confirm("Cậu có chắc chắn muốn random mật khẩu mới và gửi qua email cho tài khoản #" + accountId + " không?")) {
            fetch('${pageContext.request.contextPath}/admin/account?action=reset-password&id=' + accountId, {
                method: 'POST'
            })
            .then(response => response.text())
            .then(result => {
                alert(result);
            })
            .catch(err => {
                console.error(err);
                alert("Đã xảy ra lỗi khi kết nối đến server để reset mật khẩu!");
            });
        }
    }
</script>