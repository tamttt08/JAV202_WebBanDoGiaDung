package servlet;

import dao.OrderDAO; // Đảm bảo cậu đã có OrderDAO hoặc sửa lại tên DAO tương ứng
import entity.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/order")
public class AdminOrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // Xử lý cập nhật trạng thái đơn hàng nếu có truyền action
            if ("updateStatus".equals(action)) {
                String orderIdStr = request.getParameter("id");
                String status = request.getParameter("status");

                if (orderIdStr != null && status != null) {
                    int orderId = Integer.parseInt(orderIdStr);
                    // Cập nhật trạng thái đơn hàng trong Database
                    // orderDAO.updateStatus(orderId, status);
                }
            }

            // Lấy danh sách tất cả đơn hàng
            List<Order> orders = orderDAO.findAll();
            request.setAttribute("orders", orders);

            // Forward về mảnh giao diện order-table.jsp
            request.getRequestDispatcher("/views/admin/fragments/order-table.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi Quản Lý Đơn Hàng: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}