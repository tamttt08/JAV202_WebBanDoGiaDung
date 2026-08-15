package test;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import java.time.Duration;

import static org.junit.Assert.assertTrue;

public class LoginAutomationTest {

    private WebDriver driver;

    @Before
    public void setUp() {
        // Khởi động trình duyệt Chrome tự động
        driver = new ChromeDriver();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
        driver.manage().window().maximize();
    }

    @Test
    public void testLoginSuccess() throws InterruptedException {
        // 1. Mở trang Login của ứng dụng web bán đồ gia dụng
        driver.get("http://localhost:8080/JAV202_WebBanDoGiaDung/login");

        // 2. Tìm ô nhập Username và điền thông tin (dựa vào name="username" trong code servlet/jsp)
        WebElement usernameField = driver.findElement(By.name("username"));
        usernameField.sendKeys("admin"); // Thay bằng username thật trong DB của bạn
        Thread.sleep(2000);

        // 3. Tìm ô nhập Password và điền mật khẩu (dựa vào name="password")
        WebElement passwordField = driver.findElement(By.name("password"));
        passwordField.sendKeys("112233"); // Thay bằng password thật trong DB của bạn
        Thread.sleep(2000);

        // 4. Tìm và bấm nút Đăng nhập (thường là nút type='submit' trong form)
        WebElement loginButton = driver.findElement(By.cssSelector("button[type='submit'], input[type='submit']"));
        loginButton.click();
        Thread.sleep(2000);

        // 5. Kiểm tra kết quả: Sau khi login thành công, hệ thống sẽ chuyển hướng sang /home hoặc /admin/dashboard
        String currentUrl = driver.getCurrentUrl();
        boolean isLoginSuccess = currentUrl.contains("/home") || currentUrl.contains("/admin/dashboard");

        assertTrue("Đăng nhập thất bại, URL hiện tại là: " + currentUrl, isLoginSuccess);
    }

    @After
    public void tearDown() {
        // Đóng trình duyệt sau khi test xong
        if (driver != null) {
            driver.quit();
        }
    }
}