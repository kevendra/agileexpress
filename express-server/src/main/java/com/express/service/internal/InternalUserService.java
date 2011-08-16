package com.express.service.internal;

import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UsernameNotFoundException;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.dao.DataAccessException;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.express.domain.User;
import com.express.dao.UserDao;
import com.express.service.internal.UserService;
import net.sf.ehcache.Element;
import net.sf.ehcache.Ehcache;

/**
 * Service for authentication and retrieving the currently logged in user.
 */
@Service("internalUserService")
public class InternalUserService implements UserService {

   private final UserDao userDao;

   private final Ehcache cache;

   @Autowired
   public InternalUserService(@Qualifier("userDao")UserDao userDao,
                              @Qualifier("loginCache")Ehcache cache) {
      this.userDao = userDao;
      this.cache = cache;
   }

   public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
      User user;
      String uname = username.toLowerCase();
      Element element = cache.get(uname);
      if(element != null) {
         user = (User)element.getValue();
      }
      else {
         user = userDao.findByUsername(uname);
         element = new Element(uname, user);
         cache.put(element);
      }
      return user;
  }

   public User getAuthenticatedUser() {
      SecurityContext securityContext = SecurityContextHolder.getContext();
      User user = (User) securityContext.getAuthentication().getPrincipal();
      return userDao.findById(user.getId());
   }
}
