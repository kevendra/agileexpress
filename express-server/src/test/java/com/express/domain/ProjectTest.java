package com.express.domain;

import org.junit.Before;
import org.junit.Test;
import org.unitils.UnitilsJUnit4;

import static com.express.matcher.BeanMatchers.hasValidSettersAndGettersExcluding;
import static com.express.matcher.BeanMatchers.usesPersistableEqualityStrategy;
import static com.express.matcher.BeanMatchers.usesPersistableHashCodeStrategy;
import static com.express.matcher.BeanMatchers.usesReflectionToStringBuilder;
import static junit.framework.Assert.assertEquals;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

public class ProjectTest extends UnitilsJUnit4 {

   Project project;

   @Before
   public void setUp() {
      project = new Project();
   }

   @Test
   public void shouldSetAndGetProperties() {
      assertThat(project, hasValidSettersAndGettersExcluding("equalityStrategy", "version", "storyCount", "methodology"));
   }

   @Test
   public void shouldSetAndGetMethodology() {
      project.setMethodology(Methodology.XP);
      assertThat(project.getMethodology(), is(Methodology.XP));
   }
   @Test
   public void shouldBaseEqualityOnThePersistableEqualityStrategy() {
      assertThat(project, usesPersistableEqualityStrategy());
   }

   @Test
   public void shouldBaseHashCodeOnThePersistableEqualityStrategy() {
      assertThat(project, usesPersistableHashCodeStrategy());
   }

   @Test
   public void shouldUseReflectionToStringBuilder() {
      assertThat(project, usesReflectionToStringBuilder());
   }

   @Test
   public void shouldAddAndRemoveDevelopers() {
      assertNotNull(project.getProjectWorkers());
      assertEquals(0, project.getProjectWorkers().size());
      ProjectWorker projectWorker = new ProjectWorker();
      project.addProjectWorker(projectWorker);
      assertEquals(1, project.getProjectWorkers().size());
      project.removeProjectWorker(projectWorker);
      assertEquals(0, project.getProjectWorkers().size());
   }

   @Test
   public void shouldAddAndRemoveAccessRequests() {
      assertNotNull(project.getAccessRequests());
      assertEquals(0, project.getAccessRequests().size());
      AccessRequest request = new AccessRequest();
      project.addAccessRequest(request);
      assertEquals(1, project.getAccessRequests().size());
      assertEquals(project, request.getProject());
      project.removeAccessRequest(request);
      assertEquals(0, project.getAccessRequests().size());
      assertNull(request.getProject());
   }

   @Test
   public void shouldAddAndRemoveThemes() {
      assertNotNull(project.getThemes());
      assertEquals(0, project.getThemes().size());
      Theme theme = new Theme();
      project.addTheme(theme);
      assertEquals(1, project.getThemes().size());
      assertEquals(project, theme.getProject());
      project.removeTheme(theme);
      assertEquals(0, project.getThemes().size());
      assertNull(theme.getProject());
   }

   @Test
   public void projectWorkersWithProjectAdminPermissionShouldBeReturnedAsManagers() {
      int numberOfAdmins = 1;
      assertNotNull(project.getProjectWorkers());
      assertEquals(0, project.getProjectWorkers().size());
      ProjectWorker projectWorker = new ProjectWorker();
      projectWorker.getPermissions().setProjectAdmin(true);
      project.addProjectWorker(projectWorker);
      //Add non-manager
      projectWorker = new ProjectWorker();
      project.addProjectWorker(projectWorker);
      assertThat("number of admins", project.getProjectManagers().size(), equalTo(numberOfAdmins));
   }

   @Test
   public void shouldIncrementStoryCountWhenAddedToProductBacklog() {
      assertEquals(0, project.getStoryCount().intValue());
      project.addBacklogItem(new BacklogItem(), true);
      assertEquals(1, project.getStoryCount().intValue());
   }

   @Test
   public void shouldNotIncrementStoryCountWhenMovedToProductBacklog() {
      assertEquals(0, project.getStoryCount().intValue());
      project.addBacklogItem(new BacklogItem(), false);
      assertEquals(0, project.getStoryCount().intValue());
   }

   @Test
   public void shouldIncrementStoryCountWhenAddedToIterationBacklog() {
      assertEquals(0, project.getStoryCount().intValue());
      Iteration iteration = new Iteration();
      project.addIteration(iteration);
      iteration.addBacklogItem(new BacklogItem(), true);
      assertEquals(1, project.getStoryCount().intValue());
   }

   @Test
   public void shouldNotIncrementStoryCountWhenMovedToIterationBacklog() {
      assertEquals(0, project.getStoryCount().intValue());
      Iteration iteration = new Iteration();
      project.addIteration(iteration);
      iteration.addBacklogItem(new BacklogItem(), false);
      assertEquals(0, project.getStoryCount().intValue());
   }

}
