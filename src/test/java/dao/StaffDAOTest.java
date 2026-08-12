package dao;

import entity.Staff;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class StaffDAOTest {

    private StaffDAO staffDAO;

    @Before
    public void setUp() {
        staffDAO = new StaffDAO();
    }

    @After
    public void tearDown() {
        staffDAO = null;
    }

    @Test
    public void testFindById_Success() {
        // Giả sử trong Database có Staff với ID = 1
        Integer id = 1;
        Staff staff = staffDAO.findById(id);

        if (staff != null) {
            assertEquals("ID của Staff phải khớp", id, staff.getStaffID());
        }
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Staff staff = staffDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", staff);
    }

    @Test
    public void testFindAll() {
        List<Staff> list = staffDAO.findAll();
        assertNotNull("Danh sách staff không được null", list);
    }

    @Test
    public void testFindByAccountId_NotFound() {
        Integer accountId = -9999; // Account ID không có thật
        Staff staff = staffDAO.findByAccountId(accountId);
        assertNull("Tìm theo Account ID không tồn tại phải trả về null", staff);
    }
}