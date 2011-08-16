package com.express.service.dto;

import com.googlecode.simpleobjectassembler.annotation.EntityDto;

import java.io.Serializable;

/**
 * @author Adam Boas
 *         Created on Apr 1, 2009
 */
@EntityDto(id = "id")
public class PermissionsDto implements Serializable{

   private long id;
   private Long version;
   private Boolean iterationAdmin;
   private Boolean projectAdmin;
   private static final long serialVersionUID = 4182366610220431019L;

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

   public Boolean getIterationAdmin() {
      return iterationAdmin;
   }

   public void setIterationAdmin(Boolean iterationAdmin) {
      this.iterationAdmin = iterationAdmin;
   }

   public Boolean getProjectAdmin() {
      return projectAdmin;
   }

   public void setProjectAdmin(Boolean projectAdmin) {
      this.projectAdmin = projectAdmin;
   }
}
