package com.example.verify.QrCodes.Entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table (name = "qrCodes")
@Data
public class QrCode {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;
    @Column (name = "userId")
    private Long userId;
    @Column (name = "docName")
    private String docName;
    @Column (name = "endDate")
    private LocalDate endDate;
}
