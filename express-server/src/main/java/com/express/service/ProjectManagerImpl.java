package com.express.service;

import com.express.dao.*;
import com.express.domain.*;
import com.express.service.dto.*;
import com.express.service.internal.UserService;
import com.express.service.mapping.DomainFactory;
import com.express.service.mapping.RemoteObjectFactory;
import com.express.service.notification.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.remoting.RemoteAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service("projectManager")
@Transactional(readOnly = true)
public class ProjectManagerImpl implements ProjectManager {

   private final ProjectDao projectDao;

   private final UserService userService;

   private final IterationDao iterationDao;

   private final UserDao userDao;

   private final AccessRequestDao accessRequestDao;

   private final DomainFactory domainFactory;

   private final RemoteObjectFactory remoteObjectFactory;

   private final NotificationService notificationService;

   @Autowired
   public ProjectManagerImpl(@Qualifier("internalUserService") UserService userService,
                             @Qualifier("projectDao") ProjectDao projectDao,
                             @Qualifier("remoteObjectFactory") RemoteObjectFactory remoteObjectFactory,
                             @Qualifier("domainFactory") DomainFactory domainFactory,
                             @Qualifier("iterationDao") IterationDao iterationDao,
                             @Qualifier("userDao") UserDao userDao,
                             @Qualifier("accessRequestDao") AccessRequestDao accessRequestDao,
                             @Qualifier("notificationService") NotificationService notificationService) {
      this.projectDao = projectDao;
      this.userService = userService;
      this.remoteObjectFactory = remoteObjectFactory;
      this.domainFactory = domainFactory;
      this.iterationDao = iterationDao;
      this.userDao = userDao;
      this.accessRequestDao = accessRequestDao;
      this.notificationService = notificationService;
   }


   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public ProjectDto updateProject(ProjectDto projectDto) {
      Project project = domainFactory.createProject(projectDto);
      //TODO: sort this out based on new mapping strategy
//      Project project = domainFactory.createProject(projectDto, Policy.SHALLOW);
      projectDao.save(project);
      return remoteObjectFactory.createProjectDtoDeep(project);
   }


   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void updateImpediment(IssueDto issueDto) {
      Issue issue = domainFactory.createIssue(issueDto);
      projectDao.save(issue.getIteration().getProject());
   }

   public List<ProjectDto> findAllProjects() {
      List<Project> projects = projectDao.findAll(userService.getAuthenticatedUser());
      List<ProjectDto> dtos = new ArrayList<ProjectDto>();
      for (Project project : projects) {
         dtos.add(remoteObjectFactory.createProjectDtoShallow(project));
      }
      return dtos;
   }

   public ProjectAccessData findAccessRequestData() {
      User user = userService.getAuthenticatedUser();
      ProjectAccessData data = new ProjectAccessData();
      addPendingAccessRequests(data, user);
      addAvailableAccessRequests(user, data);
      addGrantedAccessRequests(user, data);
      return data;
   }

