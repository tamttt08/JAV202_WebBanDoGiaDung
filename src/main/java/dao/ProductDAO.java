package dao;

import entity.Product;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import service.EntityConnectivity;

import java.util.List;

public class ProductDAO implements CrudDAO<Product, Integer> {

    @Override
    public void insert(Product entity) {
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
    public void update(Product entity) {
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
            Product product = em.find(Product.class, id);
            if (product != null) {
                em.remove(product);
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
    public Product findById(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.find(Product.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Product> findAll() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT p FROM Product p";
            TypedQuery<Product> query = em.createQuery(jpql, Product.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Tìm kiếm sản phẩm theo tên.
     * Dùng cho chức năng tìm kiếm sản phẩm trên trang chủ (Search bar).
     */
    public List<Product> findByName(String name) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT p FROM Product p WHERE p.productName LIKE :name";
            TypedQuery<Product> query = em.createQuery(jpql, Product.class);
            query.setParameter("name", "%" + name + "%");
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Lấy danh sách sản phẩm thuộc một danh mục cụ thể.
     * Dùng cho chức năng lọc sản phẩm theo danh mục (Filter by Category).
     */
    public List<Product> findByCategoryId(Integer categoryId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT p FROM Product p WHERE p.category.categoryID = :categoryId";
            TypedQuery<Product> query = em.createQuery(jpql, Product.class);
            query.setParameter("categoryId", categoryId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Lấy danh sách sản phẩm mới nhất để trưng bày ở trang chủ.
     * @param limit Số lượng sản phẩm muốn lấy ra (ví dụ: 8 hoặc 12 sản phẩm)
     */
    public List<Product> findFeaturedProducts(int limit) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT p FROM Product p ORDER BY p.productID DESC";
            TypedQuery<Product> query = em.createQuery(jpql, Product.class);
            query.setMaxResults(limit);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}