package dao;

import entity.Coupon;
import service.EntityConnectivity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;

public class CouponDAO {

    // 1. Lấy danh sách tất cả coupon
    public List<Coupon> findAll() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            TypedQuery<Coupon> query = em.createQuery("SELECT c FROM Coupon c ORDER BY c.couponID DESC", Coupon.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // 2. Tìm coupon theo ID
    public Coupon findById(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.find(Coupon.class, id);
        } finally {
            em.close();
        }
    }

    // 3. Tìm coupon theo Mã Code
    public Coupon findByCode(String code) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            TypedQuery<Coupon> query = em.createQuery(
                    "SELECT c FROM Coupon c WHERE LOWER(c.code) = LOWER(:code)", Coupon.class);
            query.setParameter("code", code.trim());
            List<Coupon> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    // 4. Tìm Mã Coupon HỢP LỆ (Còn hạn, còn lượt dùng, đang kích hoạt)
    public Coupon findValidCoupon(String code) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            LocalDateTime now = LocalDateTime.now();
            TypedQuery<Coupon> query = em.createQuery(
                    "SELECT c FROM Coupon c WHERE LOWER(c.code) = LOWER(:code) " +
                            "AND c.active = true " +
                            "AND c.usageLimit > 0 " +
                            "AND (c.startDate IS NULL OR c.startDate <= :now) " +
                            "AND (c.endDate IS NULL OR c.endDate >= :now)", Coupon.class);

            query.setParameter("code", code.trim());
            query.setParameter("now", now);

            List<Coupon> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    // 5. Thêm mới Coupon
    public void create(Coupon coupon) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(coupon);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    // 6. Cập nhật Coupon
    public void update(Coupon coupon) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(coupon);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    // 7. Xóa Coupon
    public void delete(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            Coupon coupon = em.find(Coupon.class, id);
            if (coupon != null) {
                em.remove(coupon);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
}