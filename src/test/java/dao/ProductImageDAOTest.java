package dao;

import entity.ProductImage;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class ProductImageDAOTest {

    private ProductImageDAO productImageDAO;

    @Before
    public void setUp() {
        productImageDAO = new ProductImageDAO();
    }

    @After
    public void tearDown() {
        productImageDAO = null;
    }

    @Test(expected = Exception.class)
    public void testCreate_NullObject() {
        // Kiểm tra khi truyền đối tượng null vào hàm create phải văng ngoại lệ
        // (JUnit 4 dùng cú pháp expected trên annotation @Test)
        productImageDAO.create(null);
    }

    @Test
    public void testDelete_NotFound() {
        // Xóa một ID hình ảnh chắc chắn không tồn tại trong DB
        int nonExistentId = -9999;

        try {
            productImageDAO.delete(nonExistentId);
            // Nếu không ném ra ngoại lệ nghĩa là pass (đúng với logic assertDoesNotThrow)
            assertTrue(true);
        } catch (Exception e) {
            fail("Xóa ID không tồn tại không được làm sập chương trình, nhưng đã văng lỗi: " + e.getMessage());
        }
    }
}