package com.express.dao.jpa;

import javax.persistence.EntityManagerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.express.dao.BacklogItemDao;
import com.express.domain.BacklogItem;

@Repository("backlogItemDao")
public class JpaBacklogItemDao extends JpaGenericDao<BacklogItem> implements BacklogItemDao {
   
   @Autowired
   public JpaBacklogItemDao(EntityManagerFactory entityManagerFactory) {
      super(BacklogItem.class);
      super.setEntityManagerFactory(entityManagerFactory);
   }
}
