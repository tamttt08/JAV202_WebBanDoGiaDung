package servlet;

import dao.ProductDAO;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/search-suggest")
public class SearchSuggestionServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            return;
        }

        // Tận dụng hàm findByName đã có sẵn trong ProductDAO của bạn
        List<Product> products = productDAO.findByName(keyword.trim());
        PrintWriter out = response.getWriter();

        if (products != null && !products.isEmpty()) {
            int limit = 0;
            for (Product p : products) {
                if (limit++ >= 5) break; // Chỉ hiển thị tối đa 5 gợi ý đầu tiên cho gọn giao diện

                out.println("<a href='" + request.getContextPath() + "/product/detail?id=" + p.getProductID() + "' class='list-group-item list-group-item-action d-flex align-items-center py-2 border-0 border-bottom'>");
                out.println("<img src='" + p.getMainImage() + "' style='width: 40px; height: 40px; object-fit: contain;' class='me-2 rounded border' onerror=\"this.src='https://via.placeholder.com/40'\">");
                out.println("<div class='overflow-hidden'>");
                out.println("<div class='fw-semibold text-dark text-truncate small'>" + p.getProductName() + "</div>");
                out.println("<div class='text-danger small fw-bold'>" + String.format("%,d", p.getPrice().longValue()) + " đ</div>");
                out.println("</div>");
                out.println("</a>");
            }
        } else {
            out.println("<div class='p-2 text-muted small text-center'>Không tìm thấy sản phẩm phù hợp</div>");
        }
    }
}