package dao;

import entity.Account;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class AccountDAOTest {

    private AccountDAO accountDAO;

    @Before
    public void setUp() {
        accountDAO = new AccountDAO();
    }

    @After
    public void tearDown() {
        accountDAO = null;
    }

    @Test
    public void testFindById_Success() {
        // Giả sử trong database của bạn đã có Account với ID = 1
        Integer id = 1;
        Account account = accountDAO.findById(id);

        if (account != null) {
            assertEquals("ID của Account phải khớp", id, account.getAccountID());
        }
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Account account = accountDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", account);
    }

    @Test
    public void testFindAll() {
        List<Account> list = accountDAO.findAll();
        assertNotNull("Danh sách Account không được null", list);
    }

    @Test
    public void testFindByUsername_NotFound() {
        Account account = accountDAO.findByUsername("khongtontaibaoji12345");
        assertNull("Username không tồn tại phải trả về null", account);
    }

    @Test
    public void testExistsByUsername_Null() {
        boolean exists = accountDAO.existsByUsername(null);
        assertFalse("Kiểm tra username null phải trả về false", exists);
    }

    @Test
    public void testFindByEmail_Null() {
        Account account = accountDAO.findByEmail(null);
        assertNull("Tìm email null phải trả về null", account);
    }
}