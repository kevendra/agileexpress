package com.express.service.mapping.converters;

import com.express.dao.ProjectDao;
import com.express.domain.Project;
import com.express.service.dto.ProjectDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ProjectDtoToProjectConverter extends AbstractObjectConverter<ProjectDto, Project> {

   private final ProjectDao projectDao;

   @Autowired
   public ProjectDtoToProjectConverter(ProjectDao projectDao) {
      this.projectDao = projectDao;
   }

   @Override
   public Project createDestinationObject(ProjectDto dto) {
      return dto.getId() == 0 ? new Project() : projectDao.findById(dto.getId());
   }

   @Override
   public void convert(ProjectDto projectDto, Project project) {
      super.convert(projectDto, project);
      if(project.getId() == 0) {
         project.setId(null);
         project.setVersion(null);
      }
   }
}
