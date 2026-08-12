package dao;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class StatsDAOTest {

    private StatsDAO statsDAO;

    @Before
    public void setUp() {
        statsDAO = new StatsDAO();
    }

    @After
    public void tearDown() {
        statsDAO = null;
    }

    @Test
    public void testGetTotalProducts() {
        long totalProducts = statsDAO.getTotalProducts();
        assertTrue("Tổng số sản phẩm phải lớn hơn hoặc bằng 0", totalProducts >= 0);
    }

    @Test
    public void testGetPendingOrdersCount() {
        long pendingCount = statsDAO.getPendingOrdersCount();
        assertTrue("Số lượng đơn hàng pending phải lớn hơn hoặc bằng 0", pendingCount >= 0);
    }

    @Test
    public void testGetTotalCustomers() {
        long totalCustomers = statsDAO.getTotalCustomers();
        assertTrue("Tổng số khách hàng phải lớn hơn hoặc bằng 0", totalCustomers >= 0);
    }

    @Test
    public void testGetTotalRevenue() {
        double totalRevenue = statsDAO.getTotalRevenue();
        assertTrue("Tổng doanh thu phải lớn hơn hoặc bằng 0", totalRevenue >= 0.0);
    }
}