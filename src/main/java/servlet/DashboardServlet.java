package servlet;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.AccountDAO;
import entity.Order;
import entity.Product;
import entity.Category;
import entity.Account;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "overview"; // Thường mặc định là Tổng quan hoặc Product
        }

        // 🔍 Nạp dữ liệu tương ứng với từng Tab
        switch (tab) {
            case "order":
                // Lấy tất cả đơn hàng từ CSDL đẩy sang JSP
                List<Order> orders = orderDAO.findAll();
                request.setAttribute("orders", orders);
                break;

            case "product":
                List<Product> products = productDAO.findAll();
                request.setAttribute("products", products);
                break;

            case "category":
                List<Category> categories = categoryDAO.findAll();
                request.setAttribute("categories", categories);
                break;

            case "account":
                List<Account> accounts = accountDAO.findAll();
                request.setAttribute("accounts", accounts);
                break;

            case "overview":
            default:
                // Nếu có tab Tổng quan thì có thể truyền các số liệu thống kê ở đây
                break;
        }

        request.setAttribute("activeTab", tab);

        // Chuyển hướng tới trang JSP giao diện admin
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}