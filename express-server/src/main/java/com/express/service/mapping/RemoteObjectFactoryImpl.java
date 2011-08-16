package com.express.service.mapping;

import com.express.dao.ProjectDao;
import com.express.domain.AccessRequest;
import com.express.domain.BacklogItem;
import com.express.domain.Iteration;
import com.express.domain.Project;
import com.express.domain.Theme;
import com.express.domain.User;
import com.express.service.dto.AccessRequestDto;
import com.express.service.dto.BacklogItemDto;
import com.express.service.dto.IterationDto;
import com.express.service.dto.ProjectDto;
import com.express.service.dto.ThemeDto;
import com.express.service.dto.UserDto;
import com.googlecode.simpleobjectassembler.ObjectAssembler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service("remoteObjectFactory")
public class RemoteObjectFactoryImpl implements RemoteObjectFactory {

   private final ObjectAssembler objectAssembler;
   private final ProjectDao projectDao;

   @Autowired
   public RemoteObjectFactoryImpl(@Qualifier("projectDao") ProjectDao projectDao,
                                  @Qualifier("objectAssembler") ObjectAssembler objectAssembler) {
      this.projectDao = projectDao;
      this.objectAssembler = objectAssembler;
   }

   public UserDto createUserDto(User user) {
      UserDto userDto = objectAssembler.assemble(user, UserDto.class);
      List<Project> projects = projectDao.findAll(user);
      userDto.setHasProjects(projects.size() > 0);
      return userDto;
   }

   public ProjectDto createProjectDtoShallow(Project project) {
      return objectAssembler.assemble(project, ProjectDto.class, "accessRequests", "history", "iterations",
            "productBacklog", "projectWorkers", "themes");
   }

   public ProjectDto createProjectDtoDeep(Project project) {
      ProjectDto projectDto = objectAssembler.assemble(project, ProjectDto.class);
      Set<String> actors = new HashSet<String>();
      appendActors(actors, project.getProductBacklog());
      for (Iteration iteration : project.getIterations()) {
         appendActors(actors, iteration.getBacklog());
      }
      projectDto.setActors(new ArrayList<String>(actors));

      return projectDto;
   }

   public IterationDto createIterationDto(Iteration iteration) {
      return objectAssembler.assemble(iteration, IterationDto.class, "project.accessRequests", "project.history",
            "project.iterations", "project.productBacklog", "project.projectWorkers", "project.themes");
   }

   public BacklogItemDto createBacklogItemDto(BacklogItem backlogItem) {
      return objectAssembler.assemble(backlogItem, BacklogItemDto.class);
   }

   public ThemeDto createThemeDto(Theme theme) {
      return objectAssembler.assemble(theme, ThemeDto.class);
   }

   public AccessRequestDto createAccessRequestDto(AccessRequest request) {
      return objectAssembler.assemble(request, AccessRequestDto.class);
   }

   private void appendActors(Set<String> actors, Set<BacklogItem> items) {
      for (BacklogItem item : items) {
         actors.add(item.getAsA());
      }
   }
}
