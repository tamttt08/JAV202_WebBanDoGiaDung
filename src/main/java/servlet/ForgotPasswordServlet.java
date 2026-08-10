package servlet;

import dao.AccountDAO;
import entity.Account;
import util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPasswordServlet", value = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "email";

        switch (action) {
            case "verify":
                request.getRequestDispatcher("/WEB-INF/views/client/verify-otp.jsp").forward(request, response);
                break;
            case "reset":
                request.getRequestDispatcher("/WEB-INF/views/client/reset-password.jsp").forward(request, response);
                break;
            default:
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // BƯỚC 1: BẤM GỬI MÃ OTP VỀ MAIL
        if ("send-otp".equals(action)) {
            String email = request.getParameter("email");
            Account acc = accountDAO.findByEmail(email); // Thêm hàm findByEmail trong AccountDAO nhé

            if (acc == null) {
                request.setAttribute("errorMessage", "Email này chưa được đăng ký hệ thống!");
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
                return;
            }

            // Sinh mã OTP 6 số ngẫu nhiên
            String otp = String.format("%06d", new Random().nextInt(999999));
            long expiryTime = System.currentTimeMillis() + (5 * 60 * 1000); // Hết hạn sau 5 phút

            // Lưu vào Session
            session.setAttribute("RESET_EMAIL", email);
            session.setAttribute("OTP_CODE", otp);
            session.setAttribute("OTP_EXPIRY", expiryTime);

            // Gửi email
            boolean isSent = EmailUtil.sendOtpEmail(email, otp);
            if (isSent) {
                response.sendRedirect(request.getContextPath() + "/forgot-password?action=verify");
            } else {
                request.setAttribute("errorMessage", "Gửi email thất bại. Vui lòng thử lại!");
                request.getRequestDispatcher("/WEB-INF/views/client/forgot-password.jsp").forward(request, response);
            }

            // BƯỚC 2: XÁC NHẬN MÃ OTP
        } else if ("verify-otp".equals(action)) {
            String inputOtp = request.getParameter("otp");
            String savedOtp = (String) session.getAttribute("OTP_CODE");
            Long expiry = (Long) session.getAttribute("OTP_EXPIRY");

            if (savedOtp == null || expiry == null || System.currentTimeMillis() > expiry) {
                request.setAttribute("errorMessage", "Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới!");
                request.getRequestDispatcher("/WEB-INF/views/client/verify-otp.jsp").forward(request, response);
                return;
            }

            if (!savedOtp.equals(inputOtp)) {
                request.setAttribute("errorMessage", "Mã OTP không chính xác!");
                request.getRequestDispatcher("/WEB-INF/views/client/verify-otp.jsp").forward(request, response);
                return;
            }

            // OTP đúng -> Cho phép qua trang đổi mật khẩu
            session.setAttribute("OTP_VERIFIED", true);
            response.sendRedirect(request.getContextPath() + "/forgot-password?action=reset");

            // BƯỚC 3: CẬP NHẬT MẬT KHẨU MỚI
        } else if ("reset-password".equals(action)) {
            Boolean isVerified = (Boolean) session.getAttribute("OTP_VERIFIED");
            String email = (String) session.getAttribute("RESET_EMAIL");

            if (isVerified == null || !isVerified || email == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }

            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
                request.getRequestDispatcher("/WEB-INF/views/client/reset-password.jsp").forward(request, response);
                return;
            }

            // Cập nhật mật khẩu trong CSDL
            Account acc = accountDAO.findByEmail(email);
            if (acc != null) {
                acc.setPassword(newPassword); // Nên dùng BCrypt mã hóa mật khẩu nếu có
                accountDAO.update(acc);

                // Dọn dẹp Session
                session.removeAttribute("RESET_EMAIL");
                session.removeAttribute("OTP_CODE");
                session.removeAttribute("OTP_EXPIRY");
                session.removeAttribute("OTP_VERIFIED");

                session.setAttribute("successMessage", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
                response.sendRedirect(request.getContextPath() + "/login");
            }
        }
    }
}