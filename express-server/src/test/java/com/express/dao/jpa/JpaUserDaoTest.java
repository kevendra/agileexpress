package com.express.dao.jpa;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.fail;

import org.junit.Test;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import com.express.AbstractUnitilsTestBase;
import com.express.dao.UserDao;
import com.express.domain.User;

/**
 * @author Adam Boas
 *
 */
@DataSet("/datasets/DataRemovalDataSet.xml")
public class JpaUserDaoTest extends AbstractUnitilsTestBase
{
   @SpringBeanByName
   private UserDao userDao;
   
   @Test
   public void testSaveSetsIdAndRemoveWorks()
   {
      User subscriber = new User();
      subscriber.setEmail("testuser@test.com");
      assertNull(subscriber.getId());
      this.userDao.save(subscriber);
      assertNotNull(subscriber.getId());
      Long id = subscriber.getId();
      subscriber = null;
      subscriber = this.userDao.findById(id);
      assertNotNull(subscriber);
      
      this.userDao.remove(id);
      subscriber = null;
      try {
         subscriber = this.userDao.findById(id);
         fail("SubscriberDetails was not removed.");
      }
      catch(ObjectRetrievalFailureException e) {
         assertNull("SubscriberDetails was not removed.", subscriber);
      }
   }
   
//   @Test
//   public void testFindAllUsers() {
//      User subscriber = new User();
//      subscriber.setId(1l);
//      subscriber.setActive(true);
//      subscriber.setEmail("testuser1@test.com");
//      this.userDao.save(subscriber);
//      
//      User activePublisher = new User();
//      activePublisher.setId(2l);
//      activePublisher.setActive(true);
//      activePublisher.setEmail("testuser2@test.com");
//      this.userDao.save(activePublisher);
//      
//      User inActivePublisher = new User();
//      inActivePublisher.setId(3l);
//      inActivePublisher.setActive(false);
//      inActivePublisher.setEmail("testuser3@test.com");
//      this.userDao.save(inActivePublisher);
//      
//      assertEquals(2, (this.userDao.findAllUsers(true)).size());
//      assertEquals(1, (this.userDao.findAllUsers(false)).size());
//   }

   @Test
   public void testFindByUsername() {
      String email = "tester@abc.com";
      User user = new User();
      user.setEmail(email);
      userDao.save(user);
      
      assertNotNull(this.userDao.findByUsername("tESter@aBc.com"));
      assertNotNull(this.userDao.findByUsername(email));
   }
   
//   @Test
//   public void testSaveWithoutUsernameFails()
//   {
//      SubscriberDetails subscriber = new SubscriberDetails();
//      try
//      {
//         userDao.save(subscriber);
//         fail("Should be unable to save without a username");
//      }
//      catch(DataIntegrityViolationException e)
//      {
//         assertNotNull(e); //this is good
//      }
//   }
}
