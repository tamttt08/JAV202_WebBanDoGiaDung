package dao;

import entity.Feedback;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import service.EntityConnectivity;

import java.util.List;

public class FeedbackDAO implements CrudDAO<Feedback, Integer> {

    @Override
    public void create(Feedback entity) {
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
    public void update(Feedback entity) {
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
            Feedback feedback = em.find(Feedback.class, id);
            if (feedback != null) {
                em.remove(feedback);
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
    public Feedback findById(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.find(Feedback.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Feedback> findAll() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT f FROM Feedback f";
            TypedQuery<Feedback> query = em.createQuery(jpql, Feedback.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Lấy danh sách tất cả đánh giá/phản hồi của một sản phẩm cụ thể.
     * Dùng để hiển thị khu vực bình luận ở trang chi tiết sản phẩm (Product Detail UI).
     */
    public List<Feedback> findByProductId(Integer productId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT f FROM Feedback f WHERE f.product.productID = :productId ORDER BY f.createdAt DESC";
            TypedQuery<Feedback> query = em.createQuery(jpql, Feedback.class);
            query.setParameter("productId", productId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}