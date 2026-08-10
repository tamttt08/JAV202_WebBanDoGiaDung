package dao;

import entity.ProductImage;

import jakarta.persistence.EntityManager;
import service.EntityConnectivity;

public class ProductImageDAO {

    public void create(ProductImage image) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(image);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(int imageId) {
        EntityManager em = EntityConnectivity.getEntityManager();
        try {
            em.getTransaction().begin();
            ProductImage image = em.find(ProductImage.class, imageId);
            if (image != null) {
                em.remove(image);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}