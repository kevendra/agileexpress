package com.express.dao.jpa;

import com.express.dao.IssueDao;
import com.express.domain.Issue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManagerFactory;

/**
 *
 */
@Repository("issueDao")
public class JpaIssueDao extends JpaGenericDao<Issue> implements IssueDao {

   @Autowired
   public JpaIssueDao(EntityManagerFactory entityManagerFactory) {
      super(Issue.class);
      super.setEntityManagerFactory(entityManagerFactory);
   }
}
