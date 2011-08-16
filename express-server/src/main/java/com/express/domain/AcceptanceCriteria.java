package com.express.domain;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;

import javax.persistence.*;

/**
 * AcceptanceCriteria models one or more tests which must be passed in order for a Story to be
 * considered complete. A story can have many aceptanceCriteria.
 */
@Entity
@Table(name = "criteria")
public class AcceptanceCriteria implements Persistable {

   @Transient
   private PersistableEqualityStrategy equalityStrategy = new PersistableEqualityStrategy(this);

   @Id
   @GeneratedValue(strategy = GenerationType.TABLE, generator = "gen_criteria")
   @TableGenerator(name = "gen_criteria", table = "sequence_list", pkColumnName = "name",
            valueColumnName = "next_value", allocationSize = 1, initialValue = 100,
            pkColumnValue = "criteria")
   @Column(name="criteria_id")
   private Long id;

   @Version @Column(name="version_no")
   private Long version;

   @Column(name = "reference")
   private String reference;

   @Column(name = "title")
   private String title;

   @Column(name = "description")
   private String description;

   @Column(name = "verified")
   private boolean verified;

   @ManyToOne @JoinColumn( name = "backlog_id")
   private BacklogItem backlogItem;

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

   public String getReference() {
      return reference;
   }

   public void setReference(String reference) {
      this.reference = reference;
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

   public boolean isVerified() {
      return verified;
   }

   public void setVerified(boolean verified) {
      this.verified = verified;
   }

   public BacklogItem getBacklogItem() {
      return backlogItem;
   }

   public void setBacklogItem(BacklogItem backlogItem) {
      this.backlogItem = backlogItem;
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

   public String toCSV() {
      StringBuilder result = new StringBuilder();
      result.append(reference).append(",");
      result.append(title).append(",");
      result.append(description).append(",");
      result.append(verified);
      return result.toString();
   }
}
