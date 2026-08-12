package dao;

import entity.Feedback;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class FeedbackDAOTest {

    private FeedbackDAO feedbackDAO;

    @Before
    public void setUp() {
        feedbackDAO = new FeedbackDAO();
    }

    @After
    public void tearDown() {
        feedbackDAO = null;
    }

    @Test
    public void testFindById_Success() {
        // Giả sử trong Database có Feedback với ID = 1
        Integer id = 1;
        Feedback feedback = feedbackDAO.findById(id);

        if (feedback != null) {
            assertEquals("ID của Feedback phải khớp", id, feedback.getFeedbackID());
        }
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Feedback feedback = feedbackDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", feedback);
    }

    @Test
    public void testFindAll() {
        List<Feedback> list = feedbackDAO.findAll();
        assertNotNull("Danh sách feedback không được null", list);
    }

    @Test
    public void testFindByProductId() {
        Integer productId = 1; // ID sản phẩm mẫu
        List<Feedback> list = feedbackDAO.findByProductId(productId);
        assertNotNull("Danh sách feedback theo Product ID không được null", list);
    }
}