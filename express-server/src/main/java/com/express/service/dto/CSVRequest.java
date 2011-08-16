package com.express.service.dto;

/**
 *
 */

public class CSVRequest {
   public static final int TYPE_ITERATION_BACKLOG = 1;

   public static final int TYPE_PRODUCT_BACKLOG = 2;

   private long id;

   private int type;

   public long getId() {
      return id;
   }

   public void setId(long id) {
      this.id = id;
   }

   public int getType() {
      return type;
   }

   public void setType(int type) {
      this.type = type;
   }
}
