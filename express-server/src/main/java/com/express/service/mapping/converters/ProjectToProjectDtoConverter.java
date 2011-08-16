package com.express.service.mapping.converters;

import com.express.domain.Project;
import com.express.service.dto.ProjectDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.stereotype.Component;

import java.util.Collections;

@Component
public class ProjectToProjectDtoConverter extends AbstractObjectConverter<Project, ProjectDto> {
   @Override
   public void convert(Project project, ProjectDto projectDto) {
      super.convert(project, projectDto);
      Collections.sort(projectDto.getProductBacklog());
      Collections.sort(projectDto.getIterations());
      Collections.sort(projectDto.getHistory());
   }
}
