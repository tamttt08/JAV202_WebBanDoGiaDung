package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/change-language")
public class LanguageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lang = request.getParameter("lang");

        // Kiểm tra hợp lệ, mặc định là vi nếu truyền bậy
        if (lang == null || (!lang.equals("vi") && !lang.equals("en"))) {
            lang = "vi";
        }

        // Lưu ngôn ngữ vào Session
        HttpSession session = request.getSession();
        session.setAttribute("LANG", lang);

        // Lấy URL trang người dùng đang đứng để redirect về đúng trang đó
        String referrer = request.getHeader("referer");
        if (referrer != null && !referrer.isEmpty()) {
            response.sendRedirect(referrer);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/account");
        }
    }
}