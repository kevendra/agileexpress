package com.express.service;

import com.express.dao.AccessRequestDao;
import com.express.dao.IterationDao;
import com.express.dao.ProjectDao;
import com.express.dao.UserDao;
import com.express.domain.AccessRequest;
import com.express.domain.BacklogItem;
import com.express.domain.Issue;
import com.express.domain.Iteration;
import com.express.domain.Project;
import com.express.domain.ProjectWorker;
import com.express.domain.Theme;
import com.express.domain.User;
import com.express.service.dto.AccessRequestDto;
import com.express.service.dto.BacklogItemDto;
import com.express.service.dto.CSVRequest;
import com.express.service.dto.IssueDto;
import com.express.service.dto.LoadBacklogRequest;
import com.express.service.dto.ProjectDto;
import com.express.service.dto.ProjectWorkerDto;
import com.express.service.dto.ProjectWorkersUpdateRequest;
import com.express.service.dto.ThemeDto;
import com.express.service.dto.ThemesUpdateRequest;
import com.express.service.internal.UserService;
import com.express.service.mapping.DomainFactory;
import com.express.service.mapping.RemoteObjectFactory;
import com.express.service.notification.NotificationService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class ProjectManagerImplTest {

   static final Long ID = 1l;
   @Mock
   private ProjectDao projectDao;
   @Mock
   private IterationDao iterationDao;
   @Mock
   private UserDao userDao;
   @Mock
   private UserService userService;
   @Mock
   private DomainFactory domainFactory;
   @Mock
   private RemoteObjectFactory remoteObjectFactory;
   @Mock
   NotificationService notificationService;
   @Mock
   AccessRequestDao accessRequestDao;
   
   private ProjectManager projectManager;

   @Before
   public void setUp() {
      MockitoAnnotations.initMocks(this);
      projectManager = new ProjectManagerImpl(userService,
                                              projectDao,
                                              remoteObjectFactory,
                                              domainFactory,
                                              iterationDao,
                                              userDao,
                                              accessRequestDao,
                                              notificationService);
   }

   private void intializeSecureContext() {
      User user = new User();
      user.setId(ID);
      Authentication auth = new UsernamePasswordAuthenticationToken(user, "xxx");
      SecurityContextHolder.getContext().setAuthentication(auth);
   }
   
   @Test
   public void shouldCreateProjectFromDto() {
      ProjectDto dto = new ProjectDto();
      Project domain = new Project();
      given(domainFactory.createProject(dto)).willReturn(domain);
      projectDao.save(domain);
      given(remoteObjectFactory.createProjectDtoDeep(domain)).willReturn(dto);
      projectManager.updateProject(dto);
   }
 
   @Test
   public void shouldCreateEffortRecordsForOpenIterations() {
      Project project = new Project();
      List<Iteration> iterations = new ArrayList<Iteration>();
      Iteration iteration = new Iteration();
      iteration.setProject(project);
      iterations.add(iteration);
      iteration = new Iteration();
      iteration.setProject(project);
      iterations.add(iteration);
      given(iterationDao.findOpenIterations()).willReturn(iterations);
      projectDao.save(project);
      projectDao.save(project);
      
      projectManager.createHistoryRecords();
   }

   @Test
   public void shouldFindAllProjectsForLoggedInUser() {
      this.intializeSecureContext();
      Project project = new Project();
      List<Project> projects = new ArrayList<Project>();
      projects.add(project);
      User user = new User();
      user.setId(ID);
      given(userService.getAuthenticatedUser()).willReturn(user);
      given(projectDao.findAll(user)).willReturn(projects);
      given(remoteObjectFactory.createProjectDtoShallow(project)).willReturn(new ProjectDto());
      
      List<ProjectDto> dtos = projectManager.findAllProjects();
      assertEquals(projects.size(), dtos.size());
   }

   @Test
   public void shouldFindProjectById() {
      Project project = new Project();
      given(projectDao.findById(ID)).willReturn(project);
      given(remoteObjectFactory.createProjectDtoDeep(project)).willReturn(new ProjectDto());
      
      projectManager.findProject(ID);
   }
   
  

   @Test
   public void shouldUpdateThemes() {
      Long projectId = 1l;
      Project project = new Project();
      ThemesUpdateRequest request = new ThemesUpdateRequest();
      ThemeDto dto = new ThemeDto();
      request.getThemes().add(dto);
      request.setProjectId(projectId);
      given(projectDao.findById(projectId)).willReturn(project);
      given(domainFactory.createTheme(dto)).willReturn(new Theme());
      projectDao.save(project);
      
      projectManager.updateThemes(request);
   }

   @Test
   public void shouldLoadThemes() {
      Long projectId = 1l;
      Theme theme = new Theme();
      Project project = new Project();
      project.addTheme(theme);
      given(projectDao.findById(projectId)).willReturn(project);
      given(remoteObjectFactory.createThemeDto(theme)).willReturn(new ThemeDto());
      assertEquals(1, projectManager.loadThemes(projectId).size());
   }

   @Test
   public void shouldLoadProductBacklog() {
      Long projectId = 1l;
      Project project = new Project();
      BacklogItem item = new BacklogItem();
      project.addBacklogItem(item, true);
      LoadBacklogRequest request = new LoadBacklogRequest();
      request.setType(LoadBacklogRequest.TYPE_PROJECT);
      request.setParentId(projectId);
      given(projectDao.findById(projectId)).willReturn(project);
      given(remoteObjectFactory.createBacklogItemDto(item)).willReturn(new BacklogItemDto());
      assertEquals(1, projectManager.loadBacklog(request).size());
   }

   @Test
   public void shouldLoadIterationBacklog() {
      Long iterationId = 1l;
      Project project = new Project();
      Iteration iteration = new Iteration();
      project.addIteration(iteration);
      BacklogItem item = new BacklogItem();
      iteration.addBacklogItem(item, true);
      LoadBacklogRequest request = new LoadBacklogRequest();
      request.setType(LoadBacklogRequest.TYPE_ITERATION);
      request.setParentId(iterationId);
      given(iterationDao.findById(iterationId)).willReturn(iteration);
      given(remoteObjectFactory.createBacklogItemDto(item)).willReturn(new BacklogItemDto());
      assertEquals(1, projectManager.loadBacklog(request).size());
   }

   @Test
   public void shouldUpdateProjectWorkers() {
      ProjectWorkersUpdateRequest request = new ProjectWorkersUpdateRequest();
      Project project = new Project();
      request.setProjectId(1l);
      List<ProjectWorkerDto> workers = new ArrayList<ProjectWorkerDto>();
      ProjectWorkerDto worker = new ProjectWorkerDto();
      workers.add(worker);
      request.setWorkers(workers);
      given(projectDao.findById(request.getProjectId())).willReturn(project);
      given(domainFactory.createProjectWorker(worker)).willReturn(new ProjectWorker());
      projectDao.save(project);
      projectManager.updateProjectWorkers(request);
      assertEquals(1, project.getProjectWorkers().size());
   }

   @Test
   public void shouldLoadAccessRequests() {
      Long projectId = 1l;
      Project project = new Project();
      AccessRequest accessRequest = new AccessRequest();
      project.addAccessRequest(accessRequest);
      given(projectDao.findById(projectId)).willReturn(project);
      given(remoteObjectFactory.createAccessRequestDto(accessRequest)).willReturn(new AccessRequestDto());
      assertEquals(1, projectManager.loadAccessRequests(projectId).size());
   }

   @Test
   public void csvRequestShouldSwitchOnIterationType() {
      CSVRequest request = new CSVRequest();
      Long id = 1l;
      request.setId(id);
      request.setType(CSVRequest.TYPE_ITERATION_BACKLOG);
      given(iterationDao.findById(id)).willReturn(new Iteration());
      projectManager.getCSV(request);
   }

   @Test
   public void csvRequestShouldSwitchProductOnType() {
      CSVRequest request = new CSVRequest();
      Long id = 1l;
      request.setId(id);
      request.setType(CSVRequest.TYPE_PRODUCT_BACKLOG);
      given(projectDao.findById(id)).willReturn(new Project());
      projectManager.getCSV(request);
   }

   @Test
   public void shouldUpdateImpediment() {
      IssueDto issueDto = new IssueDto();
      Issue issue = mock(Issue.class);
      Iteration iteration = mock(Iteration.class);
      when(issue.getIteration()).thenReturn(iteration);
      Project project = mock(Project.class);
      when(iteration.getProject()).thenReturn(project);
      when(domainFactory.createIssue(issueDto)).thenReturn(issue);
      projectManager.updateImpediment(issueDto);
      verify(domainFactory).createIssue(issueDto);
      verify(projectDao).save(project);
   }
}
