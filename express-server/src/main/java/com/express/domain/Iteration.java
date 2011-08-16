package com.express.domain;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.hibernate.annotations.OptimisticLock;

import javax.persistence.*;
import java.util.*;

/**
 * Models an Iteration which is effectively a work period for a project. an Iteration
 * primarily contains a backlog which is a list of Stories which need to be completed before completion.
 *
 * @author adam boas
 */
@Entity
@Table(name = "iteration")
@NamedQueries({
      @NamedQuery(name = "Iteration.findOpen", query = "SELECT I FROM Iteration I WHERE I.startDate <= :date AND I.endDate >= :date")
})
public class Iteration implements Persistable, Comparable<Iteration>, BacklogContainer {

   private static final long serialVersionUID = -4839071199885329170L;

   public static final String QUERY_FIND_OPEN = "Iteration.findOpen";

   @Transient
   private PersistableEqualityStrategy equalityStrategy = new PersistableEqualityStrategy(this);

   @Id
   @GeneratedValue(strategy = GenerationType.TABLE, generator = "gen_iteration")
   @TableGenerator(name = "gen_iteration", table = "sequence_list", pkColumnName = "name",
         valueColumnName = "next_value", allocationSize = 1, initialValue = 100,
         pkColumnValue = "iteration")
   @Column(name = "iteration_id")
   private Long id;

   @Version
   @Column(name = "version_no")
   private Long version;

   @Column(name = "start_date")
   @Temporal(value = TemporalType.TIMESTAMP)
   private Calendar startDate;

   @Column(name = "end_date")
   @Temporal(value = TemporalType.TIMESTAMP)
   private Calendar endDate;

   @Column(name = "title")
   private String title;

   @Column(name = "goal") @Lob
   private String goal;

   @Column(name = "final_velocity")
   private Integer finalVelocity;

   @ManyToOne
   @JoinColumn(name = "project_id")
   @OptimisticLock(excluded = true)
   private Project project;

   @OneToMany(mappedBy = "iteration", cascade = CascadeType.ALL)
   @OptimisticLock(excluded = true)
   private Set<BacklogItem> backlog;

   @OneToMany(mappedBy = "iteration", cascade = CascadeType.ALL)
   @OptimisticLock(excluded = true)
   private Set<Issue> impediments;

   @OneToMany(mappedBy = "iteration", cascade = CascadeType.ALL)
   private Set<DailyIterationStatusRecord> history;

   public Iteration() {
      backlog = new HashSet<BacklogItem>();
      impediments = new HashSet<Issue>();
      history = new HashSet<DailyIterationStatusRecord>();
   }

   public Long getId() {
      return id;
   }

   public void setId(Long id) {
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

   public Project getProject() {
      return project;
   }

   public void setProject(Project project) {
      this.project = project;
   }

   public Set<BacklogItem> getBacklog() {
      return this.backlog;
   }

   public void setBacklog(Set<BacklogItem> backlog) {
      this.backlog = backlog;
   }

   public Integer getFinalVelocity() {
      return finalVelocity;
   }

   public void setFinalVelocity(Integer finalVelocity) {
      this.finalVelocity = finalVelocity;
   }

   public void addBacklogItem(BacklogItem backlogItem, boolean isNew) {
      this.backlog.add(backlogItem);
      backlogItem.setIteration(this);
      backlogItem.setProject(null);
      if(isNew) {
         this.project.incrementStoryCount();
      }
   }

   public BacklogItem removeBacklogItem(BacklogItem backlogItem) {
      if (this.backlog.remove(backlogItem)) {
         backlogItem.setIteration(null);
         return backlogItem;
      }
      return null;
   }

   public Set<DailyIterationStatusRecord> getHistory() {
      return history;
   }

   public void setHistory(Set<DailyIterationStatusRecord> history) {
      this.history = history;
   }

   public void addHistoryRecord(DailyIterationStatusRecord record) {
      this.history.add(record);
   }

   public Set<Issue> getImpediments() {
      return impediments;
   }

   public void setImpediments(Set<Issue> impediments) {
      this.impediments = impediments;
   }

   public void addImpediment(Issue impediment) {
      this.impediments.add(impediment);
      impediment.setIteration(this);
   }

   public void removeImpediment(Issue impediment) {
      this.impediments.remove(impediment);
      impediment.setIteration(null);
   }

   public int compareTo(Iteration iteration) {
      return this.startDate.compareTo(iteration.getStartDate());
   }

   /**
    * Task effort is intended to change over time as tasks are completed or moved toward completion.
    * This method returns the current remaining hours of effort to complete this Iteration.
    *
    * @return int representing the current remaining hours of effort to complete this Iteration.
    */
   public int getTaskEffortRemaining() {
      int remainingHours = 0;
      for (BacklogItem item : backlog) {
         remainingHours += item.getTaskEffortRemaining();
      }
      return remainingHours;
   }

   /**
    * It is not intended that Velocity vary in the life of an Iteration. It will, however, alter
    * if the effort value of a story in the iteration is altered or a Story is removed or added.
    *
    * @return int representing the current velocity (number of Story Points) in whatever measure
    *         has been set in the parent project.
    */
   public int getStoryPoints() {
      int velocity = 0;
      for (BacklogItem item : backlog) {
         velocity += item.getEffort();
      }
      return velocity;
   }

   public int getStoryPointsCompleted() {
      int total = 0;
      for(BacklogItem item : backlog) {
         if(item.getStatus() == Status.DONE) {
            total += item.getEffort();
         }
      }
      return total;
   }

   public BacklogItem findBacklogItemByReference(String ref) {
      for (BacklogItem item : backlog) {
         if (item.getReference().equals(ref)) {
            return item;
         }
         BacklogItem task = item.findTaskByReference(ref);
         if(task != null) {
            return task;
         }
      }
      return null;
   }

   @Override
   public boolean equals(Object obj) {
      return equalityStrategy.entityEquals(obj);
   }

   @Override
   public int hashCode() {
      return equalityStrategy.entityHashCode(super.hashCode());
   }

   @Override
   public String toString() {
      return new ReflectionToStringBuilder(this).toString();
   }

   public String getBacklogAsCSV() {
      StringBuilder result = new StringBuilder();
      for(BacklogItem item : backlog) {
         result.append(item.toCSV());
         result.append("\n");
      }
      return result.toString();
   }

}
