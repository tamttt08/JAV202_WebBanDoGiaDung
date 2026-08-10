package servlet;

import dao.OrderDAO;
import dao.ProductDAO;
import entity.*;
import model.CartItem;
import util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutServlet", value = {"/checkout", "/checkout/process"})
public class CheckoutServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();
        HttpSession session = request.getSession();

        // 1. KIỂM TRA ĐĂNG NHẬP
        if (!AuthUtil.isAuthenticated(request)) {
            session.setAttribute("error", "Vui lòng đăng nhập để tiến hành thanh toán!");
            session.setAttribute("REDIRECT_URL", request.getContextPath() + "/cart");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account account = AuthUtil.getUser(request);
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // 2. HIỂN THỊ TRANG CHECKOUT
        if ("/checkout".equals(path)) {
            String[] selectedProductIds = request.getParameterValues("selectedProductIds");

            if (selectedProductIds == null || selectedProductIds.length == 0) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            List<CartItem> checkoutItems = new ArrayList<>();
            BigDecimal grandTotal = BigDecimal.ZERO;

            for (String idStr : selectedProductIds) {
                try {
                    int pId = Integer.parseInt(idStr);
                    if (cart.containsKey(pId)) {
                        CartItem item = cart.get(pId);
                        checkoutItems.add(item);
                        grandTotal = grandTotal.add(item.getTotalPrice());
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            session.setAttribute("checkoutItems", checkoutItems);
            session.setAttribute("checkoutGrandTotal", grandTotal);

            request.getRequestDispatcher("/WEB-INF/views/client/checkout.jsp").forward(request, response);

            // 3. XỬ LÝ LƯU ĐƠN HÀNG
        } else if ("/checkout/process".equals(path)) {
            List<CartItem> checkoutItems = (List<CartItem>) session.getAttribute("checkoutItems");
            BigDecimal grandTotal = (BigDecimal) session.getAttribute("checkoutGrandTotal");

            if (checkoutItems == null || checkoutItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Nhận thông tin giao hàng từ form
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String address = request.getParameter("address");
            String note = request.getParameter("note");

            Order order = new Order();

            String orderCode = "DH" + System.currentTimeMillis() / 1000;
            order.setOrderCode(orderCode);

            order.setSubTotal(grandTotal);
            order.setDiscountAmount(BigDecimal.ZERO); // Nếu chưa làm phần voucher thì để 0
            order.setTotalAmount(grandTotal);

            order.setReceiverName(receiverName);
            order.setReceiverPhone(receiverPhone);
            order.setShippingAddress(address);
            order.setNote(note);
            order.setStatus(Order.OrderStatus.Pending);

            if (account != null && account.getCustomer() != null) {
                order.setCustomer(account.getCustomer());
            }

            // Tạo danh sách chi tiết đơn hàng (OrderDetail)
            List<OrderDetail> details = new ArrayList<>();
            for (CartItem item : checkoutItems) {
                OrderDetail detail = new OrderDetail();
                detail.setOrder(order);
                detail.setProduct(item.getProduct());
                detail.setQuantity(item.getQuantity());
                detail.setUnitPrice(item.getProduct().getPrice());
                details.add(detail);
            }
            order.setOrderDetails(details);

            try {
                // STEP 1: Lưu đơn hàng vào CSDL
                orderDAO.create(order);

                // STEP 2: Cập nhật trừ số lượng tồn kho
                for (CartItem item : checkoutItems) {
                    Product p = productDAO.findById(item.getProduct().getProductID());
                    if (p != null) {
                        int remainingStock = p.getStockQuantity() - item.getQuantity();
                        p.setStockQuantity(Math.max(remainingStock, 0));
                        productDAO.update(p);
                    }
                }

                // STEP 3: Xóa các sản phẩm đã đặt khỏi giỏ hàng
                for (CartItem item : checkoutItems) {
                    cart.remove(item.getProduct().getProductID());
                }
                session.setAttribute("cart", cart);
                session.removeAttribute("checkoutItems");
                session.removeAttribute("checkoutGrandTotal");

                // STEP 4: Chuyển sang trang đặt hàng thành công
                request.getRequestDispatcher("/WEB-INF/views/client/checkout-success.jsp").forward(request, response);

            } catch (Exception e) {
                System.err.println("🔴 LỖI TẠO ĐƠN HÀNG:");
                e.printStackTrace();

                session.setAttribute("errorMessage", "Đã xảy ra lỗi khi tạo đơn hàng: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/checkout");
            }
        }
    }
}