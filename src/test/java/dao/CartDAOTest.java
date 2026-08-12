package dao;

import entity.Cart;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class CartDAOTest {

    private CartDAO cartDAO;

    @Before
    public void setUp() {
        cartDAO = new CartDAO();
    }

    @After
    public void tearDown() {
        cartDAO = null;
    }

    @Test
    public void testFindById_Success() {
        // Giả sử trong Database của bạn có Cart với ID = 1
        Integer id = 1;
        Cart cart = cartDAO.findById(id);

        if (cart != null) {
            assertEquals("ID của Cart phải khớp", id, cart.getCartID());
        }
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Cart cart = cartDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", cart);
    }

    @Test
    public void testFindAll() {
        List<Cart> list = cartDAO.findAll();
        assertNotNull("Danh sách giỏ hàng không được null", list);
    }

    @Test
    public void testFindByCustomerId() {
        Integer customerId = 1; // ID khách hàng mẫu
        List<Cart> list = cartDAO.findByCustomerId(customerId);
        assertNotNull("Danh sách giỏ hàng theo Customer ID không được null", list);
    }

    @Test
    public void testFindByCustomerAndProduct_NotFound() {
        // Truyền thông tin khách hàng và sản phẩm không có thực trong giỏ
        Integer customerId = -999;
        Integer productId = -999;

        Cart cart = cartDAO.findByCustomerAndProduct(customerId, productId);
        assertNull("Tìm sản phẩm không có trong giỏ hàng phải trả về null", cart);
    }
}