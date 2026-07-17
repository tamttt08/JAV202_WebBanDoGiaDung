package entity;

import entity.Customer;
import entity.Product;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Carts")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "CartID")
    private Integer cartID;

    @ManyToOne
    @JoinColumn(name = "CustomerID", nullable = false)
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "ProductID", nullable = false)
    private Product product;

    @Column(name = "Quantity", nullable = false)
    private Integer quantity = 1;
}