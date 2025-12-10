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
        if (LocalDate.now().isEqual(endDate.minusDays(7)) || (LocalDate.now().isAfter(endDate.minusDays(7)) && LocalDate.now().isBefore(endDate)) || LocalDate.now().isEqual(endDate)) {
            return DocStatus.EXPIRING_SOON;
        } else
        if (endDate.isBefore(LocalDate.now())) {
            return DocStatus.INVALID;
        } else
        return DocStatus.VALID;
    }
}
