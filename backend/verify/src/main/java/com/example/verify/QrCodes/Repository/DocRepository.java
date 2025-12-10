package com.example.verify.QrCodes.Repository;

import com.example.verify.QrCodes.Entity.VerifiedDocs;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DocRepository extends JpaRepository<VerifiedDocs, Long> {
    List<VerifiedDocs> findByUserId(Long userId);
}
