package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/overview")
public class AdminOverviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cậu có thể truyền thêm dữ liệu thống kê vào đây sau này
        // request.setAttribute("totalProducts", 100);

        // Forward sang trang fragment tổng quan
        request.getRequestDispatcher("/views/admin/fragments/overview.jsp").forward(request, response);
    }
}