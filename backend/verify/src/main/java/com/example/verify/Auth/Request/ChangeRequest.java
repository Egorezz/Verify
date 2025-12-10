package com.example.verify.Auth.Request;

import lombok.Data;

@Data
public class ChangeRequest {
    private String email;
    private String password;
}
