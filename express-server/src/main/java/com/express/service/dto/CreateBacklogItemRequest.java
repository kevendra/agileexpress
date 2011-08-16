package com.express.service.dto;

import java.io.Serializable;


public class CreateBacklogItemRequest implements Serializable {

   private static final long serialVersionUID = -6979146785438719380L;
   
   public static final int PRODUCT_BACKLOG_STORY = 0;
   public static final int STORY = 1;
   public static final int TASK = 2;
   
   private Integer type;
   
   private long parentId;
   
   private  BacklogItemDto backlogItem;


   public int getType() {
      return type;
   }

   
   public void setType(int type) {
      this.type = type;
   }

   
   public long getParentId() {
      return parentId;
   }

   
   public void setParentId(long parentId) {
      this.parentId = parentId;
   }

   
   public BacklogItemDto getBacklogItem() {
      return backlogItem;
   }

   
   public void setBacklogItem(BacklogItemDto backlogItem) {
      this.backlogItem = backlogItem;
   }

}
