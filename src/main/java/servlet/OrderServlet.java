package servlet;

import dao.OrderDAO;
import entity.Account;
import entity.Customer;
import entity.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AuthUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderServlet", value = "/orders")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Kiểm tra đăng nhập bằng AuthUtil chuẩn của project
        if (!AuthUtil.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Lấy Account thông qua AuthUtil
        Account account = AuthUtil.getUser(request);
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 3. Lấy thông tin Customer từ Account
        Customer customer = account.getCustomer();
        if (customer == null) {
            request.setAttribute("error", "Tài khoản quản trị không có lịch sử đơn hàng cá nhân!");
            request.getRequestDispatcher("/WEB-INF/views/client/home.jsp").forward(request, response);
            return;
        }

        // 4. Lấy tab trạng thái từ URL (mặc định là 'all')
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "all";
        }

        // 5. Gọi DAO lấy danh sách đơn hàng thực tế theo mã khách hàng và tab
        List<Order> orders = orderDAO.findByCustomerAndStatus(customer.getCustomerID(), tab);
        if (orders == null) {
            orders = new ArrayList<>();
        }

        // 6. Đẩy dữ liệu ra view orders.jsp
        request.setAttribute("orders", orders);
        request.setAttribute("activeTab", tab);
        request.getRequestDispatcher("/WEB-INF/views/client/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}