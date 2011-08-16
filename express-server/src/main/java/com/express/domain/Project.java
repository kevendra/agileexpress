package com.express.domain;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.OptimisticLock;

import javax.persistence.*;
import java.util.*;

/**
 * Project is the core container in the Express system. The product backlog is assigned to the
 * Project and then assigned to it's Iterations when ready to be worked on.
 *
 * @author adam boas
 */
@Entity
@Table(name = "project")
@NamedQueries({
      @NamedQuery(name = "Project.findAll", query = "SELECT P FROM Project P"),
      @NamedQuery(name = "Project.findNotWorkingOn",
            query = "SELECT DISTINCT P FROM Project P WHERE P NOT IN(SELECT P FROM Project P JOIN P.projectWorkers PW WHERE PW.worker = ?1)"),
      @NamedQuery(name = "Project.findWorkingOn", query = "SELECT P FROM Project P JOIN P.projectWorkers PW WHERE PW.worker = ?1")})

public class Project implements Persistable, BacklogContainer {
   private static final long serialVersionUID = 5917736851219902630L;

   public static final String QUERY_FIND_ALL = "Project.findAll";
   public static final String QUERY_FIND_WORKING_ON = "Project.findWorkingOn";
   public static final String QUERY_FIND_NOT_WORKING_ON = "Project.findNotWorkingOn";

   @Transient
   private PersistableEqualityStrategy equalityStrategy = new PersistableEqualityStrategy(this);

   @Id
   @GeneratedValue(strategy = GenerationType.TABLE, generator = "gen_project")
   @TableGenerator(name = "gen_project", table = "sequence_list", pkColumnName = "name",
         valueColumnName = "next_value", allocationSize = 1, initialValue = 100,
         pkColumnValue = "project")
   @Column(name = "project_id")
   private Long id;

   @Version
   @Column(name = "version_no")
   private Long version;

   @Column(name = "start_date")
   @Temporal(value = TemporalType.TIMESTAMP)
   private Calendar startDate;

   @Column(name = "title")
   private String title;

   @Column(name = "description") @Lob
   private String description;

   @Column(name = "reference")
   private String reference;

   @Column(name = "effort_unit")
   private String effortUnit;

   @Column(name = "story_count")
   private Integer storyCount = 0;

   @Enumerated(EnumType.ORDINAL)
   @Column(name = "methodology")
   private Methodology methodology;

   @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
   @Cascade(org.hibernate.annotations.CascadeType.DELETE_ORPHAN)
   @OptimisticLock(excluded = true)
   private Set<ProjectWorker> projectWorkers;

   @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
   @OptimisticLock(excluded = true)
   private Set<Iteration> iterations;

   @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
   @OptimisticLock(excluded = true)
   private Set<BacklogItem> productBacklog;

   @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
   @OptimisticLock(excluded = true)
   private Set<DailyProjectStatusRecord> history;

   @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
   @Cascade(org.hibernate.annotations.CascadeType.DELETE_ORPHAN)
   @OptimisticLock(excluded = true)
   private Set<AccessRequest> accessRequests;

   @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
   @Cascade(org.hibernate.annotations.CascadeType.DELETE_ORPHAN)
   private Set<Theme> themes;

