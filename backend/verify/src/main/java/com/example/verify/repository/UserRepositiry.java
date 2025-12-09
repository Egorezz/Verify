package com.example.verify.repository;

import com.example.verify.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepositiry extends JpaRepository<User,Long> {
    Optional<User> findByName(String username);
}
