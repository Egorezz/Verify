package com.example.verify.QrCodes.Service;

import com.example.verify.QrCodes.Entity.VerifiedDocs;
import com.example.verify.QrCodes.Repository.DocRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VerifiedDocsService {
    private final DocRepository docRepository;

    public VerifiedDocsService(DocRepository docRepository) {
        this.docRepository = docRepository;
    }

    public List<VerifiedDocs> getDocumentsByUserId(Long userId) {
            return docRepository.findByUserId(userId);
    }
}

