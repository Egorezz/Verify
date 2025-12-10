package com.example.verify.QrCodes.Controller;

import com.example.verify.Auth.Repository.UserRepository;
import com.example.verify.QrCodes.Entity.VerifiedDocs;
import com.example.verify.QrCodes.Enum.DocStatus;
import com.example.verify.QrCodes.Repository.DocRepository;
import com.example.verify.QrCodes.Service.QrService;
import com.example.verify.QrCodes.Service.VerifiedDocsService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/document")
public class QrController {
    QrService qrService;
    DocRepository docRepository;
    VerifiedDocsService verifiedDocsService;


    public QrController(QrService qrService, VerifiedDocsService verifiedDocsService, DocRepository docRepository) {
        this.qrService = qrService;
        this.verifiedDocsService = verifiedDocsService;
        this.docRepository = docRepository;
    }

    @GetMapping("/verify/{id}/user/{userId}/docName/{docName}")
    public ResponseEntity<?> verifyDoc(@PathVariable Long id, @PathVariable Long userId, @PathVariable String docName) {
        try {
            DocStatus docStatus = qrService.getStatus(id);

            VerifiedDocs verifiedDocs = new VerifiedDocs();
            verifiedDocs.setUserId(userId);
            verifiedDocs.setDocName(docName);
            verifiedDocs.setStatus(docStatus);
            docRepository.save(verifiedDocs);

            return ResponseEntity.ok(docStatus);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Document with id " + id + " not found");
        }
    }

    @GetMapping("/verified/{userId}")
    public ResponseEntity<List<VerifiedDocs>> getAllVerifiedDocs(@PathVariable Long userId) {
        return ResponseEntity.ok(verifiedDocsService.getDocumentsByUserId(userId));
    }




}
