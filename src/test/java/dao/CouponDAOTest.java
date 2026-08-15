package dao;

import entity.Coupon;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class CouponDAOTest {

    private CouponDAO couponDAO;

    @Before
    public void setUp() {
        couponDAO = new CouponDAO();
    }

    @After
    public void tearDown() {
        couponDAO = null;
    }

    @Test
    public void testFindAll() {
        List<Coupon> list = couponDAO.findAll();
        assertNotNull("Danh sách coupon trả về không được null", list);
    }

    @Test
    public void testFindById_NotFound() {
        Integer id = -9999; // ID chắc chắn không tồn tại
        Coupon coupon = couponDAO.findById(id);
        assertNull("Tìm ID không tồn tại phải trả về null", coupon);
    }

    @Test
    public void testFindByCode_NotFound() {
        String code = "KHONGTONTAICODE123";
        Coupon coupon = couponDAO.findByCode(code);
        assertNull("Mã code không tồn tại phải trả về null", coupon);
    }

    @Test
    public void testFindValidCoupon_NotFound() {
        String code = "INVALIDCODE";
        Coupon coupon = couponDAO.findValidCoupon(code);
        assertNull("Mã coupon không hợp lệ phải trả về null", coupon);
    }
}