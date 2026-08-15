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
import java.util.List;

import static org.junit.Assert.assertTrue;

public class CartAutomationTest {

    private WebDriver driver;
    private WebDriverWait wait;

    @Before
    public void setUp() {
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        driver.manage().window().maximize();
    }

    @Test
    public void testCartInterfaceAndCheckboxSelection() throws InterruptedException {
        // BƯỚC 0: Đăng nhập hệ thống
        driver.get("http://localhost:8080/JAV202_WebBanDoGiaDung/login");
        System.out.println("--- BƯỚC 0: Đang mở trang đăng nhập... ---");
        Thread.sleep(2000);

        driver.findElement(By.name("username")).sendKeys("testuser999"); // Thay tài khoản của bạn
        driver.findElement(By.name("password")).sendKeys("123456");      // Thay mật khẩu của bạn

        WebElement loginBtn = driver.findElement(By.cssSelector("button[type='submit']"));
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", loginBtn);
        System.out.println("--- BƯỚC 1: Đã thực hiện đăng nhập thành công... ---");
        Thread.sleep(2000);

        // BƯỚC 0.2: Tự động thêm 1 sản phẩm vào giỏ hàng trước khi test giao diện giỏ hàng
        driver.get("http://localhost:8080/JAV202_WebBanDoGiaDung/product/detail?id=1");
        System.out.println("--- BƯỚC 2: Đang mở trang chi tiết sản phẩm để thêm vào giỏ... ---");
        Thread.sleep(2000);

        WebElement addToCartBtn = driver.findElement(By.cssSelector("button[type='submit']"));
        if (addToCartBtn.isEnabled()) {
            ((JavascriptExecutor) driver).executeScript("arguments[0].click();", addToCartBtn);
            System.out.println("--- BƯỚC 3: Đã thêm sản phẩm vào giỏ hàng thành công! ---");
            Thread.sleep(2000);
        }

        // 1. Mở trang giỏ hàng
        driver.get("http://localhost:8080/JAV202_WebBanDoGiaDung/cart");
        System.out.println("--- BƯỚC 4: Đang tải trang giỏ hàng... ---");

        wait.until(ExpectedConditions.presenceOfElementLocated(By.tagName("body")));
        Thread.sleep(2000);

        boolean isCartPage = driver.getCurrentUrl().contains("cart");
        assertTrue("Không truy cập được vào trang giỏ hàng.", isCartPage);
        System.out.println("--- BƯỚC 5: Truy cập thành công trang giỏ hàng! ---");

        // 2. Kiểm tra xem giỏ hàng có sản phẩm hay đang trống
        List<WebElement> itemCheckboxes = driver.findElements(By.cssSelector(".item-checkbox"));
        Thread.sleep(2000);

        if (!itemCheckboxes.isEmpty()) {
            System.out.println("--- BƯỚC 6A: Giỏ hàng CÓ sản phẩm, tiến hành kiểm tra checkbox... ---");
            WebElement firstCheckbox = itemCheckboxes.get(0);

            WebElement grandTotalEl = driver.findElement(By.id("grandTotal"));
            String initialTotal = grandTotalEl.getText();

            // Click bỏ chọn checkbox
            ((JavascriptExecutor) driver).executeScript("arguments[0].click();", firstCheckbox);
            Thread.sleep(2000);

            String updatedTotal = driver.findElement(By.id("grandTotal")).getText();
            assertTrue("Tổng tiền không cập nhật khi bỏ chọn sản phẩm.", !initialTotal.equals(updatedTotal));
            System.out.println("--- BƯỚC 7: Tổng tiền đã thay đổi chính xác khi bỏ chọn sản phẩm! ---");

            // Tích chọn lại
            ((JavascriptExecutor) driver).executeScript("arguments[0].click();", firstCheckbox);
            Thread.sleep(2000);

            // =========================================================================
            // BƯỚC 5: SAU KHI KIỂM TRA CHECKBOX THÀNH CÔNG -> TIẾN HÀNH XÓA SẢN PHẨM
            // =========================================================================
            System.out.println("--- BƯỚC 8: Tiến hành xóa sản phẩm khỏi giỏ hàng... ---");
            List<WebElement> removeButtons = driver.findElements(By.cssSelector("a.btn-outline-danger"));
            assertTrue("Không tìm thấy nút xóa sản phẩm.", !removeButtons.isEmpty());

            WebElement removeBtn = removeButtons.get(0);
            ((JavascriptExecutor) driver).executeScript("arguments[0].click();", removeBtn);
            Thread.sleep(2000);

            // Xử lý hộp thoại confirm (nếu có popup OK/Cancel của trình duyệt)
            try {
                driver.switchTo().alert().accept();
                System.out.println("--- Đã bấm xác nhận OK trên hộp thoại xóa ---");
                Thread.sleep(2000);
            } catch (Exception e) {
                // Không có alert popup thì bỏ qua
            }

            // Kiểm tra kết quả sau khi xóa xem giỏ hàng đã trống chưa
            List<WebElement> remainingItems = driver.findElements(By.cssSelector(".item-checkbox"));
            if (remainingItems.isEmpty()) {
                WebElement emptyCartMsg = driver.findElement(By.cssSelector(".bi-cart-x, .text-secondary"));
                assertTrue("Sản phẩm đã bị xóa nhưng giỏ hàng không hiển thị thông báo trống.", emptyCartMsg.isDisplayed());
                System.out.println("--- BƯỚC 9: Xóa sản phẩm thành công, giỏ hàng hiện đang trống! ---");
            } else {
                System.out.println("--- BƯỚC 9: Giỏ hàng vẫn còn sản phẩm khác. ---");
            }

        } else {
            System.out.println("--- BƯỚC 3B: Giỏ hàng TRỐNG ---");
            WebElement emptyCartMsg = driver.findElement(By.cssSelector(".bi-cart-x, .text-secondary"));
            assertTrue("Giỏ hàng trống nhưng không hiển thị thông báo phù hợp.", emptyCartMsg.isDisplayed());
        }
    }

    @After
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}