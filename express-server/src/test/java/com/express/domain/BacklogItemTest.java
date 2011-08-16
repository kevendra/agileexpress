package com.express.domain;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Before;
import org.junit.Test;
import org.unitils.UnitilsJUnit4;

import java.util.HashSet;
import java.util.Set;

import static com.express.matcher.BeanMatchers.hasValidSettersAndGettersExcluding;
import static com.express.matcher.BeanMatchers.usesPersistableEqualityStrategy;
import static com.express.matcher.BeanMatchers.usesPersistableHashCodeStrategy;
import static com.express.matcher.BeanMatchers.usesReflectionToStringBuilder;
import static junit.framework.Assert.assertEquals;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

public class BacklogItemTest extends UnitilsJUnit4 {
   private static final Log LOG = LogFactory.getLog(BacklogItemTest.class);
   static final String REF = "ref-1";
   static final Theme THEME = new Theme();
   static final String THEME_TITLE = "test";
   static final String TITLE = "test title";
   static final String SUMMARY = "test summary";
   static final String STATUS = Status.DONE.getTitle();
   static final String ASSIGENED_TO = "test user";
   static final Integer EFFORT = 5;
   static final Integer BUSINESS_VALUE = 4;

   BacklogItem item;

   @Before
   public void setUp() {
      item = new BacklogItem();
      THEME.setTitle(THEME_TITLE);
      Set<Theme> themes = new HashSet<Theme>();
      themes.add(THEME);
      item.setThemes(themes);
   }

   @Test
   public void shouldSetAndGetProperties() {
      assertThat(item, hasValidSettersAndGettersExcluding("equalityStrategy", "version", "status", "taskCount"));
   }

   @Test
   public void shouldBaseEqualityOnThePersistableEqualityStrategy() {
      assertThat(item, usesPersistableEqualityStrategy());
   }

   @Test
   public void shouldBaseHashCodeOnThePersistableEqualityStrategy() {
      assertThat(item, usesPersistableHashCodeStrategy());
   }

   @Test
   public void shouldUseReflectionToStringBuilder() {
      assertThat(item, usesReflectionToStringBuilder());
   }

   @Test
   public void CSVShouldMatchKeyFields() {
      item.setEffort(EFFORT);
      item.setBusinessValue(BUSINESS_VALUE);
      item.setReference(REF);
      item.setTitle(TITLE);
      item.setSummary(SUMMARY);
      item.setStatus(Status.DONE);
      User user = new User();
      user.setFirstName("test");
      user.setLastName("user");
      item.setAssignedTo(user);
      String expected = REF + "," + THEME_TITLE + " ," + TITLE + "," + SUMMARY + "," + STATUS + "," + ASSIGENED_TO+ ","
                        + EFFORT + "," + BUSINESS_VALUE;
      assertEquals(expected, item.toCSV());
   }

   @Test
   public void shouldMarkAllTasksDoneWhenSetDone() {
      BacklogItem task = mock(BacklogItem.class);
      item.addTask(task);
      item.setDone();
      verify(task).setStatus(Status.DONE);
   }

   @Test
   public void makeStatusConsistentShouldCallUpToParentIfItemHasOne() {
      BacklogItem parent = mock(BacklogItem.class);
      item.setParent(parent);
      item.makeStatusConsistent();
      verify(parent).makeStatusConsistent();
   }

   @Test
   public void makeStatusShouldLeaveStatusUnchangedIfItemContainsNoTasks() {
      item.setStatus(Status.TEST);
      item.makeStatusConsistent();
      assertThat(item.getStatus(), is(Status.TEST));
   }

   @Test
   public void makeStatusConsistentShouldSetStatusToInProgressIfAnyTaskInProgress() {
      item.setStatus(Status.TEST);
      addTasksWithStatuses(Status.IN_PROGRESS, Status.TEST);
      item.makeStatusConsistent();
      assertThat(item.getStatus(), is(Status.IN_PROGRESS));
   }

   @Test
   public void makeStatusConsistentShouldSetStatusToOpenWhenAllTasksDone() {
      item.setStatus(Status.TEST);
      addTasksWithStatuses(Status.OPEN, Status.OPEN);
      item.makeStatusConsistent();
      assertThat(item.getStatus(), is(Status.OPEN));
   }

   @Test
   public void makeStatusConsistentShouldSetStatusToTestWhenAllTasksDone() {
      item.setStatus(Status.OPEN);
      addTasksWithStatuses(Status.TEST, Status.TEST);
      item.makeStatusConsistent();
      assertThat(item.getStatus(), is(Status.TEST));
   }

   @Test
   public void makeStatusConsistentShouldSetStatusToDoneWhenAllTasksDone() {
      item.setStatus(Status.TEST);
      addTasksWithStatuses(Status.DONE, Status.DONE);
      item.makeStatusConsistent();
      assertThat(item.getStatus(), is(Status.DONE));
   }
   
   @Test
   public void shouldAddTasksShouldIncrementTaskCount() {
      addTasksWithStatuses(Status.OPEN, Status.OPEN);
      assertThat(item.getTaskCount(), is(2));
   }

   @Test
   public void shouldRemoveTasksShouldDecrementTaskCount() {
      BacklogItem task = new BacklogItem();
      item.addTask(task);
      item.removeTask(task);
      assertThat(item.getTaskCount(), is(0));
   }

   private void addTasksWithStatuses(Status... statuses) {
      for(Status status : statuses) {
         BacklogItem task = new BacklogItem();
         task.setStatus(status);
         item.addTask(task);
      }
   }

}
