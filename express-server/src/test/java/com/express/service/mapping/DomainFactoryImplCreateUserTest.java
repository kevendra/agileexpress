package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.User;
import com.express.service.dto.AccessRequestDto;
import com.express.service.dto.UserDto;
import org.junit.Before;
import org.junit.Test;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.MatcherAssert.assertThat;

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/UserMappingTest.xml"})
public class DomainFactoryImplCreateUserTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private DomainFactoryImpl domainFactory;
   
   private static final Long EXISTING_USER_ID = 102l;
   private static final Long NON_EXISTING_USER_ID = 22l;
   private static final Long VERSION = 11l;
   private static final String EMAIL = "test@mail.com";
   private static final String FIRST_NAME = "first";
   private static final String LAST_NAME = "last";
   private static final String PASSWORD = "pass";
   private static final String PASSWORD_HINT = "hint";
   private static final String PHONE_1 = "111111";
   private static final String PHONE_2 = "22222";
   private static final boolean HAS_PROJECTS = true;
   private static final Integer COLOUR = 123;
   private static final List<AccessRequestDto> ACCESS_REQUESTS = new ArrayList<AccessRequestDto>();

   private UserDto dto;

   @Before
   public void setUp() {
      dto = new UserDto();
      dto.setEmail(EMAIL);
      dto.setVersion(VERSION);
      dto.setFirstName(FIRST_NAME);
      dto.setLastName(LAST_NAME);
      dto.setPassword(PASSWORD);
      dto.setPasswordHint(PASSWORD_HINT);
      dto.setPhone1(PHONE_1);
      dto.setPhone2(PHONE_2);
      dto.setColour(COLOUR);
      dto.setAccessRequests(ACCESS_REQUESTS);
   }

   @Test
   public void shouldCreateNewUserIfDtoHasNoId() throws Exception {
      User user = domainFactory.createUser(dto);
      assertThat(user.getId(), is(nullValue()));
   }

   @Test
   public void shouldsetCreatedAtWhenCreatingNewUser() throws Exception {
      User user = domainFactory.createUser(dto);
      assertThat(user.getCreatedDate(), not(nullValue()));
   }

   @Test
   public void shouldLoadUserFromDBIfDtoHasId() throws Exception {
      dto.setId(EXISTING_USER_ID);
      User user = domainFactory.createUser(dto);
      assertThat(user, not(nullValue()));
   }

   @Test(expected = ObjectRetrievalFailureException.class)
   public void shouldFailIfDtoHasIdThatIsNotInDB() throws Exception {
      dto.setId(NON_EXISTING_USER_ID);
      User user = domainFactory.createUser(dto);
   }

   @Test
   public void shouldMapFirstNameField() {
      assertThat(domainFactory.createUser(dto).getFirstName(), is(equalTo(FIRST_NAME)));
   }

   @Test
   public void shouldMapLastNameField() {
      assertThat(domainFactory.createUser(dto).getLastName(), is(equalTo(LAST_NAME)));
   }

   @Test
   public void shouldMapEmailField() {
      assertThat(domainFactory.createUser(dto).getEmail(), is(equalTo(EMAIL)));
   }

   @Test
   public void shouldMapPasswordField() {
      assertThat(domainFactory.createUser(dto).getPassword(), is(equalTo(PASSWORD)));
   }

   @Test
   public void shouldMapPasswordHintField() {
      assertThat(domainFactory.createUser(dto).getPasswordHint(), is(equalTo(PASSWORD_HINT)));
   }

   @Test
   public void shouldMapPhone1Field() {
      assertThat(domainFactory.createUser(dto).getPhone1(), is(equalTo(PHONE_1)));
   }

   @Test
   public void shouldMapPhone2Field() {
      assertThat(domainFactory.createUser(dto).getPhone2(), is(equalTo(PHONE_2)));
   }

   @Test
   public void shouldMapColourField() {
      assertThat(domainFactory.createUser(dto).getColour(), is(equalTo(COLOUR)));
   }
}
