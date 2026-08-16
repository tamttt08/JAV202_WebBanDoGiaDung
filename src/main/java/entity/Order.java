package entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "Orders")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderID")
    private Integer orderID;

    @Column(name = "OrderCode", length = 30, unique = true)
    private String orderCode;

    @ManyToOne
    @JoinColumn(name = "CustomerID")
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "StaffID")
    private Staff staff;

    @ManyToOne
    @JoinColumn(name = "CouponID")
    private Coupon coupon;

    @Column(name = "OrderDate", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime orderDate = LocalDateTime.now();

    @Column(name = "SubTotal", nullable = false, precision = 12, scale = 2)
    private BigDecimal subTotal;

    @Column(name = "DiscountAmount", precision = 12, scale = 2)
    private BigDecimal discountAmount = BigDecimal.ZERO;

    @Column(name = "TotalAmount", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalAmount;

    // 🟢 SỬA TÊN FIELD: Đổi từ customerName -> receiverName để tránh xung đột EL/Getter
    @Column(name = "ReceiverName", nullable = false, length = 100)
    private String receiverName;

    // 🟢 SỬA TÊN FIELD: Đổi từ customerPhone -> receiverPhone
    @Column(name = "ReceiverPhone", nullable = false, length = 15)
    private String receiverPhone;

    @Column(name = "ShippingAddress", nullable = false, length = 255)
    private String shippingAddress;

    @Column(name = "Note", length = 255)
    private String note;

    @Enumerated(EnumType.STRING)
    @Column(name = "Status", nullable = false)
    private OrderStatus status = OrderStatus.Pending;

    // 🟢 CHỐNG LẶP VÔ TẬN: Tránh lỗi khi parse JSON hoặc toString
    @JsonIgnore
    @ToString.Exclude
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderDetail> orderDetails;

    public String getFormattedOrderDate() {
        if (this.orderDate == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        return this.orderDate.format(formatter);
    }

    public enum OrderStatus {
        Pending, Paid, Shipping, Delivered, Cancelled
    }

    public String getStatusDisplayName() {
        if (this.status == null) return "";
        switch (this.status) {
            case Pending: return "Chờ xử lý";
            case Paid: return "Đã thanh toán";
            case Shipping: return "Đang giao";
            case Delivered: return "Đã giao hàng";
            case Cancelled: return "Đã hủy";
            default: return this.status.name();
        }
    }
}