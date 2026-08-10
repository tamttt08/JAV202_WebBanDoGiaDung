package servlet;

import dao.ProductDAO;
import entity.Product;
import model.CartItem;
import util.ParamUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CartServlet", value = {"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/cart/remove".equals(path)) {
            // Xóa 1 sản phẩm khỏi giỏ
            int productId = ParamUtil.getInt(request, "id", 0);
            HttpSession session = request.getSession();
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

            if (cart != null && cart.containsKey(productId)) {
                cart.remove(productId);
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Mặc định: Hiển thị trang giỏ hàng (/cart)
        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        // Tính tổng tiền toàn bộ giỏ hàng
        BigDecimal grandTotal = BigDecimal.ZERO;
        if (cart != null) {
            for (CartItem item : cart.values()) {
                grandTotal = grandTotal.add(item.getTotalPrice());
            }
        }

        request.setAttribute("grandTotal", grandTotal);
        request.getRequestDispatcher("/WEB-INF/views/client/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        // Lấy giỏ hàng từ Session (nếu chưa có thì tạo mới Map)
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        if ("/cart/add".equals(path)) {
            int productId = ParamUtil.getInt(request, "productId", 0);
            int quantity = ParamUtil.getInt(request, "quantity", 1);

            Product product = productDAO.findById(productId);
            if (product != null && quantity > 0) {
                if (cart.containsKey(productId)) {
                    // Nếu đã có trong giỏ -> Cộng dồn số lượng
                    CartItem existingItem = cart.get(productId);
                    int newQty = existingItem.getQuantity() + quantity;
                    // Kiểm tra không vượt quá tồn kho
                    if (newQty <= product.getStockQuantity()) {
                        existingItem.setQuantity(newQty);
                    } else {
                        existingItem.setQuantity(product.getStockQuantity());
                    }
                } else {
                    // Chưa có -> Thêm mới vào giỏ
                    if (quantity <= product.getStockQuantity()) {
                        cart.put(productId, new CartItem(product, quantity));
                    }
                }
            }
            session.setAttribute("cart", cart);
            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("/cart/update".equals(path)) {
            int productId = ParamUtil.getInt(request, "productId", 0);
            int quantity = ParamUtil.getInt(request, "quantity", 1);

            if (cart.containsKey(productId)) {
                Product product = productDAO.findById(productId);
                if (quantity <= 0) {
                    cart.remove(productId);
                } else if (product != null && quantity <= product.getStockQuantity()) {
                    cart.get(productId).setQuantity(quantity);
                }
            }
            session.setAttribute("cart", cart);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}