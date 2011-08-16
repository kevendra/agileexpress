package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.BacklogItem;
import com.express.domain.Status;
import org.junit.Before;
import org.junit.Test;
import org.unitils.spring.annotation.SpringBeanByName;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class RemoteObjectFactoryImplCreateBacklogItemDtoTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private RemoteObjectFactoryImpl remoteObjectFactory;

   private static final Long ITEM_ID = 102l;
   private static final Long ITERATION_ID = 44l;
   private static final Long PROJECT_ID = 33l;
   private static final Long VERSION = 11l;
   private static final String TITLE = "title";
   private static final String SUMMARY = "summary";
   private static final String DETAILED_DESCRIPTION = "description";
   private static final String AS_A = "as a";
   private static final String I_WANT = "i want";
   private static final String SO_THAT = "so that";
   private static final Integer EFFORT = 1;
   private static final Integer BUSINESS_VALUE = 2;

   private BacklogItem item;

   @Before
   public void setUp() {
      item = new BacklogItem();
      item.setId(ITEM_ID);
      item.setVersion(VERSION);
      item.setTitle(TITLE);
      item.setSummary(SUMMARY);
      item.setAsA(AS_A);
      item.setWant(I_WANT);
      item.setSoThat(SO_THAT);
      item.setDetailedDescription(DETAILED_DESCRIPTION);
      item.setStatus(Status.OPEN);
      item.setEffort(EFFORT);
      item.setBusinessValue(BUSINESS_VALUE);
   }

   @Test
   public void shouldMapIdField() throws Exception {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getId(), is(ITEM_ID));
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapSummaryField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getSummary(), is(equalTo(SUMMARY)));
   }

   @Test
   public void shouldMapAsAField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getAsA(), is(equalTo(AS_A)));
   }
   @Test
   public void shouldMapIWantField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getWant(), is(equalTo(I_WANT)));
   }
   @Test
   public void shouldMapSoThatField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getSoThat(), is(equalTo(SO_THAT)));
   }

   @Test
   public void shouldMapDetailedDescriptionField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getDetailedDescription(), is(equalTo(DETAILED_DESCRIPTION)));
   }

   @Test
   public void shouldMapStatusField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getStatus(), is(Status.OPEN.getTitle()));
   }

   @Test
   public void shouldMapEffortField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getEffort(), is(equalTo(EFFORT)));
   }

   @Test
   public void shouldMapBusinessValueField() {
      assertThat(remoteObjectFactory.createBacklogItemDto(item).getBusinessValue(), is(equalTo(BUSINESS_VALUE)));
   }

//   @Test
//   public void shouldMakeUserSuppliedResponsible() {
//      addAssignedTo();
//      assertThat(remoteObjectFactory.createBacklogItemDto(item).getAssignedTo().getId(), is(equalTo(103l)));
//   }

//   @Test
//   public void shouldNotReplaceAnyResponsibleFieldsWithDtoContents() {
//      addAssignedTo();
//      User assignedTo = remoteObjectFactory.createBacklogItemDto(item).getAssignedTo();
//      assertThat(assignedTo.getEmail(), is(equalTo("test@info.com")));
//      assertThat(assignedTo.getFirstName(), is(equalTo("jane")));
//      assertThat(assignedTo.getLastName(), is(equalTo("doe")));
//   }
//
//   private void addAssignedTo() {
//      UserDto assignedTo = new UserDto();
//      assignedTo.setId(103l);
//      assignedTo.setEmail("nothing");
//      assignedTo.setFirstName("not");
//      assignedTo.setLastName("much");
//      item.setAssignedTo(assignedTo);
//   }
}
