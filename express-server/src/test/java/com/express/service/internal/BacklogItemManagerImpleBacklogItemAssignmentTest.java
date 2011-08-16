package com.express.service.internal;

import com.express.dao.BacklogItemDao;
import com.express.dao.IterationDao;
import com.express.dao.ProjectDao;
import com.express.dao.UserDao;
import com.express.domain.BacklogItem;
import com.express.domain.Iteration;
import com.express.domain.Project;
import com.express.service.BacklogItemManager;
import com.express.service.BacklogItemManagerImpl;
import com.express.service.dto.BacklogItemAssignRequest;
import com.express.service.mapping.DomainFactory;
import com.express.service.mapping.RemoteObjectFactory;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.core.Is.is;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class BacklogItemManagerImpleBacklogItemAssignmentTest {

   @Mock
   private ProjectDao projectDao;
   @Mock
   private IterationDao iterationDao;
   @Mock
   private UserDao userDao;
   @Mock
   private BacklogItemDao backlogItemDao;
   @Mock
   private DomainFactory domainFactory;
   @Mock
   private RemoteObjectFactory remoteObjectFactory;
   @Mock
   private Project project;

   private BacklogItemManager backlogItemManager;

   private BacklogItemAssignRequest request;

   BacklogItem item;

   @Before
   public void setUp() {
      MockitoAnnotations.initMocks(this);
      backlogItemManager = new BacklogItemManagerImpl(projectDao, userDao, backlogItemDao,
            iterationDao, domainFactory, remoteObjectFactory);
      item = new BacklogItem();
      request = new BacklogItemAssignRequest();
      request.setProjectId(11l);
      when(projectDao.findById(11l)).thenReturn(project);
   }

   @Test
   public void shouldRemoveFromIterationBacklogWhenIterationFromIdProvided() {
      request.setIterationFromId(1l);
      request.setIterationToId(2l);
      request.setItemIds(new long[]{5l});

      when(projectDao.findById(11l)).thenReturn(new Project());
      Iteration from = mock(Iteration.class);
      when(iterationDao.findById(1l)).thenReturn(from);
      Iteration to = new Iteration();
      when(iterationDao.findById(2l)).thenReturn(to);
      when(backlogItemDao.findById(5l)).thenReturn(item);
      when(from.removeBacklogItem(item)).thenReturn(item);

      backlogItemManager.backlogItemAssignmentRequest(request);
      verify(from).removeBacklogItem(item);
   }

   @Test
   public void shouldRemoveFromProjectVBacklogWhenIterationFromIdNotProvided() {
      request.setProjectId(11l);
      request.setIterationToId(2l);
      request.setItemIds(new long[]{5l});

      Iteration to = new Iteration();
      when(iterationDao.findById(2l)).thenReturn(to);
      when(backlogItemDao.findById(5l)).thenReturn(item);
      when(project.removeBacklogItem(item)).thenReturn(item);

      backlogItemManager.backlogItemAssignmentRequest(request);
      verify(project).removeBacklogItem(item);
   }

   @Test
   public void shouldAddToToIterationBacklogWhenIterationToIdProvided() {
      request.setIterationFromId(1l);
      request.setIterationToId(2l);
      request.setItemIds(new long[]{5l});

      when(projectDao.findById(11l)).thenReturn(new Project());
      Iteration from = mock(Iteration.class);
      when(iterationDao.findById(1l)).thenReturn(from);
      Iteration to = new Iteration();
      when(iterationDao.findById(2l)).thenReturn(to);
      when(backlogItemDao.findById(5l)).thenReturn(item);
      when(from.removeBacklogItem(item)).thenReturn(item);

      backlogItemManager.backlogItemAssignmentRequest(request);
      assertThat(to.getBacklog().size(), is(equalTo(1)));
   }
}
