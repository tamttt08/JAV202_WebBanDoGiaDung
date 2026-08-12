package servlet;

import dao.AccountDAO;
import entity.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.EmailUtil; // Đảm bảo import đúng package util

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/account")
public class AdminAccountServlet extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // 1. XỬ LÝ TÌM KIẾM TÀI KHOẢN
        if ("search".equals(action)) {
            String keyword = request.getParameter("keyword");
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            List<Account> accounts = accountDAO.searchAccounts(keyword, role, status);
            request.setAttribute("accounts", accounts);
            request.getRequestDispatcher("/WEB-INF/views/admin/fragments/account-table.jsp").forward(request, response);
            return;
        }

        // 2. XỬ LÝ KHÓA / MỞ KHÓA TÀI KHOẢN
        if ("toggle-status".equals(action)) {
            try {
                int accountId = Integer.parseInt(request.getParameter("id"));
                boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));

                accountDAO.updateAccountStatus(accountId, newStatus);
                request.getSession().setAttribute("message", (newStatus ? "Đã mở khóa" : "Đã khóa") + " tài khoản thành công!");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=account");
            return;
        }

        // 3. MẶC ĐỊNH LOAD DANH SÁCH TÀI KHOẢN
        List<Account> accounts = accountDAO.findAll();
        request.setAttribute("accounts", accounts);
        request.getRequestDispatcher("/WEB-INF/views/admin/fragments/account-table.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // 4. XỬ LÝ RESET MẬT KHẨU NGẪU NHIÊN & GỬI EMAIL
        if ("reset-password".equals(action)) {
            response.setContentType("text/plain;charset=UTF-8");
            try {
                int accountId = Integer.parseInt(request.getParameter("id"));
                Account acc = accountDAO.findById(accountId);

                // Lấy email linh hoạt: Ưu tiên lấy từ Staff nếu có, nếu không thì lấy từ Customer
                String email = null;
                if (acc != null) {
                    if (acc.getStaff() != null && acc.getStaff().getEmail() != null) {
                        email = acc.getStaff().getEmail();
                    } else if (acc.getCustomer() != null && acc.getCustomer().getEmail() != null) {
                        email = acc.getCustomer().getEmail();
                    }
                }

                if (acc != null && email != null && !email.isEmpty()) {
                    String randomPassword = java.util.UUID.randomUUID().toString().substring(0, 8);
                    boolean updated = accountDAO.updatePassword(accountId, randomPassword);

                    if (updated) {
                        String subject = "Cấp lại mật khẩu mới - Gia Dụng Shop";
                        String content = "Xin chào " + acc.getUsername() + ",\n\nMật khẩu mới của bạn là: " + randomPassword + "\nVui lòng đăng nhập và thực hiện đổi lại mật khẩu ngay.";

                        boolean sent = EmailUtil.sendEmail(email, subject, content, false);

                        if (sent) {
                            response.getWriter().write("Đã reset mật khẩu và gửi về email: " + email);
                        } else {
                            response.getWriter().write("Đã đổi mật khẩu trong DB nhưng gửi Email thất bại!");
                        }
                    } else {
                        response.getWriter().write("Lỗi: Không thể cập nhật mật khẩu vào DB!");
                    }
                } else {
                    response.getWriter().write("Lỗi: Tài khoản không tồn tại hoặc không tìm thấy Email trong hệ thống!");
                }
            } catch (Exception e) {
                response.getWriter().write("Lỗi hệ thống: " + e.getMessage());
            }
            return;
        }

        // 5. XỬ LÝ CẬP NHẬT VAI TRÒ
        if ("update-role".equals(action)) {
            try {
                int accountId = Integer.parseInt(request.getParameter("accountId"));
                String newRole = request.getParameter("role");

                accountDAO.updateAccountRole(accountId, newRole);
                request.getSession().setAttribute("message", "Cập nhật vai trò thành công!");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Cập nhật vai trò thất bại!");
            }
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=account");
        }
    }
}