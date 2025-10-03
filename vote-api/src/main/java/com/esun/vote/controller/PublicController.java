package com.esun.vote.controller;

import com.esun.vote.dto.VoteRequest;
import com.esun.vote.service.VoteService;
import jakarta.validation.Valid;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import java.util.*;

/** 使用者投票查詢*/
@RestController
@RequestMapping("/api")
public class PublicController {
  private final JdbcTemplate jdbc;
  private final VoteService voteService;

  public PublicController(JdbcTemplate jdbc, VoteService voteService) {
    this.jdbc = jdbc; this.voteService = voteService;
  }

  @GetMapping("/items")
  public List<Map<String,Object>> items() {
    return jdbc.queryForList("CALL sp_list_items_with_count()");
  }

  @PostMapping("/votes")
  public Map<String,Object> vote(@Valid @RequestBody VoteRequest req) {
    voteService.vote(req);
    return Map.of("ok", true);
  }
}
