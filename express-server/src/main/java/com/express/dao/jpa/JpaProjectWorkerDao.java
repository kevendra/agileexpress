package com.express.dao.jpa;

import com.express.dao.ProjectWorkerDao;
import com.express.domain.ProjectWorker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManagerFactory;

@Repository("projectWorkerDao")
public class JpaProjectWorkerDao extends JpaGenericDao<ProjectWorker> implements ProjectWorkerDao {

   @Autowired
   public JpaProjectWorkerDao(EntityManagerFactory entityManagerFactory) {
      super(ProjectWorker.class);
      super.setEntityManagerFactory(entityManagerFactory);
   }

}