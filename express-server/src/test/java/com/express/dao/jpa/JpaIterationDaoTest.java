package com.express.dao.jpa;

import com.express.AbstractUnitilsTestBase;
import com.express.domain.Iteration;
import com.express.domain.Project;
import com.express.dao.IterationDao;
import com.express.dao.ProjectDao;
import org.junit.Test;
import org.unitils.spring.annotation.SpringBeanByName;
import org.unitils.dbunit.annotation.DataSet;

import java.util.Calendar;

import static junit.framework.Assert.assertEquals;

/**
 * @author Adam Boas
 */
@DataSet({"/datasets/DataRemovalDataSet.xml", "/datasets/JpaIterationDaoTest.xml"})
public class JpaIterationDaoTest extends AbstractUnitilsTestBase {
   private static final Long ID = 10l;

   @SpringBeanByName
   IterationDao iterationDao;

   @SpringBeanByName
   ProjectDao projectDao;

   private void addActiveIteration() {
      Iteration activeIteration = new Iteration();
      Calendar start = Calendar.getInstance();
      start.add(Calendar.DAY_OF_YEAR, -1);
      Calendar end = Calendar.getInstance();
      end.add(Calendar.DAY_OF_YEAR, 1);
      activeIteration.setStartDate(start);
      activeIteration.setEndDate(end);
      Project project = projectDao.findById(ID);
      project.addIteration(activeIteration);
   }

   @Test
   public void testName() {
      addActiveIteration();
      assertEquals(1, iterationDao.findOpenIterations().size());
   }
}
