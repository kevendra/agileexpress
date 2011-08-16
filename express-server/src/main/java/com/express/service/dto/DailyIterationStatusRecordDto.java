package com.express.service.dto;

import java.io.Serializable;
import java.util.Date;

public class DailyIterationStatusRecordDto implements Serializable, Comparable<DailyIterationStatusRecordDto> {

   private static final long serialVersionUID = -2430698032474395774L;
   
   private long id;
   
   private Date date;
   
   private Integer taskHoursRemaining;

   private Integer totalPoints;

   private Integer completedPoints;

   public long getId() {
      return id;
   }

   public void setId(long id) {
      this.id = id;
   }

   public Date getDate() {
      return date;
   }

   public void setDate(Date date) {
      this.date = date;
   }

   public Integer getTaskHoursRemaining() {
      return taskHoursRemaining;
   }

   public void setTaskHoursRemaining(Integer taskHoursRemaining) {
      this.taskHoursRemaining = taskHoursRemaining;
   }

   public Integer getTotalPoints() {
      return totalPoints;
   }

   public void setTotalPoints(Integer totalPoints) {
      this.totalPoints = totalPoints;
   }

   public Integer getCompletedPoints() {
      return completedPoints;
   }

   public void setCompletedPoints(Integer completedPoints) {
      this.completedPoints = completedPoints;
   }

   public int compareTo(DailyIterationStatusRecordDto record) {
      return date.compareTo(record.getDate());
   }
}
