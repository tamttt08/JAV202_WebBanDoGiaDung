package servlet;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProductImageDAO;
import entity.Category;
import entity.Product;
import entity.ProductImage;
import util.FileUtil;
import util.ParamUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collection;

@WebServlet(name = "CreateProductServlet", value = "/admin/product/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CreateProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ProductImageDAO productImageDAO = new ProductImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categories", categoryDAO.findAll());
        request.getRequestDispatcher("/WEB-INF/views/admin/product-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String productCode = "SP" + (System.currentTimeMillis() % 100000);

        // 1. Nhận dữ liệu text từ form
        String productName = ParamUtil.getString(request, "productName");
        String priceStr = ParamUtil.getString(request, "price");
        String stockQuantityStr = ParamUtil.getString(request, "stockQuantity");
        String categoryIdStr = ParamUtil.getString(request, "categoryId");
        String description = ParamUtil.getString(request, "description");

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

            // 3. XỬ LÝ ẢNH CHÍNH (MAIN IMAGE)
            String finalMainImagePath = "";
            String imageUrl = ParamUtil.getString(request, "imageUrl");
            String uploadedFileName = FileUtil.upload(request, "imageFile");

            if (uploadedFileName != null) {
                finalMainImagePath = request.getContextPath() + "/uploads/" + uploadedFileName;
            } else if (!imageUrl.isEmpty()) {
                finalMainImagePath = imageUrl;
            } else {
                finalMainImagePath = "https://via.placeholder.com/200";
            }

            // 4. Khởi tạo và gán giá trị cho Product
            Product product = new Product();
            product.setProductCode(productCode);
            product.setProductName(productName);
            product.setPrice(price);
            product.setStockQuantity(stockQuantity);
            product.setCategory(category);
            product.setDescription(description);
            product.setMainImage(finalMainImagePath);

            // 5. Lưu Product vào DB trước để lấy ID
            productDAO.create(product);

            // 6. XỬ LÝ DANH SÁCH ẢNH PHỤ (SUB IMAGES)
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                // Kiểm tra nếu ô upload tên là "subImages" và có chọn file
                if ("subImages".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_sub_" + part.getSubmittedFileName();

                    // Lưu file vào thư mục /uploads
                    String uploadPath = request.getServletContext().getRealPath("/uploads");
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();

                    part.write(uploadPath + java.io.File.separator + fileName);

                    // Đường dẫn ảnh phụ để lưu vào DB
                    String subImagePath = request.getContextPath() + "/uploads/" + fileName;

                    // Lưu vào bảng ProductImages
                    ProductImage productImage = new ProductImage(product, subImagePath);
                    productImageDAO.create(productImage);
                }
            }

            // 7. Chuyển về tab sản phẩm
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=product");

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