package servlet;

import dao.AccountDAO;
import entity.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.AuthUtil;
import util.ParamUtil;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập rồi thì chuyển hướng về trang chủ
        if (AuthUtil.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Hiển thị trang đăng nhập
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = ParamUtil.getString(request, "username");
        String password = ParamUtil.getString(request, "password");

        // 1. Kiểm tra đầu vào rỗng
        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Tên đăng nhập và Mật khẩu!");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra tài khoản trong Database
        Account account = accountDAO.findByUsername(username);

        // Lưu ý: Cần đảm bảo hàm accountDAO.findByUsername() lấy đúng thông tin
        // Nếu dùng mã hóa mật khẩu thì so sánh qua BCrypt/MD5, ở đây giả định so sánh chuỗi trực tiếp
        if (account == null || !account.getPassword().equals(password)) {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // 3. Kiểm tra xem tài khoản có bị KHOÁ (active = false) không
        if (!account.isActive()) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên!");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // 4. Đăng nhập thành công -> Lưu vào Session
        AuthUtil.setUser(request, account);

        // 5. Điều hướng người dùng
        HttpSession session = request.getSession();
        String redirectUrl = (String) session.getAttribute("REDIRECT_URL");

        if (redirectUrl != null) {
            session.removeAttribute("REDIRECT_URL"); // Xóa sau khi dùng xong
            response.sendRedirect(redirectUrl);
        } else {
            // Phân hướng mặc định theo Role
            if (AuthUtil.isManager(request) || AuthUtil.isStaff(request)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        }
    }
}