package com.express.service.dto;

import java.io.Serializable;


public class BacklogItemAssignRequest implements Serializable {

   private static final long serialVersionUID = 4494774116538737140L;
   
   private long[] itemIds;

   private long projectId;
   
   private long iterationFromId;
   
   private long iterationToId;

   public long[] getItemIds() {
      return itemIds;
   }

   public void setItemIds(long[] itemIds) {
      this.itemIds = itemIds;
   }

   public long getProjectId() {
      return projectId;
   }

   public void setProjectId(long projectId) {
      this.projectId = projectId;
   }

   public long getIterationFromId() {
      return iterationFromId;
   }

   public void setIterationFromId(long iterationFromId) {
      this.iterationFromId = iterationFromId;
   }

   public long getIterationToId() {
      return iterationToId;
   }

   public void setIterationToId(long iterationToId) {
      this.iterationToId = iterationToId;
   }
}
