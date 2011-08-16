package com.express.service.dto;

import java.util.List;
import java.io.Serializable;

/**
 *
 */
public class ProjectWorkersUpdateRequest implements Serializable {

   private List<ProjectWorkerDto> workers;

   private long projectId;

   public List<ProjectWorkerDto> getWorkers() {
      return workers;
   }

   public void setWorkers(List<ProjectWorkerDto> workers) {
      this.workers = workers;
   }

   public long getProjectId() {
      return projectId;
   }

   public void setProjectId(long projectId) {
      this.projectId = projectId;
   }
}
