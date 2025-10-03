package com.esun.vote.dto;

import jakarta.validation.constraints.*;
import java.util.List;

public class VoteRequest {
  @NotBlank
  @Pattern(regexp = "^[\\p{L}0-9_\\- ]{1,32}$") // 基本過濾，避免 XSS/奇怪字元
  private String voter;

  @NotEmpty
  private List<Long> itemIds;

  public String getVoter() { return voter; }
  public void setVoter(String voter) { this.voter = voter; }
  public List<Long> getItemIds() { return itemIds; }
  public void setItemIds(List<Long> itemIds) { this.itemIds = itemIds; }
}
