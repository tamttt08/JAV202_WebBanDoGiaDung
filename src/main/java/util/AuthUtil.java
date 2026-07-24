package util;

import entity.Account; // Import đúng Entity Account của cậu
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class AuthUtil {
    public static final String SESSION_USER = "user";

    // Lưu thông tin tài khoản đăng nhập vào Session
    public static void setUser(HttpServletRequest request, Account account) {
        HttpSession session = request.getSession();
        session.setAttribute(SESSION_USER, account);
    }

    // Lấy thông tin tài khoản đang đăng nhập từ Session
    public static Account getUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (Account) session.getAttribute(SESSION_USER);
    }

    // Kiểm tra xem người dùng đã đăng nhập (Login) chưa
    public static boolean isAuthenticated(HttpServletRequest request) {
        return getUser(request) != null;
    }

    // Kiểm tra xem tài khoản đăng nhập có phải là Quản lý (Manager) không
    public static boolean isManager(HttpServletRequest request) {
        Account acc = getUser(request);
        // So sánh trực tiếp với Enum Account.Role.Manager
        return acc != null && acc.getRole() == Account.Role.Manager;
    }

    // Kiểm tra xem tài khoản đăng nhập có phải là Nhân viên (Staff) không
    public static boolean isStaff(HttpServletRequest request) {
        Account acc = getUser(request);
        // So sánh trực tiếp với Enum Account.Role.Staff
        return acc != null && acc.getRole() == Account.Role.Staff;
    }

    // Kiểm tra xem tài khoản đăng nhập có phải là Khách hàng (Customer) không
    public static boolean isCustomer(HttpServletRequest request) {
        Account acc = getUser(request);
        // So sánh trực tiếp với Enum Account.Role.Customer
        return acc != null && acc.getRole() == Account.Role.Customer;
    }

    // Xóa thông tin đăng nhập khi người dùng Đăng xuất (Logout)
    public static void clear(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session != null) {
            session.removeAttribute(SESSION_USER);
            // Có thể dùng session.invalidate() nếu muốn xóa toàn bộ session (Xóa cả giỏ hàng tạm nếu có)
        }
    }
}