package com.esun.vote.controller;

import jakarta.validation.constraints.NotBlank;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

/** 後台管理 */
@RestController
@RequestMapping("/api/admin")
public class AdminController {
  private final JdbcTemplate jdbc;
  public AdminController(JdbcTemplate jdbc) { this.jdbc = jdbc; }

  @PostMapping("/items")
  public Map<String,Object> addItem(@RequestParam @NotBlank String name) {
    jdbc.update("CALL sp_add_item(?)", name);
    return Map.of("ok", true);
  }

  @PutMapping("/items/{id}")
  public Map<String,Object> updateItem(@PathVariable Long id,
                                       @RequestParam String name,
                                       @RequestParam(defaultValue="1") int enabled) {
    jdbc.update("CALL sp_update_item(?,?,?)", id, name, enabled);
    return Map.of("ok", true);
  }

  @DeleteMapping("/items/{id}")
  public Map<String,Object> deleteItem(@PathVariable Long id) {
    jdbc.update("CALL sp_delete_item(?)", id);
    return Map.of("ok", true);
  }
}
