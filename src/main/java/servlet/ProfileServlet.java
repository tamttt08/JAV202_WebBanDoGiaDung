package servlet;

import dao.CustomerDAO;
import entity.Account;
import entity.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.AuthUtil;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔴 1. Kiểm tra đăng nhập thông qua AuthUtil
        if (!AuthUtil.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 🔴 2. Lấy Account đang đăng nhập từ AuthUtil
        Account account = AuthUtil.getUser(request);

        if (account != null) {
            Customer customer = customerDAO.findByAccountId(account.getAccountID());
            request.setAttribute("customer", customer);
        }

        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 🔴 1. Kiểm tra đăng nhập
        if (!AuthUtil.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 🔴 2. Lấy Account hiện tại
        Account account = AuthUtil.getUser(request);

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (account != null) {
            Customer customer = customerDAO.findByAccountId(account.getAccountID());

            if (customer != null) {
                customer.setFullName(fullName);
                customer.setEmail(email);
                customer.setPhone(phone);
                customer.setAddress(address);

                boolean success = customerDAO.update(customer);

                if (success) {
                    request.setAttribute("message", "Cập nhật thông tin thành công!");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "Cập nhật thất bại, vui lòng thử lại!");
                    request.setAttribute("messageType", "danger");
                }
                request.setAttribute("customer", customer);
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }
}