package servlet;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "DeleteProductServlet", value = "/admin/product/delete")
public class DeleteProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy ID sản phẩm cần xóa từ URL
            int id = Integer.parseInt(request.getParameter("id"));

            // Thực hiện xóa
            productDAO.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Xóa xong chuyển hướng ngay về trang Quản lý sản phẩm
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}