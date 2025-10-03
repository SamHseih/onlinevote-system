package com.esun.vote.service;

import com.esun.vote.dto.VoteRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class VoteService {
  private final JdbcTemplate jdbc;

  public VoteService(JdbcTemplate jdbc) { this.jdbc = jdbc; }

  // 同時對多個 item 投票；以 Transaction 確保全部成功或全部失敗
  @Transactional
  public void vote(VoteRequest req) {
    for (Long itemId : req.getItemIds()) {
      jdbc.update("CALL sp_vote(?,?)", req.getVoter(), itemId);
    }
  }
}
