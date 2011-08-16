package com.express.domain;

/**
 * This Enumeration defines the workflow steps available to a BacklogItem of any type.
 *
 * @author adam boas
 */
public enum Status {
   OPEN("OPEN"), IN_PROGRESS("IN PROGRESS"), TEST("TEST"), DONE("DONE");
   
   private final String title;
   
   Status(String title) {
      this.title = title;
   }

   public String getTitle() {
      return title;
   }
   
   public static Status getStatus(String title) {
      if("OPEN".equals(title)) {
         return OPEN;
      }
      if("IN PROGRESS".equals(title)) {
         return IN_PROGRESS;
      }
      if("TEST".equals(title)) {
         return TEST;
      }
      if("DONE".equals(title)) {
         return DONE;
      }
      return null;
   }

}
