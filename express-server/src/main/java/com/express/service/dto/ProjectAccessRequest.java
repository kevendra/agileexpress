package com.express.service.dto;

import java.io.Serializable;
import java.util.List;

public class ProjectAccessRequest implements Serializable {

   private static final long serialVersionUID = 2233361381682891883L;
   
   private ProjectDto newProject;
   
   private List<ProjectDto> existingProjects;

   public ProjectDto getNewProject() {
      return newProject;
   }

   public void setNewProject(ProjectDto newProject) {
      this.newProject = newProject;
   }

   public List<ProjectDto> getExistingProjects() {
      return existingProjects;
   }

   public void setExistingProjects(List<ProjectDto> existingProjects) {
      this.existingProjects = existingProjects;
   }

}
