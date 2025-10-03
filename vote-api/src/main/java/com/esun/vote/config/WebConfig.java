package com.esun.vote.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

/** CORS*/
@Configuration
public class WebConfig implements WebMvcConfigurer {
  @Value("${app.cors.allowed-origins}")
  private String allowedOrigins;

  @Override
  public void addCorsMappings(CorsRegistry registry) {
    registry.addMapping("/**")
      .allowedOrigins(allowedOrigins)
      .allowedMethods("GET","POST","PUT","DELETE");
  }
}