   public Project() {
      projectWorkers = new HashSet<ProjectWorker>();
      iterations = new HashSet<Iteration>();
      productBacklog = new HashSet<BacklogItem>();
      accessRequests = new HashSet<AccessRequest>();
      themes = new HashSet<Theme>();
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

   public String getReference() {
      return reference;
   }

   public void setReference(String reference) {
      this.reference = reference;
   }

   public String getEffortUnit() {
      return effortUnit;
   }

   public void setEffortUnit(String effortUnit) {
      this.effortUnit = effortUnit;
   }

   public Set<DailyProjectStatusRecord> getHistory() {
      return history;
   }

   public void setHistory(Set<DailyProjectStatusRecord> history) {
      this.history = history;
   }

   public void addHistoryRecord(DailyProjectStatusRecord record) {
      this.history.add(record);
   }

   public Integer getStoryCount() {
      //For versions before 0.7.3 storyCount will not have been maintained
      if(storyCount == 1 && (productBacklog.size() > 1 || iterationsHaveStories())) {
         storyCount = getTotalStoryCount() + 10;
      }
      return storyCount;
   }

   public Methodology getMethodology() {
      return methodology;
   }

   public void setMethodology(Methodology methodology) {
      this.methodology = methodology;
   }

   private boolean iterationsHaveStories() {
      for(Iteration iteration : iterations) {
         if(iteration.getBacklog().size() > 1) {
            return true;
         }
      }
      return false;
   }

   public void incrementStoryCount() {
      storyCount++;
   }

   public Set<ProjectWorker> getProjectWorkers() {
      return projectWorkers;
   }

   public void setProjectWorkers(Set<ProjectWorker> projectWorkers) {
      this.projectWorkers = projectWorkers;
   }

   public void addProjectWorker(ProjectWorker projectWorker) {
      projectWorker.setProject(this);
      this.projectWorkers.add(projectWorker);
   }

   public void removeProjectWorker(ProjectWorker projectWorker) {
      projectWorker.setProject(null);
      this.projectWorkers.remove(projectWorker);
   }

   public List<User> getProjectManagers() {
      List<User> managers = new ArrayList<User>();
      for (ProjectWorker worker : projectWorkers) {
         if (worker.getPermissions().getProjectAdmin()) {
            managers.add(worker.getWorker());
         }
      }
      Collections.sort(managers);
      return managers;
   }

   public boolean isManager(User user) {
      for (ProjectWorker worker : projectWorkers) {
         if (worker.getWorker().equals(user)) {
            return true;
         }
      }
      return false;
   }

   public Set<Iteration> getIterations() {
      return iterations;
   }

   public void setIterations(Set<Iteration> iterations) {
      this.iterations = iterations;
   }

   public void addIteration(Iteration iteration) {
      this.iterations.add(iteration);
      iteration.setProject(this);
   }

   public void removeIteration(Iteration iteration) {
      this.iterations.remove(iteration);
      iteration.setProject(null);
   }

   public Set<BacklogItem> getBacklog() {
      return this.productBacklog;
   }

   public Set<BacklogItem> getProductBacklog() {
      return this.productBacklog;
   }

   public void setProductBacklog(Set<BacklogItem> productBacklog) {
      this.productBacklog = productBacklog;
   }

   public void addBacklogItem(BacklogItem backlogItem, boolean isNew) {
      this.productBacklog.add(backlogItem);
      backlogItem.setProject(this);
      backlogItem.setIteration(null);
      if (isNew) {
         this.storyCount++;
      }
   }

   public BacklogItem removeBacklogItem(BacklogItem backlogItem) {
      if (this.productBacklog.remove(backlogItem)) {
         backlogItem.setProject(null);
         return backlogItem;
      }
      return null;
   }

   public Set<AccessRequest> getAccessRequests() {
      return accessRequests;
   }

   public void setAccessRequests(Set<AccessRequest> accessRequests) {
      this.accessRequests = accessRequests;
   }

   public void addAccessRequest(AccessRequest accessRequest) {
      this.accessRequests.add(accessRequest);
      accessRequest.setProject(this);
   }

   public void removeAccessRequest(AccessRequest accessRequest) {
      this.accessRequests.remove(accessRequest);
      accessRequest.setProject(null);
   }

   public Set<Theme> getThemes() {
      return themes;
   }

   public void setThemes(Set<Theme> themes) {
      this.themes = themes;
   }

   public void addTheme(Theme theme) {
      this.themes.add(theme);
      theme.setProject(this);
   }

   public boolean removeTheme(Theme theme) {
      boolean result = this.themes.remove(theme);
      if (result) {
         theme.setProject(null);
      }
      return result;
   }

   public void clearThemes() {
      this.themes.clear();
   }

   private int getTotalStoryCount() {
      int total = 0;
      for (Iteration iteration : iterations) {
         total += iteration.getBacklog().size();
      }
      return total + productBacklog.size();
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

   public Iteration findIterationByTitle(String title) {
      for (Iteration iteration : iterations) {
         if (iteration.getTitle().equals(title)) {
            return iteration;
         }
      }
      return null;
   }

   public String getProductBacklogAsCSV() {
      StringBuilder result = new StringBuilder();
      for (BacklogItem item : productBacklog) {
         result.append(item.toCSV());
         result.append("\n");
      }
      return result.toString();
   }

   public int getStoryPointsCompleted() {
      int total = 0;
      for(BacklogItem item : productBacklog) {
         if(item.getStatus() == Status.DONE) {
            total += item.getEffort();
         }
      }
      for(Iteration iteration : iterations) {
         total += iteration.getStoryPointsCompleted();
      }
      return total;
   }

   public int getStoryPoints() {
      int points = getBacklogStoryPoints();
      return points + getIterationStoryPoints();
   }

   private int getBacklogStoryPoints() {
      int points = 0;
      for (BacklogItem item : productBacklog) {
         points += item.getEffort();
      }
      return points;
   }

   private int getIterationStoryPoints() {
      int points = 0;
      for(Iteration iteration : iterations) {
         points += iteration.getStoryPoints();
      }
      return points;
   }

}
