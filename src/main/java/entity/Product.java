package entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "Products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ProductID")
    private Integer productID;

    @Column(name = "ProductCode", unique = true, length = 20)
    private String productCode;

    @Column(name = "ProductName", nullable = false, length = 150)
    private String productName;

    @Column(name = "Price", nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(name = "StockQuantity", nullable = false)
    private Integer stockQuantity = 0;

    @ManyToOne
    @JoinColumn(name = "CategoryID")
    private Category category;

    @Column(name = "Description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "Image", length = 255)
    private String image;
}