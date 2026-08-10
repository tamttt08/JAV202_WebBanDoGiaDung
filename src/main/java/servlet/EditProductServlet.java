package servlet;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProductImageDAO;
import entity.Category;
import entity.Product;
import entity.ProductImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import util.FileUtil;
import util.ParamUtil;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;

@WebServlet(name = "EditProductServlet", value = "/admin/product/edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class EditProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ProductImageDAO productImageDAO = new ProductImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.findById(id);
            List<Category> categories = categoryDAO.findAll();

            if (product != null) {
                request.setAttribute("product", product);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/WEB-INF/views/admin/product-edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=product");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=product");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int productId = ParamUtil.getInt(request, "productId", 0);

        // 1. Tìm sản phẩm hiện tại trong CSDL
        Product product = productDAO.findById(productId);

        if (product != null) {
            // 2. Cập nhật thông tin cơ bản
            String productName = ParamUtil.getString(request, "productName");
            String priceStr = ParamUtil.getString(request, "price");
            String stockQuantityStr = ParamUtil.getString(request, "stockQuantity");
            String description = ParamUtil.getString(request, "description");
            int categoryId = ParamUtil.getInt(request, "categoryId", 0);

            product.setProductName(productName);
            product.setDescription(description);
            if (!priceStr.isEmpty()) {
                product.setPrice(new BigDecimal(priceStr));
            }
            if (!stockQuantityStr.isEmpty()) {
                product.setStockQuantity(Integer.parseInt(stockQuantityStr));
            }

            // Cập nhật Danh mục
            if (categoryId > 0) {
                Category category = categoryDAO.findById(categoryId);
                if (category != null) {
                    product.setCategory(category);
                }
            }

            // 3. Xử lý Ảnh chính (chỉ ghi đè nếu người dùng upload hoặc dán link mới)
            String uploadedFileName = FileUtil.upload(request, "imageFile");
            String imageUrl = ParamUtil.getString(request, "imageUrl");

            if (uploadedFileName != null) {
                product.setMainImage(request.getContextPath() + "/uploads/" + uploadedFileName);
            } else if (!imageUrl.isEmpty()) {
                product.setMainImage(imageUrl);
            }

            // 4. Xử lý Xóa Ảnh Phụ Cũ (nếu có chọn xóa từ giao diện)
            String[] deleteImageIds = request.getParameterValues("deleteSubImageIds");
            if (deleteImageIds != null && product.getImages() != null) {
                for (String imgIdStr : deleteImageIds) {
                    try {
                        int imageId = Integer.parseInt(imgIdStr);

                        // 4.1. Xóa khỏi Database
                        productImageDAO.delete(imageId);

                        // 4.2. XÓA KHỎI DANH SÁCH BỘ NHỚ CỦA OBJECT PRODUCT (Rất quan trọng!)
                        product.getImages().removeIf(img -> img.getImageID() == imageId);

                    } catch (NumberFormatException ignored) {}
                }
            }

            // 5. Xử lý Thêm Ảnh Phụ Mới (Upload bổ sung album)
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if ("subImages".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_sub_" + part.getSubmittedFileName();

                    String uploadPath = request.getServletContext().getRealPath("/uploads");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();

                    part.write(uploadPath + File.separator + fileName);

                    String subImagePath = request.getContextPath() + "/uploads/" + fileName;
                    ProductImage productImage = new ProductImage(product, subImagePath);
                    productImageDAO.create(productImage);
                }
            }

            // 6. Thực hiện update sản phẩm trong DB
            productDAO.update(product);
        }

        response.sendRedirect(request.getContextPath() + "/admin/product/edit?id=" + productId);
    }
}