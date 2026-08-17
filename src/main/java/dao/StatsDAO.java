package dao;

import entity.Order;
import service.EntityConnectivity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public class StatsDAO {

    public long getTotalProducts() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(p) FROM Product p", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    public long getPendingOrdersCount(String range, String filterDate) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(o) FROM Order o WHERE o.status = :status");
            appendDateFilter(jpql, range, filterDate);

            TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class)
                    .setParameter("status", Order.OrderStatus.Pending);

            setParameterValues(query, range, filterDate);

            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public long getTotalCustomers() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(c) FROM Customer c", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    public BigDecimal getTotalRevenue(String range, String filterDate) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT SUM(o.totalAmount) FROM Order o WHERE o.status = :status");
            appendDateFilter(jpql, range, filterDate);

            TypedQuery<BigDecimal> query = em.createQuery(jpql.toString(), BigDecimal.class)
                    .setParameter("status", Order.OrderStatus.Delivered);

            setParameterValues(query, range, filterDate);

            BigDecimal result = query.getSingleResult();
            return result != null ? result : BigDecimal.ZERO;
        } catch (Exception e) {
            return BigDecimal.ZERO;
        } finally {
            em.close();
        }
    }

    public List<Object[]> getTop5BestSellingProducts(String range, String filterDate) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.clear();
            StringBuilder jpql = new StringBuilder(
                    "SELECT p, SUM(od.quantity) " +
                            "FROM OrderDetail od " +
                            "JOIN od.product p " +
                            "JOIN od.order o " +
                            "WHERE o.status = :deliveredStatus"
            );

            appendDateFilter(jpql, range, filterDate);
            jpql.append(" GROUP BY p ORDER BY SUM(od.quantity) DESC");

            TypedQuery<Object[]> query = em.createQuery(jpql.toString(), Object[].class);
            query.setParameter("deliveredStatus", Order.OrderStatus.Delivered);

            setParameterValues(query, range, filterDate);

            query.setMaxResults(5);

            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Hàm phụ trợ xây dựng điều kiện JPQL bằng khoảng thời gian
    private void appendDateFilter(StringBuilder jpql, String range, String filterDate) {
        if ("specific_date".equals(range) && filterDate != null && !filterDate.trim().isEmpty()) {
            jpql.append(" AND o.orderDate >= :startDateTime AND o.orderDate <= :endDateTime");
        } else if ("today".equals(range)) {
            jpql.append(" AND o.orderDate >= :startDateTime AND o.orderDate <= :endDateTime");
        } else if ("this_month".equals(range)) {
            jpql.append(" AND FUNCTION('YEAR', o.orderDate) = FUNCTION('YEAR', CURRENT_DATE) " +
                    "AND FUNCTION('MONTH', o.orderDate) = FUNCTION('MONTH', CURRENT_DATE)");
        } else if ("this_year".equals(range)) {
            jpql.append(" AND FUNCTION('YEAR', o.orderDate) = FUNCTION('YEAR', CURRENT_DATE)");
        }
    }

    // Hàm phụ trợ truyền tham số khoảng thời gian (Từ 00:00:00 đến 23:59:59 của ngày đó)
    private void setParameterValues(TypedQuery<?> query, String range, String filterDate) {
        if ("specific_date".equals(range) && filterDate != null && !filterDate.trim().isEmpty()) {
            LocalDate date = LocalDate.parse(filterDate.trim());
            query.setParameter("startDateTime", LocalDateTime.of(date, LocalTime.MIN)); // 00:00:00
            query.setParameter("endDateTime", LocalDateTime.of(date, LocalTime.MAX));   // 23:59:59.999999999
        } else if ("today".equals(range)) {
            LocalDate today = LocalDate.now();
            query.setParameter("startDateTime", LocalDateTime.of(today, LocalTime.MIN));
            query.setParameter("endDateTime", LocalDateTime.of(today, LocalTime.MAX));
        }
    }
}