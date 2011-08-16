package com.express.service.mapping;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.AccessRequest;
import com.express.domain.User;
import org.junit.Before;
import org.junit.Test;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/UserDtoMappingTest.xml"})
public class RemoteObjectFactoryCreateUserDtoTest extends AbstractUnitilsTestBase {
   @SpringBeanByName
   private RemoteObjectFactoryImpl remoteObjectFactory;

   private static final Long USER_ID = 10l;
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
   private static final List<AccessRequest> ACCESS_REQUESTS = new ArrayList<AccessRequest>();

   private User user;

   @Before
   public void setUp() {
      user = new User();
      user.setEmail(EMAIL);
      user.setId(USER_ID);
      user.setVersion(VERSION);
      user.setFirstName(FIRST_NAME);
      user.setLastName(LAST_NAME);
      user.setPassword(PASSWORD);
      user.setPasswordHint(PASSWORD_HINT);
      user.setPhone1(PHONE_1);
      user.setPhone2(PHONE_2);
      user.setColour(COLOUR);
      user.setAccessRequests(ACCESS_REQUESTS);
   }

   @Test
   public void shouldMapIdField() {
      assertThat(remoteObjectFactory.createUserDto(user).getId(), is(equalTo(USER_ID)));
   }

   @Test
   public void shouldMapVersionField() {
      assertThat(remoteObjectFactory.createUserDto(user).getVersion(), is(equalTo(VERSION)));
   }

   @Test
   public void shouldMapEmailField() {
      assertThat(remoteObjectFactory.createUserDto(user).getEmail(), is(equalTo(EMAIL)));
   }

   @Test
   public void shouldMapFirstNameField() {
      assertThat(remoteObjectFactory.createUserDto(user).getFirstName(), is(equalTo(FIRST_NAME)));
   }

   @Test
   public void shouldMapLastNameField() {
      assertThat(remoteObjectFactory.createUserDto(user).getLastName(), is(equalTo(LAST_NAME)));
   }

   @Test
   public void shouldMapPasswordField() {
      assertThat(remoteObjectFactory.createUserDto(user).getPassword(), is(equalTo(PASSWORD)));
   }

   @Test
   public void shouldMapPasswordHintField() {
      assertThat(remoteObjectFactory.createUserDto(user).getPasswordHint(), is(equalTo(PASSWORD_HINT)));
   }

   @Test
   public void shouldMapPhone1Field() {
      assertThat(remoteObjectFactory.createUserDto(user).getPhone1(), is(equalTo(PHONE_1)));
   }

   @Test
   public void shouldMapPhone2Field() {
      assertThat(remoteObjectFactory.createUserDto(user).getPhone2(), is(equalTo(PHONE_2)));
   }

   @Test
   public void shouldMapHasProjects() {
      assertThat(remoteObjectFactory.createUserDto(user).isHasProjects(), is(true));
   }
}
