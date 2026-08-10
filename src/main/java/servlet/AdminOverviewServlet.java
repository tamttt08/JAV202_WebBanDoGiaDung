package servlet;

import dao.StatsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/overview")
public class AdminOverviewServlet extends HttpServlet {

    private StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        long totalProducts = 0;
        long pendingOrders = 0;
        long totalCustomers = 0;
        double totalRevenue = 0.0;

        // Bọc try-catch riêng từng DAO để nếu 1 cái lỗi thì các cái khác vẫn chạy
        try {
            totalProducts = statsDAO.getTotalProducts();
        } catch (Exception e) {
            System.err.println("🔴 Lỗi getTotalProducts: " + e.getMessage());
        }

        try {
            pendingOrders = statsDAO.getPendingOrdersCount();
        } catch (Exception e) {
            System.err.println("🔴 Lỗi getPendingOrdersCount: " + e.getMessage());
        }

        try {
            totalCustomers = statsDAO.getTotalCustomers();
        } catch (Exception e) {
            System.err.println("🔴 Lỗi getTotalCustomers: " + e.getMessage());
        }

        try {
            totalRevenue = statsDAO.getTotalRevenue();
        } catch (Exception e) {
            System.err.println("🔴 Lỗi getTotalRevenue: " + e.getMessage());
        }

        // Đẩy sang JSP
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("/WEB-INF/views/admin/fragments/overview.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}