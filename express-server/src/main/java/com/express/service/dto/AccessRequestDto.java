package com.express.service.dto;

import java.io.Serializable;
import java.util.Calendar;

public class AccessRequestDto implements Serializable {
   private static final long serialVersionUID = -1531630899821683796L;

   private long id;

   private Long version;

   private UserDto requestor;

   private Calendar requestDate;

   private Calendar resolvedDate;

   private Integer status;

   private String reason;

   private ProjectDto project;

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

   public UserDto getRequestor() {
      return requestor;
   }

   public void setRequestor(UserDto requestor) {
      this.requestor = requestor;
   }

   public Calendar getRequestDate() {
      return requestDate;
   }

   public void setRequestDate(Calendar requestCalendar) {
      this.requestDate = requestCalendar;
   }

   public Calendar getResolvedDate() {
      return resolvedDate;
   }

   public void setResolvedDate(Calendar resolvedCalendar) {
      this.resolvedDate = resolvedCalendar;
   }

   public Integer getStatus() {
      return status;
   }

   public void setStatus(Integer status) {
      this.status = status;
   }

   public String getReason() {
      return reason;
   }

   public void setReason(String reason) {
      this.reason = reason;
   }

   public ProjectDto getProject() {
      return project;
   }

   public void setProject(ProjectDto project) {
      this.project = project;
   }
}
