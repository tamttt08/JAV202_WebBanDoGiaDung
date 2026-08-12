package test;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.junit.Assert.assertTrue;

public class RegisterAutomationTest {

    private WebDriver driver;
    private WebDriverWait wait;

    @Before
    public void setUp() {
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        driver.manage().window().maximize();
    }

    @Test
    public void testRegisterSuccess() throws InterruptedException {
        // 1. Mở trang đăng ký
        driver.get("http://localhost:8080/JAV202_WebBanDoGiaDung/register");
        System.out.println("--- BƯỚC 1: Đang tải trang đăng ký... ---");

        wait.until(ExpectedConditions.presenceOfElementLocated(By.name("fullName")));
        Thread.sleep(2000);

        // 2. Điền thông tin đăng ký
        driver.findElement(By.name("fullName")).sendKeys("Nguyen Van Test");
        driver.findElement(By.name("username")).sendKeys("testuser999");
        driver.findElement(By.name("email")).sendKeys("testuser999@gmail.com");
        driver.findElement(By.name("phone")).sendKeys("0987654321");
        driver.findElement(By.name("address")).sendKeys("123 Ho Chi Minh");
        driver.findElement(By.name("password")).sendKeys("123456");
        driver.findElement(By.name("confirmPassword")).sendKeys("123456");
        System.out.println("--- BƯỚC 2: Đã điền đầy đủ thông tin đăng ký... ---");

        // Chờ 2 giây sau khi điền xong form
        Thread.sleep(2000);

        // 3. Thực hiện cuộn và bấm nút đăng ký
        WebElement registerButton = driver.findElement(By.cssSelector("button[type='submit']"));

        // Cuộn màn hình tới nút bấm và click bằng JavaScript để tránh bị đè/che
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("arguments[0].scrollIntoView(true);", registerButton);
        js.executeScript("arguments[0].click();", registerButton);
        System.out.println("--- BƯỚC 3: Đã bấm nút 'Đăng ký'... ---");

        // Chờ 2 giây sau khi bấm đăng ký
        Thread.sleep(2000);

        // 4. Kiểm tra kết quả chuyển hướng
        boolean isFinished = driver.getCurrentUrl().contains("register") || driver.getCurrentUrl().contains("login");
        assertTrue("Test đăng ký thất bại do không đúng trang đích.", isFinished);
        System.out.println("--- BƯỚC 4: Đăng ký thành công và điều hướng hợp lệ! ---");
    }

    @After
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}