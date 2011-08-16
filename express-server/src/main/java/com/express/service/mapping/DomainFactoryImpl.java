package com.express.service.mapping;

import com.express.dao.BacklogItemDao;
import com.express.dao.IssueDao;
import com.express.dao.IterationDao;
import com.express.dao.ProjectDao;
import com.express.dao.ProjectWorkerDao;
import com.express.dao.ThemeDao;
import com.express.dao.UserDao;
import com.express.domain.BacklogItem;
import com.express.domain.Issue;
import com.express.domain.Iteration;
import com.express.domain.Project;
import com.express.domain.ProjectWorker;
import com.express.domain.Theme;
import com.express.domain.User;
import com.express.service.dto.BacklogItemDto;
import com.express.service.dto.IssueDto;
import com.express.service.dto.IterationDto;
import com.express.service.dto.ProjectDto;
import com.express.service.dto.ProjectWorkerDto;
import com.express.service.dto.ThemeDto;
import com.express.service.dto.UserDto;
import com.googlecode.simpleobjectassembler.ObjectAssembler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.Calendar;

@Service("domainFactory")
public class DomainFactoryImpl implements DomainFactory {
   private final ObjectAssembler objectAssembler;

   private final UserDao userDao;
   private final ProjectDao projectDao;
   private final IterationDao iterationDao;
   private final BacklogItemDao backlogItemDao;
   private final ThemeDao themeDao;
   private final IssueDao issueDao;
   private final ProjectWorkerDao projectWorkerDao;

   @Autowired
   public DomainFactoryImpl(@Qualifier("userDao") UserDao userDao,
                            @Qualifier("projectDao") ProjectDao projectDao,
                            @Qualifier("iterationDao") IterationDao iterationDao,
                            @Qualifier("backlogItemDao") BacklogItemDao backlogItemDao,
                            @Qualifier("themeDao") ThemeDao themeDao,
                            @Qualifier("issueDao") IssueDao issueDao,
                            @Qualifier("projectWorkerDao") ProjectWorkerDao projectWorkerDao,
                            ObjectAssembler objectAssembler) {
      this.userDao = userDao;
      this.projectDao = projectDao;
      this.iterationDao = iterationDao;
      this.backlogItemDao = backlogItemDao;
      this.themeDao = themeDao;
      this.issueDao = issueDao;
      this.projectWorkerDao = projectWorkerDao;
      this.objectAssembler = objectAssembler;
   }

   public User createUser(UserDto dto) {
      User user = objectAssembler.assemble(dto, User.class);
      if(user.getId() == null) {
         user.setCreatedDate(Calendar.getInstance());
      }
      return user;
   }

   public Project createProject(ProjectDto dto) {
      Project project = objectAssembler.assemble(dto, Project.class, "accessRequests", "iterations", "history",
            "productBacklog", "projectWorkers", "themes");
      return project;
   }

   public Iteration createIteration(IterationDto dto) {
      Iteration iteration = objectAssembler.assemble(dto, Iteration.class, "backlog", "history", "impediments",
            "project");
      return iteration;
   }

   public BacklogItem createBacklogItem(BacklogItemDto dto) {
      return objectAssembler.assemble(dto, BacklogItem.class, "acceptanceCriteria", "assignedTo.accessRequests",
            "assignedTo.colour", "assignedTo.email", "assignedTo.firstName", "assignedTo.lastName",
            "assignedTo.password", "assignedTo.passwordHint", "assignedTo.phone1", "assignedTo.phone2",
            "assignedTo.version", "impediment", "iteration", "parent", "project", "tasks", "themes");
   }

   public Theme createTheme(ThemeDto dto) {
      return objectAssembler.assemble(dto, Theme.class, "project");
   }

   public ProjectWorker createProjectWorker(ProjectWorkerDto dto) {
      return objectAssembler.assemble(dto, ProjectWorker.class, "permissions", "worker.accessRequests",
            "worker.colour", "worker.email", "worker.firstName",
            "worker.lastName", "worker.password", "worker.passwordHint", "worker.phone1",
            "worker.phone2", "worker.version");
   }

   public Issue createIssue(IssueDto dto) {
      return objectAssembler.assemble(dto, Issue.class, "backlogItem", "iteration", "responsible.accessRequests",
            "responsible.colour", "responsible.email", "responsible.firstName",
            "responsible.lastName", "responsible.password", "responsible.passwordHint", "responsible.phone1",
            "responsible.phone2", "responsible.version");
   }
}