   public ProjectDto findProject(Long id) {
      Project project = projectDao.findById(id);
      return remoteObjectFactory.createProjectDtoDeep(project);
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void projectAccessRequest(ProjectAccessRequest request) {
      User user = userService.getAuthenticatedUser();
      if (request.getNewProject() != null) {
         Project project = domainFactory.createProject(request.getNewProject());
         //TODO: sort this out base on new mapping strategy
//         Project project = domainFactory.createProject(request.getNewProject(), Policy.DEEP);
         setProjectAdmin(project, user);
         projectDao.save(project);
         return;
      }
      for (ProjectDto projectDto : request.getExistingProjects()) {
         Project project = projectDao.findById(projectDto.getId());
         addAccessRequest(project, user);
         projectDao.save(project);
      }
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void projectAccessResponse(Long id, Boolean response) {
      AccessRequest request = accessRequestDao.findById(id);
      if (!request.getProject().isManager(userService.getAuthenticatedUser())) {
         throw new RemoteAccessException("You are not authorized to approve requests");
      }
      User requestor = request.getRequestor();
      Project project = request.getProject();
      if (response) {
         ProjectWorker worker = new ProjectWorker();
         worker.setWorker(requestor);
         project.addProjectWorker(worker);
         notificationService.sendProjectAccessAccept(request);
      }
      else {
         notificationService.sendProjectAccessReject(request);
      }
      requestor.removeAccessRequest(request);
      project.removeAccessRequest(request);
      projectDao.save(project);
      userDao.save(requestor);
   }

   public List<BacklogItemDto> loadBacklog(LoadBacklogRequest request) {
      List<BacklogItemDto> backlogDtos = new ArrayList<BacklogItemDto>();
      Set<BacklogItem> backlog;
      if (LoadBacklogRequest.TYPE_ITERATION.equals(request.getType())) {
         Iteration iteration = iterationDao.findById(request.getParentId());
         backlog = iteration.getBacklog();
      }
      else {
         Project project = projectDao.findById(request.getParentId());
         backlog = project.getProductBacklog();
      }
      for (BacklogItem item : backlog) {
         backlogDtos.add(remoteObjectFactory.createBacklogItemDto(item));
      }
      Collections.sort(backlogDtos);
      return backlogDtos;
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void createHistoryRecords() {
      List<Iteration> iterations = iterationDao.findOpenIterations();
      for (Iteration iteration : iterations) {
         int completedPoints = iteration.getStoryPointsCompleted();
         DailyIterationStatusRecord record = new DailyIterationStatusRecord(Calendar.getInstance(),
               iteration.getTaskEffortRemaining(),
               iteration.getStoryPoints(),
               completedPoints,
               iteration);
         iteration.setFinalVelocity(completedPoints);
         iteration.addHistoryRecord(record);
         projectDao.save(iteration.getProject());
      }
      List<Project> projects = projectDao.findAll();
      for (Project project : projects) {
         DailyProjectStatusRecord record = new DailyProjectStatusRecord(Calendar.getInstance(),
               project.getStoryPoints(),
               project.getStoryPointsCompleted(),
               project);
         project.addHistoryRecord(record);
         projectDao.save(project);
      }
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void updateThemes(ThemesUpdateRequest request) {
      Project project = projectDao.findById(request.getProjectId());
      project.clearThemes();
      for (ThemeDto themeDto : request.getThemes()) {
         project.addTheme(domainFactory.createTheme(themeDto));
      }
      projectDao.save(project);
   }

   public List<ThemeDto> loadThemes(Long projectId) {
      Project project = projectDao.findById(projectId);
      List<ThemeDto> themeDtos = new ArrayList<ThemeDto>();
      for (Theme theme : project.getThemes()) {
         themeDtos.add(remoteObjectFactory.createThemeDto(theme));
      }
      Collections.sort(themeDtos);
      return themeDtos;
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void updateProjectWorkers(ProjectWorkersUpdateRequest request) {
      Project project = projectDao.findById(request.getProjectId());
      project.getProjectWorkers().clear();
      for (ProjectWorkerDto workerDto : request.getWorkers()) {
         project.addProjectWorker(domainFactory.createProjectWorker(workerDto));
      }
      projectDao.save(project);
   }

   public String getCSV(CSVRequest request) {
      if (CSVRequest.TYPE_ITERATION_BACKLOG == request.getType()) {
         return iterationDao.findById(request.getId()).getBacklogAsCSV();
      }
      else {
         return projectDao.findById(request.getId()).getProductBacklogAsCSV();
      }
   }

   public List<AccessRequestDto> loadAccessRequests(Long projectId) {
      Project project = projectDao.findById(projectId);
      List<AccessRequestDto> requests = new ArrayList<AccessRequestDto>();
      for (AccessRequest request : project.getAccessRequests()) {
         requests.add(remoteObjectFactory.createAccessRequestDto(request));
      }
      return requests;
   }

   private void setProjectAdmin(Project project, User user) {
      ProjectWorker worker = new ProjectWorker();
      worker.setWorker(user);
      worker.getPermissions().setProjectAdmin(Boolean.TRUE);
      worker.getPermissions().setIterationAdmin(Boolean.TRUE);
      project.addProjectWorker(worker);
   }

   private void addAccessRequest(Project project, User user) {
      AccessRequest newRequest = new AccessRequest();
      newRequest.setRequestDate(Calendar.getInstance());
      newRequest.setStatus(AccessRequest.UNRESOLVED);
      user.addAccessRequest(newRequest);
      project.addAccessRequest(newRequest);
      for (User manager : project.getProjectManagers()) {
         notificationService.sendProjectAccessRequestNotification(newRequest, manager);
      }
   }

   private void addGrantedAccessRequests(User user, ProjectAccessData data) {
      List<ProjectDto> granted = new ArrayList<ProjectDto>();
      for (Project project : projectDao.findAll(user)) {
         granted.add(remoteObjectFactory.createProjectDtoShallow(project));
      }
      data.setGrantedList(granted);
   }

   private void addAvailableAccessRequests(User user, ProjectAccessData data) {
      List<ProjectDto> available = new ArrayList<ProjectDto>();
      for (Project project : projectDao.findAvailable(user)) {
         if (!user.hasPendingRequest(project)) {
            available.add(remoteObjectFactory.createProjectDtoShallow(project));
         }
      }
      data.setAvailableList(available);
   }

   private void addPendingAccessRequests(ProjectAccessData data, User user) {
      List<ProjectDto> pending = new ArrayList<ProjectDto>();
      for (AccessRequest request : user.getAccessRequests()) {
         pending.add(remoteObjectFactory.createProjectDtoShallow(request.getProject()));
      }
      data.setPendingList(pending);
   }
}
