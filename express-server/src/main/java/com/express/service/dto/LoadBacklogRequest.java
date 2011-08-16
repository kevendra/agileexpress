package com.express.service.dto;

public class LoadBacklogRequest {

   public static final Integer TYPE_ITERATION = 0;
   public static final Integer TYPE_PROJECT = 1;

   private Integer type;

   private long parentId;

   
   public Integer getType() {
      return type;
   }

   
   public void setType(Integer type) {
      this.type = type;
   }

   
   public long getParentId() {
      return parentId;
   }

   
   public void setParentId(long parentId) {
      this.parentId = parentId;
   }

}
