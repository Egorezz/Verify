package com.example.verify.entity;

import jakarta.persistence.*;

@Entity
@Table (name = "user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column (name = "username")
    private String username;
    @Column (name = "password")
    private String password;
}
