package servlet;

import dao.AccountDAO;
import dao.CustomerDAO;
import entity.Account;
import entity.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AuthUtil;
import util.ParamUtil;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private AccountDAO accountDAO;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập rồi thì không cho vào trang đăng ký nữa
        if (AuthUtil.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin từ Form Đăng ký
        String username = ParamUtil.getString(request, "username");
        String password = ParamUtil.getString(request, "password");
        String confirmPassword = ParamUtil.getString(request, "confirmPassword");
        String fullName = ParamUtil.getString(request, "fullName");
        String email = ParamUtil.getString(request, "email");
        String phone = ParamUtil.getString(request, "phone");
        String address = ParamUtil.getString(request, "address");

        // 1. Validate dữ liệu cơ bản
        if (username.isEmpty() || password.isEmpty() || fullName.isEmpty() || email.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không trùng khớp!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra Username đã tồn tại trong DB chưa
        if (accountDAO.findByUsername(username) != null) {
            request.setAttribute("error", "Tên đăng nhập này đã được sử dụng!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        try {
            // 3. Tạo Entity Account
            Account newAccount = new Account();
            newAccount.setUsername(username);
            newAccount.setPassword(password); // Nên mã hóa password nếu có
            newAccount.setRole(Account.Role.Customer); // Mặc định đăng ký web là Khách hàng
            newAccount.setActive(true); // Tài khoản mới tạo mặc định Hoạt động

            // Lưu Account vào DB
            accountDAO.create(newAccount);

            // 4. Tạo Entity Customer tương ứng
            Customer newCustomer = new Customer();
            newCustomer.setAccount(newAccount); // Gán quan hệ với Account vừa tạo
            newCustomer.setFullName(fullName);
            newCustomer.setEmail(email);
            newCustomer.setPhone(phone);
            newCustomer.setAddress(address);

            // Lưu Customer vào DB
            customerDAO.create(newCustomer);

            // 5. Chuyển hướng sang trang Đăng nhập và báo thành công
            request.setAttribute("success", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }
}