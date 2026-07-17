package dao;

import entity.OrderDetail;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import service.EntityConnectivity;

import java.util.List;

public class OrderDetailDAO implements CrudDAO<OrderDetail, Integer> {

    @Override
    public void insert(OrderDetail entity) {
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
    public void update(OrderDetail entity) {
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
    }

    @Override
    public void delete(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            OrderDetail orderDetail = em.find(OrderDetail.class, id);
            if (orderDetail != null) {
                em.remove(orderDetail);
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
    public OrderDetail findById(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.find(OrderDetail.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<OrderDetail> findAll() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT od FROM OrderDetail od";
            TypedQuery<OrderDetail> query = em.createQuery(jpql, OrderDetail.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Lấy danh sách tất cả các sản phẩm chi tiết thuộc một Hóa đơn cụ thể.
     * Dùng để hiển thị danh sách món đồ đã mua khi bấm "Xem chi tiết đơn hàng".
     */
    public List<OrderDetail> findByOrderId(Integer orderId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT od FROM OrderDetail od WHERE od.order.orderID = :orderId";
            TypedQuery<OrderDetail> query = em.createQuery(jpql, OrderDetail.class);
            query.setParameter("orderId", orderId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}