package com.express.service.dto;

import com.googlecode.simpleobjectassembler.annotation.EntityDto;

import java.io.Serializable;

@EntityDto(id = "id")
public class ThemeDto implements Serializable, Comparable<ThemeDto> {
   private static final long serialVersionUID = 1961279296068639742L;

   private long id;
   private Long version;
   private String title;
   private String description;
   private ProjectDto project;

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

   public ProjectDto getProject() {
      return project;
   }

   public void setProject(ProjectDto project) {
      this.project = project;
   }

   public int compareTo(ThemeDto themeDto) {
      return this.title.compareTo(themeDto.getTitle());
   }
}
