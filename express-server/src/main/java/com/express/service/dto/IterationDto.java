package com.express.service.dto;

import com.googlecode.simpleobjectassembler.annotation.EntityDto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;

@EntityDto(id = "id")
public class IterationDto implements Serializable, Comparable<IterationDto> {
   
   private static final long serialVersionUID = -1846071747249767308L;

   private long id;
   
   private Long version;
   
   private Calendar startDate;
   
   private Calendar endDate;
   
   private String title;
   
   private String goal;

   private Integer finalVelocity;
   
   private ProjectDto project;
   
   private List<BacklogItemDto> backlog;
   
   private List<DailyIterationStatusRecordDto> history;

   private List<IssueDto> impediments;

   public IterationDto() {
      this.backlog = new ArrayList<BacklogItemDto>();
      this.history = new ArrayList<DailyIterationStatusRecordDto>();
      this.impediments = new ArrayList<IssueDto>();
   }

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

   public String getTitle() {
      return title;
   }

   public void setTitle(String title) {
      this.title = title;
   }

   public String getGoal() {
      return goal;
   }

   public void setGoal(String goal) {
      this.goal = goal;
   }

   public ProjectDto getProject() {
      return project;
   }

   public void setProject(ProjectDto project) {
      this.project = project;
   }

   public List<BacklogItemDto> getBacklog() {
      return backlog;
   }

   public void setBacklog(List<BacklogItemDto> backlog) {
      this.backlog = backlog;
   }

   public List<DailyIterationStatusRecordDto> getHistory() {
      return history;
   }

   public void setHistory(List<DailyIterationStatusRecordDto> history) {
      Collections.sort(history);
      this.history = history;
   }

   public Integer getFinalVelocity() {
      return finalVelocity;
   }

   public void setFinalVelocity(Integer finalVelocity) {
      this.finalVelocity = finalVelocity;
   }

   public List<IssueDto> getImpediments() {
      return impediments;
   }

   public void setImpediments(List<IssueDto> impediments) {
      this.impediments = impediments;
   }

   public int compareTo(IterationDto iteration) {
      return this.startDate.compareTo(iteration.getStartDate());
   }

}
