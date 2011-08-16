package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.Methodology;
import com.express.domain.Project;
import com.express.service.dto.AccessRequestDto;
import com.express.service.dto.BacklogItemDto;
import com.express.service.dto.DailyProjectStatusRecordDto;
import com.express.service.dto.IterationDto;
import com.express.service.dto.ProjectDto;
import com.express.service.dto.ProjectWorkerDto;
import com.express.service.dto.ThemeDto;
import org.junit.Before;
import org.junit.Test;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.MatcherAssert.assertThat;

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/ProjectMappingTest.xml"})
public class DomainFactoryImplCreateProjectTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private DomainFactoryImpl domainFactory;

   private static final Long EXISTING_PROJECT_ID = 102l;
   private static final Long NON_EXISTING_PROJECT_ID = 22l;
   private static final Long VERSION = 11l;
   private static final Calendar START_DATE = Calendar.getInstance();
   private static final String TITLE = "title";
   private static final String DESCRIPTION = "description";
   private static final String EFFORT_UNIT = "Pts";
   private static final String REFERENCE = "REF";
   private static final String METHODOLOGY = "XP";
   private static final List<ProjectWorkerDto> PROJECT_WORKERS = new ArrayList<ProjectWorkerDto>();
   private static final List<IterationDto> ITERATIONS = new ArrayList<IterationDto>();
   private static final List<BacklogItemDto> PRODUCT_BACKLOG = new ArrayList<BacklogItemDto>();
   private static final List<DailyProjectStatusRecordDto> HISTORY = new ArrayList<DailyProjectStatusRecordDto>();
   private static final List<String> ACTORS = new ArrayList<String>();
   private static final List<ThemeDto> THEMES = new ArrayList<ThemeDto>();
   private static final List<AccessRequestDto> ACCESS_REQUESTS = new ArrayList<AccessRequestDto>();

   private ProjectDto dto;

   @Before
   public void setUp() {
      dto = new ProjectDto();
      dto.setVersion(VERSION);
      dto.setStartDate(START_DATE);
      dto.setTitle(TITLE);
      dto.setDescription(DESCRIPTION);
      dto.setEffortUnit(EFFORT_UNIT);
      dto.setReference(REFERENCE);
      dto.setMethodology(METHODOLOGY);
      dto.setProjectWorkers(PROJECT_WORKERS);
      dto.setIterations(ITERATIONS);
      dto.setProductBacklog(PRODUCT_BACKLOG);
      dto.setHistory(HISTORY);
      dto.setActors(ACTORS);
      dto.setThemes(THEMES);
      dto.setAccessRequests(ACCESS_REQUESTS);
   }

   @Test
   public void shouldCreateNewProjectIfDtoHasNoId() throws Exception {
      Project project = domainFactory.createProject(dto);
      assertThat(project.getId(), is(nullValue()));
   }

   @Test
   public void shouldLoadProjectFromDBIfDtoHasId() throws Exception {
      dto.setId(EXISTING_PROJECT_ID);
      Project project = domainFactory.createProject(dto);
      assertThat(project, not(nullValue()));
   }

   @Test(expected = ObjectRetrievalFailureException.class)
   public void shouldFailIfDtoHasIdThatIsNotInDB() throws Exception {
      dto.setId(NON_EXISTING_PROJECT_ID);
      Project project = domainFactory.createProject(dto);
   }

   @Test
   public void shouldMapStartDateField() {
      assertThat(domainFactory.createProject(dto).getStartDate(), is(equalTo(START_DATE)));
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(domainFactory.createProject(dto).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapDescriptionField() {
      assertThat(domainFactory.createProject(dto).getDescription(), is(equalTo(DESCRIPTION)));
   }

   @Test
   public void shouldMapEffortUnitField() {
      assertThat(domainFactory.createProject(dto).getEffortUnit(), is(equalTo(EFFORT_UNIT)));
   }

   @Test
   public void shouldMapReferenceField() {
      assertThat(domainFactory.createProject(dto).getReference(), is(equalTo(REFERENCE)));
   }

   @Test
   public void shouldMapMethodologyField() {
      assertThat(domainFactory.createProject(dto).getMethodology(), is(equalTo(Methodology.XP)));
   }
}
