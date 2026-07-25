package servlet;

import dao.AccountDAO; // Đảm bảo cậu đã có AccountDAO
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

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // Xử lý các thao tác khóa/mở khóa tài khoản (nếu cậu muốn phát triển thêm)
            if ("toggleLock".equals(action)) {
                String username = request.getParameter("username");
                if (username != null && !username.isEmpty()) {
                    // Gọi hàm cập nhật trạng thái active/inactive trong DAO
                    // accountDAO.toggleStatus(username);
                }
            }

            // 1. Lấy danh sách toàn bộ tài khoản
            List<Account> accounts = accountDAO.findAll();
            request.setAttribute("accounts", accounts);

            // 2. Trả về đúng mảnh HTML fragment
            request.getRequestDispatcher("/views/admin/fragments/account-table.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi Quản Lý Tài Khoản: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}