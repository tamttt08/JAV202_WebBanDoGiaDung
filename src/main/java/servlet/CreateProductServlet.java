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
import util.ParamUtil;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/product/add")
public class CreateProductServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách danh mục để đổ vào thẻ <select> trên giao diện
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/views/admin/product-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String productCode = "SP" + (System.currentTimeMillis() % 100000);

        // 1. Nhận dữ liệu từ form
        String productName = ParamUtil.getString(request, "productName");
        String priceStr = ParamUtil.getString(request, "price");
        String stockQuantityStr = ParamUtil.getString(request, "stockQuantity");
        String categoryIdStr = ParamUtil.getString(request, "categoryId");
        String description = ParamUtil.getString(request, "description");
        String image = ParamUtil.getString(request, "image");

        // 2. Validate dữ liệu bắt buộc
        if (productName.isEmpty() || priceStr.isEmpty() || stockQuantityStr.isEmpty() || categoryIdStr.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ các thông tin bắt buộc (*)");
            doGet(request, response);
            return;
        }

        try {
            // Parse dữ liệu
            BigDecimal price = new BigDecimal(priceStr);
            Integer stockQuantity = Integer.parseInt(stockQuantityStr);
            Integer categoryId = Integer.parseInt(categoryIdStr);

            // Tìm Category tương ứng
            Category category = categoryDAO.findById(categoryId);
            if (category == null) {
                request.setAttribute("error", "Danh mục đã chọn không hợp lệ!");
                doGet(request, response);
                return;
            }

            // 3. Khởi tạo và gán giá trị cho Product
            Product product = new Product();
            product.setProductCode(productCode);
            product.setProductName(productName);
            product.setPrice(price);
            product.setStockQuantity(stockQuantity);
            product.setCategory(category);
            product.setDescription(description);
            product.setImage(image.isEmpty() ? "https://via.placeholder.com/200" : image);

            // 4. Lưu vào database
            productDAO.create(product);

            // 5. Thêm thành công -> Chuyển về trang danh sách sản phẩm
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá tiền hoặc Số lượng tồn kho không đúng định dạng số!");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi thêm sản phẩm: " + e.getMessage());
            doGet(request, response);
        }
    }
}