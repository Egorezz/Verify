package com.example.verify.QrCodes.Entity;

import com.example.verify.QrCodes.Enum.DocStatus;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table (name = "verified_docs")
@Data
public class VerifiedDocs {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;
    @Column (name = "user_id")
    private Long userId;
    @Column (name = "doc_name")
    private String docName;
    @Enumerated(EnumType.STRING)
    @Column (name = "status")
    private DocStatus status;
}
