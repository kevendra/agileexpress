package com.express.dao.jpa;
import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;
import org.unitils.dbunit.annotation.DataSet;
import org.unitils.spring.annotation.SpringBeanByName;

import com.express.AbstractUnitilsTestBase;
import com.express.dao.ProjectDao;
import com.express.dao.UserDao;
import com.express.domain.Project;
import com.express.domain.User;
import com.express.domain.ProjectWorker;


@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/JpaProjectDaoTest.xml"})
public class JpaProjectDaoTest extends AbstractUnitilsTestBase {
   private static final Long USER_WITHOUT_PROJECT_ID = 104l;
   private static final Long EXISTING_USER_ID = 102l;
   private static final Long PROJECT_WITH_2_WORKERS_ID = 101l;

   @SpringBeanByName
   ProjectDao projectDao;

   @SpringBeanByName
   UserDao userDao;
   
   @Test
   public void checkNoneReturnedWhenUserHasNoProjects() {
      List<Project> projects = projectDao.findAll(userDao.findById(USER_WITHOUT_PROJECT_ID));
      assertEquals(0, projects.size());
   }
   
   @Test
   public void checkReturnForProjectWorker() {
      List<Project> projects = projectDao.findAll(userDao.findById(EXISTING_USER_ID));
      assertEquals(2, projects.size());
   }

   @Test
   public void testFindAllReturnsAllProjects() {
      List<Project> projects = projectDao.findAll();
      assertEquals(3, projects.size());
   }

   @Test
   public void checkFindAvailableForUserWithNoProjectsReturnsAllProjects() {
      User user = userDao.findById(USER_WITHOUT_PROJECT_ID);
      List<Project> projects = projectDao.findAvailable(user);
      assertEquals(3, projects.size());
   }

   @Test
   public void checkFindAvailableForUserWithTwoProjectsReturnsOne() {
      User user = userDao.findById(EXISTING_USER_ID);
      List<Project> projects = projectDao.findAvailable(user);
      assertEquals(1, projects.size());
   }

   @Test
   public void testSaveCascadesProjectWorkers() {
      User user = userDao.findById(USER_WITHOUT_PROJECT_ID);
      Project project = projectDao.findById(PROJECT_WITH_2_WORKERS_ID);
      ProjectWorker worker = new ProjectWorker();
      worker.setWorker(user);
      project.addProjectWorker(worker);
      projectDao.save(project);
      project = projectDao.findById(PROJECT_WITH_2_WORKERS_ID);
      assertEquals(3, project.getProjectWorkers().size());
   }

}
