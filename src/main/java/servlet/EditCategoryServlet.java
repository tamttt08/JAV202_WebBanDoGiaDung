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

@WebServlet(name = "EditCategoryServlet", value = "/admin/category/edit")
public class EditCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();

    // 1. Load giao diện Form chỉnh sửa kèm dữ liệu cũ
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int categoryId = ParamUtil.getInt(request, "id", 0);
        Category category = categoryDAO.findById(categoryId);

        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=category");
            return;
        }

        request.setAttribute("category", category);
        request.getRequestDispatcher("/views/admin/category-edit.jsp").forward(request, response);
    }

    // 2. Nhận dữ liệu cập nhật từ Form và lưu vào DB
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        int categoryId = ParamUtil.getInt(request, "categoryId", 0);
        String categoryName = ParamUtil.getString(request, "categoryName");
        String description = ParamUtil.getString(request, "description");

        Category category = categoryDAO.findById(categoryId);
        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=category");
            return;
        }

        if (categoryName.isEmpty()) {
            request.setAttribute("error", "Tên danh mục không được để trống!");
            request.setAttribute("category", category);
            doGet(request, response);
            return;
        }

        try {
            // Cập nhật các thông tin (Giữ nguyên CategoryCode cũ)
            category.setCategoryName(categoryName);
            category.setDescription(description);

            categoryDAO.update(category);

            // Cập nhật xong chuyển về đúng Tab Danh Mục
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=category");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật: " + e.getMessage());
            request.setAttribute("category", category);
            doGet(request, response);
        }
    }
}