package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AuthUtil;

@WebFilter({ "/manager/*", "/staff/*" })
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uriString = req.getRequestURI();

        // 1. Kiểm tra nếu chưa đăng nhập thì đá về trang đăng nhập
        if (!AuthUtil.isAuthenticated(req)) {
            req.getSession().setAttribute("REDIRECT_URL", uriString);
            res.sendRedirect(req.getContextPath() + "/dang-nhap");
            return; // Dừng lại ở đây luôn, không chạy tiếp xuống dưới!
        }

        // 2. Nếu vào vùng quản lý /manager nhưng không phải Manager thì chặn quyền (403)
        if (uriString.contains("/manager") && !AuthUtil.isManager(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN); // Trả về trang lỗi 403 luôn
            return;
        }

        // 3. Nếu mọi thứ hợp lệ thì cho phép đi tiếp vào Servlet
        chain.doFilter(req, res);
    }
}