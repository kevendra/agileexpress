package com.express.domain;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;

import javax.persistence.*;
import java.util.Calendar;

/**
 * Models the link between a User and a Project.
 *
 * @author adam boas
 */
@Entity
@Table(name = "project_worker")
public class ProjectWorker implements Persistable, Comparable<ProjectWorker> {

   @Transient
   private PersistableEqualityStrategy equalityStrategy = new PersistableEqualityStrategy(this);

   @Id
   @GeneratedValue(strategy = GenerationType.TABLE, generator = "gen_worker")
   @TableGenerator(name = "gen_worker", table = "sequence_list", pkColumnName = "name",
            valueColumnName = "next_value", allocationSize = 1, initialValue = 100,
            pkColumnValue = "worker")
   @Column(name="worker_id")
   private Long id;

   @Version @Column(name="version_no")
   private Long version;

   @Column(name="created_date") @Temporal(value = TemporalType.TIMESTAMP)
   private Calendar createdDate;

   @ManyToOne @JoinColumn(name = "project_id")
   private Project project;

   @ManyToOne @JoinColumn(name = "user_id")
   private User worker;

   @OneToOne(cascade=CascadeType.ALL) @JoinColumn(name = "permissions_id")
   private Permissions permissions;

   public ProjectWorker() {
      this.permissions = new Permissions();
      this.createdDate = Calendar.getInstance();
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

   public Project getProject() {
      return project;
   }

   public void setProject(Project project) {
      this.project = project;
   }

   public User getWorker() {
      return worker;
   }

   public void setWorker(User worker) {
      this.worker = worker;
   }

   public Permissions getPermissions() {
      return permissions;
   }

   public void setPermissions(Permissions permissions) {
      this.permissions = permissions;
   }

   public Calendar getCreatedDate() {
      return createdDate;
   }

   public void setCreatedDate(Calendar createdDate) {
      this.createdDate = createdDate;
   }

   public int compareTo(ProjectWorker projectWorker) {
      return this.createdDate.compareTo(projectWorker.getCreatedDate());
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
}
