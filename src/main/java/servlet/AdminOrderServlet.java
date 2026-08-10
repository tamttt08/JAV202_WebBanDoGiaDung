package servlet;

import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.ProductDAO;
import entity.Order;
import entity.OrderDetail;
import entity.Product;
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
    private OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            // 1. XEM CHI TIẾT ĐƠN HÀNG
            if ("detail".equals(action)) {
                String idStr = request.getParameter("id");
                if (isValidParam(idStr)) {
                    showOrderDetailModal(request, response, Integer.parseInt(idStr));
                    return;
                }
            }

            // 2. CẬP NHẬT SỐ LƯỢNG MÓN
            if ("updateDetail".equals(action)) {
                String detailIdStr = request.getParameter("detailId");
                String quantityStr = request.getParameter("quantity");
                String orderIdStr = request.getParameter("orderId");

                if (isValidParam(detailIdStr) && isValidParam(quantityStr) && isValidParam(orderIdStr)) {
                    int detailId = Integer.parseInt(detailIdStr);
                    int quantity = Integer.parseInt(quantityStr);
                    int orderId = Integer.parseInt(orderIdStr);

                    Order order = orderDAO.findById(orderId);
                    if (order != null && order.getStatus() == Order.OrderStatus.Pending) {
                        OrderDetail detail = orderDetailDAO.findById(detailId);
                        if (detail != null) {
                            if (quantity > 0) {
                                detail.setQuantity(quantity);
                                orderDetailDAO.update(detail);
                            } else {
                                orderDetailDAO.delete(detailId);
                            }
                            orderDAO.recalculateTotalAmount(orderId);
                        }
                    }
                    showOrderDetailModal(request, response, orderId);
                    return;
                }
            }

            // 3. XÓA MÓN TRONG ĐƠN
            if ("deleteDetail".equals(action)) {
                String detailIdStr = request.getParameter("detailId");
                String orderIdStr = request.getParameter("orderId");

                if (isValidParam(detailIdStr) && isValidParam(orderIdStr)) {
                    int detailId = Integer.parseInt(detailIdStr);
                    int orderId = Integer.parseInt(orderIdStr);

                    Order order = orderDAO.findById(orderId);
                    if (order != null && order.getStatus() == Order.OrderStatus.Pending) {
                        orderDetailDAO.delete(detailId);
                        orderDAO.recalculateTotalAmount(orderId);
                    }
                    showOrderDetailModal(request, response, orderId);
                    return;
                }
            }

            // 4. THÊM MÓN VÀO ĐƠN
            if ("addDetail".equals(action)) {
                String orderIdStr = request.getParameter("orderId");
                String productIdStr = request.getParameter("productId");
                String quantityStr = request.getParameter("quantity");

                if (isValidParam(orderIdStr) && isValidParam(productIdStr) && isValidParam(quantityStr)) {
                    int orderId = Integer.parseInt(orderIdStr);
                    int productId = Integer.parseInt(productIdStr);
                    int quantity = Integer.parseInt(quantityStr);

                    Product product = productDAO.findById(productId);
                    Order order = orderDAO.findByIdWithDetails(orderId);

                    if (product != null && order != null && order.getStatus() == Order.OrderStatus.Pending) {
                        OrderDetail existingDetail = null;
                        if (order.getOrderDetails() != null) {
                            for (OrderDetail detail : order.getOrderDetails()) {
                                if (detail.getProduct().getProductID() == productId) {
                                    existingDetail = detail;
                                    break;
                                }
                            }
                        }

                        if (existingDetail != null) {
                            existingDetail.setQuantity(existingDetail.getQuantity() + quantity);
                            orderDetailDAO.update(existingDetail);
                        } else {
                            OrderDetail detail = new OrderDetail();
                            detail.setOrder(order);
                            detail.setProduct(product);
                            detail.setQuantity(quantity);
                            detail.setUnitPrice(product.getPrice());
                            orderDetailDAO.create(detail);
                        }
                        orderDAO.recalculateTotalAmount(orderId);
                    }
                    showOrderDetailModal(request, response, orderId);
                    return;
                }
            }

            // 5. CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG
            if ("updateStatus".equals(action)) {
                String orderIdStr = request.getParameter("id");
                if (!isValidParam(orderIdStr)) orderIdStr = request.getParameter("orderId");
                String statusStr = request.getParameter("status");

                if (isValidParam(orderIdStr) && isValidParam(statusStr)) {
                    int orderId = Integer.parseInt(orderIdStr);
                    try {
                        Order.OrderStatus status = Order.OrderStatus.valueOf(statusStr);
                        orderDAO.updateStatus(orderId, status);
                    } catch (IllegalArgumentException e) {
                        System.err.println("Trạng thái đơn hàng không hợp lệ: " + statusStr);
                    }
                }

                List<Order> orders = orderDAO.findAll();
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/WEB-INF/views/admin/fragments/order-table.jsp").forward(request, response);
                return;
            }

            // 6. MẶC ĐỊNH LOAD BẢNG ORDER TABLE
            List<Order> orders = orderDAO.findAll();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/admin/fragments/order-table.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi Quản Lý Đơn Hàng: " + e.getMessage());
        }
    }

    private void showOrderDetailModal(HttpServletRequest request, HttpServletResponse response, int orderId)
            throws ServletException, IOException {
        Order order = orderDAO.findByIdWithDetails(orderId);
        List<Product> products = productDAO.findAll();

        if (order != null) {
            request.setAttribute("order", order);
            request.setAttribute("products", products);
            request.getRequestDispatcher("/WEB-INF/views/admin/fragments/order-detail-modal.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng #" + orderId);
        }
    }

    // HAM HELPER KIỂM TRA CHUỖI TRUYỀN VÀO CÓ HỢP LỆ KHÔNG
    private boolean isValidParam(String param) {
        return param != null && !param.trim().isEmpty() && !"undefined".equals(param) && !"null".equals(param);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}