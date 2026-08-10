package servlet;

import dao.AccountDAO;
import entity.Account;
import entity.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/account/add")
public class CreateAccountServlet extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Đã đổi chuẩn theo tên file account-add.jsp của cậu
        request.getRequestDispatcher("/WEB-INF/views/admin/account-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // 1. Validate dữ liệu nhập
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên đăng nhập và mật khẩu không được để trống!");
            request.getRequestDispatcher("/WEB-INF/views/admin/account-add.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email không được để trống!");
            request.getRequestDispatcher("/WEB-INF/views/admin/account-add.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra trùng Username
        if (accountDAO.existsByUsername(username)) {
            request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại trong hệ thống!");
            request.getRequestDispatcher("/WEB-INF/views/admin/account-add.jsp").forward(request, response);
            return;
        }

        // 3. Kiểm tra trùng Email
        if (accountDAO.findByEmail(email) != null) {
            request.setAttribute("errorMessage", "Email này đã được sử dụng!");
            request.getRequestDispatcher("/WEB-INF/views/admin/account-add.jsp").forward(request, response);
            return;
        }

        // 4. Khởi tạo đối tượng Account
        Account acc = new Account();
        acc.setUsername(username.trim());
        acc.setPassword(password.trim());

        if (role != null && !role.trim().isEmpty()) {
            try {
                acc.setRole(Account.Role.valueOf(role.trim()));
            } catch (IllegalArgumentException e) {
                acc.setRole(Account.Role.Customer);
            }
        } else {
            acc.setRole(Account.Role.Customer);
        }

        // Khởi tạo đối tượng Customer
        Customer cust = new Customer();
        cust.setFullName(fullName != null ? fullName.trim() : "");
        cust.setEmail(email.trim());
        cust.setPhone(phone != null ? phone.trim() : "");

        // 5. Lưu vào CSDL
        boolean isSuccess = accountDAO.createAccountWithCustomer(acc, cust);

        if (isSuccess) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=account");
        } else {
            request.setAttribute("errorMessage", "Thêm tài khoản thất bại, đã có lỗi xảy ra!");
            request.getRequestDispatcher("/WEB-INF/views/admin/account-add.jsp").forward(request, response);
        }
    }
}