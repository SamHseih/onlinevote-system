package com.esun.vote.service;

import com.esun.vote.dto.VoteRequest;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class VoteService {
  private final JdbcTemplate jdbc;
  public VoteService(JdbcTemplate jdbc) { this.jdbc = jdbc; }

  @Transactional(rollbackFor = Exception.class, isolation = Isolation.READ_COMMITTED)
  public void vote(String voter, List<Long> itemIds) {
    if (itemIds == null || itemIds.isEmpty()) {
      throw new IllegalArgumentException("請至少選擇一個項目");
    }
    // 單筆逐一：簡潔清楚、錯哪筆都會回滾
    for (Long itemId : itemIds) {
      jdbc.update("CALL sp_vote(?,?)", voter, itemId);
    }
    // 若想加速：
    // jdbc.batchUpdate("CALL sp_vote(?,?)", itemIds, itemIds.size(),
    //   (ps, itemId) -> { ps.setString(1, voter); ps.setLong(2, itemId); });
  }
}
