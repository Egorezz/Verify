package com.example.verify.Auth.Request;

import lombok.Data;

@Data
public class SigninRequest {
    private String username;
    private String pin;
}
