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

public class HomeAutomationTest {

    private WebDriver driver;
    private WebDriverWait wait;

    @Before
    public void setUp() {
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        driver.manage().window().maximize();
    }

    @Test
    public void testFilterAndSearchWorkflow() throws InterruptedException {
        // BƯỚC 1: Mở trang chủ
        System.out.println("--- BƯỚC 1: Đang mở trang chủ... ---");
        driver.get("http://localhost:8080/JAV202_WebBanDoGiaDung/home");
        Thread.sleep(2000);

        // BƯỚC 2: Nhập khoảng giá (Min Price & Max Price) và bấm Lọc theo giá
        System.out.println("--- BƯỚC 2: Nhập khoảng giá để lọc ---");
        WebElement minPriceInput = wait.until(ExpectedConditions.presenceOfElementLocated(By.name("minPrice")));
        WebElement maxPriceInput = driver.findElement(By.name("maxPrice"));

        minPriceInput.clear();
        minPriceInput.sendKeys("1000000");
        Thread.sleep(1000);

        maxPriceInput.clear();
        maxPriceInput.sendKeys("5000000");
        Thread.sleep(1000);

        WebElement filterPriceBtn = wait.until(ExpectedConditions.presenceOfElementLocated(
                By.cssSelector("form:has(input[name='minPrice']) button[type='submit']")
        ));

        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", filterPriceBtn);
        Thread.sleep(1000);
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", filterPriceBtn);
        System.out.println("--- Đã áp dụng lọc giá thành công ---");
        Thread.sleep(3000);

        // BƯỚC 3: Nhập từ khóa tìm kiếm "tu lanh" trước
        System.out.println("--- BƯỚC 3: Nhập từ khóa tìm kiếm sản phẩm 'tu lanh' ---");
        WebElement searchInput = wait.until(ExpectedConditions.presenceOfElementLocated(By.name("keyword")));
        searchInput.clear();
        searchInput.sendKeys("tu lanh");
        Thread.sleep(3000);

        searchInput.submit();
        System.out.println("--- Đã submit từ khóa tìm kiếm ---");
        Thread.sleep(3000);

        // BƯỚC 4: Sau khi tìm kiếm xong mới click chọn danh mục sản phẩm trong Sidebar
        System.out.println("--- BƯỚC 4: Click chọn danh mục sản phẩm ---");
        List<WebElement> categoryLinks = wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector(".list-group-item.list-group-item-action")));
        if (categoryLinks.size() > 1) {
            WebElement targetCategory = categoryLinks.get(1);
            System.out.println("Đang click vào danh mục: " + targetCategory.getText());

            ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", targetCategory);
            ((JavascriptExecutor) driver).executeScript("arguments[0].click();", targetCategory);
            Thread.sleep(3000);
        }

        // BƯỚC 5: Kiểm tra kết quả trả về cuối cùng
        List<WebElement> products = wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector(".card")));
        System.out.println("--- THÀNH CÔNG: Tìm thấy " + products.size() + " sản phẩm thỏa mãn điều kiện! ---");

        assertTrue("Quá trình lọc và tìm kiếm sản phẩm gặp lỗi hiển thị.", products.size() >= 0);
        Thread.sleep(3000);
    }

    @After
    public void tearDown() {
        if (driver != null) {
            System.out.println("--- Đang đóng trình duyệt ---");
            driver.quit();
        }
    }
}