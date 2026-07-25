package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "product"; // Mặc định là tab sản phẩm
        }
        request.setAttribute("activeTab", tab);

        // Chuyển hướng tới trang JSP giao diện admin
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}