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

        if (!AuthUtil.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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

        if (!AuthUtil.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account account = AuthUtil.getUser(request);

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        Customer customer = customerDAO.findByAccountId(account.getAccountID());

        // 1. Kiểm tra định dạng số điện thoại (10 - 11 chữ số)
        String phoneRegex = "^\\d{10,11}$";
        if (phone != null && !phone.isEmpty() && !phone.matches(phoneRegex)) {
            request.setAttribute("message", "Số điện thoại không hợp lệ! Vui lòng nhập đúng từ 10 đến 11 chữ số.");
            request.setAttribute("messageType", "danger");
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra định dạng Email khắt khe (bắt buộc tên miền trước dấu chấm >= 2 ký tự và đuôi mở rộng >= 2 ký tự)
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]{2,}\\.[a-zA-Z]{2,}$";
        if (email != null && !email.isEmpty() && !email.matches(emailRegex)) {
            request.setAttribute("message", "Địa chỉ Email không hợp lệ! Vui lòng nhập đúng tên miền chuẩn (ví dụ: name@gmail.com).");
            request.setAttribute("messageType", "danger");
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        if (account != null) {
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