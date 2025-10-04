package com.esun.vote.config;

import java.util.Map;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.http.HttpStatus;

@RestControllerAdvice
public class GlobalExceptionHandler {
  @ExceptionHandler(DataIntegrityViolationException.class)
  @ResponseStatus(HttpStatus.CONFLICT)
  public Map<String,Object> handleDup(Exception e) {
    return Map.of("ok", false, "error", "重複投票或資料限制違反");
  }

  @ExceptionHandler(IllegalArgumentException.class)
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  public Map<String,Object> handleBadReq(IllegalArgumentException e) {
    return Map.of("ok", false, "error", e.getMessage());
  }
}
