package com.example.verify.QrCodes.Controller;

import com.example.verify.QrCodes.Enum.DocStatus;
import com.example.verify.QrCodes.Service.QrService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/document")
public class QrController {
    QrService qrService;

    public QrController(QrService qrService) {
        this.qrService = qrService;
    }

    @GetMapping("/verify/{id}")
    public ResponseEntity<?> verifyDoc(@PathVariable Long id) {
        try {
            DocStatus docStatus = qrService.getStatus(id);
            return ResponseEntity.ok(docStatus);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Document with id " + id + " not found");
        }
    }

}
