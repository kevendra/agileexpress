package com.express.service.dto;

import com.googlecode.simpleobjectassembler.annotation.EntityDto;

import java.io.Serializable;
import java.util.Calendar;

@EntityDto(id = "id")
public class IssueDto implements Serializable {
   private long id;

   private Long version;

   private String title;

   private String description;

   private Calendar startDate;

   private Calendar endDate;

   private BacklogItemDto backlogItem;

   private IterationDto iteration;

   private UserDto responsible;

   public long getId() {
      return id;
   }

   public void setId(long id) {
      this.id = id;
   }

   public Long getVersion() {
      return version;
   }

   public void setVersion(Long version) {
      this.version = version;
   }

   public String getTitle() {
      return title;
   }

   public void setTitle(String title) {
      this.title = title;
   }

   public String getDescription() {
      return description;
   }

   public void setDescription(String description) {
      this.description = description;
   }

   public Calendar getStartDate() {
      return startDate;
   }

   public void setStartDate(Calendar startDate) {
      this.startDate = startDate;
   }

   public Calendar getEndDate() {
      return endDate;
   }

   public void setEndDate(Calendar endDate) {
      this.endDate = endDate;
   }

   public BacklogItemDto getBacklogItem() {
      return backlogItem;
   }

   public void setBacklogItem(BacklogItemDto backlogItem) {
      this.backlogItem = backlogItem;
   }

   public IterationDto getIteration() {
      return iteration;
   }

   public void setIteration(IterationDto iteration) {
      this.iteration = iteration;
   }

   public UserDto getResponsible() {
      return responsible;
   }

   public void setResponsible(UserDto responsible) {
      this.responsible = responsible;
   }
}
