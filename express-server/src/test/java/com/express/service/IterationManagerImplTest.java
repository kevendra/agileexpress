package com.express.service;

import com.express.dao.IterationDao;
import com.express.dao.ProjectDao;
import com.express.domain.Iteration;
import com.express.domain.Project;
import com.express.service.dto.IterationDto;
import com.express.service.dto.ProjectDto;
import com.express.service.mapping.DomainFactory;
import com.express.service.mapping.RemoteObjectFactory;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.mockito.BDDMockito.given;

/**
 *
 */
public class IterationManagerImplTest {

   IterationManager iterationManager;

   @Mock
   private DomainFactory domainFactory;
   @Mock
   private RemoteObjectFactory remoteObjectFactory;
   @Mock
   private ProjectDao projectDao;
   @Mock
   private IterationDao iterationDao;

   @Before
   public void setUp() {
      MockitoAnnotations.initMocks(this);
      iterationManager = new IterationManagerImpl(projectDao,remoteObjectFactory, domainFactory,
            iterationDao);
   }

   @Test
   public void shouldCreateIterationFromDto() {
      String title = "test title";
      ProjectDto projectDto = new ProjectDto();
      Long projectId = 1l;
      projectDto.setId(projectId);
      Project project = new Project();
      IterationDto dto = new IterationDto();
      dto.setTitle(title);
      dto.setProject(projectDto);
      Iteration domain = new Iteration();
      domain.setTitle(title);
      given(domainFactory.createIteration(dto)).willReturn(domain);
      given(projectDao.findById(projectId)).willReturn(project);
      projectDao.save(project);
      given(remoteObjectFactory.createIterationDto(domain)).willReturn(dto);
      iterationManager.createIteration(dto);
   }

   @Test
   public void shouldFindExistingIterationById() {
      Iteration iteration = new Iteration();
      given(iterationDao.findById(1l)).willReturn(iteration);
      given(remoteObjectFactory.createIterationDto(iteration)).willReturn(new IterationDto());
      iterationManager.findIteration(1l);
   }

   @Test
   public void shouldUpdateExistingIteration() {
      IterationDto iterationDto = new IterationDto();
      Iteration iteration = new Iteration();
      Project project = new Project();
      project.addIteration(iteration);
      given(domainFactory.createIteration(iterationDto)).willReturn(iteration);
      projectDao.save(project);
      iterationManager.updateIteration(iterationDto);
   }
}
