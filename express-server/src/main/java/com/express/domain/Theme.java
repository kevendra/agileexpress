package com.express.domain;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;

import javax.persistence.*;

/**
 * Models themes which backlog items share as a way of grouping them.
 */

@Entity
@Table(name = "theme")
public class Theme implements Persistable, Comparable<Theme> {

   @Transient
   private PersistableEqualityStrategy equalityStrategy = new PersistableEqualityStrategy(this);

   @Id
   @GeneratedValue(strategy = GenerationType.TABLE, generator = "gen_theme")
   @TableGenerator(name = "gen_theme", table = "sequence_list", pkColumnName = "name",
            valueColumnName = "next_value", allocationSize = 1, initialValue = 100,
            pkColumnValue = "theme")
   @Column(name="theme_id")
   private Long id;

   @Version @Column(name="version_no")
   private Long version;

   @Column(name = "title")
   private String title;

   @Column(name = "description")
   private String description;

   @ManyToOne()
   @JoinColumn(name = "project_id")
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

   public Project getProject() {
      return project;
   }

   public void setProject(Project project) {
      this.project = project;
   }

   public int compareTo(Theme theme) {
      return this.title.compareTo(theme.getTitle());
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
