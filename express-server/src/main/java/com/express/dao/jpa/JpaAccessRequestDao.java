package com.express.dao.jpa;

import com.express.dao.AccessRequestDao;
import com.express.domain.AccessRequest;
import com.express.domain.BacklogItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManagerFactory;

@Repository("accessRequestDao")
public class JpaAccessRequestDao extends JpaGenericDao<AccessRequest> implements AccessRequestDao {

   @Autowired
   public JpaAccessRequestDao(EntityManagerFactory entityManagerFactory) {
      super(AccessRequest.class);
      super.setEntityManagerFactory(entityManagerFactory);
   }
   
}
