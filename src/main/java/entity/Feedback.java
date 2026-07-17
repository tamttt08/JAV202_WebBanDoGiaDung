package entity;

import entity.Customer;
import entity.Product;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Feedbacks")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Feedback {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FeedbackID")
    private Integer feedbackID;

    @ManyToOne
    @JoinColumn(name = "CustomerID")
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "ProductID")
    private Product product;

    @Column(name = "Rating")
    private Integer rating;

    @Column(name = "Comment", columnDefinition = "TEXT")
    private String comment;

    @Column(name = "CreatedAt", insertable = false, updatable = false)
    private LocalDateTime createdAt;
}