package dao;

import entity.Customer;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import service.EntityConnectivity;

import java.util.List;

public class CustomerDAO implements CrudDAO<Customer, Integer> {

    @Override
    public void create(Customer entity) {
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
    public boolean update(Customer customer) {
        EntityManager em = EntityConnectivity.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();

            // 🔴 Dùng merge để cập nhật entity vào Context
            Customer updatedCustomer = em.merge(customer);

            // 🔴 Flush để đẩy ngay thay đổi xuống Database kiểm tra lỗi SQL
            em.flush();

            // 🔴 Commit transaction
            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans != null && trans.isActive()) {
                trans.rollback(); // Nếu có lỗi thì rollback lại
            }
            System.err.println("Lỗi cập nhật Customer:");
            e.printStackTrace(); // 👈 Cậu xem log trên console IntelliJ xem nó in ra lỗi gì ở đây
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public void delete(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            Customer customer = em.find(Customer.class, id);
            if (customer != null) {
                em.remove(customer);
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
    public Customer findById(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.find(Customer.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Customer> findAll() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT c FROM Customer c";
            TypedQuery<Customer> query = em.createQuery(jpql, Customer.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Hàm bổ sung: Tìm kiếm Khách hàng dựa theo AccountID.
     * Dùng khi muốn lấy profile chi tiết sau khi user đăng nhập.
     */
    public Customer findByAccountId(Integer accountId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT c FROM Customer c WHERE c.account.accountID = :accountId";
            TypedQuery<Customer> query = em.createQuery(jpql, Customer.class);
            query.setParameter("accountId", accountId);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}