package servlet;

import dao.CategoryDAO;
import entity.Category;
import util.ParamUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CreateCategoryServlet", value = "/admin/category/add")
public class CreateCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Hiển thị giao diện form thêm danh mục
        request.getRequestDispatcher("/views/admin/category-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ Form
        String categoryName = ParamUtil.getString(request, "categoryName");
        String description = ParamUtil.getString(request, "description");

        // 2. Validate dữ liệu bắt buộc
        if (categoryName.isEmpty()) {
            request.setAttribute("error", "Tên danh mục không được để trống!");
            doGet(request, response);
            return;
        }

        try {
            // 3. Tự động sinh mã Danh mục dạng DM001, DM002...
            long maxId = categoryDAO.getMaxCategoryId(); // Dùng hàm lấy Max ID vừa viết
            String categoryCode = String.format("DM%03d", maxId + 1);

            // 4. Khởi tạo và gán giá trị
            Category category = new Category();
            category.setCategoryCode(categoryCode);
            category.setCategoryName(categoryName);
            category.setDescription(description);

            // 5. Lưu vào CSDL
            categoryDAO.create(category);

            // 6. Thành công -> Chuyển hướng về trang quản lý danh mục / dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=category");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi thêm danh mục: " + e.getMessage());
            doGet(request, response);
        }
    }
}