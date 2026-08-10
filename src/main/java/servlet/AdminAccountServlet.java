package servlet;

import dao.AccountDAO;
import entity.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/account")
public class AdminAccountServlet extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // 1. XỬ LÝ KHÓA / MỞ KHÓA TÀI KHOẢN
        if ("toggle-status".equals(action)) {
            try {
                int accountId = Integer.parseInt(request.getParameter("id"));
                boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));

                accountDAO.updateAccountStatus(accountId, newStatus);

                request.getSession().setAttribute("message",
                        (newStatus ? "Đã mở khóa" : "Đã khóa") + " tài khoản thành công!");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại: " + e.getMessage());
            }

            // SỬA TẠI ĐÂY: Redirect về tab account trên Dashboard thay vì /admin/account
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=account");
            return;
        }

        // 2. MẶC ĐỊNH LOAD DANH SÁCH TÀI KHOẢN (Cho AJAX Fetch)
        List<Account> accounts = accountDAO.findAll();
        request.setAttribute("accounts", accounts);

        // SỬA TẠI ĐÂY: Đảm bảo có dấu "/" ở đầu path JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/fragments/account-table.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // 3. XỬ LÝ SỬA QUYỀN (Gửi từ Modal)
        if ("update-role".equals(action)) {
            try {
                int accountId = Integer.parseInt(request.getParameter("accountId"));
                String newRole = request.getParameter("role");

                accountDAO.updateAccountRole(accountId, newRole);

                request.getSession().setAttribute("message", "Cập nhật vai trò thành công!");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Cập nhật vai trò thất bại: " + e.getMessage());
            }

            // SỬA TẠI ĐÂY: Redirect về tab account trên Dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=account");
        }
    }
}