package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.Iteration;
import com.express.domain.Project;
import org.junit.Before;
import org.junit.Test;
import org.unitils.spring.annotation.SpringBeanByName;

import java.util.Calendar;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class RemoteObjectFactoryImplCreateIterationDtoTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private RemoteObjectFactoryImpl remoteObjectFactory;

   private static final Long EXISTING_ITERATION_ID = 102l;
   private static final Long PROJECT_ID = 33l;
   private static final Long VERSION = 11l;
   private static final Calendar START_DATE = Calendar.getInstance();
   private static final Calendar END_DATE = Calendar.getInstance();
   private static final String TITLE = "title";
   private static final String GOAL = "goal";
   private static final Integer FINAL_VELOCITY = 12;

   private Iteration iteration;

   @Before
   public void setUp() {
      iteration = new Iteration();
      iteration.setId(EXISTING_ITERATION_ID);
      iteration.setVersion(VERSION);
      iteration.setStartDate(START_DATE);
      iteration.setEndDate(END_DATE);
      iteration.setTitle(TITLE);
      iteration.setGoal(GOAL);
      iteration.setFinalVelocity(FINAL_VELOCITY);
   }

   @Test
   public void shouldMapIdField() throws Exception {
      assertThat(remoteObjectFactory.createIterationDto(iteration).getId(), is(EXISTING_ITERATION_ID));
   }

   @Test
   public void shouldMapStartDateField() {
      assertThat(remoteObjectFactory.createIterationDto(iteration).getStartDate(), is(equalTo(START_DATE)));
   }

   @Test
   public void shouldMapEndDateField() {
      assertThat(remoteObjectFactory.createIterationDto(iteration).getEndDate(), is(equalTo(END_DATE)));
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(remoteObjectFactory.createIterationDto(iteration).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapGoalField() {
      assertThat(remoteObjectFactory.createIterationDto(iteration).getGoal(), is(equalTo(GOAL)));
   }

   @Test
   public void shouldMapProject() {
      Project project = new Project();
      project.setId(PROJECT_ID);
      iteration.setProject(project);
      assertThat(remoteObjectFactory.createIterationDto(iteration).getProject().getId(), is(equalTo(PROJECT_ID)));
   }
}
