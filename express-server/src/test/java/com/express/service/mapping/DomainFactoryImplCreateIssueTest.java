package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.Issue;
import com.express.domain.User;
import com.express.service.dto.IssueDto;
import com.express.service.dto.IterationDto;
import com.express.service.dto.UserDto;
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

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/IssueMappingTest.xml"})
public class DomainFactoryImplCreateIssueTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private DomainFactoryImpl domainFactory;

   private static final Long EXISTING_ISSUE_ID = 102l;
   private static final Long NON_EXISTING_ISSUE_ID = 22l;
   private static final Long VERSION = 11l;
   private static final Calendar START_DATE = Calendar.getInstance();
   private static final Calendar END_DATE = Calendar.getInstance();
   private static final String TITLE = "title";
   private static final String DESCRIPTION = "desription";

   private IssueDto dto;

   @Before
   public void setUp() {
      dto = new IssueDto();
      dto.setVersion(VERSION);
      dto.setStartDate(START_DATE);
      dto.setEndDate(END_DATE);
      dto.setTitle(TITLE);
      dto.setDescription(DESCRIPTION);
   }

   @Test
   public void shouldCreateNewIssueIfDtoHasNoId() throws Exception {
      assertThat(domainFactory.createIssue(dto).getId(), is(nullValue()));
   }

   @Test
   public void shouldLoadProjectFromDBIfDtoHasId() throws Exception {
      dto.setId(EXISTING_ISSUE_ID);
      assertThat(domainFactory.createIssue(dto), not(nullValue()));
   }

   @Test(expected = ObjectRetrievalFailureException.class)
   public void shouldFailIfDtoHasIdThatIsNotInDB() throws Exception {
      dto.setId(NON_EXISTING_ISSUE_ID);
      Issue issue = domainFactory.createIssue(dto);
   }

   @Test
   public void shouldMapStartDateField() {
      assertThat(domainFactory.createIssue(dto).getStartDate(), is(equalTo(START_DATE)));
   }

   @Test
   public void shouldMapEndDateField() {
      assertThat(domainFactory.createIssue(dto).getEndDate(), is(equalTo(END_DATE)));
   }

   @Test
   public void shouldMapTitleField() {
      assertThat(domainFactory.createIssue(dto).getTitle(), is(equalTo(TITLE)));
   }

   @Test
   public void shouldMapDescriptionField() {
      assertThat(domainFactory.createIssue(dto).getDescription(), is(equalTo(DESCRIPTION)));
   }

   @Test
   public void shouldNotMapIteration() {
      dto.setIteration(new IterationDto());
      assertThat(domainFactory.createIssue(dto).getIteration(), is(nullValue()));
   }

   @Test
   public void shouldMakeUserSuppliedResponsible() {
      addResponsible();
      assertThat(domainFactory.createIssue(dto).getResponsible().getId(), is(equalTo(103l)));
   }

   @Test
   public void shouldNotReplaceAnyResponsibleFieldsWithDtoContents() {
      addResponsible();
      User responsible = domainFactory.createIssue(dto).getResponsible();
      assertThat(responsible.getEmail(), is(equalTo("test@info.com")));
      assertThat(responsible.getFirstName(), is(equalTo("jane")));
      assertThat(responsible.getLastName(), is(equalTo("doe")));
   }

   private void addResponsible() {
      UserDto responsible = new UserDto();
      responsible.setId(103l);
      responsible.setEmail("nothing");
      responsible.setFirstName("not");
      responsible.setLastName("much");
      dto.setResponsible(responsible);
   }
}
