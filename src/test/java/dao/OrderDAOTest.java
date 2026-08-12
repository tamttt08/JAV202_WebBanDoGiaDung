package dao;

import entity.Order;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.Assert.*;

public class OrderDAOTest {

    private OrderDAO orderDAO;

    @Before
    public void setUp() {
        orderDAO = new OrderDAO();
    }

    @After
    public void tearDown() {
        orderDAO = null;
    }

    @Test
    public void testFindById_Success() {
        // Giả sử trong Database có Order với ID = 1
        Integer id = 1;
        Order order = orderDAO.findById(id);

        if (order != null) {
            assertEquals("ID của Order phải khớp", id, order.getOrderID());
        }
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Order order = orderDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", order);
    }

    @Test
    public void testFindAll() {
        List<Order> list = orderDAO.findAll();
        assertNotNull("Danh sách order không được null", list);
    }

    @Test
    public void testFindByCustomerId() {
        Integer customerId = 1;
        List<Order> list = orderDAO.findByCustomerId(customerId);
        assertNotNull("Danh sách order theo Customer ID không được null", list);
    }

    @Test
    public void testFindByIdWithDetails_NotFound() {
        int orderId = -9999;
        Order order = orderDAO.findByIdWithDetails(orderId);
        assertNull("Tìm order kèm chi tiết với ID không tồn tại phải trả về null", order);
    }

    @Test
    public void testGetTotalRevenue() {
        BigDecimal revenue = orderDAO.getTotalRevenue();
        assertNotNull("Doanh thu trả về không được null", revenue);
    }

    @Test
    public void testCountTotalOrders() {
        long count = orderDAO.countTotalOrders();
        assertTrue("Tổng số đơn hàng phải lớn hơn hoặc bằng 0", count >= 0);
    }

    @Test
    public void testCountPendingOrders() {
        long count = orderDAO.countPendingOrders();
        assertTrue("Số lượng đơn pending phải lớn hơn hoặc bằng 0", count >= 0);
    }

    @Test
    public void testFindByCustomerAndStatus() {
        Integer customerId = 1;
        List<Order> list = orderDAO.findByCustomerAndStatus(customerId, "completed");
        assertNotNull("Danh sách order theo tab trạng thái không được null", list);
    }
}