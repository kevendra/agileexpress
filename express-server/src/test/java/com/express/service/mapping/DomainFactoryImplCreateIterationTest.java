package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.Iteration;
import com.express.service.dto.IterationDto;
import org.junit.Before;
import org.junit.Test;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import java.util.Calendar;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.MatcherAssert.assertThat;

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/IterationMappingTest.xml"})
public class DomainFactoryImplCreateIterationTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private DomainFactoryImpl domainFactory;

   private static final Long EXISTING_ITERATION_ID = 102l;
   private static final Long NON_EXISTING_ITERATION_ID = 22l;
   private static final Long PROJECT_ID = 33l;
   private static final Long VERSION = 11l;
   private static final Calendar START_DATE = Calendar.getInstance();
   private static final Calendar END_DATE = Calendar.getInstance();
   private static final String TITLE = "title";
   private static final String GOAL = "goal";
   private static final Integer FINAL_VELOCITY = 12;

   private IterationDto dto;

   @Before
   public void setUp() {
      dto = new IterationDto();
      dto.setVersion(VERSION);
      dto.setStartDate(START_DATE);
      dto.setEndDate(END_DATE);
      dto.setTitle(TITLE);
      dto.setGoal(GOAL);
      dto.setFinalVelocity(FINAL_VELOCITY);
   }

   @Test
   public void shouldCreateNewIterationIfDtoHasNoId() throws Exception {
      assertThat(domainFactory.createIteration(dto).getId(), is(nullValue()));
   }

   @Test
   public void shouldLoadProjectFromDBIfDtoHasId() throws Exception {
      dto.setId(EXISTING_ITERATION_ID);
      assertThat(domainFactory.createIteration(dto), not(nullValue()));
   }

   @Test(expected = ObjectRetrievalFailureException.class)
   public void shouldFailIfDtoHasIdThatIsNotInDB() throws Exception {
      dto.setId(NON_EXISTING_ITERATION_ID);
      Iteration iteration = domainFactory.createIteration(dto);
   }

   @Test
   public void shouldMapStartDateField() {
      assertThat(domainFactory.createIteration(dto).getStartDate(), is(equalTo(START_DATE)));
   }

   @Test
   public void shouldMapEndDateField() {
      assertThat(domainFactory.createIteration(dto).getEndDate(), is(equalTo(END_DATE)));
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(domainFactory.createIteration(dto).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapGoalField() {
      assertThat(domainFactory.createIteration(dto).getGoal(), is(equalTo(GOAL)));
   }

   @Test
   public void shouldBringProjectFromDatabaseIfLoadedFromDB() {
      dto.setId(EXISTING_ITERATION_ID);
      Iteration iteration = domainFactory.createIteration(dto);
      assertThat(iteration.getProject().getId(), is(equalTo(PROJECT_ID)));
   }
}
