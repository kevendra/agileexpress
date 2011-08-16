package com.express.service;

import com.express.dao.UserDao;
import com.express.domain.User;
import com.express.service.dto.ChangePasswordRequest;
import com.express.service.dto.LoginRequest;
import com.express.service.dto.UserDto;
import com.express.service.mapping.DomainFactory;
import com.express.service.mapping.RemoteObjectFactory;
import com.express.service.notification.NotificationService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.springframework.remoting.RemoteAccessException;
import org.springframework.security.providers.encoding.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service("userManager")
@Transactional(readOnly = true)
public class UserManagerImpl implements UserManager {
   private static final Log LOG = LogFactory.getLog(UserManagerImpl.class);
   
   private final UserDao userDao;
   private final PasswordEncoder passwordEncoder;
   private final RemoteObjectFactory remoteObjectFactory;
   private final DomainFactory domainFactory;

   private NotificationService notificationService;

   @Autowired
   public UserManagerImpl(@Qualifier("userDao")UserDao userDao,
                          @Qualifier("passwordEncoder")PasswordEncoder passwordEncoder,
                          @Qualifier("remoteObjectFactory")RemoteObjectFactory remoteObjectFactory,
                          @Qualifier("domainFactory")DomainFactory domainFactory,
                          @Qualifier("notificationService")NotificationService notificationService) {
      this.userDao = userDao;
      this.passwordEncoder = passwordEncoder;
      this.remoteObjectFactory = remoteObjectFactory;
      this.domainFactory = domainFactory;
      this.notificationService = notificationService;
   }

   public UserDto login(LoginRequest request) {
      User user;
      try {
         user = userDao.findByUsername(request.getUsername().toLowerCase());
      }
      catch(ObjectRetrievalFailureException e) {
         LOG.info("Invalid login attempt principle does not exist: [username:" + 
                  request.getUsername() + "]", e);
         throw new RemoteAccessException("Invalid username or password");
      }
      if(request.isPasswordReminderRequest()) {
         notificationService.sendPasswordReminderNotification(user);
         return null;
      }
      if(!passwordEncoder.isPasswordValid(user.getPassword(), request.getPassword(), user.getEmail())) {
         LOG.info("Invalid login attempt, invalid credentials for [username:" +
                  request.getUsername() + "]");
         throw new RemoteAccessException("Invalid username or password");
      }
      if(!user.isActive()) {
         LOG.info("Invalid login attempt,  account inactive for [username:" +
                  request.getUsername() + "]");
         throw new RemoteAccessException("Invalid login attempt");
      }
      return remoteObjectFactory.createUserDto(user);
   }
   
   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public Long register(UserDto dto) {
      rejectExistingUsername(dto.getEmail());
      User user = domainFactory.createUser(dto);
      user.setPassword(passwordEncoder.encodePassword(user.getPassword(), user.getEmail()));
      userDao.save(user);
      try {
         notificationService.sendConfirmationNotification(user);
      }
      catch(Exception e) {
         LOG.error("Unable to send confirmation notification", e);
         throw new RemoteAccessException("We are experiencing problems with our mail gateway. Please try to register again later. Your details have not been saved.");
      }
      
      return user.getId();
   }
   
   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void confirmRegistration(Long userId) {
      User user = userDao.findById(userId);
      user.setActive(true);
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public UserDto changePassword(ChangePasswordRequest request) {
      User user = userDao.findById(request.getUserId());
      if(passwordEncoder.isPasswordValid(user.getPassword(), request.getOldPassword(), user.getEmail())) {
         user.setPassword(passwordEncoder.encodePassword(request.getNewPassword(), user.getEmail()));
         userDao.save(user);
         return remoteObjectFactory.createUserDto(user);
      }
      throw new RemoteAccessException("Invalid password provided");
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public UserDto updateUserDetails(UserDto dto) {
      User user = domainFactory.createUser(dto);
      userDao.save(user);
      return remoteObjectFactory.createUserDto(user);
   }

   public UserDto resetPassword(Long userId) {
      return null;
   }

   private void rejectExistingUsername(String username) throws RemoteAccessException {
      try {
         User user = userDao.findByUsername(username);
         if ( user != null ) {
            throw new RemoteAccessException("The username " + username + 
                     " is already in use. Please choose another username.");
         }
      } catch(ObjectRetrievalFailureException e) {
         //This is the preferred outcome - the username is available
         if(LOG.isDebugEnabled()) {
            LOG.info("The username [\"" + username + "\"] is not in use.");
         }
      }
   }
}
