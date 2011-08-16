package com.express.service.dto;

import java.util.List;
import java.io.Serializable;

/**
 * @author Adam Boas
 *         Created on Mar 24, 2009
 */
public class ProjectAccessData implements Serializable{

   private List<ProjectDto> grantedList;
   private List<ProjectDto> pendingList;
   private List<ProjectDto> availableList;
   private static final long serialVersionUID = 6523468256134846154L;

   public List<ProjectDto> getGrantedList() {
      return grantedList;
   }

   public void setGrantedList(List<ProjectDto> grantedList) {
      this.grantedList = grantedList;
   }

   public List<ProjectDto> getPendingList() {
      return pendingList;
   }

   public void setPendingList(List<ProjectDto> pendingList) {
      this.pendingList = pendingList;
   }

   public List<ProjectDto> getAvailableList() {
      return availableList;
   }

   public void setAvailableList(List<ProjectDto> availableList) {
      this.availableList = availableList;
   }
}
