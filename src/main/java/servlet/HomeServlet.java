package servlet;

import dao.CategoryDAO;
import dao.ProductDAO;
import entity.Category;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy danh sách danh mục cho Menu bên trái
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        // 2. Lấy tham số tìm kiếm & lọc từ URL
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        Integer categoryId = null;

        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                categoryId = null; // Tránh nổ lỗi nếu categoryId không phải là số
            }
        }

        // 3. Lọc danh sách sản phẩm theo categoryId
        List<Product> products = productDAO.filterProducts(keyword, categoryId, null, null, "newest");

        // 4. Đưa dữ liệu sang JSP
        request.setAttribute("products", products);

        // Forward tới trang home.jsp
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}