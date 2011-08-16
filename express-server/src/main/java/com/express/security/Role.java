package com.express.security;

public enum Role {
   USER("ROLE_USER", "Application user"), ADMIN("ROLE_ADMIN", "Application administrator");
   
   private final String code;
   private final String description;
   
   private Role(String code, String description) {
      this.code = code;
      this.description = description;
   }
   public String getCode() {
      return code;
   }
   public String getDescription() {
      return description;
   }

}
