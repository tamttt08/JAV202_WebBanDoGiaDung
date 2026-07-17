package dao;

import entity.Cart;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import service.EntityConnectivity;

import java.util.List;

public class CartDAO implements CrudDAO<Cart, Integer> {

    @Override
    public void insert(Cart entity) {
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
    public void update(Cart entity) {
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
            Cart cart = em.find(Cart.class, id);
            if (cart != null) {
                em.remove(cart);
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
    public Cart findById(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.find(Cart.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Cart> findAll() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT c FROM Cart c";
            TypedQuery<Cart> query = em.createQuery(jpql, Cart.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Lấy danh sách giỏ hàng của một Khách hàng cụ thể.
     * Dùng để hiển thị trang giỏ hàng (Shopping Cart UI).
     */
    public List<Cart> findByCustomerId(Integer customerId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT c FROM Cart c WHERE c.customer.customerID = :customerId";
            TypedQuery<Cart> query = em.createQuery(jpql, Cart.class);
            query.setParameter("customerId", customerId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Tìm kiếm một sản phẩm cụ thể trong giỏ hàng của một khách hàng.
     * Tiện cho logic: Nếu sản phẩm đã tồn tại -> Update số lượng tăng lên, nếu chưa -> Insert mới.
     */
    public Cart findByCustomerAndProduct(Integer customerId, Integer productId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT c FROM Cart c WHERE c.customer.customerID = :customerId AND c.product.productID = :productId";
            TypedQuery<Cart> query = em.createQuery(jpql, Cart.class);
            query.setParameter("customerId", customerId);
            query.setParameter("productId", productId);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null; // Trả về null nếu sản phẩm này chưa từng được cho vào giỏ
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}