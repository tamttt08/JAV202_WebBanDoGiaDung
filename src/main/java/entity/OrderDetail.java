package entity;

import entity.Product;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "OrderDetails")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderDetailID")
    private Integer orderDetailID;

    @ManyToOne
    @JoinColumn(name = "OrderID")
    private Order order;

    @ManyToOne
    @JoinColumn(name = "ProductID")
    private Product product;

    @Column(name = "Quantity", nullable = false)
    private Integer quantity;

    @Column(name = "UnitPrice", nullable = false, precision = 10, scale = 2)
    private BigDecimal unitPrice;
}