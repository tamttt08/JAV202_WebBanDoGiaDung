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

        // 1. Lấy danh sách danh mục cho Menu
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        Integer categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : null;

        List<Product> products = productDAO.filterProducts(keyword, categoryId, null, null, "newest");

        request.setAttribute("products", products);

        request.setAttribute("products", products);

        // Forward tới trang home.jsp
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}