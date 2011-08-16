package com.express.dao.jpa;

import com.express.dao.IterationDao;
import com.express.domain.Iteration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManagerFactory;
import java.util.*;

@Repository("iterationDao")
public class JpaIterationDao extends JpaGenericDao<Iteration> implements IterationDao {

   @Autowired
   public JpaIterationDao(EntityManagerFactory entityManagerFactory) {
      super(Iteration.class);
      super.setEntityManagerFactory(entityManagerFactory);
   }

   public List<Iteration> findOpenIterations() {
      Map<String, Calendar> params = new HashMap<String, Calendar>();
      Calendar cal = Calendar.getInstance();
      params.put("date", new GregorianCalendar(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH)));
      return this.getJpaTemplate().findByNamedQueryAndNamedParams(Iteration.QUERY_FIND_OPEN,params);
   }

}
