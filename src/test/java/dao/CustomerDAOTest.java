package dao;

import entity.Customer;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class CustomerDAOTest {

    private CustomerDAO customerDAO;

    @Before
    public void setUp() {
        customerDAO = new CustomerDAO();
    }

    @After
    public void tearDown() {
        customerDAO = null;
    }

    @Test
    public void testFindById_Success() {
        // Giả sử trong Database có Customer với ID = 1
        Integer id = 1;
        Customer customer = customerDAO.findById(id);

        if (customer != null) {
            assertEquals("ID của Customer phải khớp", id, customer.getCustomerID());
        }
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Customer customer = customerDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", customer);
    }

    @Test
    public void testFindAll() {
        List<Customer> list = customerDAO.findAll();
        assertNotNull("Danh sách khách hàng không được null", list);
    }

    @Test
    public void testFindByAccountId_NotFound() {
        Integer accountId = -9999; // Account ID không có thật
        Customer customer = customerDAO.findByAccountId(accountId);
        assertNull("Tìm theo Account ID không tồn tại phải trả về null", customer);
    }
}