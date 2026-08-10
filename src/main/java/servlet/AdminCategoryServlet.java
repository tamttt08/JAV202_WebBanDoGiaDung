package servlet;

import dao.CategoryDAO;
import entity.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.ParamUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/category")
public class AdminCategoryServlet extends HttpServlet {

    private CategoryDAO dao = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "edit":
                    String idEditStr = request.getParameter("id");
                    if (idEditStr != null && !idEditStr.isEmpty()) {
                        int idEdit = Integer.parseInt(idEditStr);
                        Category category = dao.findById(idEdit);
                        // Đặt attribute "category" để khớp với category-table.jsp
                        request.setAttribute("category", category);
                    }
                    break;

                case "delete":
                    String idDeleteStr = request.getParameter("id");
                    if (idDeleteStr != null && !idDeleteStr.isEmpty()) {
                        int idDelete = Integer.parseInt(idDeleteStr);
                        dao.delete(idDelete);
                    }
                    break;
            }

            // Luôn lấy lại danh sách mới nhất để hiển thị ra Fragment
            List<Category> list = dao.findAll();
            request.setAttribute("categories", list);

            // Forward duy nhất về Fragment HTML
            request.getRequestDispatcher("/WEB-INF/views/admin/fragments/category-table.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý Danh mục: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Sinh mã Danh mục tự động (DM001, DM002,...)
        long total = dao.countCategories(); // Hoặc count() trong CategoryDAO
        String categoryCode = String.format("DM%03d", total + 1);

        // 2. Nhận dữ liệu từ form
        String categoryName = ParamUtil.getString(request, "categoryName");
        String description = ParamUtil.getString(request, "description");

        // 3. Validate dữ liệu bắt buộc
        if (categoryName.isEmpty()) {
            request.setAttribute("error", "Tên danh mục không được để trống!");
            doGet(request, response);
            return;
        }

        try {
            // 4. Khởi tạo và gán giá trị
            Category category = new Category();
            category.setCategoryCode(categoryCode);
            category.setCategoryName(categoryName);
            category.setDescription(description);

            // 5. Lưu vào Database
            dao.create(category);

            // 6. Chuyển hướng về trang danh sách/dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi thêm danh mục: " + e.getMessage());
            doGet(request, response);
        }
    }
}