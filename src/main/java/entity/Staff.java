package entity;

import entity.Account;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Staffs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Staff {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "StaffID")
    private Integer staffID;

    @OneToOne
    @JoinColumn(name = "AccountID", unique = true)
    private Account account;

    @Column(name = "FullName", nullable = false, length = 100)
    private String fullName;

    @Column(name = "Email", unique = true, length = 100)
    private String email;

    @Column(name = "Phone", length = 15)
    private String phone;

    @Column(name = "Position", length = 50)
    private String position;
}