package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.BacklogItem;
import com.express.domain.Status;
import com.express.domain.User;
import com.express.service.dto.BacklogItemDto;
import com.express.service.dto.UserDto;
import org.junit.Before;
import org.junit.Test;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.MatcherAssert.assertThat;

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/BacklogItemMappingTest.xml"})
public class DomainFactoryImplCreateBacklogItemTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private DomainFactoryImpl domainFactory;

   private static final Long EXISTING_ITERATION_ID = 102l;
   private static final Long NON_EXISTING_ITERATION_ID = 22l;
   private static final Long ITERATION_ID = 44l;
   private static final Long PROJECT_ID = 33l;
   private static final Long VERSION = 11l;
   private static final String TITLE = "title";
   private static final String SUMMARY = "summary";
   private static final String DETAILED_DESCRIPTION = "description";
   private static final String STATUS = "OPEN";
   private static final String AS_A = "as a";
   private static final String I_WANT = "i want";
   private static final String SO_THAT = "so that";
   private static final Integer EFFORT = 1;
   private static final Integer BUSINESS_VALUE = 2;

   private BacklogItemDto dto;

   @Before
   public void setUp() {
      dto = new BacklogItemDto();
      dto.setVersion(VERSION);
      dto.setTitle(TITLE);
      dto.setSummary(SUMMARY);
      dto.setAsA(AS_A);
      dto.setWant(I_WANT);
      dto.setSoThat(SO_THAT);
      dto.setDetailedDescription(DETAILED_DESCRIPTION);
      dto.setStatus(STATUS);
      dto.setEffort(EFFORT);
      dto.setBusinessValue(BUSINESS_VALUE);
   }

   @Test
   public void shouldCreateNewBacklogItemIfDtoHasNoId() throws Exception {
      assertThat(domainFactory.createBacklogItem(dto).getId(), is(nullValue()));
   }

   @Test
   public void shouldLoadProjectFromDBIfDtoHasId() throws Exception {
      dto.setId(EXISTING_ITERATION_ID);
      assertThat(domainFactory.createBacklogItem(dto), not(nullValue()));
   }

   @Test(expected = ObjectRetrievalFailureException.class)
   public void shouldFailIfDtoHasIdThatIsNotInDB() throws Exception {
      dto.setId(NON_EXISTING_ITERATION_ID);
      BacklogItem backlogItem = domainFactory.createBacklogItem(dto);
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(domainFactory.createBacklogItem(dto).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapSummaryField() {
      assertThat(domainFactory.createBacklogItem(dto).getSummary(), is(equalTo(SUMMARY)));
   }

   @Test
   public void shouldMapAsAField() {
      assertThat(domainFactory.createBacklogItem(dto).getAsA(), is(equalTo(AS_A)));
   }
   @Test
   public void shouldMapIWantField() {
      assertThat(domainFactory.createBacklogItem(dto).getWant(), is(equalTo(I_WANT)));
   }
   @Test
   public void shouldMapSoThatField() {
      assertThat(domainFactory.createBacklogItem(dto).getSoThat(), is(equalTo(SO_THAT)));
   }

   @Test
   public void shouldMapDetailedDescriptionField() {
      assertThat(domainFactory.createBacklogItem(dto).getDetailedDescription(), is(equalTo(DETAILED_DESCRIPTION)));
   }

   @Test
   public void shouldMapStatusField() {
      assertThat(domainFactory.createBacklogItem(dto).getStatus(), is(Status.OPEN));
   }

   @Test
   public void shouldMapEffortField() {
      assertThat(domainFactory.createBacklogItem(dto).getEffort(), is(equalTo(EFFORT)));
   }

   @Test
   public void shouldMapBusinessValueField() {
      assertThat(domainFactory.createBacklogItem(dto).getBusinessValue(), is(equalTo(BUSINESS_VALUE)));
   }

   @Test
   public void shouldMakeUserSuppliedResponsible() {
      addAssignedTo();
      assertThat(domainFactory.createBacklogItem(dto).getAssignedTo().getId(), is(equalTo(103l)));
   }

   @Test
   public void shouldNotReplaceAnyResponsibleFieldsWithDtoContents() {
      addAssignedTo();
      User assignedTo = domainFactory.createBacklogItem(dto).getAssignedTo();
      assertThat(assignedTo.getEmail(), is(equalTo("test@info.com")));
      assertThat(assignedTo.getFirstName(), is(equalTo("jane")));
      assertThat(assignedTo.getLastName(), is(equalTo("doe")));
   }

   private void addAssignedTo() {
      UserDto assignedTo = new UserDto();
      assignedTo.setId(103l);
      assignedTo.setEmail("nothing");
      assignedTo.setFirstName("not");
      assignedTo.setLastName("much");
      dto.setAssignedTo(assignedTo);
   }
}
