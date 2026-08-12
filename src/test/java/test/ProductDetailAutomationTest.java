package test;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.junit.Assert.assertTrue;

public class ProductDetailAutomationTest {

    private WebDriver driver;
    private WebDriverWait wait;

    @Before
    public void setUp() {
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        driver.manage().window().maximize();
    }

    @Test
    public void testAddToCartFromDetail() throws InterruptedException {
        // 1. Mở trang chi tiết sản phẩm có ID = 1 (Đảm bảo Tomcat đang chạy và có sản phẩm ID 1 trong DB)
        driver.get("http://localhost:8080/JAV202_WebBanDoGiaDung/product/detail?id=1");
        System.out.println("--- BƯỚC 1: Đang tải trang chi tiết sản phẩm... ---");

        // Đợi trang tải xong phần tên sản phẩm h2
        WebElement productName = wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("h2.fw-bold")));
        assertTrue("Không tải được thông tin sản phẩm.", productName.isDisplayed());

        // 2. Tìm ô nhập số lượng và thay đổi số lượng thành 2 (nếu sản phẩm còn hàng)
        WebElement quantityInput = driver.findElement(By.id("quantity"));
        if (quantityInput.isEnabled()) {
            quantityInput.clear();
            quantityInput.sendKeys("2");
            System.out.println("--- BƯỚC 2: Tăng số lượng sản phẩm lên 2... ---");

            // Chờ 2 giây theo yêu cầu
            Thread.sleep(2000);
        }

        // 3. Bấm nút "Thêm vào giỏ hàng"
        WebElement addToCartBtn = driver.findElement(By.cssSelector("button[type='submit']"));
        assertTrue("Nút thêm vào giỏ hàng đang bị khóa (hết hàng).", addToCartBtn.isEnabled());
        addToCartBtn.click();
        System.out.println("--- BƯỚC 3: Đã bấm nút 'Thêm vào giỏ hàng'... ---");
        Thread.sleep(2000);

        // 4. Kiểm tra xem sau khi bấm có chuyển hướng thành công sang trang giỏ hàng (/cart) không
        boolean isRedirectedToCart = wait.until(ExpectedConditions.urlContains("/cart"));
        assertTrue("Thêm sản phẩm vào giỏ hàng nhưng không chuyển hướng đến trang giỏ hàng.", isRedirectedToCart);
        System.out.println("--- BƯỚC 4: Chuyển hướng thành công sang trang giỏ hàng (/cart)! ---");
        Thread.sleep(2000);
    }

    @After
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}