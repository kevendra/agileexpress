package com.express.service.mapping.converters;

import com.express.dao.ProjectWorkerDao;
import com.express.domain.Permissions;
import com.express.domain.ProjectWorker;
import com.express.service.dto.ProjectWorkerDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ProjectWorkerDtoToProjectWorkerConverter extends AbstractObjectConverter<ProjectWorkerDto, ProjectWorker> {

   private final ProjectWorkerDao projectWorkerDao;

   @Autowired
   public ProjectWorkerDtoToProjectWorkerConverter(ProjectWorkerDao projectWorkerDao) {
      this.projectWorkerDao = projectWorkerDao;
   }

   @Override
   public ProjectWorker createDestinationObject(ProjectWorkerDto dto) {
      return dto.getId() == 0 ? new ProjectWorker() : projectWorkerDao.findById(dto.getId());
   }

   @Override
   public void convert(ProjectWorkerDto projectWorkerDto, ProjectWorker projectWorker) {
      super.convert(projectWorkerDto, projectWorker);
      if(projectWorker.getId() == 0) {
         projectWorker.setId(null);
         projectWorker.setVersion(null);
      }
      if(projectWorker.getPermissions() == null) {
         projectWorker.setPermissions(new Permissions());
      }
      projectWorker.getPermissions().setIterationAdmin(projectWorkerDto.getPermissions().getIterationAdmin());
      projectWorker.getPermissions().setProjectAdmin(projectWorkerDto.getPermissions().getProjectAdmin());
   }
}
