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
    @Column (name = "docType")
    private String docType;
    @Column (name = "endDate")
    private LocalDate endDate;
}
