package service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class EntityConnectivity {
    private static EntityManagerFactory emf;
    static {
        try {
            // Khởi tạo ngay khi class được load
            emf = Persistence.createEntityManagerFactory("BanDoGiaDung");
        } catch (Throwable e) {
            System.err.println("LỖI KHI KHỎI TẠO ENTITY MANAGER FACTORY:");
            e.printStackTrace(); // In chi tiết nguyên nhân gốc ra Console
            throw new RuntimeException("Không thể khởi tạo EntityManagerFactory!", e);
        }
    }

    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public static void closeFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}