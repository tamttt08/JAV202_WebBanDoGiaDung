package dao;

import java.util.List;

/**
 * Generic Interface đại diện cho các thao tác CRUD cơ bản trong hệ thống.
 * @param <T> Loại đối tượng Entity (ví dụ: Account, Product, Customer,...)
 * @param <K> Loại dữ liệu của Khóa chính (ví dụ: Integer, String,...)
 */
public interface CrudDAO<T, K> {

    void create(T entity);

    void update(T entity);

    void delete(K id);

    T findById(K id);

    List<T> findAll();
}