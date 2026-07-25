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
import java.math.BigDecimal;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EditProductServlet", value = "/admin/product/edit")
public class EditProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.findById(id); // Hàm lấy 1 sản phẩm theo ID
            List<Category> categories = categoryDAO.findAll(); // Lấy danh sách danh mục để hiện dropdown

            if (product != null) {
                request.setAttribute("product", product);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/views/admin/product-edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy dữ liệu từ Form
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String image = request.getParameter("image");

            // 2. Lấy Category tương ứng từ DB để set quan hệ cho Product (vì JPA dùng Entity relationship)
            Category category = categoryDAO.findById(categoryId);

            // 3. Tạo/Update thông tin cho Product object
            Product product = new Product();
            product.setProductID(id); // Nhớ gọi đúng tên getter/setter id/productId của cậu nhé
            product.setProductName(name);
            product.setPrice(price);
            product.setStockQuantity(quantity);
            product.setCategory(category); // Set trực tiếp đối tượng Category
            product.setImage(image);

            // 4. Gọi hàm update cậu vừa viết
            productDAO.update(product);

            // 5. Chuyển hướng về lại trang danh sách
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            // Có thể forward lại trang edit kèm thông báo lỗi nếu cần
        }
    }
}