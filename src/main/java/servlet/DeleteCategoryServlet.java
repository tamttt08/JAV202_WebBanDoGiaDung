package servlet;

import dao.CategoryDAO;
import util.ParamUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "DeleteCategoryServlet", value = "/admin/category/delete")
public class DeleteCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy ID danh mục cần xóa từ param
        int categoryId = ParamUtil.getInt(request, "id", 0);

        if (categoryId > 0) {
            try {
                // 2. Thực hiện xóa trong CSDL
                categoryDAO.delete(categoryId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 3. Xóa xong chuyển hướng quay lại đúng Tab Danh Mục trên Dashboard
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=category");
    }
}