package dao;

import entity.OrderDetail;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

import java.util.List;

public class OrderDetailDAOTest {

    private OrderDetailDAO orderDetailDAO;

    @Before
    public void setUp() {
        orderDetailDAO = new OrderDetailDAO();
    }

    @After
    public void tearDown() {
        orderDetailDAO = null;
    }

    @Test
    public void testFindById_Success() {
        Integer id = 1;
        OrderDetail orderDetail = orderDetailDAO.findById(id);
        assertNotNull("OrderDetail phải tồn tại trong DB", orderDetail);
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -999;
        OrderDetail orderDetail = orderDetailDAO.findById(id);
        assertNull("OrderDetail không tồn tại phải trả về null", orderDetail);
    }

    @Test
    public void testFindAll() {
        List<OrderDetail> list = orderDetailDAO.findAll();
        assertNotNull("Danh sách trả về không được null", list);
    }

    @Test
    public void testFindByOrderId() {
        Integer orderId = 1;
        List<OrderDetail> list = orderDetailDAO.findByOrderId(orderId);
        assertNotNull("Danh sách chi tiết theo OrderID không được null", list);
    }
}