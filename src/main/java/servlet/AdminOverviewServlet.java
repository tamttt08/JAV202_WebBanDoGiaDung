package servlet;

import dao.StatsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/overview")
public class AdminOverviewServlet extends HttpServlet {

    private StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String filterRange = request.getParameter("filterRange");
        String filterDate = request.getParameter("filterDate");

        // Ưu tiên xử lý: Nếu có filterDate hợp lệ thì ép range về specific_date,
        // ngược lại nếu chọn range khác (như this_month, today...) thì bỏ qua filterDate.
        if (filterDate != null && !filterDate.trim().isEmpty() && !"all".equals(filterRange)) {
            filterRange = "specific_date";
        } else if (filterRange == null || filterRange.trim().isEmpty()) {
            filterRange = "all";
        }

        // Nếu người dùng chọn mốc thời gian dạng select (all, today, this_month, this_year),
        // ta vô hiệu hóa filterDate để tránh xung đột câu lệnh query.
        if (!"specific_date".equals(filterRange)) {
            filterDate = "";
        }

        long totalProducts = 0;
        long pendingOrders = 0;
        long totalCustomers = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        List<Object[]> top5Products = null;

        try {
            totalProducts = statsDAO.getTotalProducts();
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            pendingOrders = statsDAO.getPendingOrdersCount(filterRange, filterDate);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            totalCustomers = statsDAO.getTotalCustomers();
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            totalRevenue = statsDAO.getTotalRevenue(filterRange, filterDate);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            top5Products = statsDAO.getTop5BestSellingProducts(filterRange, filterDate);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("top5Products", top5Products);
        request.setAttribute("filterRange", filterRange);
        request.setAttribute("filterDate", filterDate);

        request.getRequestDispatcher("/WEB-INF/views/admin/fragments/overview.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}