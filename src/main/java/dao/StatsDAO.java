package dao;

import entity.Order;
import service.EntityConnectivity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class StatsDAO {

    // 1. Đếm tổng số sản phẩm
    public long getTotalProducts() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(p) FROM Product p", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    // 2. Đếm số đơn hàng mới (Trạng thái Pending)
    public long getPendingOrdersCount() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(o) FROM Order o WHERE o.status = entity.Order.OrderStatus.Pending", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    // 3. Đếm tổng số khách hàng (Tài khoản role Customer/User)
    public long getTotalCustomers() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            // Đếm bảng Customer (hoặc Account nếu phân biệt qua role)
            return em.createQuery("SELECT COUNT(c) FROM Customer c", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    // 4. Tính tổng doanh thu (Chỉ tính các đơn Paid / Delivered / Shipping)
    public double getTotalRevenue() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            // Nếu xài JPQL
            String jpql = "SELECT SUM(o.totalAmount) FROM Order o WHERE o.status = :status";
            Object result = em.createQuery(jpql)
                    .setParameter("status", Order.OrderStatus.Delivered) // hoặc Completed
                    .getSingleResult();
            return result != null ? ((Number) result).doubleValue() : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
}