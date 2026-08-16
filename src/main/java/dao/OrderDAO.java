package dao;

import entity.Order;
import entity.OrderDetail;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import service.EntityConnectivity;

import java.math.BigDecimal;
import java.util.List;

public class OrderDAO implements CrudDAO<Order, Integer> {

    @Override
    public void create(Order entity) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean update(Order entity) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(entity);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
        return false;
    }

    @Override
    public void delete(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            Order order = em.find(Order.class, id);
            if (order != null) {
                em.remove(order);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public Order findById(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.find(Order.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order> findAll() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            // Dùng LEFT JOIN FETCH để nạp sẵn customer và orderDetails
            String jpql = "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.customer LEFT JOIN FETCH o.orderDetails ORDER BY o.orderDate DESC";
            TypedQuery<Order> query = em.createQuery(jpql, Order.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Lấy danh sách lịch sử mua hàng của một Khách hàng cụ thể.
     * Sắp xếp theo ngày mua mới nhất đứng đầu.
     */
    public List<Order> findByCustomerId(Integer customerId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT o FROM Order o WHERE o.customer.customerID = :customerId ORDER BY o.orderDate DESC";
            TypedQuery<Order> query = em.createQuery(jpql, Order.class);
            query.setParameter("customerId", customerId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public Order findByIdWithDetails(int orderId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT DISTINCT o FROM Order o " +
                    "LEFT JOIN FETCH o.customer " +
                    "LEFT JOIN FETCH o.orderDetails od " +
                    "LEFT JOIN FETCH od.product " +
                    "WHERE o.orderID = :orderId";
            TypedQuery<Order> query = em.createQuery(jpql, Order.class);
            query.setParameter("orderId", orderId);

            List<Order> list = query.getResultList();
            if (list != null && !list.isEmpty()) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public void recalculateTotalAmount(int orderId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Order order = em.find(Order.class, orderId);
            if (order != null) {
                // Khai báo sum kiểu BigDecimal bắt đầu từ 0
                java.math.BigDecimal total = java.math.BigDecimal.ZERO;

                for (OrderDetail od : order.getOrderDetails()) {
                    if (od.getUnitPrice() != null && od.getQuantity() != null) {
                        // Dùng multiply và BigDecimal.valueOf để nhân
                        java.math.BigDecimal itemTotal = od.getUnitPrice()
                                .multiply(java.math.BigDecimal.valueOf(od.getQuantity()));

                        total = total.add(itemTotal);
                    }
                }
                order.setTotalAmount(total);
                em.merge(order);
            }
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public boolean updateStatus(int orderId, Order.OrderStatus status) {
        EntityManager em = EntityConnectivity.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Order order = em.find(Order.class, orderId);
            if (order != null) {
                order.setStatus(status); // Cập nhật Enum Status
                em.merge(order);
            }
            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) em.close();
        }
    }

    // 1. Tính tổng doanh thu (Chỉ tính các đơn đã thành công / Delivered)
    public BigDecimal getTotalRevenue() {
        String jpql = "SELECT SUM(o.totalAmount) FROM Order o WHERE o.status = :status";
        try {
            EntityManager em = EntityConnectivity.getEntityManager();
            Object result = em.createQuery(jpql)
                    .setParameter("status", Order.OrderStatus.Delivered)
                    .getSingleResult();
            return result != null ? (BigDecimal) result : BigDecimal.ZERO;
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    // 2. Đếm tổng số đơn hàng
    public long countTotalOrders() {
        String jpql = "SELECT COUNT(o) FROM Order o";
        try {
            EntityManager em = EntityConnectivity.getEntityManager();
            return (Long) em.createQuery(jpql).getSingleResult();
        } catch (Exception e) {
            return 0;
        }
    }

    // 3. Đếm số đơn hàng đang chờ xử lý (Pending)
    public long countPendingOrders() {
        String jpql = "SELECT COUNT(o) FROM Order o WHERE o.status = :status";
        try {
            EntityManager em = EntityConnectivity.getEntityManager();
            return (Long) em.createQuery(jpql)
                    .setParameter("status", Order.OrderStatus.Pending)
                    .getSingleResult();
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * Hàm bổ sung: Lấy danh sách đơn hàng của khách hàng theo trạng thái tab (Hỗ trợ Shopee-style tabs)
     */
    public List<Order> findByCustomerAndStatus(Integer customerID, String tab) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder(
                    "SELECT DISTINCT o FROM Order o " +
                            "LEFT JOIN FETCH o.customer " +
                            "LEFT JOIN FETCH o.orderDetails od " +
                            "LEFT JOIN FETCH od.product " +
                            "WHERE o.customer.customerID = :customerID"
            );

            // Xác định Enum trạng thái tương ứng với tab
            Order.OrderStatus targetStatus = getTargetStatus(tab);

            // Nếu có trạng thái cụ thể, thêm điều kiện vào JPQL
            if (targetStatus != null) {
                jpql.append(" AND o.status = :targetStatus");
            }

            jpql.append(" ORDER BY o.orderDate DESC");

            TypedQuery<Order> query = em.createQuery(jpql.toString(), Order.class);
            query.setParameter("customerID", customerID);

            // Set parameter cho trạng thái nếu có
            if (targetStatus != null) {
                query.setParameter("targetStatus", targetStatus);
            }

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

    private static Order.OrderStatus getTargetStatus(String tab) {
        Order.OrderStatus targetStatus = null;

        if ("pending_payment".equals(tab)) {
            targetStatus = Order.OrderStatus.Pending;
        } else if ("pending_ship".equals(tab)) {
            targetStatus = Order.OrderStatus.Paid;
        } else if ("shipping".equals(tab)) {
            targetStatus = Order.OrderStatus.Shipping;
        } else if ("completed".equals(tab)) {
            targetStatus = Order.OrderStatus.Delivered;
        } else if ("returned".equals(tab)) {
            targetStatus = Order.OrderStatus.Cancelled;
        }
        return targetStatus;
    }
}