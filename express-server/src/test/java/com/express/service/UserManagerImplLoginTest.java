package com.express.service;

import com.express.dao.UserDao;
import com.express.domain.User;
import com.express.service.dto.LoginRequest;
import com.express.service.dto.UserDto;
import com.express.service.mapping.DomainFactory;
import com.express.service.mapping.RemoteObjectFactory;
import com.express.service.notification.NotificationService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.springframework.remoting.RemoteAccessException;
import org.springframework.security.providers.encoding.PasswordEncoder;
import org.unitils.UnitilsJUnit4;

import static org.junit.Assert.assertNull;
import static org.junit.Assert.fail;
import static org.mockito.BDDMockito.given;

public class UserManagerImplLoginTest extends UnitilsJUnit4 {
   static final String USERNAME = "test@test.com";
   static final String PASSWORD = "password";
   @Mock
   RemoteObjectFactory mockRemoteObjectFactory;
   @Mock
   UserDao mockUserDao;
   @Mock
   PasswordEncoder mockPasswordEncoder;
   @Mock
   DomainFactory mockDomainFactory;
   @Mock
   NotificationService mockNotificationService;

   UserManager userManager;
   
   @Before
   public void setUp() {
      MockitoAnnotations.initMocks(this);
      userManager = new UserManagerImpl(mockUserDao, mockPasswordEncoder,mockRemoteObjectFactory,
               mockDomainFactory, mockNotificationService);
   }
   
   @Test
   public void shouldLoginUserCorrectly(){
      LoginRequest request = new LoginRequest();
      request.setUsername(USERNAME);
      request.setPassword(PASSWORD);
      User user = new User();
      user.setEmail(USERNAME);
      user.setPassword(PASSWORD);
      user.setActive(true);
      given(mockUserDao.findByUsername(USERNAME)).willReturn(user);
      given(mockPasswordEncoder.isPasswordValid(PASSWORD, PASSWORD, USERNAME)).willReturn(Boolean.TRUE);
      given(mockRemoteObjectFactory.createUserDto(user)).willReturn(new UserDto());
      
      
      userManager.login(request);
   }
   
   @Test
   public void shouldRaiseExceptionWhenUserInactive(){
      LoginRequest request = new LoginRequest();
      request.setUsername(USERNAME);
      request.setPassword(PASSWORD);
      User user = new User();
      user.setEmail(USERNAME);
      user.setPassword(PASSWORD);
      given(mockUserDao.findByUsername(USERNAME)).willReturn(user);
      given(mockPasswordEncoder.isPasswordValid(PASSWORD, PASSWORD, USERNAME)).willReturn(Boolean.FALSE);
      
      
      try {
         userManager.login(request);
         fail("Login should fai for inactive users");
      }
      catch(RemoteAccessException e) {
         //This is expected
      }
   }
   
   @Test
   public void loginUserPasswordReminderRequestShouldReturnNull(){
      LoginRequest request = new LoginRequest();
      request.setUsername(USERNAME);
      request.setPassword(PASSWORD);
      request.setPasswordReminderRequest(true);
      User user = new User();
      user.setEmail(USERNAME);
      user.setPassword(PASSWORD);
      user.setActive(false);
      given(mockUserDao.findByUsername(USERNAME)).willReturn(user);
      mockNotificationService.sendPasswordReminderNotification(user);
      assertNull(userManager.login(request));
   }
   
   @Test
   public void shouldRaiseExceptionWhenAttemptingToLoginANonExistingUser(){
      LoginRequest request = new LoginRequest();
      request.setUsername(USERNAME);
      request.setPassword(PASSWORD);
      request.setPasswordReminderRequest(true);
      User user = new User();
      user.setEmail(USERNAME);
      user.setPassword(PASSWORD);
      given(mockUserDao.findByUsername(USERNAME)).willThrow(new ObjectRetrievalFailureException(User.class,USERNAME));
      
      try {
         userManager.login(request);
         fail("Login should fai for inactive users");
      }
      catch(RemoteAccessException e) {
         //This is expected
      }
   }

}
