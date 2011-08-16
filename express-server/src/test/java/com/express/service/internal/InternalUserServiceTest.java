package com.express.service.internal;

import com.express.dao.UserDao;
import com.express.domain.User;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.unitils.UnitilsJUnit4;

import static org.mockito.BDDMockito.given;

/**
 * @author Adam Boas
 *         Created on Apr 11, 2009
 */
public class InternalUserServiceTest {
   @Mock
   UserDao userDao;

   @Mock
   Ehcache cache;

   UserService userService;

   @Before
   public void setUp() {
      MockitoAnnotations.initMocks(this);
      userService = new InternalUserService(userDao, cache);
   }

   @Test
   public void loadUserByUsernameShouldReturnUserFromCache() {
      String uname = "AbCde";
      User user = new User();
      user.setEmail(uname);
      given(cache.get(uname.toLowerCase())).willReturn(new Element(uname, user));
      userService.loadUserByUsername(uname);
   }
}
