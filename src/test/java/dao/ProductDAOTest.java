package dao;

import entity.Product;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class ProductDAOTest {

    private ProductDAO productDAO;

    @Before
    public void setUp() {
        productDAO = new ProductDAO();
    }

    @After
    public void tearDown() {
        productDAO = null;
    }

    @Test
    public void testFindById_Success() {
        // Giả sử trong Database có Product với ID = 1
        Integer id = 1;
        Product product = productDAO.findById(id);

        if (product != null) {
            assertEquals("ID của Product phải khớp", id, product.getProductID());
        }
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Product product = productDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", product);
    }

    @Test
    public void testFindAll() {
        List<Product> list = productDAO.findAll();
        assertNotNull("Danh sách sản phẩm không được null", list);
    }

    @Test
    public void testFindByName() {
        String keyword = "Quạt"; // Từ khóa mẫu
        List<Product> list = productDAO.findByName(keyword);
        assertNotNull("Danh sách tìm kiếm theo tên không được null", list);
    }

    @Test
    public void testFindByCategoryId() {
        Integer categoryId = 1;
        List<Product> list = productDAO.findByCategoryId(categoryId);
        assertNotNull("Danh sách sản phẩm theo Category ID không được null", list);
    }

    @Test
    public void testFindFeaturedProducts() {
        int limit = 5;
        List<Product> list = productDAO.findFeaturedProducts(limit);
        assertNotNull("Danh sách sản phẩm nổi bật không được null", list);
        assertTrue("Số lượng sản phẩm trả về không được vượt quá limit", list.size() <= limit);
    }

    @Test
    public void testFilterProducts() {
        // Test hàm lọc tổng hợp với tham số cơ bản
        List<Product> list = productDAO.filterProducts("Test", 1, 0.0, 1000000.0, "price_asc");
        assertNotNull("Kết quả lọc sản phẩm không được null", list);
    }

    @Test
    public void testCountProducts() {
        long count = productDAO.countProducts();
        assertTrue("Tổng số sản phẩm phải lớn hơn hoặc bằng 0", count >= 0);
    }
}