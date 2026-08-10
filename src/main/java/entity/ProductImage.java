package entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ProductImages")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProductImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ImageID")
    private Integer imageID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ProductID", nullable = false)
    private Product product;

    @Column(name = "ImageURL", nullable = false, length = 255)
    private String imageURL;

    // Custom constructor giúp tạo đối tượng nhanh khi lưu ảnh phụ
    public ProductImage(Product product, String imageURL) {
        this.product = product;
        this.imageURL = imageURL;
    }
}