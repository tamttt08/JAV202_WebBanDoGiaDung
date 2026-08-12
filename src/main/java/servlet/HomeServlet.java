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

        // 2. Lấy tham số tìm kiếm, lọc danh mục & khoảng giá từ URL
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        Integer categoryId = null;
        Double minPrice = null;
        Double maxPrice = null;

        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                categoryId = null;
            }
        }

        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceStr.trim());
            } catch (NumberFormatException e) {
                minPrice = null;
            }
        }

        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceStr.trim());
            } catch (NumberFormatException e) {
                maxPrice = null;
            }
        }

        // 3. Lọc danh sách sản phẩm tổng hợp (Keyword, Category, MinPrice, MaxPrice, SortBy)
        List<Product> products = productDAO.filterProducts(keyword, categoryId, minPrice, maxPrice, "newest");

        // 4. Đưa dữ liệu sang JSP
        request.setAttribute("products", products);

        // Forward tới trang home.jsp
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}