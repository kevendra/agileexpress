package com.express.service.dto;

import com.googlecode.simpleobjectassembler.annotation.EntityDto;

import java.io.Serializable;
import java.util.List;

@EntityDto(id = "id")
public class UserDto implements Serializable{
   private static final long serialVersionUID = 1837756627356308380L;
   
   private long id;
   private Long version;
   private String email;
   private String firstName;
   private String lastName;
   private String password;
   private String passwordHint;
   private String phone1;
   private String phone2;
   private boolean hasProjects;
   private Integer colour;
   private List<AccessRequestDto> accessRequests;
   
   public long getId() {
      return id;
   }
   public void setId(long id) {
      this.id = id;
   }
   public Long getVersion() {
      return version;
   }
   public void setVersion(Long version) {
      this.version = version;
   }
   public String getEmail() {
      return email;
   }
   public void setEmail(String email) {
      this.email = email;
   }
   public String getFirstName() {
      return firstName;
   }
   public void setFirstName(String firstName) {
      this.firstName = firstName;
   }
   public String getLastName() {
      return lastName;
   }
   public void setLastName(String lastName) {
      this.lastName = lastName;
   }
   public String getPassword() {
      return password;
   }
   public void setPassword(String password) {
      this.password = password;
   }
   public String getPasswordHint() {
      return passwordHint;
   }
   public void setPasswordHint(String passwordHint) {
      this.passwordHint = passwordHint;
   }
   public String getPhone1() {
      return phone1;
   }
   public void setPhone1(String phone1) {
      this.phone1 = phone1;
   }
   public String getPhone2() {
      return phone2;
   }
   public void setPhone2(String phone2) {
      this.phone2 = phone2;
   }
   
   public Integer getColour() {
      return colour;
   }
   
   public void setColour(Integer colour) {
      this.colour = colour;
   }
   public boolean isHasProjects() {
      return hasProjects;
   }
   public void setHasProjects(boolean hasProjects) {
      this.hasProjects = hasProjects;
   }

   public List<AccessRequestDto> getAccessRequests() {
      return accessRequests;
   }

   public void setAccessRequests(List<AccessRequestDto> accessRequests) {
      this.accessRequests = accessRequests;
   }
}
