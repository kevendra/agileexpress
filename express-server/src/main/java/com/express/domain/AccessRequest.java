package com.express.domain;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;

import javax.persistence.*;
import java.util.Calendar;

/**
 * An AccessRequest models a user's request to join a Project. It effectively has 2 statuses. If it is approved
 * then the request is removed and a ProjectWorker recod is written. If it is rejected, however, we keep it to
 * stop Users making multiple requests to access a project.
 */
@Entity
@Table(name = "access_request")
public class AccessRequest implements Persistable, Comparable<AccessRequest> {
   private static final long serialVersionUID = 5229139735357304608L;

   public static final Integer UNRESOLVED = 0;
   public static final Integer APPROVED = 1;
   public static final Integer REJECTED = 2;

   @Transient
   private PersistableEqualityStrategy equalityStrategy = new PersistableEqualityStrategy(this);

   @Id
   @GeneratedValue(strategy = GenerationType.TABLE, generator = "gen_request")
   @TableGenerator(name = "gen_request", table = "sequence_list", pkColumnName = "name",
            valueColumnName = "next_value", allocationSize = 1, initialValue = 100,
            pkColumnValue = "backlog")
   @Column(name="request_id")
   private Long id;

   @Version @Column(name="version_no")
   private Long version;

   @ManyToOne @JoinColumn(name = "user_id")
   private User requestor;

   @Column(name = "request_date")
   @Temporal(value = TemporalType.TIMESTAMP)
   private Calendar requestDate;

   @Column(name = "resolved_date")
   @Temporal(value = TemporalType.TIMESTAMP)
   private Calendar resolvedDate;

   @Column(name = "status")
   private Integer status;

   @Column(name = "reason")
   private String reason;

   @ManyToOne @JoinColumn(name = "project_id")
   private Project project;

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

   public User getRequestor() {
      return requestor;
   }

   public void setRequestor(User requestor) {
      this.requestor = requestor;
   }

   public Calendar getRequestDate() {
      return requestDate;
   }

   public void setRequestDate(Calendar requestDate) {
      this.requestDate = requestDate;
   }

   public Calendar getResolvedDate() {
      return resolvedDate;
   }

   public void setResolvedDate(Calendar resolvedDate) {
      this.resolvedDate = resolvedDate;
   }

   public Integer getStatus() {
      return status;
   }

   public void setStatus(Integer status) {
      this.status = status;
   }

   public String getReason() {
      return reason;
   }

   public void setReason(String reason) {
      this.reason = reason;
   }

   public Project getProject() {
      return project;
   }

   public void setProject(Project project) {
      this.project = project;
   }

   public int compareTo(AccessRequest accessRequest) {
      return this.requestDate.compareTo(accessRequest.getRequestDate());
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
