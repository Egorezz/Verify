package com.example.verify.QrCodes.Service;

import com.example.verify.QrCodes.Entity.QrCode;
import com.example.verify.QrCodes.Repository.QrRepository;
import com.example.verify.QrCodes.Enum.DocStatus;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class QrService {
    private QrRepository qrRepository;

    public QrService(QrRepository qrRepository) {
        this.qrRepository = qrRepository;
    }

    public DocStatus getStatus(Long id) throws EntityNotFoundException {
        QrCode qrCode = qrRepository.findById(id).orElseThrow(() -> new EntityNotFoundException());
        LocalDate endDate = qrCode.getEndDate();
        LocalDate weekFromNow = LocalDate.now().plusDays(7);
        if (endDate.isBefore(LocalDate.now())) {
            return DocStatus.INVALID;
        }
        if (endDate.isEqual(LocalDate.now())) {
            return DocStatus.EXPIRING_SOON;
        }
        if (endDate.isBefore(LocalDate.now().plusDays(7)) || endDate.isEqual(weekFromNow)) {
            return DocStatus.EXPIRING_SOON;
        }
        return DocStatus.VALID;
    }
}
