package dao;

import entity.Account;
import entity.Customer;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import service.EntityConnectivity;

import java.util.List;

public class AccountDAO implements CrudDAO<Account, Integer> {

    @Override
    public void create(Account entity) {
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
    public boolean update(Account entity) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(entity);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            Account account = em.find(Account.class, id);
            if (account != null) {
                em.remove(account);
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
    public Account findById(Integer id) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            return em.find(Account.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Account> findAll() {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT a FROM Account a";
            TypedQuery<Account> query = em.createQuery(jpql, Account.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public Account findByUsername(String username) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT a FROM Account a WHERE a.username = :username";
            TypedQuery<Account> query = em.createQuery(jpql, Account.class);
            query.setParameter("username", username);
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    public boolean existsByUsername(String username) {
        if (username == null) return false;
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT COUNT(a) FROM Account a WHERE LOWER(a.username) = :username";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("username", username.trim().toLowerCase())
                    .getSingleResult();
            return count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean createAccountWithCustomer(Account account, Customer customer) {
        EntityManager em = EntityConnectivity.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(account);
            customer.setAccount(account);
            em.persist(customer);
            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean updateAccountStatus(int accountId, boolean isActive) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            String jpql = "UPDATE Account a SET a.active = :active WHERE a.accountID = :id";
            int updatedRows = em.createQuery(jpql)
                    .setParameter("active", isActive)
                    .setParameter("id", accountId)
                    .executeUpdate();
            em.getTransaction().commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean updateAccountRole(int accountId, String newRole) {
        EntityManager em = EntityConnectivity.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Account acc = em.find(Account.class, accountId);
            if (acc != null) {
                acc.setRole(Account.Role.valueOf(newRole));
                em.merge(acc);
                trans.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public Account findByEmail(String email) {
        if (email == null) return null;
        email = email.trim().toLowerCase();

        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            String jpql = "SELECT c.account FROM Customer c WHERE LOWER(c.email) = :email";
            TypedQuery<Account> query = em.createQuery(jpql, Account.class);
            query.setParameter("email", email);
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

    public List<Account> searchAccounts(String keyword, String role, String statusStr) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT a FROM Account a WHERE 1=1");

            if (keyword != null && !keyword.trim().isEmpty()) {
                jpql.append(" AND LOWER(a.username) LIKE :keyword");
            }
            if (role != null && !role.trim().isEmpty()) {
                jpql.append(" AND a.role = :role");
            }
            if (statusStr != null && !statusStr.trim().isEmpty()) {
                jpql.append(" AND a.active = :active");
            }

            TypedQuery<Account> query = em.createQuery(jpql.toString(), Account.class);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (role != null && !role.trim().isEmpty()) {
                query.setParameter("role", Account.Role.valueOf(role));
            }
            if (statusStr != null && !statusStr.trim().isEmpty()) {
                query.setParameter("active", Boolean.parseBoolean(statusStr));
            }

            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean updatePassword(int accountId, String newPassword) {
        EntityManager em = EntityConnectivity.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Account account = em.find(Account.class, accountId);
            if (account != null) {
                account.setPassword(newPassword);
                em.merge(account);
                trans.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}