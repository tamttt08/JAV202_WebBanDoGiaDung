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
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Không thể khởi tạo EntityManagerFactory!");
        }
    }
    // Mỗi khi cần dùng ở Service, các bạn gọi hàm này để lấy một "ông thợ" mới
    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    // Hàm này dùng để đóng xưởng khi tắt Server (thường gọi ở ContextListener)
    public static void closeFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }

}
