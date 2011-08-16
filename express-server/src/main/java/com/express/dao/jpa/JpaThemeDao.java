package com.express.dao.jpa;

import com.express.dao.ThemeDao;
import com.express.domain.Theme;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManagerFactory;

@Repository("themeDao")
public class JpaThemeDao extends JpaGenericDao<Theme> implements ThemeDao {

   @Autowired
   public JpaThemeDao(EntityManagerFactory entityManagerFactory) {
      super(Theme.class);
      super.setEntityManagerFactory(entityManagerFactory);
   }

}