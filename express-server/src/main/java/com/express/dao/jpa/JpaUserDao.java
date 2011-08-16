package com.express.dao.jpa;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import javax.persistence.EntityManagerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ObjectRetrievalFailureException;
import org.springframework.stereotype.Repository;

import com.express.dao.UserDao;
import com.express.domain.User;

@Repository("userDao")
public class JpaUserDao extends JpaGenericDao<User> implements UserDao {
   
   @Autowired
   public JpaUserDao(EntityManagerFactory entityManagerFactory) {
      super(User.class);
      super.setEntityManagerFactory(entityManagerFactory);
   }

   @SuppressWarnings("unchecked")
   public User findByUsername(String username) {
      Map<String, String> params = new HashMap<String, String>();
      params.put("email", username.toLowerCase());
      List<User> users = this.getJpaTemplate().findByNamedQueryAndNamedParams(User.QUERY_FIND_BY_USERNAME,params);
      if (users == null || users.size() != 1) {
         throw new ObjectRetrievalFailureException(User.class, username);
      }
      return users.get(0);
   }

}
