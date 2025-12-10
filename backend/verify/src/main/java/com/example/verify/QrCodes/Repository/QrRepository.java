package com.example.verify.QrCodes.Repository;

import com.example.verify.QrCodes.Entity.QrCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface QrRepository extends JpaRepository<QrCode, Long> {
}
