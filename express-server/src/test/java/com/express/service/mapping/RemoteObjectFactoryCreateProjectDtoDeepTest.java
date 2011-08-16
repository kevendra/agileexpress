package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.AccessRequest;
import com.express.domain.BacklogItem;
import com.express.domain.DailyProjectStatusRecord;
import com.express.domain.Iteration;
import com.express.domain.Methodology;
import com.express.domain.Project;
import com.express.domain.ProjectWorker;
import com.express.domain.Theme;
import org.junit.Before;
import org.junit.Test;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import java.util.Calendar;
import java.util.HashSet;
import java.util.Set;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/UserDtoMappingTest.xml"})
public class RemoteObjectFactoryCreateProjectDtoDeepTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private RemoteObjectFactoryImpl remoteObjectFactory;

   private static final Long USER_ID = 10l;
   private static final Long VERSION = 11l;
   private static final Calendar START_DATE = Calendar.getInstance();
   private static final String TITLE = "title";
   private static final String DESCRIPTION = "description";
   private static final String EFFORT_UNIT = "Pts";
   private static final String REFERENCE = "REF";
   private static final Set<ProjectWorker> PROJECT_WORKERS = new HashSet<ProjectWorker>();
   private static final Set<Iteration> ITERATIONS = new HashSet<Iteration>();
   private static final Set<BacklogItem> PRODUCT_BACKLOG = new HashSet<BacklogItem>();
   private static final Set<DailyProjectStatusRecord> HISTORY = new HashSet<DailyProjectStatusRecord>();
   private static final Set<Theme> THEMES = new HashSet<Theme>();
   private static final Set<AccessRequest> ACCESS_REQUESTS = new HashSet<AccessRequest>();

   private Project project;

   @Before
   public void setUp() {
      project = new Project();
      project.setId(USER_ID);
      project.setVersion(VERSION);
      project.setAccessRequests(ACCESS_REQUESTS);
      project.setStartDate(START_DATE);
      project.setTitle(TITLE);
      project.setDescription(DESCRIPTION);
      project.setEffortUnit(EFFORT_UNIT);
      project.setReference(REFERENCE);
      project.setMethodology(Methodology.XP);
      project.setProjectWorkers(PROJECT_WORKERS);
      project.setIterations(ITERATIONS);
      project.setProductBacklog(PRODUCT_BACKLOG);
      project.setAccessRequests(ACCESS_REQUESTS);
      project.setThemes(THEMES);
      project.setHistory(HISTORY);
   }

   @Test
   public void shouldMapIdField() {
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getId(), is(equalTo(USER_ID)));
   }

   @Test
   public void shouldMapVersionField() {
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getVersion(), is(equalTo(VERSION)));
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapdescriptionField() {
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getDescription(), is(equalTo(DESCRIPTION)));
   }

   @Test
   public void shouldMapEffortUnitField() {
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getEffortUnit(), is(equalTo(EFFORT_UNIT)));
   }

   @Test
   public void shouldMapReferenceField() {
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getReference(), is(equalTo(REFERENCE)));
   }

   @Test
   public void shouldMapMethodologyField() {
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getMethodology(), is(equalTo("XP")));
   }

   @Test
   public void shouldMapProjectWorkers() {
      ProjectWorker projectWorker = new ProjectWorker();
      projectWorker.setId(2l);
      projectWorker.getPermissions().setId(3l);
      PROJECT_WORKERS.add(projectWorker);
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getProjectWorkers().size(), is(1));
   }

   @Test
   public void shouldMapThemes() {
      Theme theme = new Theme();
      theme.setId(3l);
      THEMES.add(theme);
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getThemes().size(), is(1));
   }

   @Test
   public void shouldMapHistory() {
      DailyProjectStatusRecord record = new DailyProjectStatusRecord(Calendar.getInstance(), 1, 1, project);
      record.setId(4l);
      HISTORY.add(record);
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getHistory().size(), is(1));
   }

   @Test
   public void shouldMapIterations() {
      Iteration iteration = new Iteration();
      iteration.setId(5l);
      ITERATIONS.add(iteration);
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getIterations().size(), is(1));
   }

   @Test
   public void shouldMapProductBacklog() {
      BacklogItem item = new BacklogItem();
      item.setId(6l);
      PRODUCT_BACKLOG.add(item);
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getProductBacklog().size(), is(1));
   }

   @Test
   public void shouldMapAccessRequests() {
      AccessRequest accessRequest = new AccessRequest();
      accessRequest.setId(7l);
      ACCESS_REQUESTS.add(accessRequest);
      assertThat(remoteObjectFactory.createProjectDtoDeep(project).getAccessRequests().size(), is(1));
   }
}
