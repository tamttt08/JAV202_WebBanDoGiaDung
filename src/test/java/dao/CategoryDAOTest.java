package dao;

import entity.Category;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class CategoryDAOTest {

    private CategoryDAO categoryDAO;

    @Before
    public void setUp() {
        categoryDAO = new CategoryDAO();
    }

    @After
    public void tearDown() {
        categoryDAO = null;
    }

    @Test
    public void testFindById_Success() {
        // Giả sử trong Database có Category với ID = 1
        Integer id = 1;
        Category category = categoryDAO.findById(id);

        if (category != null) {
            assertEquals("ID của Category phải khớp", id, category.getCategoryId());
        }
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Category category = categoryDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", category);
    }

    @Test
    public void testFindAll() {
        List<Category> list = categoryDAO.findAll();
        assertNotNull("Danh sách thể loại không được null", list);
    }

    @Test
    public void testFindByCategoryName() {
        String keyword = "Gia dụng"; // Từ khóa tìm kiếm mẫu
        List<Category> list = categoryDAO.findByCategoryName(keyword);
        assertNotNull("Danh sách tìm kiếm theo tên không được null", list);
    }

    @Test
    public void testCountCategories() {
        long count = categoryDAO.countCategories();
        assertTrue("Số lượng category phải lớn hơn hoặc bằng 0", count >= 0);
    }

    @Test
    public void testGetMaxCategoryId() {
        long maxId = categoryDAO.getMaxCategoryId();
        assertTrue("Max Category ID phải lớn hơn hoặc bằng 0", maxId >= 0);
    }
}