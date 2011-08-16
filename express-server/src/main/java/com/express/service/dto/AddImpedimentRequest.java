package com.express.service.dto;

/**
 *
 */
public class AddImpedimentRequest {

   long backlogItemId;

   long iterationId;

   IssueDto impediment;

   public long getBacklogItemId() {
      return backlogItemId;
   }

   public void setBacklogItemId(long backlogItemId) {
      this.backlogItemId = backlogItemId;
   }

   public long getIterationId() {
      return iterationId;
   }

   public void setIterationId(long iterationId) {
      this.iterationId = iterationId;
   }

   public IssueDto getImpediment() {
      return impediment;
   }

   public void setImpediment(IssueDto impediment) {
      this.impediment = impediment;
   }
}
