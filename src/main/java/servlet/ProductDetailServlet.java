package servlet;

import dao.ProductDAO;
import entity.Product;
import util.ParamUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ProductDetailServlet", value = "/product/detail")
public class ProductDetailServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = ParamUtil.getInt(request, "id", 0);

        Product product = productDAO.findById(id);

        if (product == null) {
            // Không tìm thấy sản phẩm -> Quay về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setAttribute("product", product);
        request.getRequestDispatcher("/WEB-INF/views/client/product-detail.jsp").forward(request, response);
    }
}